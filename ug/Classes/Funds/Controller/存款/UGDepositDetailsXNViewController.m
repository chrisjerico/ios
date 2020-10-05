//
//  UGDepositDetailsXNViewController.m
//  UGBWApp
//
//  Created by fish on 2020/10/1.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGDepositDetailsXNViewController.h"
#import "UGdepositModel.h"
#import "UGDepositDetailsTableViewCell.h"
#import "UGDepositDetailsCollectionViewCell.h"
#import "UITextView+Extension.h"
@interface UGDepositDetailsXNViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIScrollView *mUIScrollView;
@property (nonatomic, strong) UGchannelModel *selectChannelModel ;  //选中的数据
@property (nonatomic, strong) NSIndexPath *lastPath;                //选中的表索引
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <UGchannelModel *> *tableDataArray;
//===================================================================
@property (nonatomic, strong)IBOutlet  UICollectionView *collectionView ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayoutConstraint;        /**<  contentCollectionView 的约束高*/
@property (nonatomic, strong) NSArray <UGchannelModel *> *channelDataArray;
@property (nonatomic, strong) NSMutableArray <NSString *> *amountDataArray;
@property (strong, nonatomic)  NSString *currencyRate;              //汇率
//===================================================================
@property (weak, nonatomic) IBOutlet UITextView *inputTV;           //备注
@property (weak, nonatomic) IBOutlet UITextField *inputTxf;         //金额输入
@property (strong, nonatomic)  NSString *dayTime;                   //上午/下午
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;            //时间
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;           //金额
@property (nonatomic, weak)IBOutlet UIButton *submit_button;              //提交按钮
@end

@implementation UGDepositDetailsXNViewController
@synthesize  lastPath,item;
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.tableView removeObserver:self forKeyPath:@"contentSize" context:@"tableContext"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUIStyle];
    [self setCollectionViewStyle];
    [self setTableViewStyle];
    [self.inputTxf addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];

    self.moneyLabel.text = @"";
    [self.inputTV setPlaceholderWithText:@"请填写备注信息" Color:Skin1.textColor3];
    _tableDataArray = [NSMutableArray new];
    _amountDataArray = [NSMutableArray new];
    _selectChannelModel = [UGchannelModel new];

    if (self.item) {
        _tableDataArray = [[NSMutableArray alloc] initWithArray: item.channel2];
        _selectChannelModel = [_tableDataArray objectAtIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        lastPath = indexPath;

        NSMutableAttributedString *mas = [[NSAttributedString alloc] initWithData:[self.item.name dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil].mutableCopy;
        self.title = mas.string;
        [self setUIData:_selectChannelModel];
    }
    
    [self.tableView reloadData];
    
    
    __weakSelf_(__self);
    __block NSTimer *__timer = [NSTimer scheduledTimerWithInterval:1 repeats:true block:^(NSTimer *timer) {
        {
            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |                 NSSecondCalendarUnit;
            NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
            int hour = (int)[dateComponent hour];
            
            NSLog(@"hour is: %d", hour);
            if (hour <=5) {
                __self.dayTime = @"凌晨";
            }
            else if (hour <=11) {
                __self.dayTime = @"上午";

            }
            else if (hour <=17) {
                __self.dayTime = @"下午";

            }
            else {
                __self.dayTime = @"晚上";
            }
        }
        
        NSString *date = [[NSDate date] stringWithFormat:@"yyyy/MM/dd"];
        NSString *time = [[NSDate date] stringWithFormat:@"HH:mm"];
        __self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",date,__self.dayTime,time];
        
        if (!__self) {
            [__timer invalidate];
            __timer = nil;
        }
    }];
    if (__timer.block) {
        __timer.block(nil);
    }
}



#pragma mark - UI
-(void)setUIStyle{
    [self.view setBackgroundColor:Skin1.textColor4];
    self.submit_button.layer.cornerRadius = 5;
    self.submit_button.layer.masksToBounds = YES;
    
    FastSubViewCode(self.view);
    subLabel(@"币种内容Label").textColor = Skin1.textColor1;
    subLabel(@"二微码Label").textColor = Skin1.textColor1;
    subLabel(@"提示2Label").textColor = Skin1.textColor1;
    subLabel(@"提示1Label").textColor = [UIColor whiteColor];
    subView(@"提示bgView").backgroundColor = RGBA(255, 95, 108, 1);
    subView(@"2微码bgView").layer.borderWidth = 1;
    subView(@"2微码bgView").layer.borderColor = [RGBA(223 , 230, 240, 1)CGColor];
    subView(@"金额bgView").layer.borderWidth = 1;
    subView(@"金额bgView").layer.borderColor = [RGBA(223 , 230, 240, 1)CGColor];
    subView(@"时间bgView").layer.borderWidth = 1;
    subView(@"时间bgView").layer.borderColor = [RGBA(223 , 230, 240, 1)CGColor];

}

-(void)setCollectionViewStyle{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((self.view.frame.size.width-80 ) / 3, 40);
    layout.minimumLineSpacing = 10.0; // 竖
    layout.minimumInteritemSpacing = 10.0; // 横
    layout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20);
    
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"UGDepositDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGDepositDetailsCollectionViewCell"];

}

