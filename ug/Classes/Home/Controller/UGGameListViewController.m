//
//  UGGameListViewController.m
//  ug
//
//  Created by ug on 2019/6/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGameListViewController.h"
#import "WSLWaterFlowLayout.h"
#import "UGGameListCollectionViewCell.h"
#import "UGPlatformGameModel.h"
#import "QDWebViewController.h"

@interface UGGameListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *gameListCellId = @"UGGameListCollectionViewCell";
@implementation UGGameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.game.title;
    self.view.backgroundColor = UGBackgroundColor;
    [self.view addSubview:self.collectionView];
    [self getGameList];
}

- (void)getGameList {
    
    NSDictionary *params = @{@"id":self.game.gameId};
    [CMNetwork getGameListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            self.dataArray = model.data;
            [self.collectionView reloadData];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

- (void)getGotoGameUrl:(UGSubGameModel *)game {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"id":self.game.gameId,
                             @"game":game.code
                             };
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork getGotoGameUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            QDWebViewController *qdwebVC = [[QDWebViewController alloc] init];
            
            NSLog(@"网络链接：model.data = %@",model.data);
            qdwebVC.urlString = [CMNetwork encryptionCheckSignForURL:model.data];
            qdwebVC.enterGame = YES;
            [self.navigationController pushViewController:qdwebVC  animated:YES];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

#pragma mark UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGGameListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameListCellId forIndexPath:indexPath];
    UGSubGameModel *model = self.dataArray[indexPath.row];
    model.type = self.game.title;
    cell.item = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self getGotoGameUrl:self.dataArray[indexPath.row]];
    
}


#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float itemW = (UGScreenW - 5 * 4) / 3;
    return CGSizeMake(itemW,itemW + 60);
    
}

/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 3;
}
/** 行数*/
-(CGFloat)rowCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 5;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return 5;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return 5;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return UIEdgeInsetsMake(5, 0, 5, 0);
    
}


- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        WSLWaterFlowLayout *flow = [[WSLWaterFlowLayout alloc] init];
        flow.delegate = self;
        flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
        
        UICollectionView *collectionView = ({
            float collectionViewH;
            if ([CMCommon isPhoneX]) {
                collectionViewH = UGScerrnH - 88 - 10;
            }else {
                collectionViewH = UGScerrnH - 64 - 10;
            }
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 5, UGScreenW - 10, collectionViewH) collectionViewLayout:flow];
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.layer.cornerRadius = 10;
            collectionView.layer.masksToBounds = YES;
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView setShowsHorizontalScrollIndicator:NO];
            [collectionView registerNib:[UINib nibWithNibName:@"UGGameListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:gameListCellId];
            collectionView;
            
        });
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

@end
