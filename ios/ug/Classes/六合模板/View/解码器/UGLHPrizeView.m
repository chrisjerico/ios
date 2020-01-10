//
//  UGLHPrizeView.m
//  ug
//
//  Created by ug on 2020/1/9.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGLHPrizeView.h"
#import "UGLHlotteryNumberModel.h"
#import "CMAudioPlayer.h"
#import "CountDown.h"

@interface UGLHPrizeView ()<UICollectionViewDelegate,UICollectionViewDataSource>
//六合开奖View
@property (weak, nonatomic) IBOutlet UIView *liuheResultContentView;                    /**<   六合开奖View*/
@property (weak, nonatomic) IBOutlet UILabel *lotteryTitleLabel;                        /**<   XX期开奖结果*/
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;                               /**<   咪*/
@property (weak, nonatomic) IBOutlet UICollectionView *lotteryCollectionView;           /**<  开奖的显示*/
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;                                /**<  开奖的时间显示*/
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;                           /**<  开奖的倒计时显示*/
@property (weak, nonatomic) IBOutlet UISwitch *lotteryUISwitch;                         /**<   六合switch*/
@property (weak, nonatomic) IBOutlet UIView *liuheForumContentView;                     /**<   六合板块View*/
@property (weak, nonatomic) IBOutlet UIImageView *hormImgV;                             /**<  喇叭图片*/
@property (weak, nonatomic) IBOutlet UILabel *lottyLabel;                               /**<  开奖提示文字*/
@property (nonatomic, strong) UGLHlotteryNumberModel *lhModel;
@property (strong, nonatomic)  CountDown *countDownForLabel;                            /**<   倒计时工具*/
@property (nonatomic)  BOOL hormIsOpen;                                                /**<  喇叭是否开启*/
@property (nonatomic,strong)  CMAudioPlayer *player ;                                  /**<  播放器*/
@property (strong, nonatomic) NSTimer *timer;
//--------------------------------------------
@end

@implementation UGLHPrizeView

- (instancetype)UGLHPrizeView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGLHPrizeView" owner:nil options:nil];
    return [objs firstObject];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        UGLHPrizeView *v = [[UGLHPrizeView alloc] initView];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (instancetype)initView {
    if (self = [super init]) {
        self = [self UGLHPrizeView];
    }
    return self;
}
@end
