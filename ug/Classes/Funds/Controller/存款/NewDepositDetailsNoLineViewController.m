//
//  NewDepositDetailsNoLineViewController.m
//  UGBWApp
//
//  Created by ug on 2020/12/9.
//  Copyright © 2020 ug. All rights reserved.
//

#import "NewDepositDetailsNoLineViewController.h"
#import "UGFundsTransferView.h"
#import "UGFunds2microcodeView.h"
#import "UGFundsTransfer2View.h"
#import "UGDepositDetailsTableViewCell.h"
#import "SLWebViewController.h"
#import "UGdepositModel.h"
#import "UGFundsBankView.h"
#import "UGDepositDetailsCollectionViewCell.h"
@interface NewDepositDetailsNoLineViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *tishi1Label;/**<   最👆的提示 */
@property (weak, nonatomic) IBOutlet UILabel *tishi2Label;/**<   最👇的提示 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;/**<   支付通道 */
@property (weak, nonatomic) IBOutlet UGFundsTransferView *uGFundsTransferView;/**<   银行名称 */
//@property (weak, nonatomic) IBOutlet UGFunds2microcodeView *uGFunds2microcodeView;/**<   二维码 */
@property (weak, nonatomic) IBOutlet UITextField *textField;/**<  输入金额txf */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;/**<  金额列表 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colectionViewHeight;/**<  金额列表  高*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;/**<   支付通道table 高 */
@property (weak, nonatomic) IBOutlet UITextView *remarkTV;/**<   备注 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;/**<   用户名称*/
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;            //时间
@property (weak, nonatomic) IBOutlet UIButton *blank_button;/**<  银行按钮 */
@property (weak, nonatomic) IBOutlet UIButton *submit_button;/**<  提交按钮 */

//===========================================数据=====================================================
@property (nonatomic, strong) UGchannelModel *selectChannelModel ;/**<  选中的支付通道 */
@property (nonatomic, strong) NSIndexPath *lastPath;/**<  最后选中table Index */
@property (nonatomic, strong) NSMutableArray <UGchannelModel *> *tableDataArray;/**<  支付通道 table数据*/
@property (nonatomic, strong) NSMutableArray<UGrechargeBankModel> *blankDataArray;/**<  银行数据*/
@property (nonatomic, strong) UGrechargeBankModel *selectBank;/**<  选中银行数据*/
@property (nonatomic, strong) NSMutableArray <NSString *> *amountDataArray;/**<  金额列表数据 collectionView*/
@end

@implementation NewDepositDetailsNoLineViewController
@synthesize  lastPath;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:Skin1.textColor4];
    _blankDataArray = [NSMutableArray<UGrechargeBankModel> new];
    _amountDataArray = [NSMutableArray new];
//    self.submit_button.backgroundColor = Skin1.navBarBgColor;
//    self.blank_button.backgroundColor = Skin1.navBarBgColor;
//    [self.submit_button.layer setBorderWidth:1];
//    [self.blank_button.layer setBorderWidth:1];
//    [self.submit_button.layer setBorderColor:Skin1.navBarBgColor.CGColor];
//    [self.blank_button.layer setBorderColor:Skin1.navBarBgColor.CGColor];
//    self.blank_button.layer.cornerRadius = 5;
//    self.blank_button.layer.masksToBounds = YES;
//    self.submit_button.layer.cornerRadius = 5;
//    self.submit_button.layer.masksToBounds = YES;
    __weakSelf_(__self);
