//
//  UGPromotionTableController.m
//  ug
//
//  Created by ug on 2019/5/9.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotionTableController.h"
#import "YBPopupMenu.h"
#import "UGPromotion4rowTableViewCell.h"
#import "UGPromotion5rowButtonTableViewCell.h"
#import "UGPromotion2rowTableViewCell.h"
#import "UGinviteLisModel.h"
#import "UGbetStatModel.h"
#import "UGBetListModel.h"
#import "UGPormotionUserInfoView.h"
#import "UGinviteDomainModel.h"
#import "UGdepositStatModel.h"
#import "UGdepositListModel.h"
#import "UGwithdrawStatModel.h"
#import "UGwithdrawListModel.h"
#import "UGrealBetStatModel.h"
#import "UGrealBetListModel.h"
#import "UGPromotion6rowButtonTableViewCell.h"


@interface UGPromotionTableController ()<YBPopupMenuDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int pageNumber;
@property(nonatomic, assign) NSInteger levelindex;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *levelArray;
@property (nonatomic, strong) UIButton *levelButton;
@property (nonatomic, assign) PromotionTableType tableType;
@property (nonatomic, strong) UIImageView *arrowImageView;

#pragma mark - 表格
@property (nonatomic,strong)UITableView *tableView;
#pragma mark - 数据 （NSMutableArray 可变数组;NSArray 数组）
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation UGPromotionTableController

- (instancetype)initWithTableType:(PromotionTableType )tableType {
    self = [super init];
    if (self) {
        self.tableType = tableType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = [UIColor redColor];
    switch (self.tableType) {
        case PromotionTableTypeMember://会员管理
            self.titleArray = @[@"分级",@"用户名",@"在线状态",@"注册时间",@"操作/状态"];//5 == 按钮
            break;
        case PromotionTableTypeBettingReport://投注报表
            self.titleArray = @[@"分级",@"日期",@"投注金额",@"佣金"];//4
            break;
        case PromotionTableTypeBettingRecord://投注记录
            self.titleArray = @[@"分级",@"用户",@"日期",@"金额"];//4
            break;
        case PromotionTableTypeDomainBinding://域名绑定
            self.titleArray = @[@"首页推荐链接",@"注册推荐链接"];//2
            break;
        case PromotionTableTypeDepositStatement://存款报表
            self.titleArray = @[@"分级",@"日期",@"存款金额",@"存款人数"];//4
            break;
        case PromotionTableTypeDepositRecord://存款记录
            self.titleArray = @[@"分级",@"用户",@"日期",@"存款金额"];//4
            break;
        case PromotionTableTypeWithdrawalReport://提款报表
            self.titleArray = @[@"分级",@"日期",@"提款金额",@"提款人数"];//4
            break;
        case PromotionTableTypeWithdrawalRcord://提款记录
            self.titleArray = @[@"分级",@"用户名",@"日期",@"提款金额"];//4
            break;
        case PromotionTableTypeRealityReport://真人报表
            self.titleArray = @[@"分级",@"日期",@"投注金额",@"会员输赢"];//4
            break;
        case PromotionTableTypeRealityRcord://真人记录
            self.titleArray = @[@"分级",@"用户",@"游戏",@"日期",@"投注金额",@"会员输赢"];//5
            break;
        default:
            break;
    }
    
    self.levelArray = @[@"全部下线",@"1级下线",@"2级下线",@"3级下线",@"4级下线",@"5级下线",@"6级下线",@"7级下线",@"8级下线",@"9级下线",@"10级下线"];
    [self.view addSubview:self.titleView];
    
    if(_tableView == nil){
        //bounds 和 frame 区别:bounds,指的是空间本身大小，x=0，y=0；frame，x指的是在父控件的位置和大小
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,45, UGScreenW , UGScerrnH- 45-45-k_Height_NavBar) style:UITableViewStylePlain];
        //        [UIScreen mainScreen].bounds;指的是屏幕大小
        _tableView.dataSource = self;//遵循数据源
        _tableView.delegate = self;//遵循协议
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        [self.tableView registerNib:[UINib nibWithNibName:@"UGPromotion4rowTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGPromotion4rowTableViewCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"UGPromotion5rowButtonTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGPromotion5rowButtonTableViewCell"];
         [self.tableView registerNib:[UINib nibWithNibName:@"UGPromotion2rowTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGPromotion2rowTableViewCell"];
            [self.tableView registerNib:[UINib nibWithNibName:@"UGPromotion6rowButtonTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGPromotion6rowButtonTableViewCell"];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
        self.tableView.rowHeight = 44;
    }
    [self.view addSubview:_tableView];
    

    _dataArray = [NSMutableArray array];//初始化数据
    
    _pageSize = 20;
    _pageNumber = 1;
    _levelindex = 1;
    
     WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNumber = 1;
        [weakSelf swithAction];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNumber =weakSelf.pageNumber+1;
        [weakSelf swithAction];
    }];
    
    [self swithAction];
    
}

-(void)swithAction{
    switch (self.tableType) {
        case PromotionTableTypeMember://会员管理
            //5 == 按钮
        {
            [self teamInviteListData];
        }
            break;
        case PromotionTableTypeBettingReport://投注报表
            //4
        {
            [self teamBetStatData];
        }
            break;
        case PromotionTableTypeBettingRecord://投注记录
            //4
        {
            [self teamBetListData];
        }
            break;
        case PromotionTableTypeDomainBinding://域名绑定
            //2
        {
            [self teamInviteDomainData];
        }
            break;
        case PromotionTableTypeDepositStatement://存款报表
            //4
        {
            [self teamDepositStatData];
        }
            break;
        case PromotionTableTypeDepositRecord://存款记录
            //4
        {
            [self  teamDepositListData];
        }
            break;
        case PromotionTableTypeWithdrawalReport://提款报表
            //4
        {
            [self teamWithdrawStatData];
        }
            break;
        case PromotionTableTypeWithdrawalRcord://提款记录
            //4
        {
            [self teamWithdrawListData];
        }
            break;
        case PromotionTableTypeRealityReport://真人报表
            //4
        {
            [self teamRealBetStatData];
        }
            break;
        case PromotionTableTypeRealityRcord://真人记录
            //5
        {
            [self teamRealBetListData];
        }
            break;
            
    }
}

- (void)levelClick {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.arrowImageView.transform = transform;
    
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.levelArray icons:nil menuWidth:CGSizeMake(UGScreenW / self.titleArray.count + 70, 180) delegate:self];
    popView.type = YBPopupMenuTypeDefault;
    popView.fontSize = 15;
    [popView showRelyOnView:self.levelButton];

}

