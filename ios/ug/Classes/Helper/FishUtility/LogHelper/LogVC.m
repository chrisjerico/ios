//
//  LogVC.m
//  C
//
//  Created by fish on 2018/5/17.
//  Copyright © 2018年 fish. All rights reserved.
//

#ifdef DEBUG

#import "LogVC.h"

#import "TextFieldAlertView.h"

#import "AFHTTPSessionManager.h"
#import "NSMutableArray+KVO.h"
#import <SafariServices/SafariServices.h>

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
    
    
    
    {//切换按钮六合
        NSMutableArray *titles = @[].mutableCopy;
        [titles addObject:@"当前skintyle"];
        [titles addObject:@"切换到六合"];
        UIAlertController *ac = [AlertHelper showAlertView:nil msg:@"请选择操作" btnTitles:[titles arrayByAddingObject:@"取消"]];
        
        [ac setActionAtTitle:@"当前skintyle" handler:^(UIAlertAction *aa) {
            NSLog(@"%@",[NSString stringWithFormat: @"当前skintyle = %@",Skin1.skitString]);
        }];
        [ac setActionAtTitle:@"切换到六合" handler:^(UIAlertAction *aa) {
            [UGSkinManagers lhSkin];
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
    NSMutableArray *titles = @[].mutableCopy;
    for (SiteModel *sm in APP.allSites) {
        if (sm.host.length) {
            [titles addObject:sm.siteId];
        }
    }
    [titles sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 substringFromIndex:1].intValue > [obj2 substringFromIndex:1].intValue;
    }];
    UIAlertController *ac = [AlertHelper showAlertView:nil msg:@"请选择要切换的站点" btnTitles:[titles arrayByAddingObject:@"取消"]];
    for (NSString *key in titles) {
        [ac setActionAtTitle:key handler:^(UIAlertAction *aa) {
            [APP setValue:key forKey:@"_SiteId"];
            [APP setValue:[APP.allSites objectWithValue:key keyPath:@"siteId"].host forKey:@"_Host"];
            [_logVC.currentSiteIdButton setTitle:key forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"当前站点Key"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
}

// 下载APP
- (IBAction)onLHBtnClick:(UIButton *)sender {
    // 文本弹框
    TextFieldAlertView *tfav = _LoadView_from_nib_(@"TextFieldAlertView");
    tfav.title = @"下载链接中的id";
    tfav.didConfirmBtnClick = ^(TextFieldAlertView *__weak tfav, NSString *text) {
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (!text.isInteger) {
            [HUDHelper showMsg:@"id必须为数字"];
            return ;
        }
        UIAlertController *ac = [AlertHelper showActionSheet:nil msg:nil btnTitles:@[@"下载已审核的APP", @"下载审核中的APP"] cancel:@"取消"];
        [ac setActionAtTitle:@"下载已审核的APP" handler:^(UIAlertAction *aa) {
            SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:_NSString(@"https://fhapp168l.com/eipeyipeyi/index-%@.html?rand=%u", text, arc4random())]];
            sf.允许未登录访问 = true;
            sf.允许游客访问 = true;
            [NavController1 presentViewController:sf animated:YES completion:nil];
        }];
        [ac setActionAtTitle:@"下载审核中的APP" handler:^(UIAlertAction *aa) {
            SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:_NSString(@"https://fhapp168l.com/eipeyipeyi/index-%@.html?test=9999&rand=%u", text, arc4random())]];
            sf.允许未登录访问 = true;
            sf.允许游客访问 = true;
            [NavController1 presentViewController:sf animated:YES completion:nil];
        }];
        [tfav hide];
    };
    [tfav showToWindow];
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
