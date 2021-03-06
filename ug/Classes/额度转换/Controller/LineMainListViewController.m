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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor: Skin1.bgColor];
    
    _moneyTxt.delegate = self;
    self.lineCollection.dataSource = self;
    self.lineCollection.delegate = self;
    //    self.lineCollection.bounces = NO;
    
    [self.lineCollection registerNib:[UINib nibWithNibName:@"LineMainListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LineMainListCollectionViewCell"];
    
    [self.lineCollection reloadData];
    
    float height =   self.lineCollection.collectionViewLayout.collectionViewContentSize.height;
    self.lineCollection.cc_constraints.height.constant = height + 5;
    
    
    if (Skin1.isBlack) {
        _lineCollection.backgroundColor = Skin1.bgColor;
        FastSubViewCode(self.view);
        subLabel(@"转出Label").textColor = Skin1.textColor1;
        subLabel(@"转入Label").textColor = Skin1.textColor1;
        subLabel(@"转入金额Label").textColor = Skin1.textColor1;
        subLabel(@"元Label").textColor = Skin1.textColor1;
        subLabel(@"元Label").superview.backgroundColor = Skin1.bgColor;
        [subButton(@"全部Btn") setTitleColor:Skin1.textColor1 forState:UIControlStateNormal];
        [subButton(@"100Btn") setTitleColor:Skin1.textColor1 forState:UIControlStateNormal];
        [subButton(@"500Btn") setTitleColor:Skin1.textColor1 forState:UIControlStateNormal];
        [subButton(@"1000Btn") setTitleColor:Skin1.textColor1 forState:UIControlStateNormal];
        [subButton(@"5000Btn") setTitleColor:Skin1.textColor1 forState:UIControlStateNormal];
        [subButton(@"10000Btn") setTitleColor:Skin1.textColor1 forState:UIControlStateNormal];
        subButton(@"全部Btn").backgroundColor = Skin1.bgColor;
        subButton(@"100Btn").backgroundColor = Skin1.bgColor;
        subButton(@"500Btn").backgroundColor = Skin1.bgColor;
        subButton(@"1000Btn").backgroundColor = Skin1.bgColor;
        subButton(@"5000Btn").backgroundColor = Skin1.bgColor;
        subButton(@"10000Btn").backgroundColor = Skin1.bgColor;
    }
    
    _transferArray = [NSMutableArray array];
    for (UGPlatformGameModel *game in self.dataArray) {
        [self.transferArray addObject:game.title];
    }
    self.outIndex = -1;
    self.inIndex = -1;
}

-(void)setDataArray:(NSMutableArray<UGPlatformGameModel *> *)dataArray{
    _dataArray = dataArray;

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
        [cell.contentView setBackgroundColor:Skin1.isBlack ? Skin1.bgColor : Skin1.conversionCellColor];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        WeakSelf
        cell.refreshBlock = ^{
            model.refreshing = YES;
            [weakSelf checkRealBalance:model indexs:indexPath];
            
        };
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate


//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float itemW = (APP.Width - 0.0 )/ 3.0;
    
    CGSize size = {itemW, itemW*2/3};
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
    
    if (self.outIndex == -1) {
        [SVProgressHUD showInfoWithStatus:@"请选择转出钱包"];
        return;
    }
    if (self.inIndex == -1) {
        [SVProgressHUD showInfoWithStatus:@"请选择转入钱包"];
        return;
    }
    ck_parameters(^{
        ck_parameter_non_empty(self.moneyLabel1.text, @"请选择转出钱包");
        ck_parameter_non_empty(self.moneyLabel2.text, @"请选择转入钱包");
        ck_parameter_non_equal(self.moneyLabel1.text, self.moneyLabel2.text, @"转出钱包和转入钱包不能一致");
        ck_parameter_non_empty(self.moneyTxt.text, @"请输入转换金额");
    
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        
        

        NSLog(@"self.outIndex = %ld",(long)self.outIndex);
        NSLog(@"self.inIndex = %ld",(long)self.inIndex);
        [self.moneyTxt resignFirstResponder];
        UGPlatformGameModel *outModel;
        UGPlatformGameModel *intModel;
       
        outModel = self.dataArray[self.outIndex];
        if ([CMCommon stringIsNull:outModel.gameId] ) {
            outModel.gameId = @"0";
        }
        
        intModel = self.dataArray[self.inIndex];
        if ([CMCommon stringIsNull:intModel.gameId] ) {
            intModel.gameId = @"0";
        }
       
        [SVProgressHUD showWithStatus:nil];
        
        NSString *amount = self.moneyTxt.text;
        if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
            return;
        }
        NSDictionary *params = @{@"fromId": outModel.gameId ,
                                 @"toId": intModel.gameId ,
                                 @"money":amount,
                                 @"token":[UGUserModel currentUser].sessid,
        };
        WeakSelf;
        [CMNetwork manualTransferWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                SANotificationEventPost(UGNotificationGetUserInfo, nil);
                weakSelf.moneyLabel1.text = nil;
                weakSelf.moneyLabel2.text = nil;
                weakSelf.moneyTxt.text = nil;
                
                if (!outModel || !intModel)
                    SANotificationEventPost(UGNotificationGetUserInfo, nil);
                
                // 刷新ui
                intModel.balance = [AppDefine stringWithFloat:(intModel.balance.doubleValue + amount.doubleValue) decimal:4];
                outModel.balance = [AppDefine stringWithFloat:(outModel.balance.doubleValue - amount.doubleValue) decimal:4];
                [weakSelf.lineCollection reloadData];
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    });
}