-(void)setTableViewStyle{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView registerNib:[UINib nibWithNibName:@"UGDepositDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGDepositDetailsTableViewCell"];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.rowHeight = 44;
    _tableView.scrollEnabled = NO;
    [self.tableView addObserver:self forKeyPath:@"contentSize"  options:NSKeyValueObservingOptionNew context:@"tableContext"];
}

/** 监听自适应高度 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat ht = self.tableView.contentSize.height;
        self.tableView.cc_constraints.height.constant  = ht +2;
    }
}

//设置数据
- (void)setUIData:(UGchannelModel *)channelModel{
    FastSubViewCode(self.view);
    //=====================================
    subLabel(@"币种内容Label").text = channelModel.domain;
    [subLabel(@"链名称内容Label") setText:channelModel.address];
    subLabel(@"二微码Label").text = channelModel.account;
    
    NSLog(@"channelModel.currencyRate = %@",channelModel.currencyRate);
    UIImage * image = [SGQRCodeObtain generateQRCodeWithData:channelModel.account size:160.0];
    [subImageView(@"二微码ImageV") setImage:image];
    [subLabel(@"提示2Label") setText:self.item.prompt];
    [subLabel(@"提示1Label") setText:item.transferPrompt];//address
    
    
    if (![CMCommon stringIsNull:channelModel.branchAddress]) {
        float hlc = [channelModel.branchAddress floatValue];
        float currencyRate =  [channelModel.currencyRate floatValue];
        float jg = (100 + hlc) * currencyRate/100;
        self.currencyRate  = [NSString stringWithFormat:@"%f", jg];
    } else {
        self.currencyRate  = channelModel.currencyRate;
    }
   
    [subLabel(@"汇率Label") setText:[NSString stringWithFormat:@"1 USDT = %@ CNY",[CMCommon randStr:[self currencyRateStr:self.currencyRate count:1.0] scale:2]]];
    //=====================================

    UGparaModel *bankModel= channelModel.para;
    if ([CMCommon stringIsNull:bankModel.fixedAmount]) {
        self.amountDataArray = [[NSMutableArray alloc] initWithArray:self->item.quickAmount];
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
    
    if (self.amountDataArray.count==0) {
        self.heightLayoutConstraint.constant = 0.0;
    }
    else{
        if (self.amountDataArray.count%3==0) {
            self.heightLayoutConstraint.constant = self.amountDataArray.count/3*60+1;
        } else {
            self.heightLayoutConstraint.constant = self.amountDataArray.count/3*60+60+1;
        }
    }
    [self.collectionView reloadData];
    
    
}
//返回汇率
-(NSString *)currencyRateStr:(NSString *)rateStr count :(float )count{
    float hl = [rateStr floatValue];
    float rate =  count / hl ;
    return [NSString stringWithFormat:@"%f",rate];
}

//计算金额
-(NSString *)moenyCount :(float )count{
    float hl = [[self currencyRateStr:self.currencyRate count:1.0]  floatValue];
    NSLog(@"hl = %f",hl);
    float rate =  count / hl ;
    return [NSString stringWithFormat:@"%f",rate];
}

#pragma mark -textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField *)textField
{

    float multip = textField.text.floatValue;
    
    if (multip > 0) {
        [self setMoneyLabelText:multip];
    }

}

-(void)setMoneyLabelText:(float )multip{
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",[CMCommon randStr:[self moenyCount:multip] scale:2]];
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
    self.inputTxf.text = nuberStr;
    [self setMoneyLabelText:nuberStr.floatValue];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
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
        
    }
    

}
#pragma mark - 事件 复制
- (IBAction)wmCopyTaped:(id)sender {
    FastSubViewCode(self.view);
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string =  subLabel(@"二微码Label").text;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}
- (IBAction)jeCopyTaped:(id)sender {
    FastSubViewCode(self.view);
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string =  subLabel(@"金额Label").text;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}


- (IBAction)submitAction:(id)sender {
    [self rechargeTransfer];
}

//线下支付
- (void)rechargeTransfer{
    
    NSString *amount = [self.inputTxf.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"amount = %@",amount);
    NSString *remark = [self.inputTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"remark = %@",remark);
    NSString *payer = [NSString stringWithFormat:@"%@USDT",self.moneyLabel.text];
    
    if ([CMCommon stringIsNull:amount]) {
        [self.view makeToast:@"请输入金额"];
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
    
    NSLog(@"params = %@",params);
    
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
