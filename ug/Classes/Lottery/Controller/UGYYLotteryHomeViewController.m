//
//  UGYYLotteryHomeViewController.m
//  ug
//
//  Created by ug on 2019/9/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGYYLotteryHomeViewController.h"
#import "UGhomeRecommendCollectionViewCell.h"
#import "UGYYPlatformGames.h"
#import "UGYYLotterySecondHomeViewController.h"
#import "UGLotteryHomeController.h"

@interface UGYYLotteryHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation UGYYLotteryHomeViewController
-(void)skin{
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
   
    
    [self getPlatformGamesWithParams];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
   [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
     self.title = @"购彩大厅";
    
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
     _dataArray = [NSMutableArray array];
    [self initCollectionView];
    WeakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getPlatformGamesWithParams];
    }];
    
    [self getPlatformGamesWithParams];
}
- (void)initCollectionView {
    
    float itemW = (UGScreenW - 15) / 2;
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemW / 2);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(UGScreenW, 10);
        layout;
        
    });
    
    UICollectionView *collectionView = ({
        float collectionViewH;
        
        collectionViewH = UGScerrnH - k_Height_NavBar -k_Height_StatusBar+20;
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 10, UGScreenW - 10, collectionViewH) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.layer.cornerRadius = 10;
        collectionView.layer.masksToBounds = YES;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGhomeRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGhomeRecommendCollectionViewCell"];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView;
        
    });
    
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
}


#pragma mark UICollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGhomeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGhomeRecommendCollectionViewCell" forIndexPath:indexPath];
    UGYYPlatformGames *model = self.dataArray[indexPath.row];
    cell.item = model;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UGYYPlatformGames *listModel = self.dataArray[indexPath.row];
    
    if ([@"lottery" isEqualToString:listModel.category]) {//彩票
        UGLotteryHomeController*vc = [[UGLotteryHomeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([@"game" isEqualToString:listModel.category] ) {//电子
        UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
        vc.title = [NSString stringWithFormat:@"%@系列",listModel.categoryName];
         vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([@"fish" isEqualToString:listModel.category]) {//捕鱼
        UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
        vc.title = [NSString stringWithFormat:@"%@系列",listModel.categoryName];
        vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([@"card" isEqualToString:listModel.category]) {//棋牌
        
        UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
        vc.title = [NSString stringWithFormat:@"%@系列",listModel.categoryName];
        vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([@"sport" isEqualToString:listModel.category]) {//体育
        UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
        vc.title = [NSString stringWithFormat:@"%@系列",listModel.categoryName];
        vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([@"real" isEqualToString:listModel.category]) {//真人
        
        UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
        vc.title = [NSString stringWithFormat:@"%@系列",listModel.categoryName];
        vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    NSLog(@"listModel.category = %@",listModel.category);
}


#pragma mark 网络请求
- (void)getPlatformGamesWithParams {
    
    [CMNetwork getPlatformGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [self.collectionView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            
            self.dataArray = model.data;
            [self.collectionView reloadData];
            
        } failure:^(id msg) {
            
        }];
    }];
    
}
@end
