//
//  SinglePopView.m
//  UGBWApp
//
//  Created by andrew on 2020/7/20.
//  Copyright © 2020 ug. All rights reserved.
//

#import "SinglePopView.h"
#import "SGBrowserView.h"
@interface SinglePopView()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet mYYLabel *yyLabel;

@end

@implementation SinglePopView

static SinglePopView *singlePopView = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singlePopView = [[self alloc] init];
    });
    return singlePopView;
    
}

- (instancetype)init
{
    CGRect frame = CGRectMake(0,0, UGScreenW, UGScreenW*(200.0/375.0));
    self = [super initWithFrame:frame];
    if (self) {
       
        self.contentView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];//(owner:self ，firstObject必要)
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
    }
    return self;
}

- (IBAction)closeBtnClick:(id)sender {
    [SGBrowserView hide];
}

-(void)setContent:(NSString *)content{
    _content = content;
     NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:content];
        text.yy_font = [UIFont systemFontOfSize:17];
        NSError *error;
        NSDataDetector *dataDetector=[NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
        NSArray *arrayOfAllMatches=[dataDetector matchesInString:wholeText options:NSMatchingReportProgress range:NSMakeRange(0, wholeText.length)];
        //NSMatchingOptions匹配方式也有好多种，我选择NSMatchingReportProgress，一直匹配
    
      //我们得到一个数组，这个数组中NSTextCheckingResult元素中包含我们要找的URL的range，当然可能找到多个URL，找到相应的URL的位置，用YYlabel的高亮点击事件处理跳转网页
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
            //        NSLog(@"%@",NSStringFromRange(match.range));
            [text yy_setTextHighlightRange:match.range//设置点击的位置
                                     color:[UIColor orangeColor]
                           backgroundColor:[UIColor whiteColor]
                                 tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                     NSLog(@"这里是点击事件");
                                     //跳转用的WKWebView
                                     WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
                                     [self.view addSubview:webView];
                                     [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[wholeText substringWithRange:match.range]]]];
                                     
                                 }];
        }
        self.yyLabel.attributedText = text;
   
 
}
@end
