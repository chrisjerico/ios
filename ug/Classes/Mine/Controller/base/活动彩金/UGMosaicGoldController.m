//
//  UGMosaicGoldController.m
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMosaicGoldController.h"
#import "UGMosaicGoldModel.h"
#import "UGMosaicGoldTableViewCell.h"
#import "UGMosaicGoldFinishView.h"
#import "UGActivityGoldView.h"


@interface UGMosaicGoldController ()
@property (nonatomic, strong) NSArray <UGMosaicGoldModel *> *dataArray;

@end

@implementation UGMosaicGoldController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weakSelf_(__self);
    self.tableView.backgroundColor = Skin1.is23 ? RGBA(135 , 135 ,135, 1) :Skin1.textColor4;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGMosaicGoldTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGMosaicGoldTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 120, 0);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [__self activityWinApplyList];
    }];
    [self activityWinApplyList];
}

- (void)rootLoadData {
     [self activityWinApplyList];
}

- (void)activityWinApplyList {
    
    
    NSDictionary *params = [NSDictionary new];
       if (![CMCommon stringIsNull:_typeid]) {

           params = @{@"token":[UGUserModel currentUser].sessid,
                      @"category":_typeid
           };
       }
       else{
           params = @{@"token":[UGUserModel currentUser].sessid};
       }
    WeakSelf;
    [CMNetwork activityWinApplyListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [weakSelf.tableView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            NSDictionary *data =  model.data;
            NSArray *list = [data isKindOfClass:[NSDictionary class]] ? [data objectForKey:@"list"] : ([data isKindOfClass:[NSArray class]] ? data : nil);
            
            //            //字典转模型
            //            UserMembersShareBean *membersShare = [[UserMembersShareBean alloc]initWithDictionary:dic[kMsg]
            
            //数组转模型数组
            weakSelf.dataArray = [UGMosaicGoldModel arrayOfModelsFromDictionaries:list error:nil];
            
            NSLog(@"self.dataArray = %@",weakSelf.dataArray);
            [weakSelf.tableView reloadData];
        } failure:^(id msg) {
             [SVProgressHUD showErrorWithStatus:msg];
            
        }];
        
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGMosaicGoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGMosaicGoldTableViewCell" forIndexPath:indexPath];
    
    cell.item = self.dataArray[indexPath.row];
    UGMosaicGoldModel *model = self.dataArray[indexPath.row];
       NSLog(@"model=%@",model);
    WeakSelf
    cell.myBlock = ^{
//        model.param.showWinAmount = YES;
//        model.param.quickAmount1 = @"20";
//        model.param.quickAmount2 = @"200";
//        model.param.quickAmount3 = @"30";
//        model.param.quickAmount4 = @"40";
//        model.param.quickAmount5 = @"50";
//        model.param.quickAmount6 = @"600000";
//        model.param.quickAmount7 = @"50000";
//        model.param.quickAmount8 = @"80";
//        model.param.quickAmount9 = @"90";
//        model.param.quickAmount10 = @"1000";
//        model.param.quickAmount11 = @"11000";
//        model.param.win_apply_content= @"<p><img src=\"https://cdn01.heziweb.net/upload/a002/customise/ueditor/php/upload/20190909/15680447042539.png\" style=\"white-space: normal;\"/></p>";
      
        
        UGActivityGoldView *notiveView = _LoadView_from_nib_(@"UGActivityGoldView");
        notiveView.frame = CGRectMake(20, 120, UGScreenW - 40, UGScerrnH - 260);
         NSLog(@"model=%@",model);
        notiveView.item = ({
            model.param.mid = model.mid;
            model.param;
        });
//        [notiveView show];
        CGPoint showCenter = CGPointMake(APP.Width/2,APP.Height/2);
        [SGBrowserView showMoveView:notiveView moveToCenter:showCenter];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UGMosaicGoldModel *model = self.dataArray[indexPath.row];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:model.param.win_apply_image] placeholderImage:[UIImage imageNamed:@"winapply_default"]];
    
    if (Skin1.isBlack) {
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label) {
            label.text = @"彩金活动";
            label.textColor = [UIColor whiteColor];
        })
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = imgView;
            custom.isAutoWidth = YES;
            //                custom.positionType = LEECustomViewPositionTypeRight;
        })
        .LeeAction(@"确认", nil)
        .LeeCancelAction(@"关闭", nil)
        .LeeHeaderColor(Skin1.bgColor)
        .LeeShow();
    } else {
        [LEEAlert alert].config
        .LeeTitle(@"彩金活动")
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.view = imgView;
            custom.isAutoWidth = YES;
            
            //                custom.positionType = LEECustomViewPositionTypeRight;
        })
        .LeeAction(@"确认", nil)
        .LeeCancelAction(@"关闭", nil)
        .LeeShow();
    }
    

}

@end
