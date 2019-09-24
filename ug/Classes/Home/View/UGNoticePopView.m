//
//  UGNoticePopView.m
//  ug
//
//  Created by ug on 2019/6/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGNoticePopView.h"

@interface UGNoticePopView ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextV;

@end
@implementation UGNoticePopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGNoticePopView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.contentTextV.editable = NO;
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    NSString *str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",self.frame.size.width - 5,content];
    NSAttributedString *__block attStr = [[NSAttributedString alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         attStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
         dispatch_async(dispatch_get_main_queue(), ^{
            self.contentTextV.attributedText = attStr;
        });
    });
    
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

@end
