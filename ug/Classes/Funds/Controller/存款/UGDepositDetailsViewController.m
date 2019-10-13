//
//  UGDepositDetailsViewController.m
//  ug
//
//  Created by ug on 2019/9/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGDepositDetailsViewController.h"
#import "UGDepositDetailsCollectionViewCell.h"
#import "UGdepositModel.h"
#import "YLEdgeLabel.h"
#import "UGDepositDetailsTableViewCell.h"
#import "UGFundsBankView.h"
#import "SLWebViewController.h"
#import "TGWebViewController.h"
#import "BAWebViewController.h"

@interface UGDepositDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *mUIScrollView;

@property (nonatomic, strong) UGchannelModel *selectChannelModel ;
@property(nonatomic,strong)NSIndexPath *lastPath;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataArray;

@property (nonatomic, strong)UIView *bg_label;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UILabel *tiplabel;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong) UICollectionView *collectionView ;
@property (nonatomic, strong) NSArray *channelDataArray;
@property (nonatomic, strong) NSMutableArray *amountDataArray;

@property (nonatomic, strong)UIButton *blank_button;
@property (nonatomic, strong) NSMutableArray<UGrechargeBankModel> *blankDataArray;
@property (nonatomic, strong)UGrechargeBankModel *selectBank;

@property (nonatomic, strong)UIButton *submit_button;
@property (nonatomic, strong)UIView *submit_View;
@end

@implementation UGDepositDetailsViewController
@synthesize  lastPath;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _amountDataArray = [NSMutableArray new];
    _channelDataArray = [NSArray new];
    _tableDataArray = [NSMutableArray new];
    _blankDataArray = [NSMutableArray<UGrechargeBankModel> new];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    if (self.item) {
        _channelDataArray = _item.channel;
        _tableDataArray =[[NSMutableArray alloc] initWithArray:_channelDataArray];
        
    }
    
    [self creatUI];

    if (self.item) {
        _selectChannelModel = [_tableDataArray objectAtIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        lastPath = indexPath;
        
        self.title = _item.name;
        [self setUIData:_selectChannelModel];
    }

    [self.tableView reloadData];
    
}
#pragma mark -UIData
- (void)setUIData:(UGchannelModel *)channelModel{

        //==============================================================

    self->_blankDataArray = nil;
    NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
    [waitQueue addOperationWithBlock:^{
        UGparaModel *bankModel= channelModel.para;
        
        
        self->_blankDataArray = bankModel.bankList ;//显示银行数据
        
       
        if ([CMCommon stringIsNull:bankModel.fixedAmount]) {
            
            self.amountDataArray = [[NSMutableArray alloc] initWithArray:self->_item.quickAmount];
        }
        else{
            
            NSArray  *array = [bankModel.fixedAmount componentsSeparatedByString:@" "];
            
            for (int i = 0; i<array.count; i++) {
                if (![CMCommon stringIsNull:[array objectAtIndex:i]]) {
                    [self.amountDataArray addObject:[array objectAtIndex:i]];
                }
            }
        
        }
        
        
        float height ;
        
        if ([CMCommon judgeStr:(int)self.amountDataArray.count with:3]) {
            //能整除   高度
            int verticalCount = (int)self.amountDataArray.count/3;
            height = 5*2+verticalCount*40.0 + (verticalCount -1)*10;
        } else {
            int verticalCount = (int)self.amountDataArray.count/3  +1;
            height = 5*2+verticalCount*40.0 + (verticalCount -1)*10;
        }
        
        NSLog(@"height = %f",height);

        // 同步到主线程
         dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([CMCommon arryIsNull:self->_blankDataArray]) {
                [self->_blank_button setHidden:YES];
            } else {
                [self->_blank_button setHidden:NO];
            }
            
            [self.collectionView reloadData];
            
            [self.collectionView  mas_remakeConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(self.view.mas_left).with.offset(0);
                 make.right.equalTo(self.view.mas_right).with.offset(0);
                 make.width.equalTo(self.view.mas_width);
                 make.height.mas_equalTo(height);
                 make.top.equalTo(self.mUIScrollView.mas_bottom).offset(0);
                 
             }];
            self.collectionView.height = height;
            
            //==============================================================
            [self.label  mas_remakeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.equalTo(self.view.mas_left).with.offset(30);
                 make.right.equalTo(self.view.mas_right).with.offset(-30);
                 make.top.mas_equalTo(self.collectionView.mas_bottom).offset(10);
                 make.width.mas_equalTo(UGScreenW-40);
                 
                 
             }];
            [self.label setText:self.item.prompt];
            [self.label sizeToFit];
            NSLog(@"%@",NSStringFromCGRect(self.label.frame));
            
            
            [self.bg_label  mas_remakeConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(self.view.mas_left).with.offset(0);
                 make.right.equalTo(self.view.mas_right).with.offset(0);
                 make.top.equalTo(self.collectionView.mas_bottom).offset(0);
                 make.width.mas_equalTo(UGScreenW-20);
                 make.height.equalTo(self.label.mas_height).offset(20);
                 
             }];
            
