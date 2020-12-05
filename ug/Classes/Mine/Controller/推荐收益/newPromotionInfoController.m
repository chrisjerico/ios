//
//  newPromotionInfoController.m
//  UGBWApp
//
//  Created by ug on 2020/12/3.
//  Copyright © 2020 ug. All rights reserved.
//

#import "newPromotionInfoController.h"
#import "UGinviteInfoModel.h"
#import "UGSystemConfigModel.h"
#import "HelpDocModel.h"
@interface newPromotionInfoController (){
    float btnH;
}

@property (strong, nonatomic)  UGinviteInfoModel *mUGinviteInfoModel;   /**<   数据*/

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;    /**<   最大图片*/
@property (weak, nonatomic) IBOutlet UIView *wm1View;                 /**<   2微码view1*/
@property (weak, nonatomic) IBOutlet UIView *wm2View;                 /**<   2微码view2*/
@property (nonatomic, assign) BOOL showHomeUrl;                       /**<   2微码view1 显示开关*/
@property (nonatomic, assign) BOOL showRegisterUrl;
//佣金比例
@property (weak, nonatomic) IBOutlet UIView *big2View;/**<  佣金比例2View*/
@property (weak, nonatomic) IBOutlet UIView *bigView;/**<  佣金比例1View*/
@property (strong, nonatomic) NSMutableArray *buttons;/**<  btn数组**/
@property (weak, nonatomic) IBOutlet UILabel *mContentLbl;/**<  佣金比例内容*/
@property (weak, nonatomic) IBOutlet UIStackView *btnsView;/**<  btnView**/
@property (weak, nonatomic) IBOutlet UIView *btnsBgView;/**<  btn背景View**/
@property (nonatomic, strong) NSMutableArray <HelpDocModel *> * itemArry;//多个web文档
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackHeight;
@end

@implementation newPromotionInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    设置样式
    [self selfViewStyle];
//    佣金比例样式
    [self bigViewInitStyle];
