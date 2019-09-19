//
//  UGDepositDetailsNoLineViewController.m
//  ug
//
//  Created by ug on 2019/9/13.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGDepositDetailsNoLineViewController.h"
#import "UGDepositDetailsTableViewCell.h"
#import "SLWebViewController.h"
#import "UGdepositModel.h"
#import "UGFundsBankView.h"

#import "UGFundsTransferView.h"
#import "UGFunds2microcodeView.h"
#import "UGFundsTransfer2View.h"

@interface UGDepositDetailsNoLineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *mUIScrollView;

@property (nonatomic, strong) UGchannelModel *selectChannelModel ;
@property(nonatomic,strong)NSIndexPath *lastPath;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataArray;

@property (nonatomic, strong)UIView *bg_label;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UILabel *tiplabel;
@property (nonatomic, strong) NSArray *channelDataArray;
@property (nonatomic, strong)UILabel *tip2label;
@property (nonatomic, strong)UGFundsTransferView *uGFundsTransferView;
@property (nonatomic, strong)UGFundsTransfer2View *uGFundsTransfer2View;
@property (nonatomic, strong)UGFunds2microcodeView *uGFunds2microcodeView;

@property (nonatomic, strong)UIButton *blank_button;
@property (nonatomic, strong) NSMutableArray<UGrechargeBankModel> *blankDataArray;
@property (nonatomic, strong)UGrechargeBankModel *selectBank;

@property (nonatomic, strong)UIButton *submit_button;
@end

@implementation UGDepositDetailsNoLineViewController
@synthesize  lastPath,item;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _channelDataArray = [NSArray new];
    _tableDataArray = [NSMutableArray new];
    _blankDataArray = [NSMutableArray<UGrechargeBankModel> new];
    
    [self.view setBackgroundColor:UGRGBColor(239, 239, 244)];
    
    if (self.item) {
        _channelDataArray = item.channel;
        _tableDataArray =[[NSMutableArray alloc] initWithArray:_channelDataArray];
        
    }
    
    [self creatUI];
    
    if (self.item) {
        _selectChannelModel = [_tableDataArray objectAtIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        lastPath = indexPath;

        self.title = item.name;
        [self setUIData:_selectChannelModel];
    }
    
    [self.tableView reloadData];
}

