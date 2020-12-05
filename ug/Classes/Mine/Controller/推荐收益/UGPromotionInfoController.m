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
#import "HelpDocModel.h"
@interface UGPromotionInfoController (){
    float btnH;
}
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
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel4;//佣金方案

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

@property (weak, nonatomic) IBOutlet UIView *bigView;/**<  佣金比例View*/
@property (strong, nonatomic) NSMutableArray *buttons;/**<  btn数组**/
@property (weak, nonatomic) IBOutlet UILabel *mContentLbl;/**<  佣金比例内容*/
@property (weak, nonatomic) IBOutlet UIStackView *btnsView;/**<  btnView**/
@property (weak, nonatomic) IBOutlet UIView *btnsBgView;/**<  btn背景View**/
@property (nonatomic, strong) NSMutableArray <HelpDocModel *> * itemArry;//多个web文档
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackHeight;
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
    
    [self.cell5BgView setBackgroundColor:Skin1.textColor4];
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
    
    [self.headerImageView setHidden:YES];
    self.headerImageView.height = 0.1;
    
    [self teamInviteInfoData];
    [self bigViewInitStyle];
}

-(void)bigViewInitStyle{
    [self.mContentLbl setTextColor:Skin1.textColor1];
    [self.btnsView setBackgroundColor:Skin1.textColor3];
    [self.btnsBgView setBackgroundColor:RGBA(196, 203, 204, 1)];
    self.bigView.layer.borderColor=[Skin1.textColor3 CGColor];
    self.bigView.layer.borderWidth= 1;
    self.bigView.layer.cornerRadius = 5;
    self.bigView.layer.masksToBounds = YES;
    
    [self.bigView setBackgroundColor:Skin1.CLBgColor];
    _buttons = [NSMutableArray new];
    _itemArry = [NSMutableArray new];
    btnH = 35.0;
    self.mContentLbl.text = @"";
}

- (void)cleanAllStack {
    NSArray * allStack = @[self.btnsView];
    for (UIStackView * stack in allStack) {
        for (UIView * view in stack.arrangedSubviews) {
            [stack removeArrangedSubview:view];
            [view removeFromSuperview];
        }
    }
}
-(void)resetData{

    [self cleanAllStack];
    for (NSInteger i = 0; i < _itemArry.count; i++) {
        HelpDocModel * item = _itemArry[i];
        WeakSelf
        [self bindButtonTitle:item.btnTitle Action:^(UIButton *button) {
            [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
                [weakSelf selectButtonSetRedColor:sender];
                [weakSelf loadText:item.webName];
            }];
        }];
    }
    UIButton *btnOne = [_buttons objectAtIndex:0];
    [btnOne setTitleColor:[UIColor redColor] forState:0];
    [CMCommon setBorderWithView:btnOne top:NO left:NO bottom:NO right:YES borderColor:Skin1.CLBgColor borderWidth:1];
    [btnOne setBackgroundColor:Skin1.CLBgColor];
    HelpDocModel * itemOne = _itemArry[0];
    [self loadText:itemOne.webName];
    self.stackHeight.constant = _itemArry.count *  btnH;
    
}
-(void)loadText:(NSString *)content{
    self.mContentLbl.text = content;
}
- (void)bindButtonTitle:(NSString *)content Action: (void (^)(UIButton *)) handle{
    UIView * view = [UIView new];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:content forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.numberOfLines = 2;
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button setBackgroundColor:RGBA(196, 203, 204, 1)];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
        make.height.mas_equalTo(btnH);
    }];
    [self.btnsView addArrangedSubview:view];
    [_buttons addObject:button];
    handle(button);
}
-(void)selectButtonSetRedColor:(UIControl *)sender{
    [self allButtonSetTitleBlackColor];
    UIButton *btn = (UIButton *)sender;
    [btn setTitleColor:[UIColor redColor] forState:0];
    [CMCommon setBorderWithView:btn top:NO left:NO bottom:NO right:YES borderColor:Skin1.CLBgColor borderWidth:1];
    [btn setBackgroundColor:Skin1.CLBgColor];
}

