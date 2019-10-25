//
//  LogVC.m
//  C
//
//  Created by fish on 2018/5/17.
//  Copyright © 2018年 fish. All rights reserved.
//

#if defined(DEBUG) || defined(APP_TEST)

#import "LogVC.h"

#import "TextFieldAlertView.h"

#import "AFHTTPSessionManager.h"
#import "NSMutableArray+KVO.h"

@interface LogVC ()<NSMutableArrayDidChangeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *reqTableView;     /**<    请求TableView */
@property (weak, nonatomic) IBOutlet UITableView *paramsTableView;  /**<    参数TableView */
@property (weak, nonatomic) IBOutlet UITextView *resTextView;       /**<    响应TextView */
@property (weak, nonatomic) IBOutlet UITextView *logTextView;       /**<    日志TextView */
@property (weak, nonatomic) IBOutlet UIButton *collectButton;       /**<    收藏按钮 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *hostSegmentedControl;  /**<    主机地址 SegmentedControl */
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
    [superview addGestureRecognizer:({
        UISwipeGestureRecognizer *swipe = [UISwipeGestureRecognizer gestureRecognizer:^(UISwipeGestureRecognizer *sender) {
            [NavController1.topView endEditing:true];
            [superview addSubview:_logVC.view];
            
            [UIView animateWithDuration:0.25 animations:^{
                _logVC.view.center = CGPointMake(superview.width/2, superview.height/2);
            } completion:^(BOOL finished) {
                [_logVC.reqTableView reloadData];
            }];
        }];
        swipe.numberOfTouchesRequired = 2;
        swipe.direction = UISwipeGestureRecognizerDirectionDown;
        swipe;
    })];
}

+ (void)addRequestModel:(CCSessionModel *)sm {
    [_logVC.allRequest insertObject:sm atIndex:0];
    if (_logVC.view.by > 10) {
        [_logVC.reqTableView reloadData];
    }
//    if (_logVC.allRequest.count > 50)
//        [_logVC.allRequest removeLastObject];
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
    
    if ([[NSUserDefaults standardUserDefaults] containsKey:@"HostIndex"])
        _hostSegmentedControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"HostIndex"];
    [self onHostSegmentedControlValueChanged:_hostSegmentedControl];
    
    _reqTableView.rowHeight = 46;
    _paramsTableView.rowHeight = 25;
    _paramsTableView.hidden = true;
}


#pragma mark - IBAction

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

- (IBAction)onRepeatBtnClick:(UIButton *)sender {
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

- (IBAction)onCollectBtnClick:(UIButton *)sender {
    if (sender.selected) {
        [_collects removeObject:_selectedModel];
        [_reqTableView reloadData];
    } else if (![_collects containsObject:_selectedModel]) {
        [_collects insertObject:_selectedModel atIndex:0];
        [HUDHelper showMsg:@"添加成功"];
    }
}

- (IBAction)onHideBtnClick:(UIButton *)sender {
    UIView *superview = APP.Window;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.center = CGPointMake(superview.width/2, -superview.height/2);
    } completion:^(BOOL finished) {
        [APP.Window sendSubviewToBack:self.view];
    }];
}

// 切换服务器
- (IBAction)onHostSegmentedControlValueChanged:(UISegmentedControl *)sender {
    static NSInteger selectedIdx = 0;
    NSInteger idx = sender.selectedSegmentIndex;
    NSString *host = nil;
    switch (idx) {
        case 1: {   // test10
            host = @"http://test10.6yc.com/";
            break;
        }
        default: {  // c083
            host = @"http://103.9.230.243/";
        }
    }
    APP.HOST = baseServerUrl = host;
    [[NSUserDefaults standardUserDefaults] setInteger:idx forKey:@"HostIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    selectedIdx = idx;
}

// 全部请求、书签、日志
- (IBAction)onTopSegmentedControlValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _collectButton.selected = false;
    } else if (sender.selectedSegmentIndex == 1) {
        _collectButton.selected = true;
    } else if (sender.selectedSegmentIndex == 2) {
        _logTextView.text = _log;
        [_logTextView scrollRangeToVisible:_logTextView.selectedRange];
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