- (void)setUIData:(UGchannelModel *)channelModel{

    //==============================================================
    
    self->_blankDataArray = nil;
    
    UGparaModel *bankModel= channelModel.para;
    
    
    self->_blankDataArray = bankModel.bankList ;//显示银行数据
    
     channelModel.paymentid = self.item.pid;
     [self.uGFundsTransferView setItem:channelModel];
     self.tiplabel .text = self.item.depositPrompt;
    self.label.text = self.item.prompt;
    
    if ([CMCommon arryIsNull:self->_blankDataArray]) {
        [self->_blank_button setHidden:YES];
    } else {
        [self->_blank_button setHidden:NO];
    }
    

    if ([CMCommon stringIsNull:channelModel.qrcode]) {
        [self->_uGFunds2microcodeView setHidden:YES];
    } else {
        [self->_uGFunds2microcodeView setHidden:NO];
        [self.uGFunds2microcodeView setHeaderImageStr:channelModel.qrcode];
    }
    
    
    //==============================================================
    [self.tiplabel  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view.mas_left).with.offset(10);
         make.right.equalTo(self.view.mas_right).with.offset(-10);
         make.top.equalTo(self.mUIScrollView.mas_top).offset(0);
         make.width.mas_equalTo(UGScreenW-20);
         
     }];
    [self.tiplabel setText:item.transferPrompt];
    [self.tiplabel sizeToFit];
    NSLog(@"%@",NSStringFromCGRect(self.tiplabel.frame));
    //==============================================================
    [self.tip2label  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view.mas_left).with.offset(10);
         make.right.equalTo(self.view.mas_right).with.offset(-10);
         make.top.equalTo(self.tiplabel.mas_bottom).offset(0);
         make.width.mas_equalTo(UGScreenW-20);
         make.height.mas_equalTo(34);
     }];
    NSLog(@"%@",NSStringFromCGRect(self.tip2label.frame));
    //==============================================================
    float tableViewHeight = self->_tableDataArray.count *44.0;
    [self.tableView  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view.mas_left).with.offset(0);
         make.right.equalTo(self.view.mas_right).with.offset(0);
         make.top.equalTo(self.tip2label.mas_bottom).offset(0);
         make.height.mas_equalTo(tableViewHeight);

     }];
    //==============================================================
    [self.uGFundsTransferView  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view.mas_left).with.offset(0);
         make.right.equalTo(self.view.mas_right).with.offset(0);
         make.top.equalTo(self.tableView.mas_bottom).offset(0);
         make.width.mas_equalTo(UGScreenW);
         make.height.mas_equalTo(208);
     }];
    NSLog(@"%@",NSStringFromCGRect(self.uGFundsTransferView.frame));
    
    //==============================================================
    [self.uGFunds2microcodeView  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view.mas_left).with.offset(0);
         make.right.equalTo(self.view.mas_right).with.offset(0);
         make.top.equalTo(self.uGFundsTransferView.mas_bottom).offset(0);
         make.width.mas_equalTo(UGScreenW);
         make.height.mas_equalTo(120);
     }];
    NSLog(@"%@",NSStringFromCGRect(self.uGFunds2microcodeView.frame));
     //==============================================================
    if ([CMCommon stringIsNull:channelModel.qrcode]) {
        [self.uGFundsTransfer2View  mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view.mas_left).with.offset(0);
             make.right.equalTo(self.view.mas_right).with.offset(0);
             make.top.equalTo(self.uGFundsTransferView.mas_bottom).offset(0);
             make.width.mas_equalTo(UGScreenW);
             make.height.mas_equalTo(181);
         }];
    } else {
        [self.uGFundsTransfer2View  mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view.mas_left).with.offset(0);
             make.right.equalTo(self.view.mas_right).with.offset(0);
             make.top.equalTo(self.uGFunds2microcodeView.mas_bottom).offset(0);
             make.width.mas_equalTo(UGScreenW);
             make.height.mas_equalTo(181);
         }];
    }

    //==============================================================
    [self.label  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view.mas_left).with.offset(10);
         make.right.equalTo(self.view.mas_right).with.offset(-10);
         make.top.mas_equalTo(self.uGFundsTransfer2View.mas_bottom).offset(10);
         make.width.mas_equalTo(UGScreenW-40);


     }];
    [self.label setText:self.item.prompt];
    [self.label sizeToFit];
    NSLog(@"%@",NSStringFromCGRect(self.label.frame));
    
    
    [self.bg_label  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view.mas_left).with.offset(0);
         make.right.equalTo(self.view.mas_right).with.offset(0);
         make.top.equalTo(self.uGFundsTransfer2View.mas_bottom).offset(0);
         make.width.mas_equalTo(UGScreenW-20);
         make.height.equalTo(self.label.mas_height).offset(20);

     }];
    [self.bg_label setBackgroundColor:[UIColor redColor]];
    //==================================================================
    [self.blank_button  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view.mas_left).with.offset(0);
         make.right.equalTo(self.view.mas_right).with.offset(0);
         make.top.equalTo(self.bg_label.mas_bottom).offset(10);
         make.height.mas_equalTo(44);
         
     }];
     //==============================================================
    
    if ([self.blank_button isHidden]) {
        [self.submit_button  mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view.mas_left).with.offset(0);
             make.right.equalTo(self.view.mas_right).with.offset(0);
             make.top.equalTo(self.bg_label.mas_bottom).offset(20);
             make.height.mas_equalTo(44);
             
         }];
    } else {
        [self.submit_button  mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view.mas_left).with.offset(0);
             make.right.equalTo(self.view.mas_right).with.offset(0);
             make.top.equalTo(self.blank_button.mas_bottom).offset(20);
             make.height.mas_equalTo(44);
             
         }];
    }
  
    if ([CMCommon stringIsNull:channelModel.qrcode]) {
        if ([self.blank_button isHidden]) {
           _mUIScrollView.contentSize = CGSizeMake(UGScreenW, self.tiplabel.height+self.tip2label.height+self.tableView.height+self.uGFundsTransferView.height+self.bg_label.height+self.blank_button.height+self.submit_button.height+20+self.uGFundsTransfer2View.height);
        } else {
            _mUIScrollView.contentSize = CGSizeMake(UGScreenW, self.tiplabel.height+self.tip2label.height+self.tableView.height+self.uGFundsTransferView.height+self.bg_label.height+self.blank_button.height+self.submit_button.height+64+self.uGFundsTransfer2View.height);
        }
        
    } else {
        if ([self.blank_button isHidden]) {
            _mUIScrollView.contentSize = CGSizeMake(UGScreenW, self.tiplabel.height+self.tip2label.height+self.tableView.height+self.uGFundsTransferView.height+self.bg_label.height+self.blank_button.height+self.submit_button.height+20+self.uGFundsTransfer2View.height+self.uGFunds2microcodeView.height);
        } else {
            _mUIScrollView.contentSize = CGSizeMake(UGScreenW, self.tiplabel.height+self.tip2label.height+self.tableView.height+self.uGFundsTransferView.height+self.bg_label.height+self.blank_button.height+self.submit_button.height+64+self.uGFundsTransfer2View.height+self.uGFunds2microcodeView.height);
        }
        
    }
    
    
    
    
}