- (void)allButtonSetTitleBlackColor {
    // UIButton
    for (UIView *v in self.buttons) {
        if ([ v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            [btn setTitleColor:[UIColor blackColor] forState:0];
            [btn setBackgroundColor:RGBA(196, 203, 204, 1)];
            [CMCommon setBorderWithView:btn top:NO left:NO bottom:NO right:YES borderColor:Skin1.textColor3 borderWidth:1];
        }
    }
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
    
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"彩票返点" WebName:self.mUGinviteInfoModel.fandian_intro]];
    }
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.real_fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"真人返点" WebName:self.mUGinviteInfoModel.real_fandian_intro]];
    }
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.fish_fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"捕鱼返点" WebName:self.mUGinviteInfoModel.fish_fandian_intro]];
    }
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.game_fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"电子返点" WebName:self.mUGinviteInfoModel.game_fandian_intro]];
    }
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.esport_fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"电竞返点" WebName:self.mUGinviteInfoModel.esport_fandian_intro]];
    }
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.sport_fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"体育返点" WebName:self.mUGinviteInfoModel.sport_fandian_intro]];
    }
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.card_fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"棋牌返点" WebName:self.mUGinviteInfoModel.card_fandian_intro]];
    }
    
    
    self.userNameLabel.text = self.mUGinviteInfoModel.username;
    self.promotionIdlabel.text =self.mUGinviteInfoModel.rid;
    self.promotionUrlLabel.text = self.mUGinviteInfoModel.link_i;
    self.registerUrlLabel.text = self.mUGinviteInfoModel.link_r;
    self.incomeLabel.text = self.mUGinviteInfoModel.month_earn;
    double proportion = [self.mUGinviteInfoModel.fandian doubleValue];
    double jg =  proportion *1000/100;
    NSString *jgStr = [NSString stringWithFormat:@"%.2f",jg];
    
    self.mContentLbl.text = self.mUGinviteInfoModel.fandian_intro;
    
    if([@"c186" isEqualToString:APP.SiteId]||[@"test60f" isEqualToString:APP.SiteId]){
        self.sectionLabel4.text = @"方案一：佣金比例图如上，有效投注达到100万以上，将可赚取0.1%的佣金【100万X0.001=1000】1000元佣金!有效投注越高，佣金就越高，亏损分红达到1万以上，另可再次得到1%佣金，【10000X0.1=1000】1000元亏损分红！";
    }
    else{
        self.sectionLabel4.text =  [NSString stringWithFormat:@"您推荐的会员在下注结算后，佣金会自动按照比例加到您的资金账户上。例如：您所推荐的会员下注1000元，您的收益=1000元*(一级下线比例比如：%@%%）=%@元。",self.mUGinviteInfoModel.fandian,jgStr];
    }

   [self.myQrcode1ImageView setImage:[SGQRCodeObtain generateQRCodeWithData:self.mUGinviteInfoModel.link_i size:160.0]];
    
    [self.myQrcode2ImageView setImage:[SGQRCodeObtain generateQRCodeWithData:self.mUGinviteInfoModel.link_r size:160.0]];
    
    
    self.totalMembers.text = self.mUGinviteInfoModel.total_member;
    self.monthMembers.text = self.mUGinviteInfoModel.month_member;
    
   self.sectionLabel3.text = self.mUGinviteInfoModel.fandian_intro;
    
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];

    if ([@"c126b" isEqualToString:APP.SiteId]) {
        [self.headerImageView setImage:[UIImage imageNamed:@"c126bHeaderBgImg"]];
    }
    else if([@"c126" isEqualToString:APP.SiteId]){
        [self.headerImageView setImage:[UIImage imageNamed:@"c126HeaderBgImg"]];
    }
    else if([@"c186" isEqualToString:APP.SiteId]||[@"test60f" isEqualToString:APP.SiteId]){
        [self.headerImageView setImage:[UIImage imageNamed:@"c186HeaderBgImg"]];
    }
    else{
        [self.headerImageView setImage:[UIImage imageNamed:@"promotioninfo"]];
    }
    
    if ([config.myreco_img isEqualToString:@"0"]) {
        
        [self.headerImageView setHidden:NO];
        
        if ([@"c126b" isEqualToString:APP.SiteId]){
            self.headerImageView.height = kScreenWidth * 22.12 / 18.26;
        }
        else if([@"c126" isEqualToString:APP.SiteId]){
            self.headerImageView.height = kScreenWidth * 45 / 69;
        }
        else if([@"c186" isEqualToString:APP.SiteId]||[@"test60f" isEqualToString:APP.SiteId]){
            self.headerImageView.height = kScreenWidth * 15.88 / 24.34;
        }
        else{
            self.headerImageView.height = 256;
        }
        
        [self reloadView];
    }
    else if([config.myreco_img isEqualToString:@"1"]) {
        
        [self.headerImageView setHidden:YES];
        self.headerImageView.height = 0.1;
        [self reloadView];
       
    }

}

-(void)reloadView{
    if(self.itemArry.count){
        [self resetData];
    }
    else{
        self.stackHeight.constant = 0.0;
    }
    [self.tableView reloadData];

}
@end
