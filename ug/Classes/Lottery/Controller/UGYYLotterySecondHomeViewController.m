//
//  UGYYLotterySecondHomeViewController.m
//  ug
//
//  Created by ug on 2019/9/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGYYLotterySecondHomeViewController.h"
#import "UGhomeRecommendCollectionViewCell.h"

@interface UGYYLotterySecondHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation UGYYLotterySecondHomeViewController

- (void)skin {
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    [self.collectionView  reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    
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
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(UGScreenW, 10);
        layout;
        
    });
    
    UICollectionView *collectionView = ({
        float collectionViewH;
        
        collectionViewH = UGScerrnH - k_Height_NavBar -k_Height_StatusBar+20;
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5,10, UGScreenW - 10, collectionViewH) collectionViewLayout:layout];
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
    [cell setBackgroundColor: [[UGSkinManagers shareInstance] sethomeContentColor]];
    cell.layer.borderColor = [[[UGSkinManagers shareInstance] sethomeContentColor] CGColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self getGotoGameUrl:self.dataArray[indexPath.row]];
}


#pragma mark 网络请求

- (void)getGotoGameUrl:(UGYYGames *)game {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"id":game.gameId
                             };
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork getGotoGameUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                QDWebViewController *qdwebVC = [[QDWebViewController alloc] init];
                 NSLog(@"网络链接：model.data = %@",model.data);
                qdwebVC.urlString = [CMNetwork encryptionCheckSignForURL:model.data];
                qdwebVC.enterGame = YES;
                [self.navigationController pushViewController:qdwebVC  animated:YES];
            });
            
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

@end

