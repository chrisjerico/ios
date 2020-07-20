//
//  LogVC.m
//  C
//
//  Created by fish on 2018/5/17.
//  Copyright © 2018年 fish. All rights reserved.
//

#ifdef APP_TEST

#import "LogVC.h"
#import "CMAudioPlayer.h"

#import "AFHTTPSessionManager.h"
#import "NSMutableArray+KVO.h"
#import <SafariServices/SafariServices.h>
#import "UGPromotionsListController.h"

// View
#import "TextFieldAlertView.h"
#import "DZPMainView.h"
#import "SitesView.h"
#import "HotBranchView.h"
#import "BetDetailViewController.h"
#import "DZPModel.h"
#import "UGPopViewController.h"
@interface LogVC ()<NSMutableArrayDidChangeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *reqTableView;     /**<    请求TableView */
@property (weak, nonatomic) IBOutlet UITableView *paramsTableView;  /**<    参数TableView */
@property (weak, nonatomic) IBOutlet UITextView *resTextView;       /**<    响应TextView */
@property (weak, nonatomic) IBOutlet UIButton *collectButton;       /**<    收藏按钮 */
@property (weak, nonatomic) IBOutlet UIButton *currentSiteIdButton; /**<   当前站点按钮 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *toolSegmentedControl;

@property (nonatomic) NSMutableArray <CCSessionModel *>*allRequest; /**<    请求列表 */
@property (nonatomic) NSMutableArray <CCSessionModel *>*collects;   /**<    收藏列表 */

@property (nonatomic) CCSessionModel *selectedModel;                /**<    选中的请求 */
@property (nonatomic) NSArray <NSString *>*selectedModelKeys;       /**<    选中请求的参数名 */

@property (nonatomic) NSMutableString *log;                         /**<    日志 */



@property (nonatomic, strong) NSArray <DZPModel *> *dzpArray;   /**<   转盘活动数据 */
@end

@implementation LogVC

static LogVC *_logVC = nil;

+ (void)enableLogVC {
    if (_logVC)
        return;
    _logVC = [[UIStoryboard storyboardWithName:@"Log" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LogVC"];
    
    UIView *superview = APP.Window;
    _logVC.view.frame = superview.bounds;
    _logVC.view.by = 0;
    
    // 添加手势
    void (^block)(UISwipeGestureRecognizer *) = ^(UISwipeGestureRecognizer *sender) {
        [NavController1.topView endEditing:true];
        [superview addSubview:_logVC.view];
        [_logVC.currentSiteIdButton setTitle:APP.SiteId forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.25 animations:^{
            _logVC.view.center = CGPointMake(superview.width/2, superview.height/2);
        } completion:^(BOOL finished) {
            [_logVC.reqTableView reloadData];
        }];
    };
    [superview addGestureRecognizer:({
        UISwipeGestureRecognizer *swipe = [UISwipeGestureRecognizer gestureRecognizer:block];
        swipe.numberOfTouchesRequired = 2;
        swipe.direction = UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
        swipe;
    })];
    [superview addGestureRecognizer:({
        UISwipeGestureRecognizer *swipe = [UISwipeGestureRecognizer gestureRecognizer:^(__kindof UISwipeGestureRecognizer *gr) {
            [[UGSkinManagers last] useSkin];
            [HUDHelper showMsg:[UGSkinManagers currentSkin].skitString];
        }];
        swipe.numberOfTouchesRequired = 2;
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
        swipe;
    })];
    [superview addGestureRecognizer:({
        UISwipeGestureRecognizer *swipe = [UISwipeGestureRecognizer gestureRecognizer:^(__kindof UISwipeGestureRecognizer *gr) {
            [[UGSkinManagers next] useSkin];
            [HUDHelper showMsg:[UGSkinManagers currentSkin].skitString];
        }];
        swipe.numberOfTouchesRequired = 2;
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
        swipe;
    })];
    
    // 3击拷贝手势
    [_logVC.resTextView addGestureTapEventHandle:^(id sender, UITapGestureRecognizer *gestureRecognizer) {
        [UIPasteboard generalPasteboard].string = _logVC.resTextView.text;
        [HUDHelper showMsg:@"已拷贝"];
    }].numberOfTapsRequired = 3;
}

+ (void)addRequestModel:(CCSessionModel *)sm {
    [_logVC.allRequest insertObject:sm atIndex:0];
    if (_logVC.view.by > 10) {
        [_logVC.reqTableView reloadData];
    }
}

+ (void)addLog:(NSString *)log {
    [_logVC.log appendFormat:@"%@  %@\n", [[NSDate date] stringWithFormat:@"[HH:mm:ss.SSS]"], log];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _log = [@"" mutableCopy];
    _allRequest = [NSMutableArray array];
    
    _collects = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"Collectedequests"]] mutableCopy];
    if (!_collects.count)
        _collects = [NSMutableArray array];
    [_collects addObserver:self];
    
    _reqTableView.rowHeight = 46;
    _paramsTableView.rowHeight = 25;
    _paramsTableView.hidden = true;
}


#pragma mark - IBAction

