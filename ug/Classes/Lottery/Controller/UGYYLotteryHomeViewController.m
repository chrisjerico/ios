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
#import "Global.h"

@interface UGYYLotteryHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation UGYYLotteryHomeViewController

- (BOOL)允许未登录访问 { return ![@"c049,c008" containsString:APP.SiteId]; }
- (BOOL)允许游客访问 { return true; }

- (void)skin {
    [self.view setBackgroundColor: Skin1.bgColor];
    [self getPlatformGamesWithParams];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 禁用侧滑返回
//    self.fd_interactivePopDisabled = true;
    

    if (!self.title) {
        self.title =@"游戏大厅";
    }
    _dataArray = [NSMutableArray array];
    [self.view setBackgroundColor: Skin1.bgColor];
    
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    
    [self initCollectionView];
    
    WeakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getPlatformGamesWithParams];
    }];
    [self getPlatformGamesWithParams];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)initCollectionView {
    
    float itemW = (UGScreenW - 15) / 2;
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemW / 2);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(UGScreenW, 10);
        layout;
    });
    
    UICollectionView *collectionView = ({
        float collectionViewH;
        collectionViewH = UGScerrnH - k_Height_NavBar -k_Height_StatusBar+20;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, UGScreenW, collectionViewH) collectionViewLayout:layout];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGhomeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGhomeRecommendCollectionViewCell" forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UGYYPlatformGames *listModel = self.dataArray[indexPath.row];
    if ([@"lottery" isEqualToString:listModel.category]) {//彩票
        [NavController1 pushViewController:[UGLotteryHomeController new] animated:YES];
        return;
    }
    
    UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
    vc.title = _NSString(@"%@系列", listModel.categoryName);
    vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
    [NavController1 pushViewController:vc animated:YES];
}


#pragma mark 网络请求

- (void)getPlatformGamesWithParams {
    [CMNetwork getPlatformGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [self.collectionView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            
           [Global getInstanse].lotterydataArray = self.dataArray = model.data;
            [self.collectionView reloadData];
        } failure:^(id msg) {
        }];
    }];
}

@end
