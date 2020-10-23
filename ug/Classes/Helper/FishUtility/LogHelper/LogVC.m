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
#import "TKLMainViewController.h"
#import "AFHTTPSessionManager.h"
#import "NSMutableArray+KVO.h"
#import <SafariServices/SafariServices.h>

// View
#import "TextFieldAlertView.h"
#import "DZPMainView.h"
#import "SitesView.h"
#import "HotBranchView.h"
#import "BetDetailViewController.h"
#import "DZPModel.h"
#import "UGPopViewController.h"
#import "CMLabelCommon.h"
#import "NewLotteryHomeViewController.h"
#import "CMTimeCommon.h"

@interface LogVC ()<NSMutableArrayDidChangeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *reqTableView;     /**<    请求TableView */
@property (weak, nonatomic) IBOutlet UITableView *paramsTableView;  /**<    参数TableView */
@property (weak, nonatomic) IBOutlet UIButton *collectButton;       /**<    收藏按钮 */
@property (weak, nonatomic) IBOutlet UIButton *showNewRequestBtn;
@property (weak, nonatomic) IBOutlet UIButton *currentSiteIdButton; /**<   当前站点按钮 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *toolSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextView *retTextView;

@property (nonatomic) NSMutableArray <CCSessionModel *>*allRequest; /**<    请求列表 */
@property (nonatomic) NSMutableArray <CCSessionModel *>*aNewRequest; /**<    请求列表 */
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
}

+ (void)addRequestModel:(CCSessionModel *)sm {
    [_logVC.aNewRequest insertObject:sm atIndex:0];
    [_logVC.showNewRequestBtn setTitle:_NSString(@"有%ld条新请求，点击查看", (long)_logVC.aNewRequest.count) forState:UIControlStateNormal];
}

+ (void)addLog:(NSString *)log {
    [_logVC.log appendFormat:@"%@  %@\n", [[NSDate date] stringWithFormat:@"[HH:mm:ss.SSS]"], log];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _log = [@"" mutableCopy];
    _allRequest = [NSMutableArray array];
    _aNewRequest = @[].mutableCopy;
    
    _collects = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"Collectedequests"]] mutableCopy];
    if (!_collects.count)
        _collects = [NSMutableArray array];
    [_collects addObserver:self];
    
    _reqTableView.rowHeight = 46;
    _paramsTableView.rowHeight = 25;
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



