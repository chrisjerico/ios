//
//  UGYYLotterySecondHomeViewController.m
//  ug
//
//  Created by ug on 2019/9/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGYYLotterySecondHomeViewController.h"
#import "UGGameListViewController.h"

#import "UGhomeRecommendCollectionViewCell.h"

@interface UGYYLotterySecondHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation UGYYLotterySecondHomeViewController

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)skin {
    [self.view setBackgroundColor: Skin1.bgColor];
    [self.collectionView  reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor: Skin1.bgColor];
    
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    [self initCollectionView];
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
        float collectionViewH = UGScerrnH - k_Height_NavBar -k_Height_StatusBar+20;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, UGScreenW, collectionViewH) collectionViewLayout:layout];
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
    cell.itemGame = (UGYYGames *)self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UGYYGames *game = self.dataArray[indexPath.row];
    // 去二级游戏列表
    if (game.isPopup) {
        UGGameListViewController *vc = [[UGGameListViewController alloc] init];
        vc.game = game;
        [NavController1 pushViewController:vc animated:YES];
        return;
    }
    NSDictionary *dict = @{@"real":@2,
                           @"fish":@3,
                           @"game":@4,
                           @"card":@5,
                           @"sport":@6,
    };
    NSInteger linkCategory = [dict[game.category] intValue];
    if (!linkCategory) {
        linkCategory = 2;
    }
    [NavController1 pushViewControllerWithLinkCategory:linkCategory linkPosition:game.gameId.intValue];
}

@end