//    网络数据
    [self teamInviteInfoData];
    
}
//    设置样式
-(void)selfViewStyle{
    
    self.showHomeUrl = YES;
    self.showRegisterUrl = YES;
    
    FastSubViewCode(self.view)
    self.view.backgroundColor = Skin1.textColor4;
    subButton(@"推荐复制btn").layer.cornerRadius = 3;
    subButton(@"推荐复制btn").layer.masksToBounds = YES;
    [subButton(@"推荐复制btn") setBackgroundColor:Skin1.navBarBgColor];
    
    subButton(@"注册复制btn").layer.cornerRadius = 3;
    subButton(@"注册复制btn").layer.masksToBounds = YES;
    [subButton(@"注册复制btn") setBackgroundColor:Skin1.navBarBgColor];
    
    [subView(@"用户名View") setBackgroundColor:Skin1.textColor4];
    [subView(@"推荐idView") setBackgroundColor:Skin1.textColor4];
    [subView(@"首页推荐View") setBackgroundColor:Skin1.textColor4];
    [subView(@"2微码1View") setBackgroundColor:Skin1.textColor4];
    [subView(@"注册推荐View") setBackgroundColor:Skin1.textColor4];
    [subView(@"2微码2View") setBackgroundColor:Skin1.textColor4];
    [subView(@"佣金比例View") setBackgroundColor:Skin1.textColor4];
    [subView(@"本月推荐收益View") setBackgroundColor:Skin1.textColor4];
    [subView(@"本月推荐会员View") setBackgroundColor:Skin1.textColor4];
    [subView(@"会员总计View") setBackgroundColor:Skin1.textColor4];
    [subView(@"底View") setBackgroundColor:Skin1.textColor4];
    [subLabel(@"彩票返点label") setBackgroundColor:Skin1.textColor4];
    [subLabel(@"真人返点label") setBackgroundColor:Skin1.textColor4];
    [subLabel(@"捕鱼返点label") setBackgroundColor:Skin1.textColor4];
    [subLabel(@"电子返点label") setBackgroundColor:Skin1.textColor4];
    [subLabel(@"电竞返点label") setBackgroundColor:Skin1.textColor4];
    [subLabel(@"棋牌返点label") setBackgroundColor:Skin1.textColor4];
    [subView(@"标题1View") setBackgroundColor:Skin1.CLBgColor];
    [subView(@"标题2View") setBackgroundColor:Skin1.CLBgColor];
    [subView(@"标题3View") setBackgroundColor:Skin1.CLBgColor];
    
    [subLabel(@"用户名标题label") setTextColor:Skin1.textColor1];
    [subLabel(@"我的用户label") setTextColor:Skin1.textColor1];
    [subLabel(@"我的推荐标题label") setTextColor:Skin1.textColor1];
    [subLabel(@"我的推荐label") setTextColor:Skin1.textColor1];
    [subLabel(@"首页推荐地址") setTextColor:Skin1.textColor1];
    [subLabel(@"二微码label") setTextColor:Skin1.textColor1];
    [subLabel(@"注册推荐标题label") setTextColor:Skin1.textColor1];
    [subLabel(@"二微码2label") setTextColor:Skin1.textColor1];
    [subLabel(@"佣金比例label") setTextColor:Skin1.textColor1];
    [subLabel(@"彩票返点label") setTextColor:Skin1.textColor1];
    [subLabel(@"真人返点label") setTextColor:Skin1.textColor1];
    [subLabel(@"捕鱼返点label") setTextColor:Skin1.textColor1];
    [subLabel(@"电子返点label") setTextColor:Skin1.textColor1];
    [subLabel(@"电竞返点label") setTextColor:Skin1.textColor1];
    [subLabel(@"体育返点label") setTextColor:Skin1.textColor1];
    [subLabel(@"棋牌返点label") setTextColor:Skin1.textColor1];
    [subLabel(@"文字label") setTextColor:Skin1.textColor1];
    [subLabel(@"本月推荐标题label") setTextColor:Skin1.textColor1];
    [subLabel(@"推荐收益label") setTextColor:Skin1.textColor1];
    [subLabel(@"推荐会员标题label") setTextColor:Skin1.textColor1];
    [subLabel(@"推荐会员label") setTextColor:Skin1.textColor1];
    [subLabel(@"推荐会员总计标题label") setTextColor:Skin1.textColor1];
    [subLabel(@"会员总计label") setTextColor:Skin1.textColor1];
    [subLabel(@"标题1label") setTextColor:Skin1.textColor2];
    [subLabel(@"标题2label") setTextColor:Skin1.textColor2];
    [subLabel(@"佣金计算label") setTextColor:Skin1.textColor2];
    
    subLabel(@"我的用户label").text = @"";
    subLabel(@"我的推荐label").text = @"";
    subLabel(@"推荐地址label").text = @"";
    subLabel(@"注册地址label").text = @"";
    subLabel(@"彩票返点label").text = @"";
    subLabel(@"真人返点label").text = @"";
    subLabel(@"捕鱼返点label").text = @"";
    subLabel(@"电子返点label").text = @"";
    subLabel(@"电竞返点label").text = @"";
    subLabel(@"体育返点label").text = @"";
    subLabel(@"棋牌返点label").text = @"";
    subLabel(@"文字label").text = @"";
    subLabel(@"推荐收益label").text = @"";
    subLabel(@"推荐会员label").text = @"";
    subLabel(@"会员总计label").text = @"";
    
    [subLabel(@"彩票返点label") setHidden:YES];
    [subLabel(@"真人返点label") setHidden:YES];
    [subLabel(@"捕鱼返点label") setHidden:YES];
    [subLabel(@"电子返点label") setHidden:YES];
    [subLabel(@"电竞返点label") setHidden:YES];
    [subLabel(@"体育返点label") setHidden:YES];
    [subLabel(@"棋牌返点label") setHidden:YES];

    
}
#pragma mark -佣金样式1
//    佣金比例样式
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

//网络数据
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

        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}
