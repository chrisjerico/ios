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
    self.introTextView.text = item.intro;
    
}


//领红包
- (void)activityGetRedBag{
    
    //    NSString *date = @"2019-09-04";
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"id":self.item.rid
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork activityGetRedBagWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD showSuccessWithStatus:model.msg];
            
                [self hiddenSelf];
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
                [self hiddenSelf];
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
