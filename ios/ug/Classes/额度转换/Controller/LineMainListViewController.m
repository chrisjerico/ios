//
//  LineMainListViewController.m
//  ug
//
//  Created by ug on 2020/2/21.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LineMainListViewController.h"
#import "LineMainListCollectionViewCell.h"
#import "YBPopupMenu.h"

@interface LineMainListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,YBPopupMenuDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *lineCollection;   /**<   内容列表 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel1;              /**<   转出 */
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn1;               /**<   转出按钮 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel2;              /**<  转入 */
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn2;               /**<   转入按钮 */
@property (weak, nonatomic) IBOutlet UITextField *moneyTxt;             /**<   转入金额 */
@property (weak, nonatomic) IBOutlet UIImageView *transferOutArrow; /**<   转出箭头ImageView */
@property (weak, nonatomic) IBOutlet UIImageView *tarnsferInArrow;  /**<   转入箭头ImageView */

@property (nonatomic, strong) YBPopupMenu *transferOutPopView;
@property (nonatomic, strong) YBPopupMenu *transferInPopView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *itemBtns;
@property (nonatomic, strong) NSMutableArray <NSString *> *transferArray;
@property (nonatomic, assign) NSInteger outIndex;
@property (nonatomic, assign) NSInteger inIndex;

@end

@implementation LineMainListViewController
-(void)dataReLoad{
    [self.lineCollection reloadData];
}
- (NSMutableArray<NSString *> *)transferArray {
    if (_transferArray == nil) {
        _transferArray = [NSMutableArray array];
    }
    return _transferArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor: Skin1.bgColor];
    
    _moneyTxt.delegate = self;
    self.lineCollection.dataSource = self;
    self.lineCollection.delegate = self;
    
    [self.lineCollection registerNib:[UINib nibWithNibName:@"LineMainListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LineMainListCollectionViewCell"];

    [self.lineCollection reloadData];
    
     float height =   self.lineCollection.collectionViewLayout.collectionViewContentSize.height;
    self.lineCollection.cc_constraints.height.constant = height;
 
}

-(void)setDataArray:(NSMutableArray<UGPlatformGameModel *> *)dataArray{
    _dataArray = dataArray;
    [self.transferArray addObject:@"我的钱包"];
    for (UGPlatformGameModel *game in self.dataArray) {
        [self.transferArray addObject:game.title];
    }
}

#pragma mark UICollectionView datasource
//collectionView有几个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    int sections = 1;
    return sections;
}
//每个section有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger rows = self.dataArray.count;
    return rows;
}

//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    {
        LineMainListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LineMainListCollectionViewCell" forIndexPath:indexPath];
        UGPlatformGameModel *model = self.dataArray[indexPath.row];
        cell.item = model;
        [cell.nameLabel setTextColor:Skin1.textColor1];
        [cell.contentView setBackgroundColor:Skin1.conversionCellColor];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [[UIColor whiteColor] CGColor];

        WeakSelf
        cell.refreshBlock = ^{
            model.refreshing = YES;
            [weakSelf checkRealBalance:model];
            [weakSelf.lineCollection reloadData];
        };
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate


//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float itemW = (APP.Width - 0.0 )/ 3.0;
    
    CGSize size = {itemW, itemW};
    return size;
    
}

//item偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

}
#pragma mark YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0) {
        if (ybPopupMenu == self.transferOutPopView) {
            self.moneyLabel1.text = self.transferArray[index];
            self.outIndex = index;
        } else {
            self.moneyLabel2.text = self.transferArray[index];
            self.inIndex = index;
        }
    }
    
    if (ybPopupMenu == self.transferOutPopView) {
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
        self.transferOutArrow.transform = transform;
    }else {
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
        self.tarnsferInArrow.transform = transform;
        
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.moneyTxt resignFirstResponder];
        return NO;
    }
    if (textField.text.length + string.length - range.length > 8) {
        return NO;
    }
    return YES;
}
#pragma mark - 点击事件

// 选择转出钱包
- (IBAction)transferOutClick:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.transferOutArrow.transform = transform;
    self.transferOutPopView = [[YBPopupMenu alloc] initWithTitles:self.transferArray icons:nil menuWidth:CGSizeMake(self.moneyBtn1.width+30, 250) delegate:self];
    self.transferOutPopView.fontSize = 14;
    self.transferOutPopView.type = YBPopupMenuTypeDefault;
    [self.transferOutPopView showRelyOnView:self.moneyBtn1];
}