#pragma mark YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0) {
        _levelindex = index;
       [self swithAction];
        
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
    self.arrowImageView.transform = transform;
    
}

- (UIView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW, 44)];
        _titleView.backgroundColor = [UIColor clearColor];
        for (int i = 0; i < self.titleArray.count; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(UGScreenW / self.titleArray.count * i, 0, UGScreenW / self.titleArray.count, 44)];
            
            if (self.tableType != PromotionTableTypeDomainBinding) {
                if (i == 0) {
                    UIButton *button = [[UIButton alloc] initWithFrame:view.bounds];
                    button.backgroundColor = [UIColor clearColor];
                    [button addTarget:self action:@selector(levelClick)];
                    self.levelButton = button;
                    [view addSubview:button];
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(view.width - 18, (view.height - 18) / 2, 18, 18)];
                    imgView.image = [UIImage imageNamed:@"jiantou"];
                    [view addSubview:imgView];
                    self.arrowImageView = imgView;
                }
            }
            
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:view.bounds];
            titleLabel.text = self.titleArray[i];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
            [view addSubview:titleLabel];
            
            [_titleView addSubview:view];
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,_titleView.height - 0.6, _titleView.width, 0.6)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_titleView addSubview:line];
        
    }
    return _titleView;
}

//UI +tableView
#pragma mark - UITableViewDelegate,UITableViewDataSource
//表格组数 Sections 组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//每组返回行数 Rows 行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
//每个单元格的e内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.tableType) {
        case PromotionTableTypeMember://会员管理
           //5 == 按钮
        {
            UGPromotion5rowButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGPromotion5rowButtonTableViewCell" forIndexPath:indexPath];
            UGinviteLisModel *model = (UGinviteLisModel *)self.dataArray[indexPath.row];
            cell.firstLabel.text = [NSString stringWithFormat:@"%@级下线",model.level];
            cell.secondLabel.text = model.username;
            if ([CMCommon stringIsNull:model.enable]) {
                cell.thirdLabel.text = @"--";
            } else {
               cell.thirdLabel.text = model.enable;
            }
            if ([CMCommon stringIsNull:model.regtime]) {
                cell.fourthLabel.text = @"--";
            } else {
                cell.fourthLabel.text = model.regtime;
            }
        
            [cell.fifthButton setHidden:NO];
            [cell.fifthLabel setHidden:YES];
            
            if ([model.is_setting isEqualToString:@"1"]) {
                //去充值
//                [cell.fifthButton setHidden:NO];
                 [cell.fifthButton setHidden:NO];
                [cell.pointView setHidden:NO];
            } else {
                [cell.fifthButton setHidden:YES];
                 [cell.pointView setHidden:YES];
            }
            
            
            if ([model.enable isEqualToString:@"正常"]) {
                
                [cell.pointView setBackgroundColor:[UIColor greenColor]];
            } else {
                [cell.pointView setBackgroundColor:[UIColor redColor]];
            }
            
            cell.promotion5rowButtonBlock = ^{
                
               
                if ([model.is_setting isEqualToString:@"1"]) {
                    //去充值
                    [self showUGPormotionUserInfoViewWithModel:model];
                    
                } else {

                }
            };
            return cell;
        }
            break;
        case PromotionTableTypeBettingReport://投注报表
            //4
        {
            UGPromotion4rowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGPromotion4rowTableViewCell" forIndexPath:indexPath];
            UGbetStatModel *model = (UGbetStatModel *)self.dataArray[indexPath.row];
            int intLevel = [model.level intValue];
            
            if (intLevel == 0) {
                 cell.firstLabel.text = @"全部下线";
            }
            else{
                 cell.firstLabel.text = [NSString stringWithFormat:@"%d级下线",intLevel];
            }
           
            if ([CMCommon stringIsNull:model.date]) {
                cell.secondLabel.text = @"--";
            } else {
                cell.secondLabel.text = model.date;
            }
            cell.thirdLabel.text = model.bet_sum;
            cell.fourthLabel.text = model.fandian_sum;
            return cell;
        }
            break;
        case PromotionTableTypeBettingRecord://投注记录
            //4
        {
            UGPromotion4rowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGPromotion4rowTableViewCell" forIndexPath:indexPath];
            UGBetListModel *model = (UGBetListModel *)self.dataArray[indexPath.row];
            int intLevel = [model.level intValue];
            
            cell.firstLabel.text = [NSString stringWithFormat:@"%d级下线",intLevel];
            
            cell.secondLabel.text = model.username;
            
            if ([CMCommon stringIsNull:model.date]) {
                cell.thirdLabel.text = @"--";
            } else {
                cell.thirdLabel.text = model.date;
            }
           
            cell.fourthLabel.text = model.money;
            return cell;
        }
            break;
        case PromotionTableTypeDomainBinding://域名绑定
          //2
        {
            UGPromotion2rowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGPromotion2rowTableViewCell" forIndexPath:indexPath];
            UGinviteDomainModel *model = (UGinviteDomainModel *)self.dataArray[indexPath.row];
            cell.firstLabel.text = [NSString stringWithFormat:@"http://%@",model.domain];
            cell.secondLabel.text = [NSString stringWithFormat:@"http://%@",model.domain];
            return cell;
        }
            break;
        case PromotionTableTypeDepositStatement://存款报表
            //4
        {
            UGPromotion4rowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGPromotion4rowTableViewCell" forIndexPath:indexPath];
            UGdepositStatModel *model = (UGdepositStatModel *)self.dataArray[indexPath.row];
            int intLevel = [model.level intValue];
             if (intLevel == 0) {
                      cell.firstLabel.text = @"全部下线";
             }
             else{
                  cell.firstLabel.text = [NSString stringWithFormat:@"%d级下线",intLevel];
             }
            if ([CMCommon stringIsNull:model.date]) {
                cell.secondLabel.text = @"--";
            } else {
                cell.secondLabel.text = model.date;
            }
            cell.thirdLabel.text = model.amount;
            int intMember = [model.member intValue];
            if (intMember) {
                 cell.fourthLabel.text = [NSString stringWithFormat:@"%d人",intMember];
            } else {
                cell.fourthLabel.text = @"--";
            }
            
            return cell;
        }
            break;
        case PromotionTableTypeDepositRecord://存款记录
            //4
        {
            UGPromotion4rowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGPromotion4rowTableViewCell" forIndexPath:indexPath];
            UGdepositListModel *model = (UGdepositListModel *)self.dataArray[indexPath.row];
            int intLevel = [model.level intValue];
            
            cell.firstLabel.text = [NSString stringWithFormat:@"%d级下线",intLevel];
            cell.secondLabel.text = model.username;
            
            if ([CMCommon stringIsNull:model.date]) {
                cell.thirdLabel.text = @"--";
            } else {
                cell.thirdLabel.text = model.date;
            }
            cell.fourthLabel.text = model.amount;
          
            return cell;
        }
            break;
        case PromotionTableTypeWithdrawalReport://提款报表
            //4
        {
            UGPromotion4rowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGPromotion4rowTableViewCell" forIndexPath:indexPath];
            UGwithdrawStatModel *model = (UGwithdrawStatModel *)self.dataArray[indexPath.row];
             int intLevel = [model.level intValue];
            if (intLevel == 0) {
                     cell.firstLabel.text = @"全部下线";
            }
            else{
                 cell.firstLabel.text = [NSString stringWithFormat:@"%d级下线",intLevel];
            }
        
            if ([CMCommon stringIsNull:model.date]) {
                cell.secondLabel.text = @"--";
            } else {
                cell.secondLabel.text = model.date;
            }
            cell.thirdLabel.text = model.amount;
            int intMember = [model.member intValue];
            if (intMember) {
                cell.fourthLabel.text = [NSString stringWithFormat:@"%d人",intMember];
            } else {
                cell.fourthLabel.text = @"--";
            }
            return cell;
        }
            break;
        case PromotionTableTypeWithdrawalRcord://提款记录
            //4
        {
            UGPromotion4rowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGPromotion4rowTableViewCell" forIndexPath:indexPath];
            UGwithdrawListModel *model = (UGwithdrawListModel *)self.dataArray[indexPath.row];
            int intLevel = [model.level intValue];
            
            cell.firstLabel.text = [NSString stringWithFormat:@"%d级下线",intLevel];
            cell.secondLabel.text = model.username;
            
            if ([CMCommon stringIsNull:model.date]) {
                cell.thirdLabel.text = @"--";
            } else {
                cell.thirdLabel.text = model.date;
            }
            cell.fourthLabel.text = model.amount;
            
            return cell;
        }
            break;
        case PromotionTableTypeRealityReport://真人报表
            //4
        {
            UGPromotion4rowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGPromotion4rowTableViewCell" forIndexPath:indexPath];
            UGrealBetStatModel *model = (UGrealBetStatModel *)self.dataArray[indexPath.row];
             int intLevel = [model.level intValue];
              if (intLevel == 0) {
                       cell.firstLabel.text = @"全部下线";
              }
              else{
                   cell.firstLabel.text = [NSString stringWithFormat:@"%d级下线",intLevel];
              }
            if ([CMCommon stringIsNull:model.date]) {
                cell.secondLabel.text = @"--";
            } else {
                cell.secondLabel.text = model.date;
            }
            cell.thirdLabel.text = model.validBetAmount;
          
            cell.fourthLabel.text =  model.netAmount;
         
            return cell;
        }
            break;
        case PromotionTableTypeRealityRcord://真人记录
            //5
        {
            UGPromotion6rowButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGPromotion6rowButtonTableViewCell" forIndexPath:indexPath];
           
            
            UGrealBetListModel *model = (UGrealBetListModel *)self.dataArray[indexPath.row];
            int intLevel = [model.level intValue];
            
            cell.firstLabel.text = [NSString stringWithFormat:@"%d级下线",intLevel];
           
            
            if ([CMCommon stringIsNull:model.username]) {
                cell.secondLabel.text = @"--";
            } else {
                cell.secondLabel.text = model.username;
            }
            
            if ([CMCommon stringIsNull:model.platform]) {
                cell.thirdLabel.text = @"--";
            } else {
               cell.thirdLabel.text = model.platform;
            }
            if ([CMCommon stringIsNull:model.date]) {
                cell.fourthLabel.text = @"--";
            } else {
                cell.fourthLabel.text = model.date;
            }
            cell.fifthLabel.text = model.validBetAmount;
            
            cell.sixLabel.text =  model.comNetAmount;
            
            return cell;
        }
            break;
 
    }
    
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (self.tableType) {
        case PromotionTableTypeMember://会员管理
            //5 == 按钮
        {
            
        }
            break;
        case PromotionTableTypeBettingReport://投注报表
            //4
        {
            
        }
            break;
        case PromotionTableTypeBettingRecord://投注记录
            //4
        {
            
            
            UGBetListModel *model = (UGBetListModel *)self.dataArray[indexPath.row];
            
    
            
            NSString *str = [NSString stringWithFormat:@"游戏名称：%@ \n投注日期：%@ \n投注期数：%@ \n投注号码：%@ \n玩法：%@ \n开奖号码：%@ \n赔率：%@ \n中奖金额：%@",
             model.lottery_name,
             model.date,
             model.actionNo,
             model.actionData,
             model.Groupname,
             model.lotteryNo,
             model.odds,
             model.bonus];
            
            [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                
                label.text = @"下注记录详情";
            })
            .LeeAddContent(^(UILabel *label) {
                
                label.text = str;
                
                label.textAlignment = NSTextAlignmentLeft;
            })
            .LeeAction(@"取消", nil)
            .LeeAction(@"确定", nil)
            .LeeShow();
        }
            break;
        case PromotionTableTypeDomainBinding://域名绑定
            //2
        {
           
        }
            break;
        case PromotionTableTypeDepositStatement://存款报表
            //4
        {
           
        }
            break;
        case PromotionTableTypeDepositRecord://存款记录
            //4
        {
           
        }
            break;
        case PromotionTableTypeWithdrawalReport://提款报表
            //4
        {
            
        }
            break;
        case PromotionTableTypeWithdrawalRcord://提款记录
            //4
        {
           
        }
            break;
        case PromotionTableTypeRealityReport://真人报表
            //4
        {
            
        }
            break;
        case PromotionTableTypeRealityRcord://真人记录
            //5
        {
           
        }
            break;
            
    }
 
}
//网络请求
#pragma mark -- 网络请求
//得到下线信息列表数据
- (void)teamInviteListData{
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             };
    
    [SVProgressHUD showWithStatus:nil];
