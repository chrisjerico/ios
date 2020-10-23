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
#import "UGMosaicGoldViewController.h"
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
		if ([APP.SiteId isEqualToString:@"c198"]){

		} else if (Skin1.isBlack||Skin1.is23||Skin1.isGPK) {
             self.backgroundColor = Skin1.bgColor;
            _titleLabel.textColor = Skin1.textColor4;
        } else {
             self.backgroundColor = RGBA(240, 243, 246, 1);
            _titleLabel.textColor = Skin1.textColor1;
        }
        _activity.hidesWhenStopped = YES;
        _activity.color = [UIColor lightGrayColor];
        _myWebView.delegate = self;
        _myWebView.backgroundColor = Skin1.textColor4;
        _myWebView.scalesPageToFit=YES;
        _myWebView.multipleTouchEnabled=YES;
        _myWebView.userInteractionEnabled=YES;
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
	if ([APP.SiteId isEqualToString:@"c198"]){
		//编号：	126813
		//标题：	ios】公告不依后台设置显示 【普通】
	} else if (Skin1.isBlack) {
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
    
    NSString *meta = [NSString stringWithFormat:@"var meta = document.createElement('meta');meta.content='width=device-width,initial-scale=1.0,minimum-scale=.5,maximum-scale=3';meta.name='viewport';document.getElementsByTagName('head')[0].appendChild(meta);"];
    [_myWebView stringByEvaluatingJavaScriptFromString:meta];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{//判断是否是单击
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
