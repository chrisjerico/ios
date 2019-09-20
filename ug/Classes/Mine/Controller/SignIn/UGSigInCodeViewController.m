//
//  UGSigInCodeViewController.m
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSigInCodeViewController.h"
#import "UGSignInModel.h"
#import "UGSignInCollectionViewCell.h"
#import "UGSignInHeaderView.h"
#import "UGSignInScrHeaderView.h"
#import "UGSignInScrFootView.h"
#import "UGSignInHistoryView.h"

#import "UGSignInHistoryModel.h"
#import "UGSystemConfigModel.h"


@interface UGSigInCodeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    UIScrollView *mUIScrollView;
    
    UGSignInHeaderView *mUGSignInHeaderView;
    UGSignInScrHeaderView *mUGSignInScrHeaderView;
    UGSignInScrFootView *mUGSignInScrFootView;
     UIButton *mUGSignInButton;
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionDataArray;
@property (nonatomic, strong) UGSignInModel *checkinListModel;
@property (nonatomic, strong) NSMutableArray *historyDataArray;

@end

@implementation UGSigInCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"签到";
    self.view.backgroundColor = UGRGBColor(89, 109, 191);
    _collectionDataArray = [NSMutableArray new];
    _historyDataArray = [NSMutableArray new];
     [self getCheckinListData];
    
    
    

}



#pragma mark - UIS

