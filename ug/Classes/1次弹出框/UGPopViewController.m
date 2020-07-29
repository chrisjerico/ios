//
//  UGPopViewController.m
//  UGBWApp
//
//  Created by ug on 2020/7/20.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGPopViewController.h"

@interface UGPopViewController ()

@end

@implementation UGPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.content) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:_content];
        text.yy_font = [UIFont systemFontOfSize:17];
        NSError *error;
        NSDataDetector *dataDetector=[NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
        NSArray *arrayOfAllMatches=[dataDetector matchesInString:_content options:NSMatchingReportProgress range:NSMakeRange(0, _content.length)];
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
                [self dismissViewControllerAnimated:NO completion:^{
                    [CMCommon goUrl:[self.content substringWithRange:match.range]];
                }];
                
            }];
        }
        if (self.remarkLbl) {
            self.remarkLbl.attributedText = text;
        }
    }
}

-(IBAction)cancelBtnAction:(id)sender{
     NSLog(@"cancelBtnAction");
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}
-(IBAction)rightBtnAction:(id)sender{
     NSLog(@"rightBtnAction");
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

@end
