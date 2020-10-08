//
//  HelpDocViewController.m
//  UGBWApp
//
//  Created by fish on 2020/10/6.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HelpDocViewController.h"

@interface HelpDocViewController ()<UIWebViewDelegate>
{
    float btnH;
}
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnViewWidth;
@property (weak, nonatomic) IBOutlet UIWebView *mWebView;
@property (weak, nonatomic) IBOutlet UIStackView *nameStack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackHeight;
@property (strong, nonatomic) NSMutableArray *buttons;
@end

@implementation HelpDocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _buttons = [NSMutableArray new];
    self.mWebView.delegate = self;
    [self.mWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#FFFFFF'"];
    [CMCommon setBorderWithView:_btnView top:NO left:YES bottom:NO right:YES borderColor:RGBA(252, 223, 224, 1) borderWidth:1.0];
    btnH = 44.0;
    
    if (self.webName.length) {
        self.btnViewWidth.constant = 0.0;
        [self loadHtml:self.webName];
    } else {
        self.btnViewWidth.constant = 80.0;
        if(self.itemArry.count){
            [self resetData];
        }
        else{
            self.stackHeight.constant = 0.0;
        }
    }
    
 
}

-(void)resetData{

    [self cleanAllStack];
    for (NSInteger i = 0; i < _itemArry.count; i++) {
        HelpDocModel * item = _itemArry[i];
        WeakSelf
        [self bindButtonTitle:item.btnTitle Action:^(UIButton *button) {
            [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                [weakSelf selectButtonSetRedColor:sender];
                [weakSelf loadHtml:item.webName];
            }];
        }];
    }
    UIButton *btnOne = [_buttons objectAtIndex:0];
    [btnOne setTitleColor:[UIColor redColor] forState:0];
    HelpDocModel * itemOne = _itemArry[0];
    [self loadHtml:itemOne.webName];
    self.stackHeight.constant = _itemArry.count *  btnH;
    
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

- (void)cleanAllStack {
    NSArray * allStack = @[self.nameStack];
    for (UIStackView * stack in allStack) {
        for (UIView * view in stack.arrangedSubviews) {
            [stack removeArrangedSubview:view];
            [view removeFromSuperview];
        }
    }
}

- (void)bindButtonTitle:(NSString *)content Action: (void (^)(UIButton *)) handle{
    UIView * view = [UIView new];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:content forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.numberOfLines = 2;
    [button setTitleColor:[UIColor blackColor] forState:0];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
        make.height.mas_equalTo(btnH);
    }];
    [self.nameStack addArrangedSubview:view];
    [_buttons addObject:button];
    handle(button);
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

#pragma ---- UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.mWebView.backgroundColor = [UIColor clearColor];
    [self.mWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#FFFFFF'"];
}

@end