//    [self.submit_button addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
//        [__self rechargeTransfer];
//    }];
//    [self.blank_button addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
//        [__self submitAcion];
//    }];
//
    __block NSTimer *__timer = [NSTimer scheduledTimerWithInterval:1 repeats:true block:^(NSTimer *timer) {

        NSString *date = [[NSDate date] stringWithFormat:@"yyyy/MM/dd"];
        NSString *time = [[NSDate date] stringWithFormat:@"HH:mm"];
        __self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",date,time];
        
        if (!__self) {
            [__timer invalidate];
            __timer = nil;
        }
    }];
    if (__timer.block) {
        __timer.block(nil);
    }

    _tableDataArray = [NSMutableArray new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"UGDepositDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGDepositDetailsTableViewCell"];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.rowHeight = 44;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((self.view.frame.size.width-20-60 ) / 3, 40);
    layout.minimumLineSpacing = 10.0; // 竖
    layout.minimumInteritemSpacing = 10.0; // 横
    layout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"UGDepositDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGDepositDetailsCollectionViewCell"];
    [self.collectionView setCollectionViewLayout:layout];
    self.textField.layer.borderColor= UGRGBColor(221, 221, 221).CGColor;
    self.textField.layer.borderWidth= 1;
    
    if (self.item) {
        _tableDataArray = [[NSMutableArray alloc] initWithArray:_item.channel];
        _selectChannelModel = [_tableDataArray objectAtIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        lastPath = indexPath;
        NSMutableAttributedString *mas = [[NSAttributedString alloc] initWithData:[_item.name dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil].mutableCopy;
        self.title = mas.string;
        [self setUIData:_selectChannelModel];
    }


}


- (void)setUIData:(UGchannelModel *)channelModel{
   
    FastSubViewCode(self.view)
    /**<   最👆的提示 */
    if ([CMCommon stringIsNull:self.item.depositPrompt]) {
        [self.tishi1Label.superview setHidden:YES];
    } else {
        [self.tishi1Label.superview setHidden:NO];
        
        self.tishi1Label.text = self.item.depositPrompt;
        if (self.item.depositPrompt.isHtmlStr) {
                self.tishi1Label.attributedText = ({
                  NSMutableAttributedString *mas = [[NSAttributedString alloc] initWithData:[self.item.prompt dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil].mutableCopy;
                  NSLog(@"string = %@",mas.string);
                  
                  mas;
              });
            self.tishi1Label.font = [UIFont systemFontOfSize:20];
        }
    }
    /**<    最👇的提示  */
    if ([CMCommon stringIsNull:self.item.prompt]) {
        [self.tishi2Label.superview setHidden:YES];
    } else {
        [self.tishi2Label.superview setHidden:NO];
        self.tishi2Label.text = self.item.prompt;
        if (self.item.prompt.isHtmlStr) {
                self.tishi2Label.attributedText = ({
                  NSMutableAttributedString *mas = [[NSAttributedString alloc] initWithData:[self.item.prompt dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil].mutableCopy;
                  NSLog(@"string = %@",mas.string);

                  mas;
              });
            self.tishi2Label.font = [UIFont systemFontOfSize:20];
        }
    }
    /**<   银行名称 */
    self.blankDataArray = nil;
    UGparaModel *bankModel= channelModel.para;
    self.blankDataArray = bankModel.bankList.mutableCopy ;//显示银行数据
    channelModel.paymentid = self.item.pid;
    [self.uGFundsTransferView setItem:channelModel];
    /**<   二维码 */
    if (![CMCommon stringIsNull:channelModel.qrcode]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:channelModel.qrcode] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [LEEAlert alert].config
        .LeeTitle(@"二维码")
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = imgView;
            custom.isAutoWidth = YES;
        })
        .LeeCancelAction(@"关闭", nil)
        .LeeShow();
    }
    
    /**<   二维码 */
//    if ([CMCommon stringIsNull:channelModel.qrcode]) {
//        [self.uGFunds2microcodeView setHidden:YES];
//    } else {
//        [self.uGFunds2microcodeView setHidden:NO];
//        [self.uGFunds2microcodeView setHeaderImageStr:channelModel.qrcode];
//    }
//    self.uGFunds2microcodeView .showBlock = ^{
//        if ([CMCommon stringIsNull:channelModel.qrcode]) {
//            return ;
//        } else {
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
//            [imgView sd_setImageWithURL:[NSURL URLWithString:channelModel.qrcode] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//            [LEEAlert alert].config
//            .LeeTitle(@"二维码")
//            .LeeAddCustomView(^(LEECustomView *custom) {
//                custom.view = imgView;
//                custom.isAutoWidth = YES;
//            })
//            .LeeCancelAction(@"关闭", nil)
//            .LeeShow();
//        }
//    };
//    /**<  银行按钮 */
//    if ([CMCommon arryIsNull:self.blankDataArray]) {
//        [self.blank_button.superview setHidden:YES];
//    } else {
//        [self.blank_button.superview setHidden:NO];
//    }

    /**<  金额列表 */
    if ([CMCommon stringIsNull:bankModel.fixedAmount]) {
        self.amountDataArray = [[NSMutableArray alloc] initWithArray:self.item.quickAmount];
    }
    else{
        NSArray  *array = [bankModel.fixedAmount componentsSeparatedByString:@" "];
        if (![CMCommon arryIsNull:self.amountDataArray]) {
            [self.amountDataArray removeAllObjects];
        }
        for (int i = 0; i<array.count; i++) {
            if (![CMCommon stringIsNull:[array objectAtIndex:i]]) {
                [self.amountDataArray addObject:[array objectAtIndex:i]];
            }
        }
    }

    if ([CMCommon arryIsNull:self.amountDataArray]) {
        [self.collectionView.superview setHidden:YES];
    } else {
        [self.collectionView.superview setHidden:NO];
        float height ;
        if ([CMCommon judgeStr:(int)self.amountDataArray.count with:3]) {
            //能整除   高度
            int verticalCount = (int)self.amountDataArray.count/3;
            height = 5*2+verticalCount*40.0 + (verticalCount -1)*10;
        } else {
            int verticalCount = (int)self.amountDataArray.count/3  +1;
            height = 5*2+verticalCount*40.0 + (verticalCount -1)*10;
        }
        self.colectionViewHeight.constant = height;
    }

    if (APP.isHideText) {
        if ([CMCommon arryIsNull:self.amountDataArray]) {
            [self.textField.superview setHidden:NO];
        } else {
            [self.textField.superview setHidden:YES];
        }
    }
        /**<   支付通道 */
    self.tableViewHeight.constant = self.tableDataArray.count *44.0 +3;
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UGDepositDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGDepositDetailsTableViewCell" forIndexPath:indexPath];
    
    UGchannelModel *channelModel = [_tableDataArray objectAtIndex:indexPath.row];
    
    cell.nameStr = [NSString stringWithFormat:@"%@",channelModel.payeeName];
    
    NSInteger row = [indexPath row];
    
    NSInteger oldRow = [lastPath row];
    
    if (row == oldRow && self.lastPath!=nil) {
        
        cell.headerImageStr = @"RadioButton-Selected";
        
    }else{
        cell.headerImageStr = @"RadioButton-Unselected";
        
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger newRow = [indexPath row];
    
    NSInteger oldRow = (self .lastPath !=nil)?[self .lastPath row]:-1;
    
    if (newRow != oldRow) {
        UGDepositDetailsTableViewCell *newcell = [tableView cellForRowAtIndexPath:indexPath];
        
        newcell.headerImageStr = @"RadioButton-Selected";
        
        UGDepositDetailsTableViewCell *oldcell = [tableView cellForRowAtIndexPath:self.lastPath];
        
        oldcell.headerImageStr = @"RadioButton-Unselected";
        
        self .lastPath = indexPath;
        
        UGchannelModel *channelModel = [_tableDataArray objectAtIndex:indexPath.row];
        
        _selectChannelModel = channelModel;
        
        [self setUIData:_selectChannelModel];
        
        //清空数据
        self.textField.text = @"";
        self.remarkTV.text = @"";
        self.userNameTF.text = @"";
    }
    

}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _amountDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGDepositDetailsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGDepositDetailsCollectionViewCell" forIndexPath:indexPath];
    cell.myStr = [_amountDataArray objectAtIndex:indexPath.row];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld分区---%ldItem", indexPath.section, indexPath.row);
    NSString *nuberStr = [_amountDataArray objectAtIndex:indexPath.row];
    self.textField.text = nuberStr;
}


