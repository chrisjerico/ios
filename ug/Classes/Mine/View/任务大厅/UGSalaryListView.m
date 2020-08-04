//
//  UGSalaryListView.m
//  UGBWApp
//
//  Created by ug on 2020/4/11.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGSalaryListView.h"

#import "UGPromotion4rowTableViewCell.h"

@interface UGSalaryListView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *title1Label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation UGSalaryListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGSalaryListView" owner:self options:0].firstObject;
        self.frame = frame;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        [self.tableView registerNib:[UINib nibWithNibName:@"UGPromotion4rowTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGPromotion4rowTableViewCell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.layer.cornerRadius = 8;
        
        self.closeButton.layer.cornerRadius = 5;
         self.closeButton.layer.masksToBounds = YES;
        self.layer.masksToBounds = YES;

        

        if (Skin1.isBlack) {
            [self setBackgroundColor: Skin1.bgColor];
        } else {
            [self setBackgroundColor:[UIColor whiteColor]];
        }

    }
    return self;
    
}


//获取俸禄列表数据
- (void)getMissionBonusList {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork getMissionBonusListUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            NSLog(@"model.data = %@",model.data);
            weakSelf.dataArray = model.data;
            NSLog(@"dataArray = %@",self.dataArray);

        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

- (IBAction)close:(id)sender {
    [self hiddenSelf];
}

- (void)setDataArray:(NSArray<UGSignInHistoryModel *> *)dataArray {

    _dataArray = dataArray;
    if (![CMCommon arryIsNull:_dataArray]) {
         [self.tableView reloadData];
    }
   
    
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPromotion4rowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGPromotion4rowTableViewCell" forIndexPath:indexPath];
   UGSignInHistoryModel *model = (UGSignInHistoryModel *)self.dataArray[indexPath.row];


    cell.firstLabel.text = model.levelName;
    cell.secondLabel.text = model.weekBons;
    cell.thirdLabel.text = model.MonthBons;
    [cell.lineView setHidden:NO];
    [cell.fouthButton setHidden:NO];
    [cell.fourthLabel setHidden:YES];
    cell.promotion4rowButtonBlock = ^{
        if (model.bonsId) {
           NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                                    @"bonsId":model.bonsId,
                                    };
           
           [SVProgressHUD showWithStatus:nil];
               WeakSelf;
           [CMNetwork taskSendMissionBonusWithParams:params completion:^(CMResult<id> *model, NSError *err) {
               [CMResult processWithResult:model success:^{
                     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                         [SVProgressHUD showSuccessWithStatus:model.msg];
                           NSLog(@"model.data = %@",model.data);
                         [weakSelf close:nil];
                    });
                 
                   
               } failure:^(id msg) {
                   
                   [SVProgressHUD showErrorWithStatus:msg];
                    [weakSelf close:nil];
                  
               }];
           }];
        }
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UGPromotion4rowTableViewCell *headerView = (UGPromotion4rowTableViewCell*)[[NSBundle mainBundle] loadNibNamed:@"UGPromotion4rowTableViewCell" owner:self options:0].firstObject;

    headerView.firstLabel.text = @"等级";
    headerView.secondLabel.text = @"周俸禄";
    headerView.thirdLabel.text = @"月俸禄";
    headerView.fourthLabel.text = @"领取";
   [headerView.lineView setHidden:NO];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView=(UITableViewHeaderFooterView *)view;
    [headerView.backgroundView setBackgroundColor:[UIColor whiteColor]];
}

- (void)show {
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    

    
    [maskView addSubview:view];
    [window addSubview:maskView];
    
}

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
    
}

@end