- (void)createUI{
    //签到按钮
    //滚动面版
    //已连续3天签到
    //日期列表
    //今日签到
    //连续签到礼包
    
    //-签到按钮======================================
    if (mUGSignInHeaderView == nil) {
        mUGSignInHeaderView = [[UGSignInHeaderView alloc] initView];
        [mUGSignInHeaderView setFrame:CGRectMake(0, 0,UGScreenW, 40.0)];
        WeakSelf;
        mUGSignInHeaderView.signInHeaderViewnBlock = ^{
           //签到记录
            NSLog(@"签到记录");
            
            [weakSelf getCheckinHistoryData ];
        };
    }
    [self.view addSubview:mUGSignInHeaderView];
    //-滚动面版======================================
    if (mUIScrollView == nil) {
        mUIScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, UGScreenW , UGScerrnH -40.0-IPHONE_SAFEBOTTOMAREA_HEIGHT)];
        mUIScrollView.showsHorizontalScrollIndicator = NO;//不显示水平拖地的条
        mUIScrollView.showsVerticalScrollIndicator=NO;//不显示垂直拖动的条
        mUIScrollView.bounces = NO;//到边了就不能再拖地
        //UIScrollView被push之后返回，会发生控件位置偏移，用下面的代码就OK
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view addSubview:mUIScrollView];
   

    //-已连续3天签到======================================
    if (mUGSignInScrHeaderView == nil) {
        mUGSignInScrHeaderView = [[UGSignInScrHeaderView alloc] initView];
        [mUGSignInScrHeaderView setFrame:CGRectMake(0, 0,UGScreenW, 95.0)];
       
    }
    [mUIScrollView addSubview:mUGSignInScrHeaderView];
    //-日期列表======================================
    float itemW = (UGScreenW - 10 - 40)/4;
    float itemH = 185.0;
    
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.estimatedItemSize = CGSizeMake(self.width, collectionViewH);//自适应高度
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.minimumInteritemSpacing = 5;//最小间距
        layout.minimumLineSpacing = 5;//最小行距
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;//水平
        layout;
        
    });
    UICollectionView *collectionView = ({
        float collectionViewH = 400;
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 95+15, UGScreenW - 10, collectionViewH) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.layer.cornerRadius = 4;
        collectionView.layer.masksToBounds = YES;
        collectionView.layer.borderWidth = 4;
        collectionView.layer.borderColor = [[UIColor colorWithRed:237.0/255.0 green:250.0/255.0 blue:254.0/255.0 alpha:1] CGColor];
 
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGSignInCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGSignInCollectionViewCell"];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView;
        
    });
     if (self.collectionView == nil) {
         self.collectionView = collectionView;
     }
    [mUIScrollView addSubview:collectionView];
    //-今日签到======================================
    if (mUGSignInButton == nil) {
        mUGSignInButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        mUGSignInButton.frame = CGRectMake(100, 100, 100, 40);
        // 按钮的正常状态
        [mUGSignInButton setTitle:@"马上签到" forState:UIControlStateNormal];
        // 设置按钮的背景色
        mUGSignInButton.backgroundColor = UGRGBColor(111, 126, 233);
        // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
        [mUGSignInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // titleLabel：UILabel控件
        mUGSignInButton.titleLabel.font = [UIFont systemFontOfSize:22];
        
        mUGSignInButton.layer.cornerRadius = 20;
        
        mUGSignInButton.layer.masksToBounds = YES;
        
        [mUGSignInButton addTarget:self action:@selector(mUGSignInButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    [mUIScrollView addSubview:mUGSignInButton];
    
    [mUGSignInButton mas_makeConstraints:^(MASConstraintMaker *make)
     {
         
         make.top.mas_equalTo(self.collectionView.mas_bottom).offset(-20.0);
         make.centerX.mas_equalTo(self.view.mas_centerX);
         make.width.equalTo(@140);
         make.height.equalTo(@40);
     }];
    
    //-连续签到礼包======================================
    if (mUGSignInScrFootView == nil) {
        mUGSignInScrFootView = [[UGSignInScrFootView alloc] initView];
        [mUGSignInScrFootView setFrame:CGRectMake(0, 530,UGScreenW, 175.0)];
        WeakSelf;
        mUGSignInScrFootView.signInScrFootFiveBlock = ^{
            //5天领取
            NSLog(@"5天领取");
            [weakSelf checkinBonusData:@"5"];
            
        };
        mUGSignInScrFootView.signInScrFootSevenBlock = ^{
            //7天领取
            NSLog(@"7天领取");
            [weakSelf checkinBonusData:@"7"];
        };
    }
    [mUIScrollView addSubview:mUGSignInScrFootView];
    //=================================================
     mUIScrollView.contentSize = CGSizeMake(UGScreenW, 800);
    
    [self setUIData];
}

- (void)setUIData{
    
    //已连续XX天签到
    //日期列表
    //连续签到
    //-已连续XX天签到======================================
    [mUGSignInScrHeaderView setSignInNumberStr:[NSString stringWithFormat:@"%@",self.checkinListModel.checkinTimes]];
    //-日期列表======================================
    _collectionDataArray = [NSMutableArray arrayWithArray: self.checkinListModel.checkinList];
    [self.collectionView reloadData];
    //-连续签到======================================
   NSMutableArray  *checkinBonusArray = [NSMutableArray arrayWithArray: self.checkinListModel.checkinBonus];
    if (![CMCommon arryIsNull:checkinBonusArray] && checkinBonusArray.count>=2) {
        UGcheckinBonusModel *checkinBonusModel1= [checkinBonusArray objectAtIndex:0];
        UGcheckinBonusModel *checkinBonusModel2= [checkinBonusArray objectAtIndex:1];
        
        [mUGSignInScrFootView setFiveStr:[NSString stringWithFormat:@"5天礼包(%@)",checkinBonusModel1.BonusInt]];
        [mUGSignInScrFootView setSevenStr:[NSString stringWithFormat:@"7天礼包(%@)",checkinBonusModel2.BonusInt]];
        
        //checkinBonus 第一个是5天签到奖励，第二个是7天签到奖励，switch 奖励是否开启领奖==>控制，isComplete 是否可以领奖
        //Switch只有0 和 1；字符串
        //android 只有用到isComplete
        if (checkinBonusModel1.isComplete) {
  
            mUGSignInScrFootView.fiveButton.userInteractionEnabled =NO;//交互关闭
            mUGSignInScrFootView.fiveButton.alpha= 1;//透明度
            [mUGSignInScrFootView.fiveButton setBackgroundColor:UGRGBColor(244, 246, 254)];
            [mUGSignInScrFootView.fiveButton setTitle:@"已领取" forState:UIControlStateNormal];
        } else {
         
            
            mUGSignInScrFootView.fiveButton.userInteractionEnabled =YES;//交互
            mUGSignInScrFootView.fiveButton.alpha= 1;//透明度
            [mUGSignInScrFootView.fiveButton setBackgroundColor:UGRGBColor(114, 108, 227)];
            [mUGSignInScrFootView.fiveButton setTitle:@"领取" forState:UIControlStateNormal];
        }
        
        if (checkinBonusModel2.isComplete) {
           
            mUGSignInScrFootView.sevenButtton.userInteractionEnabled =NO;//交互关闭
            mUGSignInScrFootView.sevenButtton.alpha= 1;//透明度
            [mUGSignInScrFootView.sevenButtton setBackgroundColor:UGRGBColor(244, 246, 254)];
            [mUGSignInScrFootView.sevenButtton setTitle:@"已领取" forState:UIControlStateNormal];
        } else {
    
            mUGSignInScrFootView.sevenButtton.userInteractionEnabled =YES;//交互
            mUGSignInScrFootView.sevenButtton.alpha= 1;//透明度
            [mUGSignInScrFootView.sevenButtton setBackgroundColor:UGRGBColor(114, 108, 227)];
            [mUGSignInScrFootView.sevenButtton setTitle:@"领取" forState:UIControlStateNormal];
        }
        
    }
    //-今日签到======================================
//    "serverTime": "2019-09-04",
//    签到列表里去找今天的日期，isCheckin 就是他的状态
//    如果是false ：马上签到==》点击签到
//    已经签到了才只显示==》今日已签
    BOOL kisCheckIn = NO;
    for (int i = 0; i<_collectionDataArray.count; i++) {
        UGCheckinListModel *model = [self.collectionDataArray objectAtIndex:i];
        if ([model.whichDay isEqualToString:self.checkinListModel.serverTime]) {
            
            kisCheckIn = model.isCheckin;
            
            break;
        }
        
    }
    
    if (kisCheckIn) {
        [mUGSignInButton setTitle:@"今日已签" forState:UIControlStateNormal];
        mUGSignInButton.userInteractionEnabled =NO;//交互关闭
        mUGSignInButton.alpha= 0.8;//透明度
    } else {
        [mUGSignInButton setTitle:@"马上签到" forState:UIControlStateNormal];
        mUGSignInButton.userInteractionEnabled =YES;//交互
        mUGSignInButton.alpha= 1;//透明度
    }
    

    
}

#pragma mark UICollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    if (section == 0) {
        return 4;
    }
    else {
        return 3;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGSignInCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGSignInCollectionViewCell" forIndexPath:indexPath];
    
    int row = 0;
    if (indexPath.section == 0) {
        row = 0;
    } else {
        row = 4;
    }
    UGCheckinListModel *model = [self.collectionDataArray objectAtIndex:row + indexPath.row];
    NSLog(@"row = %d,model = %@",row,model);
    model.serverTime = self.checkinListModel.serverTime;
    cell.item = model;
    WeakSelf;
    cell.signInBlock = ^{
        //UICollectionViewCell 点击
        NSLog(@"UICollectionViewCell 点击");
       
         if(cell.item.isCheckin == false && cell.item.isMakeup == true){
            // 显示签到的蓝色按钮；==》可以点击签到事件
           NSLog(@"显示签到的蓝色按钮；==》可以点击签到事件");
            
              NSString *date = model.whichDay;
//             UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
//
//             if (config.mkCheckinSwitch) {
                  [weakSelf checkinDataWithType:@"1" Date:date];
//             } else {
//                 [self.view makeToast:@"现在不能补签"];
//             }
           

        }
         else if(cell.item.isCheckin == false && cell.item.isMakeup == false){
   
//            int a = [CMCommon compareDate:model.serverTime withDate:model.whichDay withFormat:@"yyyy-MM-dd" ];
             
               NSString *date = model.whichDay;

                   [weakSelf checkinDataWithType:@"0" Date:date];
            
             
//             if (a >= 0) {
             
//             } else {
//                [weakSelf checkinDataWithType:@"1" Date:date];
//             }
             
         }
    };
    
   
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

//边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);//分别为上、左、下、右
}
#pragma mark -- 网络请求
//得到日期列表数据
- (void)getCheckinListData {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork checkinListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            weakSelf.checkinListModel = model.data;
            NSLog(@"checkinList = %@",weakSelf.checkinListModel);
            NSLog(@"serverTime = %@",weakSelf.checkinListModel.serverTime);
             [self createUI];
//
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

//得到领取连续签到奖励数据
- (void)checkinBonusData:(NSString *)type {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"type":type
                             };
    
    [SVProgressHUD showWithStatus:nil];
//    WeakSelf;
    [CMNetwork checkinBonusWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD showSuccessWithStatus:model.msg];
            
             [self getCheckinListData];
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

//用户签到（签到类型：0是签到，1是补签）
- (void)checkinDataWithType:(NSString *)type Date:(NSString *)date{
    
//    NSString *date = @"2019-09-04";
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"type":type,
                             @"date":date
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork checkinWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD showSuccessWithStatus:model.msg];
            
             [self getCheckinListData];
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

//得到签到历史列表数据
- (void)getCheckinHistoryData {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    
    [SVProgressHUD showWithStatus:nil];
//    WeakSelf;
    [CMNetwork checkinHistoryWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            self->_historyDataArray = model.data;
            NSLog(@"_historyDataArray = %@",self->_historyDataArray);
            NSLog(@"model.data = %@",model.data);
            
         
            [self showUGSignInHistoryView];
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}
#pragma mark -- 其他方法
- (void)showUGSignInHistoryView {
    
    UGSignInHistoryView *notiveView = [[UGSignInHistoryView alloc] initWithFrame:CGRectMake(20, 120, UGScreenW - 40, UGScerrnH - 260)];
    notiveView.dataArray = self->_historyDataArray;
    notiveView.checkinMoney = self.checkinListModel.checkinMoney;
    notiveView.checkinTimes= [NSString stringWithFormat:@"%@",self.checkinListModel.checkinTimes];
    
    if (![CMCommon arryIsNull:self->_historyDataArray]) {
        [notiveView show];
    }
    
   
}

- (void)mUGSignInButtonClicked {
    
    NSString *date = self.checkinListModel.serverTime;
    
    [self checkinDataWithType:@"0" Date:date];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