//    WeakSelf;
    [CMNetwork teamInviteListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            
            if (self.pageNumber == 1 ) {
                
                [self.dataArray removeAllObjects];
            }
            //数组转模型数组
            NSArray *array =  [UGinviteLisModel arrayOfModelsFromDictionaries:list error:nil];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];

            if (array.count < self.pageSize) {
                        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                        [self.tableView.mj_footer setHidden:YES];
            }else{
               
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                [self.tableView.mj_footer setHidden:NO];
            }
        } failure:^(id msg) {
            
 
            
        }];
        
        if ([self.tableView.mj_header isRefreshing]) {
              [self.tableView.mj_header endRefreshing];
          }
          
          if ([self.tableView.mj_footer isRefreshing]) {
              [self.tableView.mj_footer endRefreshing];
          }
}];
}

//得到投注报表列表数据
- (void)teamBetStatData  {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             };
    
    [SVProgressHUD showWithStatus:nil];
//    WeakSelf;
    [CMNetwork teamBetStatWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            
             if (self.pageNumber == 1 ) {
                          
                  [self.dataArray removeAllObjects];
              }
                      
            //数组转模型数组
            NSArray *array  = [UGbetStatModel arrayOfModelsFromDictionaries:list error:nil];
             [self.dataArray addObjectsFromArray:array];
             [self.tableView reloadData];
            if (array.count < self.pageSize) {
                       [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                       [self.tableView.mj_footer setHidden:YES];
           }else{
              
               [self.tableView.mj_footer setState:MJRefreshStateIdle];
               [self.tableView.mj_footer setHidden:NO];
           }
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

//得到投注记录列表数据
- (void)teamBetListData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
         return;
     }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             };
    
    [SVProgressHUD showWithStatus:nil];
