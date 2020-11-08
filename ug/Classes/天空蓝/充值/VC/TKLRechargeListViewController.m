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
#import "UGDepositDetailsXNViewController.h"
#import "UGDepositDetailsViewController.h"
#import "UGDepositDetailsNoLineViewController.h"
@interface TKLRechargeListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger myRow;
}
@property (weak, nonatomic) IBOutlet UIView *colloectionBgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSMutableArray <UGpaymentModel *> *tableViewDataArray;
@property (nonatomic, strong) UGdepositModel *mUGdepositModel;
@property (strong, nonatomic) UICollectionView  *collectionView;
@property (strong, nonatomic)UGDepositDetailsXNViewController *vc1;
@property (strong, nonatomic)UGDepositDetailsViewController *vc2;
@property (strong, nonatomic)UGDepositDetailsNoLineViewController *vc3;
@end

@implementation TKLRechargeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Skin1.bgColor;
    [self.view addSubview:self.collectionView];
    myRow = 0;
    _tableViewDataArray = [NSMutableArray  new];
    _vc1 = _LoadVC_from_storyboard_(@"UGDepositDetailsXNViewController");
    _vc2 = [UGDepositDetailsViewController new];
    _vc3 = [UGDepositDetailsNoLineViewController new];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.colloectionBgView).with.offset(10);
        make.right.bottom.equalTo(self.colloectionBgView).with.offset(-10);
    }];
    
    [self rechargeCashierData];
   
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tableViewDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TKLCollectionViewCell" forIndexPath:indexPath];
    UGpaymentModel *model = self.tableViewDataArray[indexPath.row];
    cell.item = model;
    if (myRow == indexPath.row) {
        [cell setChecked:YES];
    }
    else{
        [cell setChecked:NO];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld分区---%ldItem", indexPath.section, indexPath.row);
    UGpaymentModel *model = self.tableViewDataArray[indexPath.row];
    if (myRow == indexPath.row) {
        myRow = -1;
        NSLog(@"暂停 == 暂停");
    }
    else
    {
        myRow = indexPath.row;
        NSLog(@"开始 == 开始");
    }
    [_collectionView reloadData];
    
    [self goVC:model];
}
    
 

-(void)goVC:(UGpaymentModel *)model{
    if ([model.pid isEqualToString:@"xnb_transfer"]) {

        UGDepositDetailsXNViewController *vc = _LoadVC_from_storyboard_(@"UGDepositDetailsXNViewController");
        vc.item = model;
        [_contentView removeAllSubviews];
        [_contentView addSubview:vc.view];
     
    }
    else if (![model.pid isEqualToString:@"alihb_online"] && [model.pid containsString:@"online"]) {
        UGDepositDetailsViewController *vc = [UGDepositDetailsViewController new];
        vc.item = model;
        [_contentView removeAllSubviews];
        [_contentView addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_contentView);
        }];
        
    }
    else {
        UGDepositDetailsNoLineViewController *vc = [UGDepositDetailsNoLineViewController new];
        vc.item = model;
        [_contentView removeAllSubviews];
        [_contentView addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_contentView);
        }];
      
    }
}

-(void)selectItme:(int)row{
    UGpaymentModel *model = self.tableViewDataArray[row];
    [self goVC:model];
}

-(void)reLoadDate{
    [self rechargeCashierData];
}

#pragma mark - collectionView样式
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        CGFloat width = UGScreenW -20;
        NSInteger col = 2; // 列数
        
        HLHorizontalPageLayout *layout = [[HLHorizontalPageLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        // item宽
        CGFloat itemWidth = (width - 10 * (col-1) - layout.sectionInset.left - layout.sectionInset.right) / col;
        layout.itemSize = CGSizeMake( itemWidth, 50.0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 15, width, 50.0 * 2 + 20) collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TKLCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"TKLCollectionViewCell"];
        _collectionView.backgroundColor = Skin1.bgColor;
    }
    return _collectionView;
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

            NSLog(@"转账提示 = %@",weakSelf.mUGdepositModel.depositPrompt);
            NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
            [waitQueue addOperationWithBlock:^{
                for (int i = 0; i<weakSelf.mUGdepositModel.payment.count; i++) {
                    
                    UGpaymentModel *uGpaymentModel =  (UGpaymentModel*)[weakSelf.mUGdepositModel.payment objectAtIndex:i];
                    if(![CMCommon arryIsNull:uGpaymentModel.channel]){
                        if (self.type == RT_在线) {
                            if (![uGpaymentModel.pid isEqualToString:@"alihb_online"] && [uGpaymentModel.pid containsString:@"online"]) {
                                [weakSelf.tableViewDataArray addObject:uGpaymentModel];
                                uGpaymentModel.quickAmount = weakSelf.mUGdepositModel.quickAmount;
                                uGpaymentModel.transferPrompt = weakSelf.mUGdepositModel.transferPrompt;
                                uGpaymentModel.depositPrompt = weakSelf.mUGdepositModel.depositPrompt;
                            }
                        }
                        else if(self.type == RT_转账 ){
                            if (![uGpaymentModel.pid isEqualToString:@"alihb_online"] && [uGpaymentModel.pid containsString:@"online"]) {
                            }
                            else{
                                [weakSelf.tableViewDataArray addObject:uGpaymentModel];
                                uGpaymentModel.quickAmount = weakSelf.mUGdepositModel.quickAmount;
                                uGpaymentModel.transferPrompt = weakSelf.mUGdepositModel.transferPrompt;
                                uGpaymentModel.depositPrompt = weakSelf.mUGdepositModel.depositPrompt;
                            }
                        }

                    }
                    
                }
                // 同步到主线程
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf.collectionView reloadData];
                     
                     dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));

                     dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                         [weakSelf selectItme:0];
                     });
                });
            }];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
//            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}


@end
