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

@interface UGLHPrizeView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}
@property (strong, nonatomic) IBOutlet UIView *contentView;
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
@property (nonatomic,strong)  CMAudioPlayer *player ;


/**<  播放器*/

@property (nonatomic,strong)  NSString *myGid;

//--------------------------------------------
@property (nonatomic,strong) UGLHlotteryNumberModel *lastLHModel;
@property (nonatomic)  int count;
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
    NSArray *objs=[bundle loadNibNamed:@"UGLHPrizeView" owner:self options:nil];
    return [objs firstObject];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
//        UGLHPrizeView *v = [[UGLHPrizeView alloc] initView];
//        [self addSubview:v];

        self.contentView = [self UGLHPrizeView];
        CGRect frame = CGRectMake(0, 0, APP.Width*0.9, 160);
        self.frame = frame;
        self.contentView.frame = frame;
        [self addSubview:self.contentView];
        [self initSubView];
    }
    return self;
}

- (instancetype)initView {
    if (self = [super init]) {
        self.contentView = [self UGLHPrizeView];
        [self addSubview:self.contentView];
        [self initSubView];
       
    }
    return self;
}

-(void)initSubView{
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
    
    
    NSDictionary *params ;
    
    if ([CMCommon stringIsNull:self.gid]) {
        params = @{
            
        };
    } else {
        params = @{
          
            @"gameId":self.gid
        };
    }
    WeakSelf;
    [CMNetwork lotteryNumberWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // UI更新代码
                FastSubViewCode(weakSelf);
                if (!weakSelf.lotteryCollectionView) {
                    weakSelf.hormIsOpen = YES;
                    weakSelf.lotteryUISwitch = (UISwitch *)[self viewWithTag:10];
                    [weakSelf.lotteryUISwitch setOn:SysConf.lhcdocMiCard] ;
                    weakSelf.lotteryCollectionView = (UICollectionView *)[self viewWithTag:11];
                    weakSelf.lotteryCollectionView.backgroundColor = [UIColor whiteColor];
                    weakSelf.lotteryCollectionView.dataSource = self;
                    weakSelf.lotteryCollectionView.delegate = self;
                    weakSelf.lotteryCollectionView.tagString= @"六合开奖";
                    [weakSelf.lotteryCollectionView setBounces:NO];
                    [weakSelf.lotteryCollectionView setScrollEnabled:NO];
                    [weakSelf.lotteryCollectionView registerNib:[UINib nibWithNibName:@"UGLHLotteryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGLHLotteryCollectionViewCell"];
                    weakSelf.player = [[CMAudioPlayer alloc] init];
                }
                
              
                
                weakSelf.lhModel = nil;
                NSLog(@"model= %@",model.data);
                weakSelf.lhModel = (UGLHlotteryNumberModel *)model.data;
                weakSelf.lhModel.numSxArrary = [weakSelf.lhModel.numSx componentsSeparatedByString:@","];
                weakSelf.lhModel.numbersArrary = [weakSelf.lhModel.numbers componentsSeparatedByString:@","];
                weakSelf.lhModel.numColorArrary = [weakSelf.lhModel.numColor componentsSeparatedByString:@","];
                
                if ([CMCommon stringIsNull:weakSelf.lhModel.lotteryStr]) {
                    if (weakSelf.lhModel.numbersArrary.count) {
                        [subLabel(@"准备开奖Label") setHidden:YES];
                        [weakSelf.lotteryCollectionView reloadData];
                    }
                }
                else{
                    if (weakSelf.lhModel.numbersArrary.count) {
                        [subLabel(@"准备开奖Label") setHidden:YES];
                        [weakSelf.lotteryCollectionView reloadData];
                    }
                    else{
                        subLabel(@"准备开奖Label").text = weakSelf.lhModel.lotteryStr;
                        [subLabel(@"准备开奖Label") setHidden:NO];
                    }
                }
            
                NSString *nper = [self.lhModel.issue  substringFromIndex:4];
                if ([CMCommon stringIsNull:self.lhModel.lhcdocLotteryNo]) {
                    subLabel(@"开奖结果Label").text = [NSString stringWithFormat:@"第%@期开奖结果",nper];
                } else {
                    subLabel(@"开奖结果Label").text = [NSString stringWithFormat:@"第%@期开奖结果",self.lhModel.lhcdocLotteryNo];
                }
                
                [CMLabelCommon setRichNumberWithLabel:subLabel(@"开奖结果Label") Color:[UIColor redColor] FontSize:17.0];
                NSArray *endTimeArray = [weakSelf.lhModel.endtime componentsSeparatedByString:@" "];
                subLabel(@"下期开奖日期Label").text = [endTimeArray objectAtIndex:0];
                
                long long startLongLong = [CMTimeCommon timeSwitchTimestamp:self.lhModel.serverTime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
                long long finishLongLong = [CMTimeCommon timeSwitchTimestamp:self.lhModel.endtime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
                [weakSelf startLongLongStartStamp:startLongLong*1000 longlongFinishStamp:finishLongLong*1000];
                
//                [subLabel(@"倒计时Label")setHidden:NO];
//                subLabel(@"倒计时Label").text = @"我进来了";

            }];
            
            
        } failure:^(id msg) {
            
        }];
    }];
}