//UI数据
-(void)setUIDate{
    FastSubViewCode(self.view)
    
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"彩票返点" WebName:self.mUGinviteInfoModel.fandian_intro]];
        subLabel(@"彩票返点label").text = [NSString stringWithFormat:@"彩票返点:%@",self.mUGinviteInfoModel.fandian_intro];
        [subLabel(@"彩票返点label") setHidden: NO];
    }
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.real_fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"真人返点" WebName:self.mUGinviteInfoModel.real_fandian_intro]];
        subLabel(@"真人返点label").text = [NSString stringWithFormat:@"真人返点:%@",self.mUGinviteInfoModel.real_fandian_intro];
        [subLabel(@"真人返点label") setHidden: NO];
    }
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.fish_fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"捕鱼返点" WebName:self.mUGinviteInfoModel.fish_fandian_intro]];
        subLabel(@"捕鱼返点label").text = [NSString stringWithFormat:@"捕鱼返点:%@",self.mUGinviteInfoModel.fish_fandian_intro];
        [subLabel(@"捕鱼返点label") setHidden: NO];
    }
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.game_fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"电子返点" WebName:self.mUGinviteInfoModel.game_fandian_intro]];
        subLabel(@"电子返点label").text = [NSString stringWithFormat:@"电子返点:%@",self.mUGinviteInfoModel.game_fandian_intro];
        [subLabel(@"电子返点label") setHidden: NO];
    }
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.esport_fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"电竞返点" WebName:self.mUGinviteInfoModel.esport_fandian_intro]];
        subLabel(@"电竞返点label").text = [NSString stringWithFormat:@"电竞返点:%@",self.mUGinviteInfoModel.esport_fandian_intro];
        [subLabel(@"电竞返点label") setHidden: NO];
    }
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.sport_fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"体育返点" WebName:self.mUGinviteInfoModel.sport_fandian_intro]];
        subLabel(@"体育返点label").text = [NSString stringWithFormat:@"体育返点:%@",self.mUGinviteInfoModel.sport_fandian_intro];
        [subLabel(@"体育返点label") setHidden: NO];
    }
    if (![CMCommon stringIsNull:self.mUGinviteInfoModel.card_fandian_intro]) {
        [_itemArry addObject:[[HelpDocModel alloc] initWithBtnTitle:@"棋牌返点" WebName:self.mUGinviteInfoModel.card_fandian_intro]];
        subLabel(@"棋牌返点label").text = [NSString stringWithFormat:@"棋牌返点:%@",self.mUGinviteInfoModel.card_fandian_intro];
        [subLabel(@"棋牌返点label") setHidden: NO];
    }

    self.mContentLbl.text = self.mUGinviteInfoModel.fandian_intro;
    subLabel(@"我的用户label").text = self.mUGinviteInfoModel.username;
    subLabel(@"我的推荐label").text = self.mUGinviteInfoModel.rid;
    subLabel(@"推荐地址label").text = self.mUGinviteInfoModel.link_i;
    subLabel(@"注册地址label").text = self.mUGinviteInfoModel.link_r;
    subLabel(@"推荐收益label").text = self.mUGinviteInfoModel.month_earn;
    subLabel(@"推荐会员label").text = self.mUGinviteInfoModel.total_member;
    subLabel(@"会员总计label").text = self.mUGinviteInfoModel.month_member;
    
    double proportion = [self.mUGinviteInfoModel.fandian doubleValue];
    double jg =  proportion *1000/100;
    NSString *jgStr = [NSString stringWithFormat:@"%.2f",jg];
    if([@"c186" isEqualToString:APP.SiteId]||[@"test60f" isEqualToString:APP.SiteId]){
        subLabel(@"佣金计算label").text = @"方案一：佣金比例图如上，有效投注达到100万以上，将可赚取0.1%的佣金【100万X0.001=1000】1000元佣金!有效投注越高，佣金就越高，亏损分红达到1万以上，另可再次得到1%佣金，【10000X0.1=1000】1000元亏损分红！";
    }
    else{
        subLabel(@"佣金计算label").text =  [NSString stringWithFormat:@"您推荐的会员在下注结算后，佣金会自动按照比例加到您的资金账户上。例如：您所推荐的会员下注1000元，您的收益=1000元*(一级下线比例比如：%@%%）=%@元。",self.mUGinviteInfoModel.fandian,jgStr];
    }
   
    [subImageView(@"推荐ImgV") setImage:[SGQRCodeObtain generateQRCodeWithData:self.mUGinviteInfoModel.link_i size:160.0]];
    [subImageView(@"注册imgV") setImage:[SGQRCodeObtain generateQRCodeWithData:self.mUGinviteInfoModel.link_r size:160.0]];

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
    }
    else if([config.myreco_img isEqualToString:@"1"]) {
        
        [self.headerImageView setHidden:YES];
        self.headerImageView.height = 0.1;

    }

    [self reloadView];
}


-(void)reloadView{

    if (APP.isShowAll) {
        [self.big2View setHidden:NO];
        [self.bigView setHidden:YES];
    } else {
        [self.big2View setHidden:YES];
        [self.bigView setHidden:NO];
        if(self.itemArry.count){
            [self resetData];
        }
        else{
            self.stackHeight.constant = 0.0;
        }
    }
    
   
}
//事件
- (IBAction)homeUrlCopy:(id)sender {
    FastSubViewCode(self.view)
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = subLabel(@"推荐地址label").text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}

- (IBAction)registerUrlCopy:(id)sender {
    FastSubViewCode(self.view)
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = subLabel(@"注册地址label").text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}
- (IBAction)homeSwitchClick:(id)sender {
    //====
    self.showHomeUrl = !self.showHomeUrl;
    [_wm1View setHidden:!self.showHomeUrl];
    
}

- (IBAction)registerSwitchClick:(id)sender {
    self.showRegisterUrl = !self.showRegisterUrl;
    [_wm2View setHidden:!self.showRegisterUrl];
}

@end
