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
#import "UGMosaicGoldViewController.h"

@interface UGPromoteDetailController ()<UIWebViewDelegate>

@property (nonatomic, assign) CGFloat labelH;
@property (nonatomic, assign) CGFloat ImgH;
@property (nonatomic, assign) CGFloat webH;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIScrollView *mUIScrollView;

@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIWebView *myWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) FLAnimatedImageView *mimgView;

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
    
    _labelH = 1;
    _ImgH = 1;
    _webH = 1500;
    //-滚动面版======================================
    if (_mUIScrollView == nil) {
        UIScrollView *mUIScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, UGScreenW , UGScerrnH -IPHONE_SAFEBOTTOMAREA_HEIGHT-k_Height_NavBar)];
        mUIScrollView.showsHorizontalScrollIndicator = NO;//不显示水平拖地的条
        mUIScrollView.showsVerticalScrollIndicator=YES;//不显示垂直拖动的条
        mUIScrollView.bounces = NO;//到边了就不能再拖地
        //UIScrollView被push之后返回，会发生控件位置偏移，用下面的代码就OK
        //        self.automaticallyAdjustsScrollViewInsets = NO;
        //        self.edgesForExtendedLayout = UIRectEdgeNone;
        mUIScrollView.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:mUIScrollView];
        self.mUIScrollView = mUIScrollView;
        
        [_mUIScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.left.equalTo(self.view);
        }];
    }
    
    self.view.backgroundColor = Skin1.textColor4;
    self.contentTextView.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = Skin1.textColor1;
    
    [self.mUIScrollView addSubview:self.titleLabel];
    [self.mUIScrollView addSubview:self.myWebView];
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
    [self setViewContr];
}

