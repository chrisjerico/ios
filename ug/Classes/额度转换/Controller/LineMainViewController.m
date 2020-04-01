//
//  LineMainViewController.m
//  ug
//
//  Created by ug on 2020/2/19.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LineMainViewController.h"
#import "XYYSegmentControl.h"
#import "UGPlatformGameModel.h"
#import "UGBMHeaderView.h"
#import "LineMainListViewController.h"
@interface LineMainViewController ()<XYYSegmentControlDelegate>{
    UGBMHeaderView *headView;                /**<   黑色模板导航头 */
}

@property (nonatomic, strong)XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSArray <NSString *> *itemArray;

@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *gamedataArray ;    //电子
@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *realdataArray ;    //视讯
@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *carddataArray ;    //棋牌
@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *esportdataArray ;  //电竞
@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *fishdataArray ;    //捕鱼
@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *sportdataArray ;    //体育


@property (nonatomic, strong)LineMainListViewController *gameView;
@property (nonatomic, strong)LineMainListViewController *realView;
@property (nonatomic, strong)LineMainListViewController *cardView;
@property (nonatomic, strong)LineMainListViewController *esportView;
@property (nonatomic, strong)LineMainListViewController *fishView;
@property (nonatomic, strong)LineMainListViewController *sportView;

@end

@implementation LineMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"额度转换";
    _gamedataArray = [NSMutableArray new];
    _realdataArray = [NSMutableArray new];
    _carddataArray = [NSMutableArray new];
    _esportdataArray = [NSMutableArray new];
    _fishdataArray = [NSMutableArray new];
    _sportdataArray = [NSMutableArray new];
    
    [self getRealGames];
}
#pragma mark - 网络数据
- (void)getRealGames {
    __weakSelf_(__self);
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork getRealGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            NSMutableArray <UGPlatformGameModel *> *dataArray = model.data;
            
            for (UGPlatformGameModel*obj in dataArray) {
                
                if ([obj.category isEqualToString:@"game"]) {
                    [__self.gamedataArray addObject:obj];
                }
                if ([obj.category isEqualToString:@"real"]) {
                    [__self.realdataArray addObject:obj];
                }
                if ([obj.category isEqualToString:@"card"]) {
                    [__self.carddataArray addObject:obj];
                }
                if ([obj.category isEqualToString:@"esport"]) {
                    [__self.esportdataArray addObject:obj];
                }
                if ([obj.category isEqualToString:@"fish"]) {
                    [__self.fishdataArray addObject:obj];
                }
                if ([obj.category isEqualToString:@"sport"]) {
                    [__self.sportdataArray addObject:obj];
                }
                
                
            }
            [self buildSegment];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

#pragma mark - UI

-(void)creatView{
    //===============导航头布局=================
    headView = [[UGBMHeaderView alloc] initView];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        make.top.equalTo(self.view.mas_top).with.offset(k_Height_StatusBar);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.height.equalTo([NSNumber numberWithFloat:110]);
        make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
    }];
}
- (void)buildSegment
{
    
    self.itemArray = @[@"视讯",@"棋牌",@"电子",@"电竞",@"捕鱼",@"体育"];
    if (Skin1.isBlack) {
        [self creatView];
        self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , headView.frame.size.height+headView.frame.origin.y, self.view.width, self.view.height) channelName:self.itemArray source:self];
        [self.view addSubview:self.slideSwitchView];
        [self.slideSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.mas_bottom);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    } else {
        self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
        [self.view addSubview:self.slideSwitchView];
    }
    
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = Skin1.textColor1;
    self.slideSwitchView.tabItemNormalFont = 13;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = RGBA(203, 43, 37, 1.0) ;
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = Skin1.bgColor;
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = RGBA(203, 43, 37, 1.0) ;
    
}

#pragma mark - XYYSegmentControlDelegate

- (NSUInteger)numberOfTab:(XYYSegmentControl *)view {
    return [self.itemArray count];//items决定
}

///待加载的控制器
- (UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number {
    // 视讯
    if (number == 0) {
        if (!_realView) {
            _realView  = _LoadVC_from_storyboard_(@"LineMainListViewController") ;
        }
        _realView.dataArray = _realdataArray;
        return _realView;
    }
    // 棋牌
    else if (number == 1) {
        if (!_cardView) {
            _cardView  = _LoadVC_from_storyboard_(@"LineMainListViewController") ;
        }
        _cardView.dataArray = _carddataArray;
        return _cardView;
    }
    // 电子
    else if (number == 2) {
        if (!_gameView) {
            _gameView  = _LoadVC_from_storyboard_(@"LineMainListViewController") ;
        }
        _gameView.dataArray = _gamedataArray;
        return _gameView;
    }
    // 电竞
    else if (number == 3) {
        if (!_esportView) {
            _esportView  = _LoadVC_from_storyboard_(@"LineMainListViewController") ;
        }
        _esportView.dataArray = _esportdataArray;
        return _esportView;
    }
    // 捕鱼
    else if (number == 4) {
        if (!_fishView) {
            _fishView  = _LoadVC_from_storyboard_(@"LineMainListViewController") ;
        }
        _fishView.dataArray = _fishdataArray;
        return _fishView;
    }
    //体育
    else {
        if (!_sportView) {
            _sportView  = _LoadVC_from_storyboard_(@"LineMainListViewController") ;
        }
        _sportView.dataArray = _sportdataArray;
        return _sportView;
    }
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {
    // 视讯
       if (number == 0) {
           if (!_realView.dataArray) {
                _realView.dataArray = _realdataArray;
           }
           [_realView dataReLoad];
       }
       // 棋牌
       else if (number == 1) {
           if (!_cardView.dataArray) {
                _cardView.dataArray = _carddataArray;
           }
           [_cardView dataReLoad];
       }
       // 电子
       else if (number == 2) {
           if (!_gameView.dataArray) {
                _gameView.dataArray = _gamedataArray;
           }
           [_gameView dataReLoad];
       }
       // 电竞
       else if (number == 3) {
           if (!_esportView.dataArray) {
                _esportView.dataArray = _esportdataArray;
           }
           [_esportView dataReLoad];
       }
       // 捕鱼
       else if (number == 4) {
           if (!_fishView.dataArray) {
                _fishView.dataArray = _fishdataArray;
           }
           [_fishView dataReLoad];
       }
       //体育
       else {
           if (!_sportView.dataArray) {
                _sportView.dataArray = _sportdataArray;
           }
           [_sportView dataReLoad];
       }
}
@end
