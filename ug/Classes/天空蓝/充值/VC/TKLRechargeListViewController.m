//
//  TKLRechargeListViewController.m
//  UGBWApp
//
//  Created by fish on 2020/11/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "TKLRechargeListViewController.h"
#import "TKLCollectionViewCell.h"
#import "HLHorizontalPageLayout.h"
#import "UGdepositModel.h"
@interface TKLRechargeListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView  *collectionView;
@property (nonatomic, strong) UGdepositModel *mUGdepositModel;
@property (nonatomic, strong) NSMutableArray <UGpaymentModel *> *tableViewDataArray;

@end

@implementation TKLRechargeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Skin1.bgColor;
    [self collectionViewInit];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tableViewDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TKLCollectionViewCell" forIndexPath:indexPath];
    UGpaymentModel *model = self.tableViewDataArray[indexPath.row];
    cell.item = model;
    return cell;
}


#pragma mark - collectionView样式
- (void)collectionViewInit {
    
    
    CGFloat width = self.collectionView.bounds.size.width;
    NSInteger col = 2; // 列数
    
    HLHorizontalPageLayout *layout = [[HLHorizontalPageLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    // item宽
    CGFloat itemWidth = (width - 10 * (col-1) - layout.sectionInset.left - layout.sectionInset.right) / col;
    layout.itemSize = CGSizeMake( itemWidth, 44.0);
    
    [_collectionView setCollectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TKLCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"TKLCollectionViewCell"];
    _collectionView.backgroundColor = Skin1.bgColor;

}

#pragma mark -- 网络请求
//得到支付列表数据
- (void)rechargeCashierData {
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    if (!UGLoginIsAuthorized()) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork rechargeCashierWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            weakSelf.mUGdepositModel = model.data;
//            NSLog(@"odel.data = %@",model.data);
            
            NSLog(@"转账提示 = %@",weakSelf.mUGdepositModel.depositPrompt);
//            weakSelf.tableViewDataArray = weakSelf.mUGdepositModel.payment;
            NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
            [waitQueue addOperationWithBlock:^{
                for (int i = 0; i<weakSelf.mUGdepositModel.payment.count; i++) {
                    
                    UGpaymentModel *uGpaymentModel =  (UGpaymentModel*)[weakSelf.mUGdepositModel.payment objectAtIndex:i];
                    if(![CMCommon arryIsNull:uGpaymentModel.channel]){
                        [weakSelf.tableViewDataArray addObject:uGpaymentModel];
                        uGpaymentModel.quickAmount = weakSelf.mUGdepositModel.quickAmount;
                        uGpaymentModel.transferPrompt = weakSelf.mUGdepositModel.transferPrompt;
                        uGpaymentModel.depositPrompt = weakSelf.mUGdepositModel.depositPrompt;
                    }
                }
                // 同步到主线程
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf.collectionView reloadData];
                });
            }];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}


@end