// 重发
- (IBAction)onRepeatBtnClick:(UIButton *)sender {
#define k_Height_NavContentBar 44.0f
#define k_Height_NavBar (IS_PhoneXAll ? 88.0 : 64.0)//导航栏
#define k_Height_StatusBar (IS_PhoneXAll? 44.0 : 20.0)//状态栏
#define k_Height_TabBar (IS_PhoneXAll ? 83.0 : 49.0)//标签栏的高度
#define IPHONE_SAFEBOTTOMAREA_HEIGHT (IS_PhoneXAll ? 34 : 0)//安全的底部区域
#define IPHONE_TOPSENSOR_HEIGHT      (IS_PhoneXAll ? 32 : 0)//高级传感器
    
#pragma mark ----用来测试的
    {//切换按钮六合
        NSMutableArray *titles = @[].mutableCopy;
        [titles addObject:@"时间搓"];
        [titles addObject:@"天空蓝额度"];
        UIAlertController *ac = [AlertHelper showAlertView:nil msg:@"请选择操作" btnTitles:[titles arrayByAddingObject:@"取消"]];
        
        [ac setActionAtTitle:@"天空蓝额度" handler:^(UIAlertAction *aa) {
            TKLMainViewController *vc = [[TKLMainViewController alloc] init];
            [NavController1 pushViewController:vc animated:true];
//            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"TKLMainListViewController") animated:true];
        }];

        
        [ac setActionAtTitle:@"时间搓" handler:^(UIAlertAction *aa) {
           NSString *time1 = [CMTimeCommon timestampSwitchTime:1602923724 andFormatter:@"yyyy-MM-dd HH:mm"];
            NSLog(@"time1 = %@",time1);//time1 = 2020-10-17 16:35
            
//            NSString *time2 = [CMTimeCommon currentDateStringWithFormat:@"yyyy-MM-dd HH:mm"];
//            NSLog(@"time2 = %@",time2);//time2 = 2020-10-17 17:19
            NSString *time2 = @"2020-10-17 16:34";
            NSDate *date1 = [CMTimeCommon dateForStr:time1 format:@"yyyy-MM-dd HH:mm"];
            NSDate *date2 = [CMTimeCommon dateForStr:time2 format:@"yyyy-MM-dd HH:mm"];
            
           int k =  [CMTimeCommon compareOneDay:date2 withAnotherDay:date1 formatter:@"yyyy-MM-dd HH:mm"];
            
            NSLog(@"k = %d",k);
            
           
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
        
        sObj.completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
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

// 显示新请求
- (IBAction)onShowNewRequestBtnClick:(UIButton *)sender {
    [_allRequest insertObjects:_aNewRequest atIndex:0];
    [_aNewRequest removeAllObjects];
    [_reqTableView reloadData];
    [_showNewRequestBtn setTitle:@"有0条新请求，点击查看" forState:UIControlStateNormal];
}

- (IBAction)onUnfoldBtnClick:(UIButton *)sender {
    static BOOL isUnfold = false;
    isUnfold = !isUnfold;
    _reqTableView.cc_constraints.height.constant = isUnfold ? APP.Height - 240 - APP.BottomSafeHeight - APP.StatusBarHeight : 180;
}

- (IBAction)onResSegmentedControlValueChanged:(UISegmentedControl *)sender {
    _retTextView.hidden = sender.selectedSegmentIndex;
}

// 显示返回结果
- (IBAction)onShowResultBtnClick:(UIButton *)sender {
    static UITextView *tv = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIView *v = [[UIView alloc] initWithFrame:APP.Bounds];
        v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [v addSubview:tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, APP.Width-20, APP.Height-100)]];
        tv.editable = false;
        tv.layer.masksToBounds = true;
        tv.layer.cornerRadius = 20;
        [v addSubview:({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(v.width-60, 50, 50, 50);
            [btn setTitle:@"关闭" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                tv.superview.hidden = true;
            }];
            btn;
        })];
        [v addSubview:({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(v.width-110, 50, 50, 50);
            [btn setTitle:@"拷贝" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                [UIPasteboard generalPasteboard].string = tv.text;
                [HUDHelper showMsg:@"已拷贝"];
            }];
            btn;
        })];
        [APP.Window addSubview:v];
    });
    if (_selectedModel.error) {
        tv.text = [_selectedModel.error description];
    } else if (_selectedModel.resObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_selectedModel.resObject options:NSJSONWritingPrettyPrinted error:nil];
        tv.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    [APP.Window addSubview:tv.superview];
    tv.superview.hidden = false;
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
        subLabel(@"StateLabel").text = sm.resObject ? @"✅" : (sm.error ? @"❌" : @"🕓");
        subLabel(@"TitleLabel").text = sm.urlString;
        subLabel(@"DetailLabel").text = _NSString(@"%@", sm.resObject[@"msg"]);
        subLabel(@"TimeLabel").text = sm.duration >= 1000 ? _NSString(@"%.1fs", sm.duration/1000.0) : _NSString(@"%dms", (int)sm.duration);
        subLabel(@"TimeLabel").hidden = !(sm.resObject || sm.error);
        subLabel(@"TimeLabel").hidden = true;
        
        [subButton(@"拷贝URLButton") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"拷贝URLButton") addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton  *sender) {
            [UIPasteboard generalPasteboard].string = sm.urlString;
            [HUDHelper showMsg:@"已拷贝URL"];
        }];
        [subButton(@"拷贝URL+参数Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"拷贝URL+参数Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton  *sender) {
            [UIPasteboard generalPasteboard].string = [sm.urlString stringByAppendingURLParams:sm.params];
            [HUDHelper showMsg:@"已拷贝URL+参数"];
        }];
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
            _retTextView.text = [_selectedModel.error description];
        } else if (_selectedModel.resObject) {
            __block CCSessionModel *lastModel = _selectedModel;
            NSData *data = [NSJSONSerialization dataWithJSONObject:_selectedModel.resObject options:NSJSONWritingPrettyPrinted error:nil];
            if (data.length > 10000) {
                _retTextView.text = @"正在加载中。。。";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (lastModel == self.selectedModel) {
                        self.retTextView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    }
                });
            } else {
                _retTextView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
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
