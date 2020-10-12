//
//  YNHLPrizeDetailView.m
//  UGBWApp
//
//  Created by ug on 2020/9/3.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNHLPrizeDetailView.h"
#import "CMLabelCommon.h"
@interface YNHLPrizeDetailView (){
     UIScrollView* maskView;
}
@property (weak, nonatomic) IBOutlet UIButton *submitButton;    /**<   确认下注Button */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;    /**<   取消Button */

@property (nonatomic) float amount; /**<   总金额*/
@end
@implementation YNHLPrizeDetailView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YNHLPrizeDetailView" owner:self options:0].firstObject;
        
        float h = 0;
        h = UGScerrnH - 300;
        if (h < 600) {
            h = 600;
        }
 
        self.size = CGSizeMake(UGScreenW - 50, h);
        self.center = CGPointMake(UGScreenW / 2 , UGScerrnH / 2);
        self.submitButton.layer.cornerRadius = 3;
        self.submitButton.layer.masksToBounds = YES;
        
        self.cancelButton.layer.cornerRadius = 3;
        self.cancelButton.layer.masksToBounds = YES;
        self.cancelButton.layer.borderColor = Skin1.bgColor.CGColor;
        self.cancelButton.layer.borderWidth = 0.7;

        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}


- (void)show {
    FastSubViewCode(self)
    if (Skin1.isBlack||Skin1.is23) {
        [self setBackgroundColor:Skin1.bgColor];

        [subLabel(@"标题Label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"特等奖label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"一等奖label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"二等奖label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"三等奖label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"四等奖label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"五等奖label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"六等奖label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"七等奖label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"尾巴label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"t0label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"t1label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"t2label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"t3label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"t4label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"t5label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"t6label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"t7label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"t8label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"t9label")setTextColor:[UIColor whiteColor]];
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
        [subLabel(@"标题Label")setTextColor:[UIColor blackColor]];
        [subLabel(@"特等奖label")setTextColor:[UIColor blackColor]];
        [subLabel(@"一等奖label")setTextColor:[UIColor blackColor]];
        [subLabel(@"二等奖label")setTextColor:[UIColor blackColor]];
        [subLabel(@"三等奖label")setTextColor:[UIColor blackColor]];
        [subLabel(@"四等奖label")setTextColor:[UIColor blackColor]];
        [subLabel(@"五等奖label")setTextColor:[UIColor blackColor]];
        [subLabel(@"六等奖label")setTextColor:[UIColor blackColor]];
        [subLabel(@"七等奖label")setTextColor:[UIColor blackColor]];
        [subLabel(@"尾巴label")setTextColor:[UIColor blackColor]];
        [subLabel(@"t0label")setTextColor:[UIColor blackColor]];
        [subLabel(@"t1label")setTextColor:[UIColor blackColor]];
        [subLabel(@"t2label")setTextColor:[UIColor blackColor]];
        [subLabel(@"t3label")setTextColor:[UIColor blackColor]];
        [subLabel(@"t4label")setTextColor:[UIColor blackColor]];
        [subLabel(@"t5label")setTextColor:[UIColor blackColor]];
        [subLabel(@"t6label")setTextColor:[UIColor blackColor]];
        [subLabel(@"t7label")setTextColor:[UIColor blackColor]];
        [subLabel(@"t8label")setTextColor:[UIColor blackColor]];
        [subLabel(@"t9label")setTextColor:[UIColor blackColor]];
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    
        [CMLabelCommon messageAction:subLabel(@"特等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor]];
        [CMLabelCommon messageAction:subLabel(@"一等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor]];
        [CMLabelCommon messageAction:subLabel(@"二等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor]];
        [CMLabelCommon messageAction:subLabel(@"三等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor]];
        [CMLabelCommon messageAction:subLabel(@"四等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor]];
        [CMLabelCommon messageAction:subLabel(@"五等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor]];
        [CMLabelCommon messageAction:subLabel(@"六等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor]];
        [CMLabelCommon messageAction:subLabel(@"七等奖label") labStr:@"" separation:@"-" length:4 andMarkColor:[UIColor redColor]];
        [CMLabelCommon messageAction:subLabel(@"八等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor]];

    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* view = self;
    if (!maskView) {
        maskView = [[UIScrollView alloc] initWithFrame:window.bounds];
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [maskView addSubview:view];
        [window addSubview:maskView];
    }
    
    view.hidden = NO;
  
}

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
}

- (IBAction)cancelClick:(id)sender {
    
    [self hiddenSelf];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (IBAction)submitClick:(id)sender {
    [self hiddenSelf];
    if (self.betClickBlock) {
        self.betClickBlock();
    }
}


-(void)setNextIssueModel:(UGNextIssueModel *)nextIssueModel{
    _nextIssueModel = nextIssueModel;
    FastSubViewCode(self)
    [subLabel(@"特等奖label") setText:_nextIssueModel.d0];
    [subLabel(@"一等奖label") setText:_nextIssueModel.d1];
    [subLabel(@"二等奖label")setText: [_nextIssueModel.d2 stringByReplacingOccurrencesOfString:@"," withString:@"-"]];
    [subLabel(@"三等奖label")setText:[_nextIssueModel.d3 stringByReplacingOccurrencesOfString:@"," withString:@"-"]];
    [subLabel(@"四等奖label")setText:[_nextIssueModel.d4 stringByReplacingOccurrencesOfString:@"," withString:@"-"]];
    [subLabel(@"五等奖label")setText:[_nextIssueModel.d5 stringByReplacingOccurrencesOfString:@"," withString:@"-"]];
    [subLabel(@"六等奖label")setText:[_nextIssueModel.d6 stringByReplacingOccurrencesOfString:@"," withString:@"-"]];
    [subLabel(@"七等奖label")setText:[_nextIssueModel.d7 stringByReplacingOccurrencesOfString:@"," withString:@"-"]];
    [subLabel(@"t0label")setText:_nextIssueModel.t0];
    [subLabel(@"t1label")setText:_nextIssueModel.t1];
    [subLabel(@"t2label")setText:_nextIssueModel.t2];
    [subLabel(@"t3label")setText:_nextIssueModel.t3];
    [subLabel(@"t4label")setText:_nextIssueModel.t4];
    [subLabel(@"t5label")setText:_nextIssueModel.t5];
    [subLabel(@"t6label")setText:_nextIssueModel.t6];
    [subLabel(@"t7label")setText:_nextIssueModel.t7];
    [subLabel(@"t8label")setText:_nextIssueModel.t8];
    [subLabel(@"t9label")setText:_nextIssueModel.t9];
    

    
    
}
@end