//    WeakSelf;
    [CMNetwork teamBetListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            
             if (self.pageNumber == 1 ) {
                         
                 [self.dataArray removeAllObjects];
             }
                                 
            
            //数组转模型数组
            NSArray *array = [UGBetListModel arrayOfModelsFromDictionaries:list error:nil];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < self.pageSize) {
                        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                        [self.tableView.mj_footer setHidden:YES];
            }else{
               
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                [self.tableView.mj_footer setHidden:NO];
            }
            
        } failure:^(id msg) {
            
     
            
        }];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

//得到代理域名信息列表数据
- (void)teamInviteDomainData{
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             };
    
    [SVProgressHUD showWithStatus:nil];
//    WeakSelf;
    [CMNetwork teamInviteDomainWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            if (self.pageNumber == 1 ) {
                
                [self.dataArray removeAllObjects];
            }
            //数组转模型数组
            NSArray *array =[UGinviteDomainModel arrayOfModelsFromDictionaries:list error:nil];
             [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < self.pageSize) {
                        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                        [self.tableView.mj_footer setHidden:YES];
            }else{
               
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                [self.tableView.mj_footer setHidden:NO];
            }
            
        } failure:^(id msg) {

            
        }];
        if ([self.tableView.mj_header isRefreshing]) {
           [self.tableView.mj_header endRefreshing];
       }
       
       if ([self.tableView.mj_footer isRefreshing]) {
           [self.tableView.mj_footer endRefreshing];
       }
    }];
}

