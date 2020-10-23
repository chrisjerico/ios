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
@property (nonatomic, weak)IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <UGSubGameModel *> *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn; //搜索按钮
@property (weak, nonatomic) IBOutlet UITextField *textF; //搜索textF

@end

static NSString *gameListCellId = @"UGGameListCollectionViewCell";

@implementation UGGameListViewController

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.game.title;
    self.view.backgroundColor = Skin1.bgColor;
    self.searchBtn.layer.cornerRadius = 5;
    self.searchBtn.layer.masksToBounds = YES;
    [self.searchBtn setBackgroundColor:Skin1.navBarBgColor];
    [self collectionViewStyle];
    [self getGameList:YES];
}

- (IBAction)searchAction:(id)sender {
    [self getGameList:NO];
}
- (IBAction)allAction:(id)sender {
    [self getGameList:YES];
}

- (void)getGameList: (BOOL)isAll {
    
    WeakSelf;
    NSDictionary *params;
    if (isAll) {
        params = @{@"id":self.game.gameId};
    } else {
        NSString *searchStr = @"";
        if (![CMCommon stringIsNull:self.textF.text]) {
            searchStr = self.textF.text.stringByTrim;
        }
        
       params = @{@"id":self.game.gameId,
                  @"search_text":searchStr
                  };
    }
     
    [CMNetwork getGameListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            weakSelf.dataArray = model.data;
            [weakSelf.collectionView reloadData];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

- (void)getGotoGameUrl:(UGSubGameModel *)game {
    if (!UGLoginIsAuthorized()) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UGNotificationShowLoginView object:nil];
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"id":self.game.gameId,
                             @"game":game.code
                             };
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork getGotoGameUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            QDWebViewController *qdwebVC = [[QDWebViewController alloc] init];
            
            NSLog(@"网络链接：model.data = %@",model.data);
            qdwebVC.urlString = [CMNetwork encryptionCheckSignForURL:model.data];
            qdwebVC.enterGame = YES;
            [weakSelf.navigationController pushViewController:qdwebVC  animated:YES];
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


- (void)collectionViewStyle {

    WSLWaterFlowLayout *flow = [[WSLWaterFlowLayout alloc] init];
    flow.delegate = self;
    flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;

    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.layer.cornerRadius = 10;
    self.collectionView.layer.masksToBounds = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerNib:[UINib nibWithNibName:@"UGGameListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:gameListCellId];
    
    [self.collectionView setCollectionViewLayout:flow];
}

- (NSMutableArray<UGSubGameModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

@end
