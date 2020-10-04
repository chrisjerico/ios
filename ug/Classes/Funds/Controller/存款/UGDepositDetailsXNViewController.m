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
//===================================================================
@property (weak, nonatomic) IBOutlet UITextView *inputTV;           //备注
@property (weak, nonatomic) IBOutlet UITextField *inputTxf;         //金额输入
@property (strong, nonatomic)  NSString *dayTime;                   //上午/下午
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;            //时间
@property (nonatomic, strong) UIButton *submit_button;              //提交按钮
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
    _tableDataArray = [NSMutableArray new];
    _amountDataArray = [NSMutableArray new];
    if (self.item) {
        _tableDataArray = [[NSMutableArray alloc] initWithArray: item.channel2];
    }
    self.submit_button.layer.cornerRadius = 5;
    self.submit_button.layer.masksToBounds = YES;
    [self.view setBackgroundColor:Skin1.textColor4];
    [self setCollectionViewStyle];
    [self setTableViewStyle];
    if (self.item) {
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
    subLabel(@"币种内容Label").textColor = Skin1.textColor1;
    subLabel(@"二微码Label").textColor = Skin1.textColor1;
    subLabel(@"提示2Label").textColor = Skin1.textColor1;
    subLabel(@"提示1Label").textColor = [UIColor whiteColor];
    subView(@"提示bgView").backgroundColor = RGBA(255, 95, 108, 1);
    //=====================================
    subLabel(@"币种内容Label").text = channelModel.domain;
    subLabel(@"二微码Label").text = channelModel.account;
    [subImageView(@"二微码ImageV") sd_setImageWithURL:[NSURL URLWithString:channelModel.qrcode] placeholderImage:[UIImage imageNamed:@"bg_microcode"]];
    [subLabel(@"提示2Label") setText:self.item.prompt];
    [subLabel(@"提示1Label") setText:item.transferPrompt];
    //=====================================
    
    subView(@"2微码bgView").layer.borderWidth = 1;
    subView(@"2微码bgView").layer.borderColor = [RGBA(223 , 230, 240, 1)CGColor];
    subView(@"金额bgView").layer.borderWidth = 1;
    subView(@"金额bgView").layer.borderColor = [RGBA(223 , 230, 240, 1)CGColor];
    subView(@"时间bgView").layer.borderWidth = 1;
    subView(@"时间bgView").layer.borderColor = [RGBA(223 , 230, 240, 1)CGColor];
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




@end
