//
//  UGredActivityView.m
//  ug
//
//  Created by ug on 2019/9/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGredActivityView.h"
#import "UGRedEnvelopeModel.h"


@interface UGredActivityView ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *redButton;

@property (weak, nonatomic) IBOutlet UITextView *introTextView;

@end


@implementation UGredActivityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGredActivityView" owner:self options:0].firstObject;
        self.frame = frame;
        [self.introTextView setEditable:NO];
        [self.redButton setBackgroundColor:UGRGBColor(197, 88, 74)];
        //边框宽度,border:边框
        self.redButton.layer.borderWidth = 2; 
        self.redButton.layer.borderColor =  [UIColor whiteColor].CGColor;
        //将button的边框设置为圆角
        self.redButton.layer.cornerRadius = 3; 
        self.redButton.layer.masksToBounds = YES;
        
       
        
    }
    return self;
    
}

- (IBAction)cancelButtonClick:(id)sender {
    [self hiddenSelf];

}
- (IBAction)redButtonClick:(id)sender {
    if (self.redClickBlock) {
        self.redClickBlock();
    }
    [self activityGetRedBag];
}

- (void)setItem:(UGRedEnvelopeModel *)item {
    _item = item;
    self.usernameLabel.text = item.username;
    self.leftCountLabel.text = item.leftCount;
    self.leftAmountLabel.text = item.leftAmount;
    
    __weakSelf_(__self);
    NSString *str = [APP htmlStyleString:item.intro];
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
            __self.introTextView.attributedText = attStr;
        });
    });
    
    if (item.canGet) {
        [self.redButton setTitle:@"立即开抢" forState:UIControlStateNormal];
    } else if (item.attendedTimes) {
        [self.redButton setTitle:@"已参与活动" forState:UIControlStateNormal];
    } else {
        [self.redButton setTitle:@"立即开抢" forState:UIControlStateNormal];
    }
}


//领红包
- (void)activityGetRedBag{
    __weakSelf_(__self);
    UGUserModel *user = [UGUserModel currentUser];
    BOOL isLogin = UGLoginIsAuthorized();
    if (!isLogin) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        [self hiddenSelf];
        return ;
    }
    if (user.isTest) {
        UIAlertController *ac = [AlertHelper showAlertView:@"温馨提示" msg:@"请先登录您的正式账号" btnTitles:@[@"取消", @"马上登录"]];
        [ac setActionAtTitle:@"马上登录" handler:^(UIAlertAction *aa) {
            SANotificationEventPost(UGNotificationShowLoginView, nil);
            [__self hiddenSelf];
        }];
        return ;
    }
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"id":self.item.rid
                             };
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork activityGetRedBagWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
             [SVProgressHUD dismiss];
            
            NSString *count = (NSString *)model.data;
            
            NSString *str = [NSString stringWithFormat:@"恭喜您获得了%@元红包",count];
            
            if ([CMCommon stringIsNull:count]) {
                  [SVProgressHUD showSuccessWithStatus:model.msg];
            } else {
                [LEEAlert alert].config
                .LeeTitle(@"温馨提示")
                .LeeContent(str)
                .LeeAction(@"确定", ^{
                    
                    // 确认点击事件Block
                    [weakSelf hiddenSelf];
                })
                .LeeShow(); // 设置完成后 别忘记调用Show来显示
            }
            
          
            
           
            
            
            
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:msg];
            
                [weakSelf hiddenSelf];
        }];
    }];
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