//得到存款报表列表数据
- (void)teamDepositStatData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             };
    
    [SVProgressHUD showWithStatus:nil];
//    WeakSelf;
    [CMNetwork teamDepositStatWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            if (self.pageNumber == 1 ) {
                           
               [self.dataArray removeAllObjects];
           }
            //            //字典转模型
            //            UserMembersShareBean *membersShare = [[UserMembersShareBean alloc]initWithDictionary:dic[kMsg]
            
            //数组转模型数组
            NSArray *array = [UGdepositStatModel arrayOfModelsFromDictionaries:list error:nil];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < self.pageSize) {
                        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                        [self.tableView.mj_footer setHidden:YES];
            }else{
               
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                [self.tableView.mj_footer setHidden:NO];
            }
            
        } failure:^(id msg) {
            
    
            
        }];
        if ([self.tableView.mj_header isRefreshing]) {
           [self.tableView.mj_header endRefreshing];
       }
       
       if ([self.tableView.mj_footer isRefreshing]) {
           [self.tableView.mj_footer endRefreshing];
       }
    }];
}

//得到存款记录列表数据
- (void)teamDepositListData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             };
    
    [SVProgressHUD showWithStatus:nil];
//    WeakSelf;
    [CMNetwork teamDepositListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [SVProgressHUD dismiss];
        [CMResult processWithResult:model success:^{
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            if (self.pageNumber == 1 ) {
                [self.dataArray removeAllObjects];
            }
                             
            //            //字典转模型
            //            UserMembersShareBean *membersShare = [[UserMembersShareBean alloc]initWithDictionary:dic[kMsg]

            //数组转模型数组
            NSArray *array = [UGdepositListModel arrayOfModelsFromDictionaries:list error:nil];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < self.pageSize) {
              [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
              [self.tableView.mj_footer setHidden:YES];
            } else {
              [self.tableView.mj_footer setState:MJRefreshStateIdle];
              [self.tableView.mj_footer setHidden:NO];
            }
                 
        } failure:nil];
        
        if ([self.tableView.mj_header isRefreshing])
            [self.tableView.mj_header endRefreshing];
        if ([self.tableView.mj_footer isRefreshing])
            [self.tableView.mj_footer endRefreshing];
    }];
}