//            // Initialization code
//            CALayer *layer= self.bg_label.layer;
//            //是否设置边框以及是否可见
//            [layer setMasksToBounds:YES];
//            //设置边框圆角的弧度
//            [layer setCornerRadius:5];
//            //设置边框线的宽
//            [layer setBorderWidth:1];
//            //设置边框线的颜色
//            [layer setBorderColor:UGRGBColor(231, 231, 231).CGColor];
            //==============================================================
            [self.tiplabel  mas_remakeConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(self.view.mas_left).with.offset(30);
                 make.right.equalTo(self.view.mas_right).with.offset(-30);
                 make.top.equalTo(self.bg_label.mas_bottom).offset(0);
                 make.width.mas_equalTo(UGScreenW-40);
             }];
            [self.tiplabel setText:self.item.transferPrompt];
            [self.tiplabel sizeToFit];
            NSLog(@"%@",NSStringFromCGRect(self.tiplabel.frame));
            //==============================================================
            float tableViewHeight = self->_tableDataArray.count *44.0;
            [self.tableView  mas_remakeConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(self.view.mas_left).with.offset(0);
                 make.right.equalTo(self.view.mas_right).with.offset(0);
                 make.top.equalTo(self.tiplabel.mas_bottom).offset(10);
                 make.height.mas_equalTo(tableViewHeight);
                 
             }];
            //==================================================================
            [self.blank_button  mas_remakeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.equalTo(self.view.mas_left).with.offset(0);
                 make.right.equalTo(self.view.mas_right).with.offset(0);
                 make.top.equalTo(self.tableView.mas_bottom).offset(10);
                 make.height.mas_equalTo(44);
                 
             }];
             
            //==================================================================
//             [self.submit_button  mas_makeConstraints:^(MASConstraintMaker *make)
//              {
//                  make.left.equalTo(self.view.mas_left).with.offset(0);
//                  make.right.equalTo(self.view.mas_right).with.offset(0);
//                  make.top.equalTo(self.blank_button.mas_bottom).offset(20);
//                  make.height.mas_equalTo(44);
//
//              }];
             
             
              self.mUIScrollView.contentSize = CGSizeMake(UGScreenW, 50.0+height+self.bg_label.height+self.tiplabel.height+tableViewHeight+self.blank_button .height+20);
        });
    }];
}


#pragma mark: - 判断是否能够被整除

-(BOOL)judgeStr:(int )number1 with:(int )number2
{
    
    
    if (fmod(number1, number2)== 0) {
        
        return YES;
    }
    else{
         return NO;
    }
   
}


#pragma mark - UI

-(void)creatUI{
    
    if (self.textField==nil) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, UGScreenW-40, 40)];
        textField.placeholder = @"请输入存款金额";
        textField.textColor = [UIColor blackColor];
        textField.font = [UIFont systemFontOfSize:14];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField = textField;
        [self.view addSubview:textField];
    }
    
    //-滚动面版======================================
    if (_mUIScrollView == nil) {
        UIScrollView *mUIScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, UGScreenW , UGScerrnH -IPHONE_SAFEBOTTOMAREA_HEIGHT-44-60-64)];
        mUIScrollView.showsHorizontalScrollIndicator = NO;//不显示水平拖地的条
        mUIScrollView.showsVerticalScrollIndicator=YES;//不显示垂直拖动的条
        mUIScrollView.bounces = NO;//到边了就不能再拖地
        //UIScrollView被push之后返回，会发生控件位置偏移，用下面的代码就OK
        //        self.automaticallyAdjustsScrollViewInsets = NO;
        //        self.edgesForExtendedLayout = UIRectEdgeNone;
        mUIScrollView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:mUIScrollView];
        self.mUIScrollView = mUIScrollView;
    }
    
    if (self.collectionView==nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((self.view.frame.size.width-60 ) / 3, 40);
        layout.minimumLineSpacing = 10.0; // 竖
        layout.minimumInteritemSpacing = 10.0; // 横
        layout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20);
        
        UICollectionView *collectionView = ({
            
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , 50, UGScreenW  , 500) collectionViewLayout:layout];
            collectionView.backgroundColor = [UIColor whiteColor];
