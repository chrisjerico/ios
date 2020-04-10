//
//  PromotePopView.m
//  ug
//
//  Created by ug on 2020/2/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromotePopView.h"
#import "UGPromoteModel.h"
#import "FLAnimatedImageView.h"
#import "SLWebViewController.h"
@interface PromotePopView ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation PromotePopView

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


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PromotePopView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        if (Skin1.isBlack||Skin1.is23) {
             self.backgroundColor = Skin1.bgColor;
            _titleLabel.textColor = Skin1.textColor4;
        } else {
             self.backgroundColor = [UIColor whiteColor];
            _titleLabel.textColor = Skin1.textColor1;
        }
        _activity.hidesWhenStopped = YES;
        _activity.color = [UIColor lightGrayColor];
        _myWebView.delegate = self;
        _myWebView.backgroundColor = Skin1.textColor4;
    }
    return self;
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
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
    
}

- (void)setItem:(UGPromoteModel *)item {
    _item = item;

    if ([CMCommon stringIsNull:_item.title]) {
        self.titleLabel.text = @"活动详情";
    } else {
        self.titleLabel.text = self.item.title;
    }

    [self.activity startAnimating];
    NSString *str = _NSString(@"<head><style>body{margin:0}img{width:auto !important;max-width:100%%;height:auto !important}</style></head>%@", self.item.content);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity stopAnimating];
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
@end