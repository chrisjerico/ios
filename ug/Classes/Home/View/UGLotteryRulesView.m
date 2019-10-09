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
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
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
        self.sureButton.layer.cornerRadius = 6;
        self.sureButton.layer.masksToBounds = YES;
        
        [self.sureButton setBackgroundColor:[[UGSkinManagers shareInstance] setNavbgColor]];
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
    [CMNetwork getLotteryRuleWithParams:@{@"id":self.gameId} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            if (model.data) {
                NSString *str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",self.frame.size.width - 10,model.data];
                NSAttributedString *__block attStr = [[NSAttributedString alloc] init];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
                    ps.lineSpacing = 5;
                    ps.alignment = NSTextAlignmentLeft;
                    ps.firstLineHeadIndent = 10;
                    ps.headIndent = 10;
                    [attStr addAttributes:@{NSParagraphStyleAttributeName:ps} range:NSMakeRange(0, attStr.length)];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        self.contentTextView.attributedText = attStr;
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
