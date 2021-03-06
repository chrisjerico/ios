//
//  UGPlatformNoticeView.m
//  ug
//
//  Created by ug on 2019/5/31.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformNoticeView.h"
#import "UGPlatformNoticeCell.h"
#import "UGNoticeHeaderView.h"
#import "UGNoticeModel.h"
#import "SLWebViewController.h"
#import "PlatWebViewController.h"

@interface UGPlatformNoticeView ()<UITableViewDelegate,UITableViewDataSource, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bigView;


@property (nonatomic, assign) NSInteger selectSection;

@end

static NSString *platformNoticeCellid = @"UGPlatformNoticeCell";
static NSString *noticeHeaderViewid = @"noticeHeaderViewid";
@implementation UGPlatformNoticeView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self = [[NSBundle mainBundle] loadNibNamed:@"UGPlatformNoticeView" owner:self options:0].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
       
        NSLog(@"SysConf.announce_first = %d",SysConf.announce_first);
        if (SysConf.announce_first) {
            self.selectSection = 0;
        } else {
            self.selectSection = -1;
        }
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
//        [self.tableView registerNib:[UINib nibWithNibName:@"cell" bundle:nil] forCellReuseIdentifier:platformNoticeCellid];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"UGNoticeHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:noticeHeaderViewid];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.bigView.layer.cornerRadius = 5;
        self.bigView.layer.borderWidth = 4;
        self.bigView.layer.borderColor = [RGBA(206, 206, 206, 1) CGColor];
        [self.bgView setBackgroundColor:Skin1.navBarBgColor];
    }
    return self;
    
}

// 在自定义UITabBar中重写以下方法，其中self.button就是那个希望被触发点击事件的按钮
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    if (view == nil) {
//        // 转换坐标系
//        CGPoint newPoint = [self.closeButton convertPoint:point fromView:self];
//        // 判断触摸点是否在button上
//        if (CGRectContainsPoint(self.closeButton.bounds, newPoint)) {
//            view = self.closeButton;
//        }
//    }
//    return view;
//}

- (IBAction)close:(id)sender {
    [self hiddenSelf];
}

- (void)setDataArray:(NSArray<UGNoticeModel *> *)dataArray {
    _dataArray = dataArray;
    UGNoticeModel *model = dataArray.firstObject;
    if (SysConf.announce_first) {
        model.hiddenBottomLine = YES;
    } else {
        model.hiddenBottomLine = NO;
    }

    [self.tableView reloadData];
}


- (void)show {
    
 
    [self.bgView setBackgroundColor: Skin1.navBarBgColor];
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [maskView addSubview:view];
    [window addSubview:maskView];
}

- (void)hiddenSelf {
    UIView *view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];


}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectSection == -1) {
        return 0;
    } else {
        if (section == self.selectSection) {
            return 1;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UGNoticeModel *nm = self.dataArray[indexPath.section];
    
    // 加载html
    {
        static UGNoticeModel *__nm = nil;
        __nm = nm;
        
        UIWebView *wv = [cell viewWithTagString:@"WebView"];
        if (!wv) {
            wv = [UIWebView new];
            wv.backgroundColor = [UIColor clearColor];
            wv.tagString = @"WebView";
            // UI代理
            wv.delegate = self;
            [wv xw_addObserverBlockForKeyPath:@"scrollView.contentSize" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                NSLog(@"newH === %f",[newVal CGSizeValue].height);
                NSLog(@"oldH === %f",[oldVal CGSizeValue].height);
                CGFloat h = __nm.cellHeight = [newVal CGSizeValue].height;
                NSLog(@"高度==========%f",h);
                [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(h);
                }];
                [tableView beginUpdates];
                [tableView endUpdates];
            }];
            [cell.contentView addSubview:wv];
            
            [wv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(cell.contentView).offset(-2);
                make.top.bottom.equalTo(cell.contentView).offset(2);
                make.height.mas_equalTo(60);
            }];
        }

        wv.scrollView.contentSize = CGSizeMake(100, __nm.cellHeight);
        if ([@"c200,c190" containsString:APP.SiteId]) {
            [wv loadHTMLString:_NSString(@"<head><style>p{margin:0;padding:0}img{width:auto !important;max-width:100%%;height:auto !important}</style></head>%@", __nm.content) baseURL:nil];
            
            NSLog(@"__nm.content =%@",__nm.content);
        } else {
            [wv loadHTMLString:[APP htmlStyleString:__nm.content] baseURL:nil];
        }
    }
    
    
    // webview 上下各一条线
    UIView *topLineView = [cell viewWithTagString:@"topLineView"];
    if (!topLineView) {
        topLineView = [UIView new];
        topLineView.backgroundColor = RGBA(220, 220, 220, 1);
//        topLineView.backgroundColor = [UIColor redColor];
        topLineView.tagString = @"topLineView";
        [cell addSubview:topLineView];

        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(cell);
            make.height.mas_equalTo(1);
        }];
    }
    UIView *bottomLineView = [cell viewWithTagString:@"bottomLineView"];
    if (!bottomLineView) {
        bottomLineView = [UIView new];
        bottomLineView.backgroundColor = RGBA(239, 239, 239, 1);
        bottomLineView.tagString = @"bottomLineView";
        [cell addSubview:bottomLineView];

        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(cell);
            make.height.mas_equalTo(1);
        }];
    }