// 清空
- (IBAction)onClearBtnClick:(UIButton *)sender {
    
    [CMCommon clearWebCache];
    [CMCommon deleteWebCache];
    [CMCommon removeLastGengHao];
    
    if (_toolSegmentedControl.selectedSegmentIndex == 0) {
        [_allRequest removeAllObjects];
        [_reqTableView reloadData];
    } else if (_toolSegmentedControl.selectedSegmentIndex == 1) {
        [_collects removeAllObjects];
        [_reqTableView reloadData];
    } else {
        _log = [@"" mutableCopy];
        [LogVC addLog:@"已清空"];
    }
}


//大转盘
- (void)getactivityTurntableList {
    
    self.dzpArray = [NSArray new];
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
    };
    [CMNetwork activityTurntableListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        
        [CMResult processWithResult:model success:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                self.dzpArray = model.data;
                NSLog(@"dzpArray = %@",self.dzpArray);
                
                if (self.dzpArray.count) {
                    
                    NSMutableArray *data =  [DZPModel mj_objectArrayWithKeyValuesArray:self.dzpArray];
                    
                    
                    DZPModel *obj = [data objectAtIndex:0];
                    
                    
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        // 需要在主线程执行的代码
                        
                        DZPMainView *recordVC = [[DZPMainView alloc] initWithFrame:CGRectZero];
                        [self.view addSubview:recordVC];
                        [recordVC mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.edges.equalTo(self.view);
                        }];
                        
                        //                        recordVC.dataArray = [DZPprizeModel mj_objectArrayWithKeyValuesArray:obj.param.prizeArr];
                        recordVC.item = obj;
                    });
                    
                }
                
            });
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}
// 重发
- (IBAction)onRepeatBtnClick:(UIButton *)sender {
#define k_Height_NavContentBar 44.0f
#define k_Height_NavBar (IS_PhoneXAll ? 88.0 : 64.0)//导航栏
#define k_Height_StatusBar (IS_PhoneXAll? 44.0 : 20.0)//状态栏
#define k_Height_TabBar (IS_PhoneXAll ? 83.0 : 49.0)//标签栏的高度
#define IPHONE_SAFEBOTTOMAREA_HEIGHT (IS_PhoneXAll ? 34 : 0)//安全的底部区域
#define IPHONE_TOPSENSOR_HEIGHT      (IS_PhoneXAll ? 32 : 0)//高级传感器
    
    
    {//切换按钮六合
        NSMutableArray *titles = @[].mutableCopy;
        [titles addObject:@"弹窗"];
        [titles addObject:@"下注明细"];
        UIAlertController *ac = [AlertHelper showAlertView:nil msg:@"请选择操作" btnTitles:[titles arrayByAddingObject:@"取消"]];
        
        [ac setActionAtTitle:@"下注明细" handler:^(UIAlertAction *aa) {
            BetDetailViewController *recordVC = _LoadVC_from_storyboard_(@"BetDetailViewController");
            [NavController1 pushViewController:recordVC animated:true];
            
        }];
        
        [ac setActionAtTitle:@"弹窗" handler:^(UIAlertAction *aa) {
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 需要在主线程执行的代码
                NSString *text = @"尊敬的会员您好，接上级通知，我司因全站系统升级临时进行维护，系统维护期间无法进入网站正常游戏，给您带来不便敬请谅解，如有问题请联系在线客服。谢谢！<a href=\"https://tw.yahoo.com/\">https://tw.yahoo.com/</a>";
                text = @"尊敬的会员您好，接上级通知，我司因全站系统升级临时进行维护，系统维护期间无法进入网站正常游戏，给您带来不便敬请谅解，如有问题请联系在线客服。谢谢！https://tw.yahoo.com";
//                for (int i = 0; i<10; i++) {
//                    SinglePopView *popView = [SinglePopView sharedInstance];
//                    NSString *text = @"尊敬的会员您好，接上级通知，我司因全站系统升级临时进行维护，系统维护期间无法进入网站正常游戏，给您带来不便敬请谅解，如有问题请联系在线客服。谢谢！<a href=\"https://tw.yahoo.com/\">https://tw.yahoo.com/</a>";
//                    popView.content = text;
//                    [SGBrowserView showZoomView:popView];
                    
//                    [LEEAlert alert].config
//                         .LeeTitle(text)
//                         .LeeCancelAction(@"关闭", nil)
//                         .LeeShow();
                    
//                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
//                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//                        // 弹出对话框
//                        [self presentViewController:alert animated:true completion:nil];
                    
                    UGPopViewController *alertView = [[UGPopViewController alloc] init];

                    alertView.content = text;
                    //    // it`s OK!
                    [self presentViewController:alertView animated:true completion:nil];
                    
//                }
                
                
            });
        }];
        
        
        return;
    }
    NSInteger idx = [_reqTableView indexPathForSelectedRow].row;
    NSMutableArray <CCSessionModel *>*requests = (_collectButton.selected ? _collects : _allRequest);
    if (requests.count > idx) {
        CCSessionModel *sm = requests[idx];
        CCSessionModel *sObj = [CCSessionModel new];
        sObj.urlString = sm.urlString;
        sObj.params = sm.params;
        sObj.isPOST = sm.isPOST;
        sObj.delegate = NetworkManager1;
        
        {
            static AFHTTPSessionManager *m = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                m = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:sObj.urlString]];
            });
            m.requestSerializer = [AFJSONRequestSerializer serializer];
            m.responseSerializer = [AFJSONResponseSerializer serializer];
            m.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
            NSMutableURLRequest *req = [m.requestSerializer requestWithMethod:sm.isPOST ? @"POST":@"GET" URLString:sm.urlString parameters:sm.params error:nil];
            [[sObj dataTask:m request:req] resume];
        }
        
        sObj.completionBlock = ^(CCSessionModel *sObj) {
            [_reqTableView reloadData];
        };
        
        [LogVC addRequestModel:sObj];
        [_reqTableView reloadData];
    }
}

