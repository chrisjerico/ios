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
@end
