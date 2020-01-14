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

#import "UGScratchMusicView.h"
#import "SGBrowserView.h"
#import "CMTimeCommon.h"
#import "CMLabelCommon.h"
#import "UGLHLotteryCollectionViewCell.h"
#import "UGLotteryRecordController.h"

@interface UGLHPrizeView ()<UICollectionViewDelegate,UICollectionViewDataSource>
//六合开奖View
@property (weak, nonatomic) IBOutlet UIView *liuheResultContentView;                    /**<   六合开奖View*/
@property (weak, nonatomic) IBOutlet UILabel *lotteryTitleLabel;                        /**<   XX期开奖结果*/
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;                               /**<   咪*/
@property (weak, nonatomic) IBOutlet UICollectionView *lotteryCollectionView;           /**<  开奖的显示*/
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;                                /**<  开奖的时间显示*/
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;                           /**<  开奖的倒计时显示*/
@property (weak, nonatomic) IBOutlet UISwitch *lotteryUISwitch;                         /**<   六合switch*/
@property (weak, nonatomic) IBOutlet UIImageView *hormImgV;                             /**<  喇叭图片*/
@property (weak, nonatomic) IBOutlet UILabel *lottyLabel;                               /**<  开奖提示文字*/
@property (nonatomic, strong) UGLHlotteryNumberModel *lhModel;

@property (nonatomic)  BOOL hormIsOpen;                                                /**<  喇叭是否开启*/
@property (nonatomic,strong)  CMAudioPlayer *player ;                                  /**<  播放器*/

//--------------------------------------------
@end

@implementation UGLHPrizeView

- (void)dealloc {
    [_countDownForLabel destoryTimer];
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

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
        //六合开奖
        
        _hormIsOpen = YES;
        [_lotteryUISwitch setOn:SysConf.lhcdocMiCard] ;
        _countDownForLabel = [[CountDown alloc] init];
        _player = [[CMAudioPlayer alloc] init];
        self.lotteryCollectionView.backgroundColor = [UIColor whiteColor];
        self.lotteryCollectionView.dataSource = self;
        self.lotteryCollectionView.delegate = self;
        self.lotteryCollectionView.tagString= @"六合开奖";
        [self.lotteryCollectionView setBounces:NO];
        [self.lotteryCollectionView setScrollEnabled:NO];
        [self.lotteryCollectionView registerNib:[UINib nibWithNibName:@"UGLHLotteryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGLHLotteryCollectionViewCell"];
        [self.lotteryUISwitch setOn:SysConf.lhcdocMiCard] ;
        [self getLotteryNumberList];
    }
    return self;
}

#pragma mark UICollectionView datasource
////组个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//组内成员个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int rows = 0;
   
    if (_lhModel.numbersArrary.count<5) {
        rows = (int)_lhModel.numbersArrary.count;
    } else {
        rows = (int)_lhModel.numbersArrary.count+1;
    }
    
    return rows;
}

//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     {
        //六合开奖
        UGLHLotteryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLHLotteryCollectionViewCell" forIndexPath:indexPath];
        FastSubViewCode(cell);
        if (indexPath.row <= 5) {
            subLabel(@"球下字").text =  [_lhModel.numSxArrary objectAtIndex:indexPath.row];
            subLabel(@"球内字").text =  [_lhModel.numbersArrary objectAtIndex:indexPath.row];
            [subImageView(@"球图") setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", [_lhModel.numColorArrary objectAtIndex:indexPath.row]]]];
        }
        if (indexPath.row == 7) {
            subLabel(@"球下字").text =  [_lhModel.numSxArrary objectAtIndex:indexPath.row-1];
            subLabel(@"球内字").text =  [_lhModel.numbersArrary objectAtIndex:indexPath.row-1];
            [subImageView(@"球图") setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", [_lhModel.numColorArrary objectAtIndex:indexPath.row-1]]]];
        }
        

        if (indexPath.row == 6) {
            subImageView(@"球图").hidden = YES;
            subLabel(@"球内字").hidden = YES;
            subLabel(@"加").hidden = NO;
            subLabel(@"球下字").hidden = YES;
            subButton(@"刮刮乐").hidden = YES;
        }
        else if (self.lotteryUISwitch.isOn&&indexPath.row == 7) {
            subImageView(@"球图").hidden = YES;
            subLabel(@"球内字").hidden = YES;
            subLabel(@"加").hidden = NO;
            subLabel(@"球下字").hidden = YES;
            subButton(@"刮刮乐").hidden = NO;
            [subButton(@"刮刮乐") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                NSLog(@"---");
                NSString *imgStr = [NSString stringWithFormat:@"icon_%@",[self->_lhModel.numColorArrary objectAtIndex:indexPath.row-1]];
                NSString *titileStr = [self->_lhModel.numbersArrary objectAtIndex:indexPath.row-1];
                NSString *titile2Str = [self->_lhModel.numSxArrary objectAtIndex:indexPath.row-1];
                UGScratchMusicView *inviteView = [[UGScratchMusicView alloc] initViewWithImgStr:imgStr upTitle:titileStr downTitle:titile2Str bgColor:[self->_lhModel.numColorArrary objectAtIndex:indexPath.row-1]];
                [SGBrowserView showMoveView:inviteView];
            }];
        }
        else {
            subImageView(@"球图").hidden = NO;
            subLabel(@"球内字").hidden = NO;
            subLabel(@"加").hidden = YES;
            subLabel(@"球下字").hidden = NO;
            subButton(@"刮刮乐").hidden = YES;
        }
        [cell setBackgroundColor: [UIColor whiteColor]];
        return cell;
    }
}

////cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        CGSize size = {40, 70};
        return size;
}
////item偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

////六合开奖  当前开奖信息
- (void)getLotteryNumberList {

    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork lotteryNumberWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            self.lhModel = nil;
            NSLog(@"model= %@",model.data);
            self.lhModel = (UGLHlotteryNumberModel *)model.data;
            self.lhModel.numSxArrary = [self->_lhModel.numSx componentsSeparatedByString:@","];
            self.lhModel.numbersArrary = [self->_lhModel.numbers componentsSeparatedByString:@","];
            self.lhModel.numColorArrary = [self->_lhModel.numColor componentsSeparatedByString:@","];
            NSLog(@"count = %lu",(unsigned long)self->_lhModel.numbersArrary.count);
            
            
            NSLog(@"lotteryStr = %@",self.lhModel.lotteryStr);
            
            if ([CMCommon stringIsNull:self.lhModel.lotteryStr]) {
                if (self.lhModel.numbersArrary.count) {
                    [self.lottyLabel setHidden:YES];
                    [self.lotteryCollectionView reloadData];
                }
            }
            else{
                self.lottyLabel.text = self.lhModel.lotteryStr;
                [self.lottyLabel setHidden:NO];
                
            }

#ifdef DEBUG
//            [self testKaiJiang];
//            return ;
#endif
            
            NSString *nper = [self.lhModel.issue  substringFromIndex:4];
            if ([CMCommon stringIsNull:self.lhModel.lhcdocLotteryNo]) {
                self.lotteryTitleLabel.text = [NSString stringWithFormat:@"第%@期开奖结果",nper];
            } else {
                self.lotteryTitleLabel.text = [NSString stringWithFormat:@"第%@期开奖结果",self.lhModel.lhcdocLotteryNo];
            }
            
            [CMLabelCommon setRichNumberWithLabel:self.lotteryTitleLabel Color:[UIColor redColor] FontSize:17.0];
            NSArray *endTimeArray = [self->_lhModel.endtime componentsSeparatedByString:@" "];
            self.timeLabel.text = [endTimeArray objectAtIndex:0];

            NSLog(@"self.lhModel.serverTime = %@",self.lhModel.serverTime);
            NSLog(@"self.lhModel.endtime = %@",self.lhModel.endtime);
            long long startLongLong = [CMTimeCommon timeSwitchTimestamp:self.lhModel.serverTime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
            long long finishLongLong = [CMTimeCommon timeSwitchTimestamp:self.lhModel.endtime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
            [self startLongLongStartStamp:startLongLong*1000 longlongFinishStamp:finishLongLong*1000];
//            countkkk ++;
        } failure:^(id msg) {
            
        }];
    }];
}