//六合开奖
///此方法用两个时间戳做参数进行倒计时
-(void)startLongLongStartStamp:(long long)strtLL longlongFinishStamp:(long long)finishLL{
    __weak __typeof(self) weakSelf= self;
    

        [_countDownForLabel countDownWithStratTimeStamp:strtLL finishTimeStamp:finishLL completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                      [weakSelf refreshUIDay:day hour:hour minute:minute second:second];
                 }];
           
        }];

}
//六合开奖
///此方法用两个时间做参数进行倒计时
//-(void)startDate:(NSDate *)startDate finishDate:(NSDate *)finishDate{
//    __weak __typeof(self) weakSelf= self;
//    if (_countDownForLabel) {
//        [_countDownForLabel destoryTimer];
//    }
//    [_countDownForLabel countDownWithStratDate:startDate finishDate:finishDate  completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
//
//        [weakSelf refreshUIDay:day hour:hour minute:minute second:second];
//    }];
//}
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
    FastSubViewCode(self);
    
    subLabel(@"倒计时Label").text = [NSString stringWithFormat:@"%@:%@:%@",hourStr,minuStr,secondStr];
    
    if ([subLabel(@"倒计时Label").text  isEqualToString:@"00:00:00"]) {
        
        [self lotterTimeAction ];
    }
}
//六合开去历史记录
- (IBAction)historyAcion:(id)sender {
    UGLotteryRecordController *recordVC = _LoadVC_from_storyboard_(@"UGLotteryRecordController");
    NSLog(@"gid = 3%@",_gid);
    NSLog(@"myGid =100 %@",[Global getInstanse].DZPid);
    recordVC.gameId = [Global getInstanse].DZPid;
    [NavController1 pushViewController:recordVC animated:true];
    
}

//六合开奖
- (IBAction)voiceAction:(UIButton*)sender {
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    
    if (!_player) {
        _player = [[CMAudioPlayer alloc] init];
    }
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

-(void)lhLotter{
    CCSessionModel * sessionModel = [NetworkManager1 lhdoc_lotteryNumber];
    sessionModel.completionBlock = ^(CCSessionModel *sm) {
        NSNumber *cn = (NSNumber *)sm.responseObject[@"code"];
        if (!sm.error  && [cn intValue] == 0) {
            self.lhModel = nil;
            UGLHlotteryNumberModel *model = (UGLHlotteryNumberModel *)[UGLHlotteryNumberModel mj_objectWithKeyValues:sm.responseObject[@"data"]];
            model.numSxArrary = [model.numSx componentsSeparatedByString:@","];
            model.numbersArrary = [model.numbers componentsSeparatedByString:@","];
            model.numColorArrary = [model.numColor componentsSeparatedByString:@","];
            model.isOpen = self.lotteryUISwitch.isOn;
     
            self.lhModel = model;
            if (!model) {
                return ;
            }
            NSLog(@"auto= %d",model.autoBL);
            if (model.autoBL) {
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                FastSubViewCode(self);
                [subLabel(@"准备开奖Label") setHidden:YES];
                [self.lotteryCollectionView reloadData];
                if (self.lhModel.issue.length>4) {
                    NSString *nper = [self.lhModel.issue  substringFromIndex:4];
                    if ([CMCommon stringIsNull:model.lhcdocLotteryNo]) {
                        subLabel(@"开奖结果Label").text = [NSString stringWithFormat:@"第%@期开奖结果",nper];
                    } else {
                        subLabel(@"开奖结果Label").text = [NSString stringWithFormat:@"第%@期开奖结果",model.lhcdocLotteryNo];
                    }
                    
                }
                
                
                [CMLabelCommon setRichNumberWithLabel:subLabel(@"开奖结果Label") Color:[UIColor redColor] FontSize:17.0];

                if (model.isFinish == 1) {
                    
                    self.lastLHModel = nil;
                    self.count = 0;
                    [self.timer invalidate];
                    self.timer = nil;
                    [self.countDownForLabel destoryTimer];
                    [self getLotteryNumberList];

                    
                }
                else
                {
                    __weak static UIView *__shared = nil;
                    if (!__shared) {
                        __shared = self;
                    }
                    if (self.lastLHModel) {
                        if ([CMCommon array:self.lastLHModel.numbersArrary isOrderEqualTo:self.lhModel.numbersArrary] ) {
                            return ;
                        }
                        else
                        {
                            model.count = self.count;
                            if (__shared == self) {
                                [self.player playLH:model ];
                            }
                            self.lastLHModel = model;
                            self.count ++;
                            NSLog(@"count = %d",self.count);
                        }
                    }
                    else{
                        if (__shared == self) {
                            [self.player playLH:model ];
                        }
                        self.lastLHModel = model;
                        self.count ++;
                        NSLog(@"count = %d",self.count);
                    }
                    
                }
                
            });
            
            if (!self) {
                self.lastLHModel = nil;
                self.count = 0;
                [self.timer invalidate];
                self.timer = nil;
                [self.countDownForLabel destoryTimer];
            }
        }
    };
    sessionModel.failureBlock = ^(NSError *error) {
        
    };
}
//六合开奖
//倒计时结束时触发
-(void)lotterTimeAction{
    [self.timer invalidate];
    self.timer = nil;
    FastSubViewCode(self);
    [subLabel(@"准备开奖Label") setHidden:NO];
    subLabel(@"下期开奖日期Label").text = @"开奖中";
    subLabel(@"倒计时Label").text = @"开奖中";
    [self setLhModel:nil];

    
    self.lastLHModel = nil;
    self.count = 0;
    
    [self lhLotter];
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithInterval:6 repeats:true block:^(NSTimer *timer) {
            [self lhLotter];
        }];
        
    }
    
}


-(void)setGid:(NSString *)gid{
    _gid = gid;
    NSLog(@"gid = 2%@",_gid);
    [[Global getInstanse] setDZPid:gid];
    // 3.GCD
    dispatch_async(dispatch_get_main_queue(), ^{
       // UI更新代码
        [self getLotteryNumberList];
    });
  
}
@end