//
//    [cell setBackgroundColor:[UIColor yellowColor]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UGNoticeHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:noticeHeaderViewid];
    UGNoticeModel *item = self.dataArray[section];
    headerView.item = item;
    WeakSelf
    headerView.clickBllock = ^{
        if (weakSelf.selectSection == -1) {
            item.hiddenBottomLine = !item.hiddenBottomLine;
            weakSelf.selectSection = section;
        } else {
            if (section == weakSelf.selectSection) {
                weakSelf.selectSection = -1;
            } else {
                UGNoticeModel *lastItem = weakSelf.dataArray[weakSelf.selectSection];
                lastItem.hiddenBottomLine = NO;
                weakSelf.selectSection = section;
            }
            item.hiddenBottomLine = !item.hiddenBottomLine;
        }
        [weakSelf.tableView reloadData];
        // 有时SectionHeader会没加载出来，不知道原因，加上这两句就ok
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView endUpdates];
    };
    UIView *line = [headerView viewWithTagString:@"第一行的下划线View"];
    if (!line) {
        line = [UIView new];
        line.tagString = @"第一行的下划线View";
        line.backgroundColor = RGBA(239, 239, 239, 1);
        [headerView addSubview:line];
    }
    line.frame = CGRectMake(0, 44, headerView.width, 1);
    line.hidden = section;
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView=(UITableViewHeaderFooterView *)view;
    [headerView.backgroundView setBackgroundColor:[UIColor whiteColor]];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"webViewDidFinishLoad0000");
    // body.style背景色
//    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.background='#FF1493'"];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSLog(@"0000");
//
//    NSString *url = [request.URL absoluteString];
//
//    NSLog(@"url = %@",url);
    
    
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {

        NSString *url = [request.URL absoluteString];
        
        //拦截链接跳转到货源圈的动态详情
        if ([url rangeOfString:@"http"].location != NSNotFound)
        {
            //跳转到你想跳转的页面
            TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
            webViewVC.url = url;
            [NavController1 pushViewController:webViewVC animated:YES];
            [self close:nil];
            return NO; //返回NO，此页面的链接点击不会继续执行，只会执行跳转到你想跳转的页面
        }
        else{

            if ([url containsString:@"?"]) {
                
                [CMCommon goVCWithUrl:url];

                [self close:nil];
                return NO; //返回NO，此页面的链接点击不会继续执行，只会执行跳转到你想跳转的页面
                
            }
            
        }

        return NO;
    }
    return YES;
}

@end
