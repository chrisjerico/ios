//
//  UGLotteryRulesView.m
//  ug
//
//  Created by ug on 2019/6/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryRulesView.h"

@interface UGLotteryRulesView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UITextView *contentTextView;


@end
@implementation UGLotteryRulesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGLotteryRulesView" owner:self options:0].firstObject;
        self.frame = frame;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;

        self.contentTextView.editable = NO;

    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentTextView.text = content;
}

- (void)setGameId:(NSString *)gameId {
    _gameId = gameId;
    [self getLotteryRule];
}

- (void)getLotteryRule {
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork getLotteryRuleWithParams:@{@"id":self.gameId} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            if (model.data) {
                NSString *str = [APP htmlStyleString:model.data];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
                    ps.lineSpacing = 5;
                    ps.alignment = NSTextAlignmentLeft;
                    ps.firstLineHeadIndent = 10;
                    ps.headIndent = 10;
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
                        [SVProgressHUD dismiss];
                        weakSelf.contentTextView.attributedText = mas;
                    });
                });
            } else {
                [SVProgressHUD dismiss];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

- (IBAction)sureClick:(id)sender {
    [self hiddenSelf];
}

- (void)show {
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    if (Skin1.isBlack) {
        [self setBackgroundColor:Skin1.bgColor];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.contentTextView setTextColor:[UIColor whiteColor]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.contentTextView setTextColor:[UIColor blackColor]];
    }
    
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