#pragma mark    ------UI
-(void)creatUI{
    
    //-滚动面版======================================
    if (_mUIScrollView == nil) {
        UIScrollView *mUIScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW , UGScerrnH -IPHONE_SAFEBOTTOMAREA_HEIGHT-44)];
        mUIScrollView.showsHorizontalScrollIndicator = NO;//不显示水平拖地的条
        mUIScrollView.showsVerticalScrollIndicator=YES;//不显示垂直拖动的条
        mUIScrollView.bounces = NO;//到边了就不能再拖地
        //UIScrollView被push之后返回，会发生控件位置偏移，用下面的代码就OK
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        self.edgesForExtendedLayout = UIRectEdgeNone;
         mUIScrollView.backgroundColor = UGRGBColor(239, 239, 244);
    
        [self.view addSubview:mUIScrollView];
        self.mUIScrollView = mUIScrollView;
    }

    
    if (self.tiplabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UGScreenW, 40)];
        label.textAlignment = NSTextAlignmentLeft;
        //        label.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = UGRGBColor(239, 239, 244);
//        label.backgroundColor = [UIColor redColor];
        label.numberOfLines = 0;
        label.text = @"ewerqwerqwerqwerqwer";
        [self.mUIScrollView addSubview:label];
        [label sizeToFit];
        NSLog(@"%@",NSStringFromCGRect(label.frame));
        
        [self.mUIScrollView addSubview:label ];
        self.tiplabel = label;
    }
    if (self.tip2label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, UGScreenW, 40)];
        label.textAlignment = NSTextAlignmentLeft;
        //        label.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        label.font = [UIFont boldSystemFontOfSize:14];
//        label.textColor = [UIColor blackColor];
        label.backgroundColor = UGRGBColor(239, 239, 244);
//        label.backgroundColor = [UIColor yellowColor];

        label.numberOfLines = 0;
        label.text = @"请选择一个任意转入账户";
        [self.mUIScrollView addSubview:label];
        NSLog(@"%@",NSStringFromCGRect(label.frame));
        
        [self.mUIScrollView addSubview:label ];
        self.tip2label = label;
    }
    if (self.tableView == nil) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 500, UGScreenW , 120) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setBackgroundColor:UGRGBColor(239, 239, 244)];
