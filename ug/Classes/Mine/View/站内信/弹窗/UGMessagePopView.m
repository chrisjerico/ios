//
//  UGMessagePopView.m
//  UGBWApp
//
//  Created by fish on 2020/10/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGMessagePopView.h"
@interface UGMessagePopView ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
@implementation UGMessagePopView
- (BOOL)允许未登录访问 {
    return true;
}
- (BOOL)允许游客访问 {
    return true;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGMessagePopView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        if (Skin1.isBlack||Skin1.is23||Skin1.isGPK) {
             self.backgroundColor = Skin1.bgColor;
        } else {
             self.backgroundColor = [UIColor whiteColor];
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

-(void)setContent:(NSString *)content{
    _content = content;
    [self.activity startAnimating];
    NSString *str = _NSString(@"<head><style>body{margin:0}img{width:auto !important;max-width:100%%;height:auto !important}</style></head>%@", _content);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity stopAnimating];
            // 加载本地HTML字符串
              [self.myWebView loadHTMLString:str baseURL:[[NSBundle mainBundle] bundleURL]];
        });
    });
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (Skin1.isBlack||Skin1.is23||Skin1.isGPK) {
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
            if (self.closeBlock) self.closeBlock();
            return NO; //返回NO，此页面的链接点击不会继续执行，只会执行跳转到你想跳转的页面
        }
        else{

            if ([url containsString:@"?"]) {
                
                [CMCommon goVCWithUrl:url];

                if (self.closeBlock) self.closeBlock();
                return NO; //返回NO，此页面的链接点击不会继续执行，只会执行跳转到你想跳转的页面
                
            }
            
        }

        return NO;
    }
    return YES;
}




@end