//六合开奖
///此方法用两个时间戳做参数进行倒计时
-(void)startLongLongStartStamp:(long long)strtLL longlongFinishStamp:(long long)finishLL{
    __weak __typeof(self) weakSelf= self;
    
    if (_countDownForLabel) {
        [_countDownForLabel destoryTimer];
    }
    
    [_countDownForLabel countDownWithStratTimeStamp:strtLL finishTimeStamp:finishLL completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {

         [weakSelf refreshUIDay:day hour:hour minute:minute second:second];
    }];
}
//六合开奖
///此方法用两个时间做参数进行倒计时
-(void)startDate:(NSDate *)startDate finishDate:(NSDate *)finishDate{
    __weak __typeof(self) weakSelf= self;
    if (_countDownForLabel) {
        [_countDownForLabel destoryTimer];
    }
    [_countDownForLabel countDownWithStratDate:startDate finishDate:finishDate  completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {

        [weakSelf refreshUIDay:day hour:hour minute:minute second:second];
    }];
}
//六合开奖
-(void)refreshUIDay:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{

    NSString *hourStr = @"";
    NSString *minuStr = @"";
    NSString *secondStr = @"";
    if (day==0) {
        if (hour<10) {
            hourStr = [NSString stringWithFormat:@"0%ld",(long)hour];
        }else{
            hourStr = [NSString stringWithFormat:@"%ld",(long)hour];
        }
    }else{
            hour = hour + 24*day;
            hourStr = [NSString stringWithFormat:@"%ld",(long)hour];
    }
    if (minute<10) {
        minuStr = [NSString stringWithFormat:@"0%ld",(long)minute];
    }else{
        minuStr = [NSString stringWithFormat:@"%ld",(long)minute];
    }
    if (second<10) {
        secondStr = [NSString stringWithFormat:@"0%ld",(long)second];
    }else{
        secondStr = [NSString stringWithFormat:@"%ld",(long)second];
    }
    
    self.countdownLabel.text = [NSString stringWithFormat:@"%@:%@:%@",hourStr,minuStr,secondStr];
    
    if ([self.countdownLabel.text  isEqualToString:@"00:00:00"]) {
        
        [self lotterTimeAction ];
    }
}
//六合开去历史记录
- (IBAction)historyAcion:(id)sender {
    UGLotteryRecordController *recordVC = _LoadVC_from_storyboard_(@"UGLotteryRecordController");
    recordVC.gameId = self.lhModel.gameId;
    [NavController1 pushViewController:recordVC animated:true];
    
}