// 选择转入钱包
- (IBAction)transferInClick:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.tarnsferInArrow.transform = transform;
    self.transferInPopView = [[YBPopupMenu alloc] initWithTitles:self.transferArray icons:nil menuWidth:CGSizeMake(self.moneyBtn2.width+30, 250) delegate:self];
    self.transferInPopView.fontSize = 14;
    self.transferInPopView.type = YBPopupMenuTypeDefault;
    [self.transferInPopView showRelyOnView:self.moneyBtn2];
}


// 开始转换
- (IBAction)startTransfer:(id)sender {
    ck_parameters(^{
        ck_parameter_non_empty(self.moneyLabel1.text, @"请选择转出钱包");
        ck_parameter_non_empty(self.moneyLabel2.text, @"请选择转入钱包");
        ck_parameter_non_equal(self.moneyLabel1.text, self.moneyLabel2.text, @"转出钱包和转入钱包不能一致");
        ck_parameter_non_empty(self.moneyTxt.text, @"请输入转换金额");
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        
        [self.moneyTxt resignFirstResponder];
        UGPlatformGameModel *outModel;
        UGPlatformGameModel *intModel;
        if (self.outIndex) {
            outModel = self.dataArray[self.outIndex - 1];
        }
        if (self.inIndex) {
            intModel = self.dataArray[self.inIndex - 1];
        }
        [SVProgressHUD showWithStatus:nil];
        
        NSString *amount = self.moneyTxt.text;
        if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
            return;
        }
        NSDictionary *params = @{@"fromId":outModel ? outModel.gameId : @"0",
                                 @"toId":intModel ? intModel.gameId : @"0",
                                 @"money":amount,
                                 @"token":[UGUserModel currentUser].sessid,
        };
        
        [CMNetwork manualTransferWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                SANotificationEventPost(UGNotificationGetUserInfo, nil);
                self.moneyLabel1.text = nil;
                self.moneyLabel2.text = nil;
                self.moneyTxt.text = nil;
                
                if (!outModel || !intModel)
                    SANotificationEventPost(UGNotificationGetUserInfo, nil);
                
                // 刷新ui
                intModel.balance = [AppDefine stringWithFloat:(intModel.balance.doubleValue + amount.doubleValue) decimal:4];
                outModel.balance = [AppDefine stringWithFloat:(outModel.balance.doubleValue - amount.doubleValue) decimal:4];
                [self.lineCollection reloadData];
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    });
}

- (void)checkRealBalance:(UGPlatformGameModel *)game {
    NSDictionary *parmas = @{@"id":game.gameId,
                             @"token":[UGUserModel currentUser].sessid
    };
    [CMNetwork checkRealBalanceWithParams:parmas completion:^(CMResult<id> *model, NSError *err) {
        
        [CMResult processWithResult:model success:^{
            NSDictionary *dict = (NSDictionary *)model.data;
            game.balance = dict[@"balance"];
            
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
        game.refreshing = NO;
        [self.lineCollection reloadData];
    }];
    
}
//一键领取
- (IBAction)onExtractAllBtnClick:(UIButton *)sender {
    if (!_dataArray.count) {
        return;
    }
    
    __weakSelf_(__self);
    __block NSInteger __cnt = 0;
    [SVProgressHUD show];
    for (UGPlatformGameModel *pgm in __self.dataArray) {
        // 快速转出游戏余额
        [CMNetwork quickTransferOutWithParams:@{@"token":UserI.sessid, @"id":pgm.gameId} completion:^(CMResult<id> *model, NSError *err) {
            __cnt++;
            if (__cnt == __self.dataArray.count) {
                [SVProgressHUD showSuccessWithStatus:@"一键提取成功"];
                // 刷新余额并刷新UI
                SANotificationEventPost(UGNotificationGetUserInfo, nil);
                for (UGPlatformGameModel *pgm in __self.dataArray) {
                    pgm.balance = @"0.00";
                }
                __self.moneyLabel1.text = nil;
                __self.moneyLabel2.text = nil;
                __self.moneyTxt.text = nil;
                [__self.lineCollection reloadData];
            }
        }];
    }
}

- (IBAction)btnAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if ([btn.tagString isEqualToString:@"全部Btn"]) {
        _moneyTxt.text = @"";
    }
    if ([btn.tagString isEqualToString:@"100Btn"]) {
        _moneyTxt.text = @"100";
    }
    if ([btn.tagString isEqualToString:@"500Btn"]) {
        _moneyTxt.text = @"500";
    }
    if ([btn.tagString isEqualToString:@"1000Btn"]) {
        _moneyTxt.text = @"1000";
    }
    if ([btn.tagString isEqualToString:@"5000Btn"]) {
        _moneyTxt.text = @"5000";
    }
    if ([btn.tagString isEqualToString:@"1000Btn"]) {
        _moneyTxt.text = @"10000";
    }
}


@end