//得到提款报表列表数据
- (void)teamWithdrawStatData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),

                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork teamWithdrawStatWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            if (self.pageNumber == 1 ) {
                           
               [self.dataArray removeAllObjects];
           }
                       
            //            //字典转模型
            //            UserMembersShareBean *membersShare = [[UserMembersShareBean alloc]initWithDictionary:dic[kMsg]
            
            //数组转模型数组
            NSArray *array = [UGwithdrawStatModel arrayOfModelsFromDictionaries:list error:nil];
             [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < self.pageSize) {
                        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                        [self.tableView.mj_footer setHidden:YES];
            }else{
               
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                [self.tableView.mj_footer setHidden:NO];
            }
            
        } failure:^(id msg) {
            
   
            
        }];
        if ([self.tableView.mj_header isRefreshing]) {
           [self.tableView.mj_header endRefreshing];
       }
       
       if ([self.tableView.mj_footer isRefreshing]) {
           [self.tableView.mj_footer endRefreshing];
       }
    }];
}

//得到提款记录列表数据
- (void)teamWithdrawListData  {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork teamWithdrawListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            if (self.pageNumber == 1 ) {
                
                [self.dataArray removeAllObjects];
            }
            //            //字典转模型
            //            UserMembersShareBean *membersShare = [[UserMembersShareBean alloc]initWithDictionary:dic[kMsg]
            
            //数组转模型数组
            NSArray *array =[UGwithdrawListModel arrayOfModelsFromDictionaries:list error:nil];
           [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < self.pageSize) {
                        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                        [self.tableView.mj_footer setHidden:YES];
            }else{
               
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                [self.tableView.mj_footer setHidden:NO];
            }
            
        } failure:^(id msg) {
            
     
            
        }];
        if ([self.tableView.mj_header isRefreshing]) {
           [self.tableView.mj_header endRefreshing];
       }
       
       if ([self.tableView.mj_footer isRefreshing]) {
           [self.tableView.mj_footer endRefreshing];
       }
    }];
}