// 切换站点
- (IBAction)onChangeSiteIdBtnClick:(UIButton *)sender {
    [[SitesView show] setDidClick:^(NSString *key) {
        [APP setValue:key forKey:@"_SiteId"];
        [APP setValue:[APP.allSites objectWithValue:key keyPath:@"siteId"].host forKey:@"_Host"];
        [_logVC.currentSiteIdButton setTitle:key forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"当前站点Key"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

// 切换热更新
- (IBAction)onLHBtnClick:(UIButton *)sender {
    [HotBranchView show];
}

// 收藏
- (IBAction)onCollectBtnClick:(UIButton *)sender {
    if (sender.selected) {
        [_collects removeObject:_selectedModel];
        [_reqTableView reloadData];
    } else if (![_collects containsObject:_selectedModel]) {
        [_collects insertObject:_selectedModel atIndex:0];
        [HUDHelper showMsg:@"添加成功"];
    }
}

// 关闭
- (IBAction)onHideBtnClick:(UIButton *)sender {
    UIView *superview = APP.Window;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.center = CGPointMake(superview.width/2, -superview.height/2);
    } completion:^(BOOL finished) {
        [APP.Window sendSubviewToBack:self.view];
    }];
}

// 全部请求、书签、日志
- (IBAction)onTopSegmentedControlValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _collectButton.selected = false;
    } else if (sender.selectedSegmentIndex == 1) {
        _collectButton.selected = true;
    }
    
    _reqTableView.superview.hidden = sender.selectedSegmentIndex == 2;
    [_reqTableView reloadData];
}

- (IBAction)onBottomSegmentedControlValueChanged:(UISegmentedControl *)sender {
    _paramsTableView.hidden = !sender.selectedSegmentIndex;
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _reqTableView) {
        return (_collectButton.selected ? _collects : _allRequest).count;
    }
    return _selectedModel.params.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    FastSubViewCode(cell);
    if (tableView == _reqTableView) {
        NSArray *array = (_collectButton.selected ? _collects : _allRequest);
        CCSessionModel *sm = array.count > indexPath.row ? array[indexPath.row] : nil;
        subLabel(@"StateLabel").text = sm.responseObject ? @"✅" : (sm.error ? @"❌" : @"🕓");
        subLabel(@"TitleLabel").text = sm.urlString;
        subLabel(@"DetailLabel").text = _NSString(@"%@", sm.responseObject[@"msg"]);
        subLabel(@"TimeLabel").text = sm.duration >= 1000 ? _NSString(@"%.1fs", sm.duration/1000.0) : _NSString(@"%dms", (int)sm.duration);
        subLabel(@"TimeLabel").hidden = !(sm.responseObject || sm.error);
    } else {
        subLabel(@"TitleLabel").text = _selectedModelKeys[indexPath.row];
        subLabel(@"DetailLabel").text =  [_selectedModel.params[_selectedModelKeys[indexPath.row]] description];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _reqTableView) {
        _selectedModel = (_collectButton.selected ? _collects : _allRequest)[indexPath.row];
        _selectedModelKeys = _selectedModel.params.allKeys;
        if (_selectedModel.error) {
            _resTextView.text = [_selectedModel.error description];
        } else if (_selectedModel.responseObject) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:_selectedModel.responseObject options:NSJSONWritingPrettyPrinted error:nil];
            _resTextView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        [_paramsTableView reloadData];
    } else {
        // 文本弹框
        TextFieldAlertView *tfav = _LoadView_from_nib_(@"TextFieldAlertView");
        tfav.title = _selectedModelKeys[indexPath.row];
        tfav.text = [_selectedModel.params[_selectedModelKeys[indexPath.row]] description];
        __weakSelf_(__self);
        tfav.didConfirmBtnClick = ^(TextFieldAlertView *__weak tfav, NSString *text) {
            __self.selectedModel.params = ({
                NSMutableDictionary *dict = [__self.selectedModel.params mutableCopy];
                dict[tfav.title] = text;
                dict;
            });
            [tfav hide];
            [__self.paramsTableView reloadData];
        };
        [tfav showToWindow];
    }
}

#pragma mark - NSMutableArrayDidChangeDelegate

- (void)array:(NSMutableArray *)array didChange:(NSDictionary<NSString *,id> *)change {
    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:_collects] forKey:@"Collectedequests"];
}

@end

#endif
