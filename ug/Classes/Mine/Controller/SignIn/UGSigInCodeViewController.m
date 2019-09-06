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

@interface UGSigInCodeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    UIScrollView *mUIScrollView;
    
    UGSignInHeaderView *mUGSignInHeaderView;
    UGSignInScrHeaderView *mUGSignInScrHeaderView;
    UGSignInScrFootView *mUGSignInScrFootView;
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionDataArray;
@property (nonatomic, strong) UGSignInModel *checkinListModel;
@end

@implementation UGSigInCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"签到";
    self.view.backgroundColor = UGRGBColor(89, 109, 191);
    _collectionDataArray = [NSMutableArray new];
    
     [self getCheckinListData];
    

}



#pragma mark - UIS

- (void)createUI{
    //签到按钮
    //滚动面版
    //已连续3天签到
    //日期列表
    //连续签到礼包
    
    //-签到按钮======================================
    if (mUGSignInHeaderView == nil) {
        mUGSignInHeaderView = [[UGSignInHeaderView alloc] initView];
        [mUGSignInHeaderView setFrame:CGRectMake(0, 0,UGScreenW, 40.0)];
        WeakSelf;
        mUGSignInHeaderView.signInHeaderViewnBlock = ^{
           //签到记录
            NSLog(@"签到记录");
            
             NSDate * nowDate = [NSDate date];
             NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
             [dateformatter setDateFormat:@"yyyy-MM-dd"];
             NSString *  locationString=[dateformatter stringFromDate:nowDate];
            NSLog(@"locationString= %@",locationString);

            [weakSelf checkinDataWithType:@"0" Date:locationString];
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
     if (mUIScrollView == nil) {
         self.collectionView = collectionView;
     }
    [mUIScrollView addSubview:collectionView];
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
            mUGSignInScrFootView.fiveButton.userInteractionEnabled =YES;//交互
            mUGSignInScrFootView.fiveButton.alpha= 1;//透明度
        } else {
            mUGSignInScrFootView.fiveButton.userInteractionEnabled =NO;//交互关闭
            mUGSignInScrFootView.fiveButton.alpha= 0.4;//透明度
        }
        
        if (checkinBonusModel2.isComplete) {
            mUGSignInScrFootView.sevenButtton.userInteractionEnabled =YES;//交互
            mUGSignInScrFootView.sevenButtton.alpha= 1;//透明度
        } else {
            mUGSignInScrFootView.sevenButtton.userInteractionEnabled =NO;//交互关闭
            mUGSignInScrFootView.sevenButtton.alpha= 0.4;//透明度
        }
        
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
            
            [weakSelf checkinDataWithType:@"0" Date:date];

        }
         else if(cell.item.isCheckin == false && cell.item.isMakeup == false){
             //如果日期大于今天，显示签到
             //如果日期小于今天，是显示补签
            int a = [CMCommon compareDate:model.serverTime withDate:model.whichDay withFormat:@"yyyy-MM-dd" ];
             
               NSString *date = model.whichDay;
             
             if (a >= 0) {
                [weakSelf checkinDataWithType:@"0" Date:date];
             } else {
                [weakSelf checkinDataWithType:@"1" Date:date];
             }
             
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
            
            [SVProgressHUD showSuccessWithStatus:model.msg];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
