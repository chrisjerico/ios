//
//  TKLMainViewController.m
//  UGBWApp
//
//  Created by fish on 2020/10/23.
//  Copyright © 2020 ug. All rights reserved.
//

#import "TKLMainViewController.h"
#import "XYYSegmentControl.h"
#import "UGPlatformGameModel.h"
#import "TKLMainListViewController.h"
#import "STBarButtonItem.h"
#import "UGBalanceConversionRecordController.h"
@interface TKLMainViewController ()<XYYSegmentControlDelegate>{
}
@property (nonatomic, strong)XYYSegmentControl *slideSwitchView;
@property (nonatomic,strong)  NSMutableArray <NSString *> *itemArray;

@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *gamedataArray ;    //电子
@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *realdataArray ;    //视讯
@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *carddataArray ;    //棋牌
@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *esportdataArray ;  //电竞
@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *fishdataArray ;    //捕鱼
@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *sportdataArray ;    //体育
@property (nonatomic, strong)TKLMainListViewController *gameView;
@property (nonatomic, strong)TKLMainListViewController *realView;
@property (nonatomic, strong)TKLMainListViewController *cardView;
@property (nonatomic, strong)TKLMainListViewController *esportView;
@property (nonatomic, strong)TKLMainListViewController *fishView;
@property (nonatomic, strong)TKLMainListViewController *sportView;
@end

@implementation TKLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"额度转换";
    [self.view setBackgroundColor: Skin1.bgColor];
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithTitle:@"转换记录" target:self action:@selector(rightBarButtonItemClick)];

    _itemArray = [NSMutableArray new];
    _gamedataArray = [NSMutableArray new];
    _realdataArray = [NSMutableArray new];
    _carddataArray = [NSMutableArray new];
    _esportdataArray = [NSMutableArray new];
    _fishdataArray = [NSMutableArray new];
    _sportdataArray = [NSMutableArray new];
    
    UGPlatformGameModel*obj = [UGPlatformGameModel new];
    obj.title = @"我的钱包";
    obj.gameId = @"0";
    UGUserModel *user = [UGUserModel currentUser];
    double floatString = [user.balance doubleValue];
    obj.balance =  [NSString stringWithFormat:@"%.2f",floatString];
    [_gamedataArray addObject:obj];
    [_realdataArray addObject:obj];
    [_carddataArray addObject:obj];
    [_esportdataArray addObject:obj];
    [_fishdataArray addObject:obj];
    [_sportdataArray addObject:obj];
    [self getRealGames];
}


- (void)rightBarButtonItemClick {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UGBalanceConversionRecordController *recordVC = [storyboard instantiateViewControllerWithIdentifier:@"UGBalanceConversionRecordController"];
    [self.navigationController pushViewController:recordVC animated:YES];
}
-(void)viewStyle{
    FastSubViewCode(self.view);
    //设置圆角边框设置边框及边框颜色
//    subView(@"左边View").layer.cornerRadius = 5;
//    subView(@"左边View").layer.masksToBounds = YES;
//    subView(@"左边View").layer.borderWidth = 1;
//    subView(@"左边View").layer.borderColor =[ [UIColor blueColor] CGColor];
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
                if ([obj.category isEqualToString:@"real"]) {
                    [__self.realdataArray addObject:obj];
                }
                if ([obj.category isEqualToString:@"game"]) {
                    [__self.gamedataArray addObject:obj];
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
            
            if (__self.realdataArray.count > 1) {
                [__self.itemArray addObject:@"视讯"];
            }
            if (__self.carddataArray.count > 1) {
                [__self.itemArray addObject:@"棋牌"];
            }
            if (__self.gamedataArray.count > 1) {
                [__self.itemArray addObject:@"电子"];
            }
            if (__self.esportdataArray.count > 1) {
                [__self.itemArray addObject:@"电竞"];
            }
            if (__self.fishdataArray.count > 1) {
                [__self.itemArray addObject:@"捕鱼"];
            }
            if (__self.sportdataArray.count > 1) {
                [__self.itemArray addObject:@"体育"];
            }
            [__self buildSegment];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}
#pragma mark - UI
- (void)buildSegment
{
    
    
    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
    [self.view addSubview:self.slideSwitchView];
    [self.slideSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(k_Height_NavBar);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
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
    
   NSString * name = [self.itemArray objectAtIndex:number];
    // 视讯
    if ([name isEqualToString:@"视讯"]) {
        if (!_realView) {
            _realView  = _LoadVC_from_storyboard_(@"TKLMainListViewController") ;
        }
        _realView.dataArray = _realdataArray;
        return _realView;
    }
    // 棋牌
    else if ([name isEqualToString:@"棋牌"]) {
        if (!_cardView) {
            _cardView  = _LoadVC_from_storyboard_(@"TKLMainListViewController") ;
        }
        _cardView.dataArray = _carddataArray;
        return _cardView;
    }
    // 电子
    else if ([name isEqualToString:@"电子"]) {
        if (!_gameView) {
            _gameView  = _LoadVC_from_storyboard_(@"TKLMainListViewController") ;
        }
        _gameView.dataArray = _gamedataArray;
        return _gameView;
    }
    // 电竞
    else if ([name isEqualToString:@"电竞"]) {
        if (!_esportView) {
            _esportView  = _LoadVC_from_storyboard_(@"TKLMainListViewController") ;
        }
        _esportView.dataArray = _esportdataArray;
        return _esportView;
    }
    // 捕鱼
    else if ([name isEqualToString:@"捕鱼"]) {
        if (!_fishView) {
            _fishView  = _LoadVC_from_storyboard_(@"TKLMainListViewController") ;
        }
        _fishView.dataArray = _fishdataArray;
        return _fishView;
    }
    //体育
    else  {
        if (!_sportView) {
            _sportView  = _LoadVC_from_storyboard_(@"TKLMainListViewController") ;
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