//                [tableView setBackgroundColor:[UIColor greenColor]];

        [tableView registerNib:[UINib nibWithNibName:@"UGDepositDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGDepositDetailsTableViewCell"];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.rowHeight = 44;
//        tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        [self.mUIScrollView addSubview:tableView ];
        tableView.scrollEnabled = NO;

        self.tableView = tableView;
    }
      if (self.uGFundsTransferView == nil) {
          UGFundsTransferView * uGFundsTransferView = [[UGFundsTransferView alloc] initWithFrame:CGRectMake(0, 500, UGScreenW , 395) ];
          [self.mUIScrollView addSubview:uGFundsTransferView ];
          self.uGFundsTransferView = uGFundsTransferView;
      }
    if (self.uGFundsTransfer2View == nil) {
        UGFundsTransfer2View * uGFundsTransfer2View = [[UGFundsTransfer2View alloc] initWithFrame:CGRectMake(0, 500, UGScreenW , 395) ];
        [self.mUIScrollView addSubview:uGFundsTransfer2View ];
        self.uGFundsTransfer2View = uGFundsTransfer2View;
    }
    if (self.uGFunds2microcodeView == nil) {
        UGFunds2microcodeView * uGFunds2microcodeView = [[UGFunds2microcodeView alloc] initWithFrame:CGRectMake(0, 500, UGScreenW , 395) ];
        [self.mUIScrollView addSubview:uGFunds2microcodeView ];
        self.uGFunds2microcodeView = uGFunds2microcodeView;
    }
    if (self.label == nil) {
        self.bg_label = [UIView new];
        [self.mUIScrollView addSubview:self.bg_label];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
        label.textAlignment = NSTextAlignmentLeft;
        //        label.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor redColor];
        label.numberOfLines = 0;
        label.text = @"";
        [self.mUIScrollView addSubview:label];
        [label sizeToFit];
        NSLog(@"%@",NSStringFromCGRect(label.frame));
        
        [self.mUIScrollView addSubview:label ];
        self.label = label;
    }
    if (self.blank_button == nil) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 500, UGScreenW, 44);
        // 按钮的正常状态
        [button setTitle:@"请选择银行" forState:UIControlStateNormal];
        // 设置按钮的背景色
        button.backgroundColor = [UIColor whiteColor];
        
        // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 设置按下状态文字的颜色
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        // 设置按钮的风格颜色,只有titleColor没有设置的时候才有用
        [button setTintColor:[UIColor whiteColor]];
        
        // titleLabel：UILabel控件
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [button addTarget:self action:@selector(showBlackList:) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer *layer= button.layer;
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        [layer setCornerRadius:5];
        //设置边框线的宽
        [layer setBorderWidth:1];
        //设置边框线的颜色
        [layer setBorderColor:UGRGBColor(231, 231, 231).CGColor];
        
        
        [self.mUIScrollView addSubview:button ];
        self.blank_button = button;
        [self.blank_button setHidden:YES];
    }
    
    if (self.submit_button == nil) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 500, UGScreenW, 44);
        // 按钮的正常状态
        [button setTitle:@"提交" forState:UIControlStateNormal];
        // 设置按钮的背景色
        button.backgroundColor = UGRGBColor(76, 149, 236.0);
        
        // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 设置按下状态文字的颜色
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        // 设置按钮的风格颜色,只有titleColor没有设置的时候才有用
        [button setTintColor:[UIColor whiteColor]];
        
        // titleLabel：UILabel控件
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [button addTarget:self action:@selector(submit_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer *layer= button.layer;
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        [layer setCornerRadius:5];
        //设置边框线的宽
        [layer setBorderWidth:1];
        //设置边框线的颜色
        [layer setBorderColor:UGRGBColor(231, 231, 231).CGColor];
        
        
        [self.mUIScrollView addSubview:button ];
        self.submit_button = button;
       
        
    }
    
    //=================================================
    _mUIScrollView.contentSize = CGSizeMake(UGScreenW, 1400);
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
    
    cell.nameStr = [NSString stringWithFormat:@"银行名称：%@",channelModel.payeeName];
    
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
    }
    

}

#pragma mark - 其他方法

-(void)showBlackList:(UIButton *)sender{
    
    UGFundsBankView *notiveView = [[UGFundsBankView alloc] initWithFrame:CGRectMake(20, 120, UGScreenW - 40, UGScerrnH - 260)];
    notiveView.dataArray = self->_blankDataArray ;
    notiveView.nameStr = @"请选择银行";
    
    WeakSelf;
    notiveView.signInHeaderViewnBlock =  ^(id model) {
        
        weakSelf.selectBank = (UGrechargeBankModel *)model;
        [weakSelf.blank_button setTitle:weakSelf.selectBank.name forState:UIControlStateNormal];
    };
    
    if (![CMCommon arryIsNull:self->_blankDataArray ]) {
        [notiveView show];
    }
}

-(void)submit_buttonClicked:(UIButton *)sender{
    
   
    
    [self rechargeTransfer];
    
    //token money payId
}


//线下支付
- (void)rechargeTransfer{
    
    NSString *amount = [self.uGFundsTransfer2View.myTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"amount = %@",amount);
    NSString *remark = [self.uGFundsTransfer2View.my2TextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"remark = %@",remark);
    NSString *payer = [self.uGFundsTransfer2View.my3TextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"amount":amount,
                             @"channel":_selectChannelModel.pid,
                             @"payee":_selectChannelModel.account,
                             @"payer":payer,
                             @"remark":remark,
                             @"depositTime":locationString
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork rechargeTransferWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
                [SVProgressHUD showSuccessWithStatus:model.msg];

        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

@end