//            collectionView.backgroundColor = [UIColor redColor];

            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerNib:[UINib nibWithNibName:@"UGDepositDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGDepositDetailsCollectionViewCell"];
            
            collectionView;
            
        });
        [self.mUIScrollView addSubview:collectionView ];
        self.collectionView = collectionView;
    }
    
    
    if (self.label == nil) {
        self.bg_label = [UIView new];
        [self.view addSubview:self.bg_label];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
        label.textAlignment = NSTextAlignmentLeft;
//        label.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [[UGSkinManagers shareInstance] setNavbgColor];
        label.backgroundColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.text = @"";
        [self.view addSubview:label];
        [label sizeToFit];
        NSLog(@"%@",NSStringFromCGRect(label.frame));
        
        [self.mUIScrollView addSubview:label ];
        self.label = label;
    }
    
    if (self.tiplabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
        label.textAlignment = NSTextAlignmentLeft;
//        label.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        label.font = [UIFont systemFontOfSize:14];
        label.textColor =  [[UGSkinManagers shareInstance] setNavbgColor];
        label.backgroundColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.text = @"";
        [self.view addSubview:label];
        [label sizeToFit];
        NSLog(@"%@",NSStringFromCGRect(label.frame));
        
        [self.mUIScrollView addSubview:label ];
        self.tiplabel = label;
    }
    
    if (self.tableView == nil) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 500, UGScreenW , 120) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setBackgroundColor:[UIColor whiteColor]];
        [tableView registerNib:[UINib nibWithNibName:@"UGDepositDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGDepositDetailsTableViewCell"];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.rowHeight = 44;
//        tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        tableView.scrollEnabled = NO;

        [self.mUIScrollView addSubview:tableView ];
        self.tableView = tableView;
    }
    
    if (self.blank_button == nil) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 500, UGScreenW, 44);
        // 按钮的正常状态
        [button setTitle:@"请选择银行" forState:UIControlStateNormal];
        // 设置按钮的背景色
        button.backgroundColor = [[UGSkinManagers shareInstance] setNavbgColor];
        
        // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // 设置按下状态文字的颜色
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
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
        [layer setBorderColor:[[UGSkinManagers shareInstance] setNavbgColor].CGColor];
        
        [self.mUIScrollView addSubview:button ];
        self.blank_button = button;
        [self.blank_button setHidden:YES];
    }
    
    if (self.submit_View == nil) {
        UIView* bg = [[UIView alloc] init];
        bg.frame = CGRectMake(0, 500, UGScreenW, 64);
        bg.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bg ];
        self.submit_View = bg;
        
        [self.submit_View  mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.view.mas_left).with.offset(0);
             make.right.equalTo(self.view.mas_right).with.offset(0);
             make.bottom.equalTo(self.view.mas_bottom).offset(-IPHONE_SAFEBOTTOMAREA_HEIGHT);
             make.height.mas_equalTo(64);
        }];
    }
    
    if (self.submit_button == nil) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 500, UGScreenW, 44);
        // 按钮的正常状态
        [button setTitle:@"开始充值" forState:UIControlStateNormal];
        // 设置按钮的背景色
        button.backgroundColor = [[UGSkinManagers shareInstance] setNavbgColor];
        
        // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // 设置按下状态文字的颜色
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        
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
        [layer setBorderColor:[[UGSkinManagers shareInstance] setNavbgColor].CGColor];
        
        
        [self.submit_View addSubview:button ];
        self.submit_button = button;
        [self.submit_button  mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.view.mas_left).with.offset(20);
             make.right.equalTo(self.view.mas_right).with.offset(-20);
             make.bottom.equalTo(self.view.mas_bottom).offset(-IPHONE_SAFEBOTTOMAREA_HEIGHT);
             make.height.mas_equalTo(40);
        }];
        
        //=================================================
        _mUIScrollView.contentSize = CGSizeMake(UGScreenW, 1400);
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
    
   
    
    cell.nameStr = channelModel.payeeName;
    
    
    
    NSInteger row = [indexPath row];
    
    NSInteger oldRow = [lastPath row];
    
    if (row == oldRow && self.lastPath!=nil) {
        cell.headerImageStr = @"RadioButton-Selected";
    } else {
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
    [self rechargeOnlinePay];

    //token money payId
}

//在线支付
- (void)rechargeOnlinePay {
    
    NSString *moneyStr = [self.textField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
    
    NSString *payId =_selectChannelModel.pid;
    
    if ([CMCommon stringIsNull:moneyStr]) {
       [self.view makeToast:@"请输入金额"];
        return;
    }
    if ([CMCommon stringIsNull:payId]) {
        return;
    }
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"payId":payId,
                             @"money":moneyStr
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork rechargeOnlinePayWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            if ([CMCommon stringIsNull:model.data]) {
                 [SVProgressHUD showSuccessWithStatus:model.msg];
            } else {
                [SVProgressHUD dismiss];
                //通知==》存款记录刷新
                SANotificationEventPost(UGNotificationWithRecordOfDeposit, nil);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.data]];
   
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

@end
