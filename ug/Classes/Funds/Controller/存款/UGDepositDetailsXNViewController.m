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

@interface UGDepositDetailsXNViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *mUIScrollView;
@property (nonatomic, strong) UGchannelModel *selectChannelModel ;  //选中的数据
@property (nonatomic, strong) NSIndexPath *lastPath;                //选中的表索引
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <UGchannelModel *> *tableDataArray;

//===================================================================
@property (weak, nonatomic) IBOutlet UITextView *inputTV;           //备注


@property (nonatomic, strong) UIButton *submit_button;              //提交按钮
@end

@implementation UGDepositDetailsXNViewController
@synthesize  lastPath,item;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableDataArray = [NSMutableArray new];
    
    if (self.item) {
        _tableDataArray = [[NSMutableArray alloc] initWithArray: item.channel2];
    }
    
    [self.view setBackgroundColor:Skin1.textColor4];
    
    if (self.item) {
        _selectChannelModel = [_tableDataArray objectAtIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        lastPath = indexPath;

        NSMutableAttributedString *mas = [[NSAttributedString alloc] initWithData:[self.item.name dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil].mutableCopy;
        self.title = mas.string;
        [self setUIData:_selectChannelModel];
    }
    
    [self.tableView reloadData];
}

//设置数据
//accoun==：充值地址
//qrcode== ：二维码图片
//domain== ：币种
//payeeName ==：列表cell显示
//Address ==:链名称
//fixedAmount==：按钮数
//prompt ==：按钮下提示
- (void)setUIData:(UGchannelModel *)channelModel{
    FastSubViewCode(self.view);
    subLabel(@"币种内容Label").text = channelModel.domain;
    subLabel(@"二微码Label").text = channelModel.account;
    [subImageView(@"二微码ImageV") sd_setImageWithURL:[NSURL URLWithString:channelModel.qrcode] placeholderImage:[UIImage imageNamed:@"bg_microcode"]];
    
    
    
    
    
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





@end