//#pragma mark - 其他方法
//-(void)showBlackList{
//    UGFundsBankView *notiveView = [[UGFundsBankView alloc] initWithFrame:CGRectMake(20, 120, UGScreenW - 40, UGScerrnH - 260)];
//    notiveView.dataArray = self->_blankDataArray ;
//    notiveView.nameStr = @"--- 请选择银行 ---";
//    WeakSelf;
//    notiveView.signInHeaderViewnBlock =  ^(id model) {
//
//        weakSelf.selectBank = (UGrechargeBankModel *)model;
//        [weakSelf.blank_button setTitle:weakSelf.selectBank.name forState:UIControlStateNormal];
//    };
//    if (![CMCommon arryIsNull:self->_blankDataArray ]) {
//        [notiveView show];
//    }
//}

-(void)submitAcion{
    [self rechargeTransfer];
}
//线下支付
- (void)rechargeTransfer{
    /**<  存款金额 */
    NSString *amount = [self.textField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"amount = %@",amount);
    //备注
    NSString *remark = [self.remarkTV.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"remark = %@",remark);
    //名称
    NSString *payer = [self.userNameTF.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"payer = %@",payer);
    
    if ([CMCommon stringIsNull:amount]) {
        [self.view makeToast:@"请输入金额"];
        return;
    }
    if ([CMCommon stringIsNull:payer]) {
        [self.view makeToast:@"请输入实际转账人姓名"];
        return;
    }
    
    NSDate *timeDate=[NSDate date];
    NSDateFormatter*dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSString * locationString=[dateformatter stringFromDate:timeDate];
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"amount":amount,
                             @"channel":_selectChannelModel.pid,
                             @"payee":_selectChannelModel.account,
                             @"payer":payer,
                             @"remark":remark,
                             @"depositTime":locationString
                             };
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork rechargeTransferWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
                [SVProgressHUD showSuccessWithStatus:model.msg];
            
            //返回上个界面
            //发送通知到存款记录
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
             SANotificationEventPost(UGNotificationDepositSuccessfully, nil);
            
             SANotificationEventPost(UGNotificationWithRecordOfDeposit, nil);

        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}


@end
