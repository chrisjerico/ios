//
//  TKLPlatformNotiveView.m
//  UGBWApp
//
//  Created by ug on 2020/9/6.
//  Copyright © 2020 ug. All rights reserved.
//

#import "TKLPlatformNotiveView.h"
#import "TKLPlatformNoticeCell.h"

@interface TKLPlatformNotiveView ()<UITableViewDelegate,UITableViewDataSource, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIWebView *mWebView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TKLPlatformNotiveView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self = [[NSBundle mainBundle] loadNibNamed:@"TKLPlatformNotiveView" owner:self options:0].firstObject;
        self.frame = frame;
     
    
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        [CMCommon setBorderWithView:self.tableView top:NO left:NO bottom:NO right:YES borderColor:RGBA(232, 232, 232, 1) borderWidth:1];
        [self.tableView registerNib:[UINib nibWithNibName:@"TKLPlatformNoticeCell" bundle:nil] forCellReuseIdentifier:@"TKLPlatformNoticeCell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;

        self.mWebView.delegate = self;
    }
    return self;
    
}


- (void)setDataArray:(NSArray<UGNoticeModel *> *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
    
    UGNoticeModel *nm = self.dataArray[0];
    if ([@"c200,c190" containsString:APP.SiteId]) {
        [self.mWebView loadHTMLString:_NSString(@"<head><style>p{margin:0;padding:0}img{width:auto !important;max-width:100%%;height:auto !important}</style></head>%@", nm.content) baseURL:nil];
    } else {
        [self.mWebView loadHTMLString:[APP htmlStyleString:nm.content] baseURL:nil];
    }
    
    if(_dataArray.count>0)
    {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];//实现点击第一行所调用的方法
    }
}


- (IBAction)close:(id)sender {
    [self hiddenSelf];
}

- (void)show {

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TKLPlatformNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TKLPlatformNoticeCell" forIndexPath:indexPath];
    UGNoticeModel *nm = self.dataArray[indexPath.row];
    cell.titleLabel.text = nm.title;
//    2.自定义UITableViewCell选中后的背景颜色和背景图片
    //修改背景颜色
    UIView *backgroundViews = [[UIView alloc]initWithFrame:cell.frame];
    backgroundViews.backgroundColor = RGBA(49, 120, 273, 1);
    [cell setSelectedBackgroundView:backgroundViews];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGNoticeModel *nm = self.dataArray[indexPath.row];
    if ([@"c200,c190" containsString:APP.SiteId]) {
        [self.mWebView loadHTMLString:_NSString(@"<head><style>p{margin:0;padding:0}img{width:auto !important;max-width:100%%;height:auto !important}</style></head>%@", nm.content) baseURL:nil];
    } else {
        [self.mWebView loadHTMLString:[APP htmlStyleString:nm.content] baseURL:nil];
    }
}

#pragma ---- UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //改变背景颜色
    self.mWebView.backgroundColor = [UIColor clearColor];
    [self.mWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#FFFFFF'"];
    
    //便可实现手势缩放，如果user-scalable=no,就会关闭手势缩放功能
    NSString*injectionJSString =@"var script = document.createElement('meta');\script.name = 'viewport';script.content=\"width=device-width, initial-scale=1.0,maximum-scale=3.0, minimum-scale=1.0, user-scalable=yes\";document.getElementsByTagName('head')[0].appendChild(script);";
    [self.mWebView stringByEvaluatingJavaScriptFromString:injectionJSString];

}
@end