//得到真人报表列表数据
- (void)teamRealBetStatData {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork teamRealBetStatWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            if (self.pageNumber == 1 ) {
                          
              [self.dataArray removeAllObjects];
          }
                      
            //            //字典转模型
            //            UserMembersShareBean *membersShare = [[UserMembersShareBean alloc]initWithDictionary:dic[kMsg]
            
            //数组转模型数组
            NSArray *array =  [UGrealBetStatModel arrayOfModelsFromDictionaries:list error:nil];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < self.pageSize) {
                        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                        [self.tableView.mj_footer setHidden:YES];
            }else{
               
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                [self.tableView.mj_footer setHidden:NO];
            }
            
        } failure:^(id msg) {
            
       
            
        }];
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

//得到真人记录列表数据
- (void)teamRealBetListData  {
    
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
                             @"page":@(self.pageNumber),
                             @"rows":@(self.pageSize),
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork teamRealBetListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            
            NSDictionary *data =  model.data;
            NSArray *list = [data objectForKey:@"list"];
            if (self.pageNumber == 1 ) {
                         
                 [self.dataArray removeAllObjects];
             }
            //            //字典转模型
            //            UserMembersShareBean *membersShare = [[UserMembersShareBean alloc]initWithDictionary:dic[kMsg]
            
            //数组转模型数组
            NSArray *array = [UGrealBetListModel arrayOfModelsFromDictionaries:list error:nil];
             [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < self.pageSize) {
                        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                        [self.tableView.mj_footer setHidden:YES];
            }else{
               
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                [self.tableView.mj_footer setHidden:NO];
            }
            
        } failure:^(id msg) {
            

            
        }];
        if ([self.tableView.mj_header isRefreshing]) {
              [self.tableView.mj_header endRefreshing];
          }
          
          if ([self.tableView.mj_footer isRefreshing]) {
              [self.tableView.mj_footer endRefreshing];
          }
    }];
}
#pragma mark -- 其他方法
- (void)showUGPormotionUserInfoViewWithModel :(UGinviteLisModel *)model{
    
    UGPormotionUserInfoView *notiveView = [[UGPormotionUserInfoView alloc] initWithFrame:CGRectMake(20, 50, UGScreenW - 40, 430)];
    [notiveView setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    notiveView.item = model;
   
    [notiveView show];
   
}
@end
