//
//  UGXNTutorialsViewController.m
//  UGBWApp
//
//  Created by fish on 2020/9/30.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGXNTutorialsViewController.h"

@interface UGXNTutorialsViewController ()<UIWebViewDelegate,SyyRadioButtonDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *mWebView;
@property (strong, nonatomic) NSMutableArray *buttons;
@end

@implementation UGXNTutorialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _buttons = [NSMutableArray new];
    self.mWebView.delegate = self;
    [self.mWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#FFFFFF'"];
    [self loadHtml:@"1"];
    WeakSelf;
    FastSubViewCode(self.view);
    [subButton(@"概括button") setTitleColor:[UIColor redColor] forState:0];
    [_buttons addObject:subButton(@"安装button")];
    [_buttons addObject:subButton(@"概括button")];
    [_buttons addObject:subButton(@"注册button")];
    [_buttons addObject:subButton(@"身份button")];
    [_buttons addObject:subButton(@"网站button")];
    [_buttons addObject:subButton(@"钱包button")];
    [_buttons addObject:subButton(@"购买button")];
    
    subButton(@"安装button").titleLabel.lineBreakMode = NSLineBreakByWordWrapping;

    subButton(@"安装button").titleLabel.numberOfLines = 2;
    [subButton(@"安装button") setTitle:@"安装虚拟\n币钱包" forState:0];
    
    
    
    [CMCommon setBorderWithView:subView(@"按钮view") top:NO left:YES bottom:NO right:YES borderColor:RGBA(252, 223, 224, 1) borderWidth:1.0];
    [subButton(@"概括button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"概括button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [weakSelf selectButtonSetRedColor:sender];
        [weakSelf loadHtml:@"1"];
    }];
    [subButton(@"安装button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"安装button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [weakSelf selectButtonSetRedColor:sender];
        [weakSelf loadHtml:@"2"];
    }];
    [subButton(@"注册button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"注册button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [weakSelf selectButtonSetRedColor:sender];
        [weakSelf loadHtml:@"3"];
    }];
    [subButton(@"身份button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"身份button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [weakSelf selectButtonSetRedColor:sender];
        [weakSelf loadHtml:@"4"];
    }];
    [subButton(@"购买button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"购买button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [weakSelf selectButtonSetRedColor:sender];
        [weakSelf loadHtml:@"5"];
    }];
    [subButton(@"网站button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"网站button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [weakSelf selectButtonSetRedColor:sender];
        [weakSelf loadHtml:@"6"];
    }];
    [subButton(@"钱包button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"钱包button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        [weakSelf selectButtonSetRedColor:sender];
        [weakSelf loadHtml:@"7"];
    }];
}

-(void)selectButtonSetRedColor:(UIControl *)sender{
    [self allButtonSetTitleBlackColor];
    UIButton *btn = (UIButton *)sender;
    [btn setTitleColor:[UIColor redColor] forState:0];
}

- (void)allButtonSetTitleBlackColor {
    // UIButton
    for (UIView *v in self.buttons) {
        if ([ v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            [btn setTitleColor:[UIColor blackColor] forState:0];
        }
    }
}


-(void)loadHtml:(NSString *)file{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:file ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.mWebView loadHTMLString:_NSString(@"<head><style>p{margin:0;padding:0}img{width:auto !important;max-width:100%%;height:auto !important}</style></head>%@", htmlCont) baseURL:baseURL];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.mWebView.backgroundColor = [UIColor clearColor];
    [self.mWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#FFFFFF'"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
