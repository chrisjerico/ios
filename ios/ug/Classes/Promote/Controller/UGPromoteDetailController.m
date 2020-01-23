//
//  UGPromoteDetailController.m
//  ug
//
//  Created by ug on 2019/6/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromoteDetailController.h"
#import "SLWebViewController.h"

#import "UGPromoteModel.h"

#import "FLAnimatedImageView.h"


@interface UGPromoteDetailController ()<UIWebViewDelegate>
@property (strong, nonatomic) UILabel *titleLabel;
//@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UIWebView *myWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation UGPromoteDetailController

- (BOOL)允许未登录访问 {
    if ([APP.SiteId isEqualToString:@"c049"]||[APP.SiteId isEqualToString:@"c008"]) {
         return false;
    } else {
         return true;
    }
}
- (BOOL)允许游客访问 {
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"活动详情";
    self.view.backgroundColor = Skin1.textColor4;
    self.contentTextView.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = Skin1.textColor1;
//    [self.view addSubview:self.titleLabel];
//    [self.view addSubview:self.contentTextView];
    [self.view addSubview:self.myWebView];
    [self.view addSubview:self.activity];

    // 点击查看更多
    if (_item.linkUrl.length) {
        FLAnimatedImageView *imgView = [FLAnimatedImageView new];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"点击查看更多" withExtension:@"gif"]];
        __weakSelf_(__self);
        [imgView addGestureTapEventHandle:^(id sender, UITapGestureRecognizer *gestureRecognizer) {
            SLWebViewController *vc = [SLWebViewController new];
            vc.urlStr = __self.item.linkUrl;
            [NavController1 pushViewController:vc animated:true];
        }];
        [self.view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottomMargin).offset(-10);
            make.width.mas_equalTo(250);
            make.height.mas_equalTo(50);
        }];
    }
}

- (void)setItem:(UGPromoteModel *)item {
    _item = item;
//    self.titleLabel.text = self.item.title;
    if ([CMCommon stringIsNull:self.item.title]) {
        self.navigationItem.title = @"活动详情";
    } else {
        self.navigationItem.title = self.item.title;
    }

    [self.activity startAnimating];
    NSString *str = [NSString stringWithFormat:@"<head><style > body{margin:0} img{width:auto !important;max-width:%f;height:auto}</style></head>%@", UGScreenW - 10, self.item.content];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,} documentAttributes:nil error:nil];
//        NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
//        ps.lineSpacing = 5;
//        [mas addAttributes:@{NSParagraphStyleAttributeName:ps,} range:NSMakeRange(0, mas.length)];
//
//        // 替换文字颜色
//        NSAttributedString *as = [mas copy];
//        for (int i=0; i<as.length; i++) {
//            NSRange r = NSMakeRange(0, as.length);
//            NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
//            UIColor *c = dict[NSForegroundColorAttributeName];
//            if (fabs(c.red - c.green) < 0.05 && fabs(c.green - c.blue) < 0.05) {
//                dict[NSForegroundColorAttributeName] = Skin1.textColor2;
//                [mas addAttributes:dict range:NSMakeRange(i, 1)];
//            }
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity stopAnimating];
//            self.contentTextView.attributedText = mas;
            // 加载本地HTML字符串
              [self.myWebView loadHTMLString:str baseURL:[[NSBundle mainBundle] bundleURL]];
        });
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (Skin1.isBlack) {
        // body.style默认字体色
        [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.color='#DDD'"];
        // body.style背景色
        [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.background='#171717'"];
        // 表格字体色、边框色
        [webView stringByEvaluatingJavaScriptFromString:@"\
           var eles = document.getElementsByTagName('table');\
           for (var i = 0; i < eles.length; i++) {\
               eles[i].setAttribute(\"style\", \"border: 0.5px solid white; background:#222\");\
           }"
        ];
        [webView stringByEvaluatingJavaScriptFromString:@"\
           var eles = document.getElementsByTagName('td');\
           for (var i = 0; i < eles.length; i++) {\
               eles[i].setAttribute(\"style\", \"color:#DDD; border: 0.5px solid white; background:#222\");\
           }"
        ];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat labelX = 5;
    CGFloat labelY = 15;
    CGFloat labelW = UGScreenW - 2*labelX;
    if (![@"c001" containsString:APP.SiteId]) {
        self.titleLabel.frame = CGRectMake(labelX, labelY, labelW, 0);
        [self.titleLabel sizeToFit];
    }
//    self.contentTextView.frame = CGRectMake(labelX, CGRectGetMaxY(self.titleLabel.frame) + 8, labelW, UGScerrnH - CGRectGetMaxY(self.titleLabel.frame) - 60 );
    
//    self.myWebView.frame = CGRectMake(labelX, CGRectGetMaxY(self.titleLabel.frame) + 8, labelW, UGScerrnH - CGRectGetMaxY(self.titleLabel.frame) - 60 );
    self.myWebView.frame = CGRectMake(labelX, labelY, labelW, UGScerrnH - CGRectGetMaxY(self.titleLabel.frame) - 60 );
    self.activity.center = CGPointMake(UGScreenW / 2, UGScerrnH / 2 - 50);

    
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]init];
        _contentTextView.font = [UIFont systemFontOfSize:17];
        [_contentTextView setEditable:NO];
    }
    return _contentTextView;
}

- (UIActivityIndicatorView *)activity {
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] init];
        _activity.hidesWhenStopped = YES;
        _activity.color = [UIColor lightGrayColor];
        
    }
    return _activity;
}

- (UIWebView *)myWebView
{
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc]init];
        _myWebView.delegate = self;
        _myWebView.backgroundColor = Skin1.textColor4;
//        [_myWebView setOpaque:NO];
    }
    return _myWebView;
}
@end