//六合开奖
- (IBAction)voiceAction:(UIButton*)sender {
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就不开启
        _hormIsOpen = NO;
        [self.hormImgV setImage:[UIImage imageNamed:@"icon_sound02"]];
        [_player pause];
        [_timer setFireDate:[NSDate distantFuture]];
    } else { // 默认开启
        _hormIsOpen = YES;
        [self.hormImgV setImage:[UIImage imageNamed:@"icon_sound01"]];
        [_player continue];
        [_timer setFireDate:[NSDate date]];
    }
}
//六合开奖
- (IBAction)loteryValueChange:(id)sender {
    
    [self.lotteryCollectionView reloadData];
}
//六合开奖
//倒计时结束时触发
-(void)lotterTimeAction{
    [self.timer invalidate];
    self.timer = nil;
    
    
    [_lottyLabel setHidden:NO];
    _timeLabel.text = @"开奖中";
//    [_timeLabel setTextColor:[UIColor blackColor]];
    _countdownLabel.text = @"开奖中";
//    [_countdownLabel setTextColor:[UIColor blackColor]];
    [self setLhModel:nil];
    
    __weakSelf_(__self);
    __block UGLHlotteryNumberModel *__lastLHModel = nil;
    __block int __count = 0;
    
    if (!_timer) {
          _timer = [NSTimer scheduledTimerWithInterval:6 repeats:true block:^(NSTimer *timer) {
                CCSessionModel * sessionModel = [NetworkManager1 lhdoc_lotteryNumber];
                sessionModel.completionBlock = ^(CCSessionModel *sm) {
                    NSNumber *cn = (NSNumber *)sm.responseObject[@"code"];
                    if (!sm.error  && [cn intValue] == 0) {
                        NSLog(@"model= %@",sm.responseObject[@"code"]);
                        NSLog(@"获取开奖信息成功");
                        NSLog(@"model= %@",sm.responseObject[@"data"]);
                        __self.lhModel = nil;
                        
                        UGLHlotteryNumberModel *model = (UGLHlotteryNumberModel *)[UGLHlotteryNumberModel mj_objectWithKeyValues:sm.responseObject[@"data"]];
                        model.numSxArrary = [model.numSx componentsSeparatedByString:@","];
                        model.numbersArrary = [model.numbers componentsSeparatedByString:@","];
                        model.numColorArrary = [model.numColor componentsSeparatedByString:@","];
                        model.isOpen = __self.lotteryUISwitch.isOn;
                        NSLog(@"model = %@",model);
                        __self.lhModel = model;
                        if (!model) {
                            return ;
                        }
                        NSLog(@"auto= %d",model.autoBL);
                        if (model.autoBL) {
                            return ;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 需要在主线程执行的代码
                            
                            [__self.lottyLabel setHidden:YES];
                            [__self.lotteryCollectionView reloadData];
                            if (__self.lhModel.issue.length>4) {
                                NSString *nper = [__self.lhModel.issue  substringFromIndex:4];
                                if ([CMCommon stringIsNull:model.lhcdocLotteryNo]) {
                                      __self.lotteryTitleLabel.text = [NSString stringWithFormat:@"第%@期开奖结果",nper];
                                } else {
                                      __self.lotteryTitleLabel.text = [NSString stringWithFormat:@"第%@期开奖结果",model.lhcdocLotteryNo];
                                }
                              
                            }
         
                            
                            [CMLabelCommon setRichNumberWithLabel:__self.lotteryTitleLabel Color:[UIColor redColor] FontSize:17.0];
        #ifdef DEBUG
        //                    if (__count < 7) {
        //                        model.isFinish = 0;
        //                    }
        //                    else{
        //                        model.isFinish = 1;
        //                    }
        #endif
                            if (model.isFinish == 1) {
                                NSArray *endTimeArray = [__self.lhModel.endtime componentsSeparatedByString:@" "];
                                __self.timeLabel.text = [endTimeArray objectAtIndex:0];
                                long long startLongLong = [CMTimeCommon timeSwitchTimestamp:self.lhModel.serverTime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
                                long long finishLongLong = [CMTimeCommon timeSwitchTimestamp:self.lhModel.endtime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
                                [__self startLongLongStartStamp:startLongLong*1000 longlongFinishStamp:finishLongLong*1000];
                                
              
                                __lastLHModel = nil;
                                __count = 0;
                                [__self.timer invalidate];
                                __self.timer = nil;
                                [__self.countDownForLabel destoryTimer];
                                [__self getLotteryNumberList ];

                            }
                            else
                            {
                                __weak static UIView *__shared = nil;
                                if (!__shared) {
                                    __shared = __self;
                                }
                                if (__lastLHModel) {
                                    if ([CMCommon array:__lastLHModel.numbersArrary isOrderEqualTo:__self.lhModel.numbersArrary] ) {
                                        return ;
                                    }
                                    else
                                    {
                                        model.count = __count;
                                        if (__shared == __self) {
                                            [__self.player playLH:model ];
                                        }
                                        __lastLHModel = model;
                                        __count ++;
                                        NSLog(@"__count = %d",__count);
                                    }
                                }
                                else{
                                    if (__shared == __self) {
                                        [__self.player playLH:model ];
                                    }
                                    __lastLHModel = model;
                                    __count ++;
                                    NSLog(@"__count = %d",__count);
                                }

                            }
                            
                        });
                        
                        if (!__self) {
                            __lastLHModel = nil;
                            __count = 0;
                            [__self.timer invalidate];
                            __self.timer = nil;
                            [__self.countDownForLabel destoryTimer];
                        }
                    }
                };
                sessionModel.failureBlock = ^(NSError *error) {
                    
                };
            }];
         
    }
    
}
//六合开奖 测试
-(void)testKaiJiang{
    {//test
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeString = [dateFormatter stringFromDate:currentDate];
        
        NSDate *pastDate= [currentDate dateByAddingTimeInterval:3]; // 半小时前是-1800   1小时后是3600   1小时前是-3600
        NSString *pastTimeString = [dateFormatter stringFromDate:pastDate];
        long long startLongLong = [CMTimeCommon timeSwitchTimestamp:timeString andFormatter:@"YYYY-MM-dd HH:mm:ss"];
        long long finishLongLong = [CMTimeCommon timeSwitchTimestamp:pastTimeString andFormatter:@"YYYY-MM-dd HH:mm:ss"];
        [self startLongLongStartStamp:startLongLong*1000 longlongFinishStamp:finishLongLong*1000];
        
    }
}
@end
