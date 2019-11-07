//
//  UGPromotionInfoController.m
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotionInfoController.h"
#import "UGinviteInfoModel.h"
#import "UGSystemConfigModel.h"

@interface UGPromotionInfoController ()
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionIdlabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionUrlLabel;//首页推广地址
@property (weak, nonatomic) IBOutlet UIImageView *promotionQrcodeImageView;//首页推广2微码
@property (weak, nonatomic) IBOutlet UILabel *registerUrlLabel;//注册推广地址
@property (weak, nonatomic) IBOutlet UIImageView *registerQrcodeImageView;////注册推广地址2微码
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;//本月推荐收益
@property (weak, nonatomic) IBOutlet UILabel *monthMembers;//本月推荐会员
@property (weak, nonatomic) IBOutlet UILabel *totalMembers;//本月推荐总数

@property (weak, nonatomic) IBOutlet UISwitch *qrcodeSwitch1;

@property (weak, nonatomic) IBOutlet UISwitch *qrcodeSwitch2;

@property (weak, nonatomic) IBOutlet UILabel *sectionLabel1;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel2;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel3;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel4;

@property (weak, nonatomic) IBOutlet UIButton *urlCopy1Button;
@property (weak, nonatomic) IBOutlet UIButton *urlCopy2Button;


@property (nonatomic, assign) BOOL showHomeUrl;
@property (nonatomic, assign) BOOL showRegisterUrl;

@property (strong, nonatomic)  UGinviteInfoModel *mUGinviteInfoModel;

@property (weak, nonatomic) IBOutlet UIImageView *myQrcode1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myQrcode2ImageView;

@property (weak, nonatomic) IBOutlet UIView *cellBgView;         /**<   我的cellbg*/
@property (weak, nonatomic) IBOutlet UILabel *myLabel;          /**<   我的 */
@property (weak, nonatomic) IBOutlet UIView *cell2BgView;         /**<   我的推荐cellbg*/
@property (weak, nonatomic) IBOutlet UILabel *myIDLabel;          /**<   我的推荐 */
@property (weak, nonatomic) IBOutlet UIView *cell3BgView;         /**<   首页推荐cellbg*/
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;          /**<   首页推荐 */
@property (weak, nonatomic) IBOutlet UILabel *twowmLabel;          /**<   2微码 */
@property (weak, nonatomic) IBOutlet UIView *cell4BgView;         /**<   注册推荐cellbg*/
@property (weak, nonatomic) IBOutlet UILabel *registeredLabel;          /**<   注册推荐 */
@property (weak, nonatomic) IBOutlet UILabel *two2wmLabel;          /**<   2微码2 */
@property (weak, nonatomic) IBOutlet UIView *cell5BgView;         /**<   佣金cellbg*/
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;          /**<   佣金 */
@property (weak, nonatomic) IBOutlet UIView *cell6BgView;         /**<   本月推荐cellbg*/
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;          /**<   本月 */
@property (weak, nonatomic) IBOutlet UIView *cell7BgView;         /**<   本月推荐会员cellbg*/
@property (weak, nonatomic) IBOutlet UILabel *monthUserLabel;          /**<   本月推荐会员 */
@property (weak, nonatomic) IBOutlet UIView *cell8BgView;         /**<   推荐会员总计cellbg*/
@property (weak, nonatomic) IBOutlet UILabel *countLabel;          /**<  推荐会员总计 */
@property (weak, nonatomic) IBOutlet UIView *cell9BgView;         /**<  最下面cellbg*/
@end