- (void)checkRealBalance:(UGPlatformGameModel *)game   indexs:(NSIndexPath *)index{
    NSDictionary *parmas = @{@"id":game.gameId,
                             @"token":[UGUserModel currentUser].sessid
    };
    
    LineMainListCollectionViewCell *cell =  (LineMainListCollectionViewCell *)[self.lineCollection cellForItemAtIndexPath:index];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [cell animationFunction ];
    });
    WeakSelf;
    [CMNetwork checkRealBalanceWithParams:parmas completion:^(CMResult<id> *model, NSError *err) {
        
        [CMResult processWithResult:model success:^{
            NSDictionary *dict = (NSDictionary *)model.data;
            game.balance = dict[@"balance"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                game.refreshing = NO;
                [cell animationFunction ];
                NSMutableArray *indexPaths = [NSMutableArray array];
                [indexPaths addObject:index];
                [weakSelf.lineCollection reloadItemsAtIndexPaths:indexPaths];
            });
            
            
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                game.refreshing = NO;
                [cell animationFunction ];
                NSMutableArray *indexPaths = [NSMutableArray array];
                [indexPaths addObject:index];
                [weakSelf.lineCollection reloadItemsAtIndexPaths:indexPaths];
            });
        }];
        
    }];
    
}
//一键领取
- (IBAction)onExtractAllBtnClick:(UIButton *)sender {
    
    
    if (!_dataArray.count) {
        return;
    }
    

    
    __weakSelf_(__self);
    
    [SVProgressHUD show];
    
    [CMNetwork oneKeyTransferOutWithParams:@{@"token":UserI.sessid} completion:^(CMResult<id> *model, NSError *err) {
       
        
        [CMResult processWithResult:model success:^{
            if (model.code != 0) return;
            
            __block NSInteger __cnt = 0;
            NSArray <UGPlatformGameModel *>*arry = [UGPlatformGameModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"games"] error:nil];
            
            for (UGPlatformGameModel *pgm in arry) {
                NSLog(@"pgm =%@",pgm.gameId);
                // 快速转出游戏余额
                [CMNetwork quickTransferOutWithParams:@{@"token":UserI.sessid, @"id":pgm.gameId} completion:^(CMResult<id> *model, NSError *err) {
                    __cnt++;
                    if (__cnt == arry.count) {
                        [SVProgressHUD showSuccessWithStatus:@"一键提取完成"];
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
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

- (IBAction)btnAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if ([btn.tagString isEqualToString:@"全部Btn"]) {
        UGUserModel *user = [UGUserModel currentUser];
        double floatString = [user.balance doubleValue];
        _moneyTxt.text = [NSString stringWithFormat:@"%.2f",floatString];;
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
    if ([btn.tagString isEqualToString:@"10000Btn"]) {
        _moneyTxt.text = @"10000";
    }
}


@end
