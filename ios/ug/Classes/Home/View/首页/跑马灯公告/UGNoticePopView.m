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
        if (Skin1.isBlack) {
             self.backgroundColor = Skin1.bgColor;
            _titleLabel.textColor = Skin1.textColor1;
        } else {
             self.backgroundColor = [UIColor whiteColor];
            _titleLabel.textColor = Skin1.textColor1;
        }
       
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    NSString *str = [APP htmlStyleString:content];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
        ps.lineSpacing = 5;
        if ([@"c134" containsString:APP.SiteId]) {
            ps.paragraphSpacing = 5;
        }

        [mas addAttributes:@{NSParagraphStyleAttributeName:ps,} range:NSMakeRange(0, mas.length)];
        // 替换文字颜色
        NSAttributedString *as = [mas copy];
        for (int i=0; i<as.length; i++) {
            NSRange r = NSMakeRange(0, as.length);
            NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
            UIColor *c = dict[NSForegroundColorAttributeName];
            if (fabs(c.red - c.green) < 0.05 && fabs(c.green - c.blue) < 0.05) {
                dict[NSForegroundColorAttributeName] = Skin1.textColor2;
                [mas addAttributes:dict range:NSMakeRange(i, 1)];
            }
        }
         dispatch_async(dispatch_get_main_queue(), ^{
            self.contentTextV.attributedText = mas;
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