@implementation UGPromotionInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Skin1.textColor4;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 90, 0);
    self.urlCopy1Button.layer.cornerRadius = 3;
    self.urlCopy1Button.layer.masksToBounds = YES;
    [self.urlCopy1Button setBackgroundColor:Skin1.navBarBgColor];
    
    self.urlCopy2Button.layer.cornerRadius = 3;
    self.urlCopy2Button.layer.masksToBounds = YES;
     [self.urlCopy2Button setBackgroundColor:Skin1.navBarBgColor];
    
    [self.cellBgView setBackgroundColor:Skin1.textColor4];
    [self.myLabel setTextColor:Skin1.textColor1];
    [self.userNameLabel setTextColor:Skin1.textColor1];
    
    [self.cell2BgView setBackgroundColor:Skin1.textColor4];
    [self.myIDLabel setTextColor:Skin1.textColor1];
    [self.promotionIdlabel setTextColor:Skin1.textColor1];
    
    [self.cell3BgView setBackgroundColor:Skin1.textColor4];
    [self.homeLabel setTextColor:Skin1.textColor1];
    [self.twowmLabel setTextColor:Skin1.textColor1];
    
    [self.cell4BgView setBackgroundColor:Skin1.textColor4];
    [self.registeredLabel setTextColor:Skin1.textColor1];
    [self.two2wmLabel setTextColor:Skin1.textColor1];
    
    [self.cell5BgView setBackgroundColor:Skin1.CLBgColor];
    [self.moneyLabel setTextColor:Skin1.textColor1];
    [self.sectionLabel4 setTextColor:Skin1.textColor1];
    
    [self.cell6BgView setBackgroundColor:Skin1.textColor4];
    [self.monthLabel setTextColor:Skin1.textColor1];
    [self.incomeLabel setTextColor:Skin1.textColor1];
    
    [self.cell7BgView setBackgroundColor:Skin1.textColor4];
    [self.monthUserLabel setTextColor:Skin1.textColor1];
    [self.monthMembers setTextColor:Skin1.textColor1];
    
    [self.cell8BgView setBackgroundColor:Skin1.textColor4];
    [self.countLabel setTextColor:Skin1.textColor1];
    [self.totalMembers setTextColor:Skin1.textColor1];
    
    [self.cell9BgView setBackgroundColor:Skin1.CLBgColor];
    [self.sectionLabel4 setTextColor:Skin1.textColor1];
    
    self.userNameLabel.text = @"";
    self.promotionIdlabel.text =@"";
    self.promotionUrlLabel.text = @"";
    self.registerUrlLabel.text = @"";
    self.incomeLabel.text = @"";
    
    
    self.totalMembers.text = @"";
    self.monthMembers.text = @"";
    
    self.sectionLabel3.text = @"";
    
    
    
    [self teamInviteInfoData];
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
  
}
- (IBAction)homeUrlCopy:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.promotionUrlLabel.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
    
}
- (IBAction)homeSwitchClick:(id)sender {//====
    
    self.showHomeUrl = !self.showHomeUrl;
    [self.tableView reloadData];
}
- (IBAction)registerUrlCopy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.registerUrlLabel.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}
- (IBAction)registerSwitchClick:(id)sender {
    
    self.showRegisterUrl = !self.showRegisterUrl;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return self.showHomeUrl ? 285 : 100;
    }else if (indexPath.section == 2) {
        
        return self.showRegisterUrl ? 285 : 100;
    }else {
        
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}

#pragma mark -- 网络请求
//得到推荐信息数据
- (void)teamInviteInfoData {
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork teamInviteInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            weakSelf.mUGinviteInfoModel = model.data;
            NSLog(@"rid = %@",weakSelf.mUGinviteInfoModel.rid);
           
            [weakSelf setUIDate];
            //
            
        } failure:^(id msg) {
            
            [SVProgressHUD dismiss];
            
        }];
    }];
}

#pragma mark -- UI数据
-(void)setUIDate{
    self.userNameLabel.text = self.mUGinviteInfoModel.username;
    self.promotionIdlabel.text =self.mUGinviteInfoModel.rid;
    self.promotionUrlLabel.text = self.mUGinviteInfoModel.link_i;
    self.registerUrlLabel.text = self.mUGinviteInfoModel.link_r;
    self.incomeLabel.text = self.mUGinviteInfoModel.month_earn;

   [self.myQrcode1ImageView setImage:[SGQRCodeObtain generateQRCodeWithData:self.mUGinviteInfoModel.link_i size:160.0]];
    
    [self.myQrcode2ImageView setImage:[SGQRCodeObtain generateQRCodeWithData:self.mUGinviteInfoModel.link_r size:160.0]];
    
    
    self.totalMembers.text = self.mUGinviteInfoModel.total_member;
    self.monthMembers.text = self.mUGinviteInfoModel.month_member;
    
   self.sectionLabel3.text = self.mUGinviteInfoModel.fandian_intro;
    
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];

    if ([config.myreco_img isEqualToString:@"0"]) {
        
        [self.headerImageView setHidden:NO];
        self.headerImageView.height = 256;
           [self.tableView reloadData];
    }
    else if([config.myreco_img isEqualToString:@"1"]) {
        
        [self.headerImageView setHidden:YES];
        self.headerImageView.height = 0.1;
        
        [self.tableView reloadData];

    }

}
@end