- (void)setItem:(UGPromoteModel *)item {
    _item = item;
    
    if (APP.isYHShowTitle) {
        
        if ([CMCommon stringIsNull:self.item.title]) {
            self.titleLabel.text = @"活动详情";
        } else {
            self.titleLabel.text = self.item.title;
        }
        self.navigationItem.title = @"活动详情";
    }
    else{
        [self.titleLabel setHidden:YES];
        if ([CMCommon stringIsNull:self.item.title]) {
            self.navigationItem.title = @"活动详情";
        } else {
            self.navigationItem.title = self.item.title;
        }
    }
    
    
    __weakSelf_(__self);
    [self.activity startAnimating];
    NSString *str = _NSString(@"<head><style>body{margin:0}img{width:auto !important;max-width:100%%;height:auto !important}</style></head>%@", self.item.content);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [__self.activity stopAnimating];
            //            __self.contentTextView.attributedText = mas;
            // 加载本地HTML字符串
            [__self.myWebView loadHTMLString:str baseURL:[[NSBundle mainBundle] bundleURL]];
            
            
        });
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (Skin1.isBlack||Skin1.is23) {
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

-(void)setViewContr{
    
       CGFloat labelX = 10;
       CGFloat labelY = 8;
       CGFloat labelW = UGScreenW - 2*labelX;
       if (![@"c001" containsString:APP.SiteId]) {
           self.titleLabel.frame = CGRectMake(labelX, labelY, labelW, 0);
           [self.titleLabel sizeToFit];
           
       }
       if (APP.isYHShowTitle) {
           self.titleLabel.frame = CGRectMake(labelX, labelY, labelW, 0);
           [self.titleLabel sizeToFit];
           [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
               make.centerX.equalTo(self.view);
               make.top.equalTo(self.view.mas_top).offset(labelY);
           }];
           
           _labelH = [_titleLabel.text heightForFont:[UIFont systemFontOfSize:17] width:labelW] + 16;
           
       }
       
       // 图片
       if (_item.pic.length) {
           FLAnimatedImageView *imgView = [FLAnimatedImageView new];
           _mimgView = imgView;
           imgView.contentMode = UIViewContentModeScaleAspectFit;
           NSURL *url = [NSURL URLWithString:_item.pic];
           UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
           if (image) {
               
               CGFloat w = labelW;
               CGFloat h = image.height/image.width * w;
               imgView.cc_constraints.height.constant = h;
               [imgView sd_setImageWithURL:url];   // 由于要支持gif动图，还是用sd加载
               
               [self.mUIScrollView addSubview:imgView];
               [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.centerX.equalTo(self.view);
                   make.top.equalTo(_titleLabel.mas_bottom).offset(labelY);
                   make.width.mas_equalTo(labelW);
                   make.height.mas_equalTo(h);
               }];
               
               _ImgH = h+8;
               
           }
       }
       
       
       if (self.item.content.length) {
           
           
           if (APP.isYHShowTitle) {
               if (_item.pic.length) {
                   [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.centerX.equalTo(self.view);
                       make.top.equalTo(_mimgView.mas_bottom).offset(labelY);
                       make.width.mas_equalTo(labelW);
//                       make.height.mas_equalTo(webH);
                        make.bottom.equalTo(self.view.mas_bottom).offset(IPHONE_SAFEBOTTOMAREA_HEIGHT);
                   }];
               } else {
                   [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.centerX.equalTo(self.view);
                       make.top.equalTo(_titleLabel.mas_bottom).offset(labelY);
                       make.width.mas_equalTo(labelW);
                      make.bottom.equalTo(self.view.mas_bottom).offset(IPHONE_SAFEBOTTOMAREA_HEIGHT);
                   }];
               }
               
           }
           else{
               if (_item.pic.length) {
                   [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.centerX.equalTo(self.view);
                       make.top.equalTo(_mimgView.mas_bottom).offset(labelY);
                       make.width.mas_equalTo(labelW);
                       make.bottom.equalTo(self.view.mas_bottom).offset(IPHONE_SAFEBOTTOMAREA_HEIGHT);
                   }];
               } else {
                   [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.centerX.equalTo(self.view);
                       make.top.equalTo(self.view.mas_top).offset(labelY);
                       make.width.mas_equalTo(labelW);
                       make.bottom.equalTo(self.view.mas_bottom).offset(IPHONE_SAFEBOTTOMAREA_HEIGHT);
                   }];
               }
           }
           
       }
       self.mUIScrollView.contentSize = CGSizeMake(APP.Width, 3000);
       self.activity.center = CGPointMake(UGScreenW / 2, UGScerrnH / 2 - 50);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];


}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    __weakSelf_(__self);
    if ([keyPath isEqualToString:@"contentSize"]) {
        NSLog(@"得到监听");
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat contentHeight  = __self.myWebView.scrollView.contentSize.height;
//            __self.myWebView.cc_constraints.height.constant = contentHeight;
//            __self.webH = contentHeight =3000;
//            __self.myWebView.scrollView.scrollEnabled = NO;
            __self.mUIScrollView.contentSize = CGSizeMake(APP.Width, __self.labelH + __self.ImgH + contentHeight +110);
            __self.mUIScrollView.scrollEnabled = YES;
            NSLog(@"WebcontentHeight= %f",contentHeight);
            NSLog(@"web.fromH = %f",__self.myWebView.frame.size.height);
            NSLog(@"self.mUIScrollView.contentSize = %f",__self.mUIScrollView.contentSize.height);
              NSLog(@"self.mUIScrollView.fromH = %f",__self.mUIScrollView.frame.size.height);

        });

    }
    
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
        [_myWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _myWebView;
}

-(void)dealloc{
    [_myWebView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    
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

            return NO; //返回NO，此页面的链接点击不会继续执行，只会执行跳转到你想跳转的页面
        }
        else{

            if ([url containsString:@"?"]) {
                
                [CMCommon goVCWithUrl:url];

                return NO; //返回NO，此页面的链接点击不会继续执行，只会执行跳转到你想跳转的页面
                
            }
            
        }

        return NO;
    }
    return YES;
}
@end
