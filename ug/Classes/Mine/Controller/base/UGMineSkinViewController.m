//
//  UGMineSkinViewController.m
//  ug
//
//  Created by ug on 2019/10/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMineSkinViewController.h"
#import "UGMineMenuCollectionViewCell.h"
#import "UGMineSkinCollectionViewCell.h"
#import "UGMineSkinFirstCollectionHeadView.h"
#import "UGSkinSeconCollectionHeadView.h"
#import "UGMineSkinModel.h"
#import "UGAvaterSelectView.h"
#import "UGMissionCenterViewController.h"
#import "UGSigInCodeViewController.h"

#import "UGFundsViewController.h"
#import "SLWebViewController.h"
#import "UGSystemConfigModel.h"
#import "UGBalanceConversionController.h"
#import "UGBankCardInfoController.h"
#import "UGPromotionIncomeController.h"
#import "UGBindCardViewController.h"
#import "UGSetupPayPwdController.h"
#import "UGYubaoViewController.h"
#import "UGSecurityCenterViewController.h"
#import "UGMailBoxTableViewController.h"
#import "UGBetRecordViewController.h"
#import "UGRealBetRecordViewController.h"
#import "UGUserInfoViewController.h"
#import "UGUserInfoViewController.h"
#import "UGUserInfoViewController.h"
#import "UGFeedBackController.h"
#import "UGMosaicGoldViewController.h"
#import "UGagentApplyInfo.h"
#import "UGAgentViewController.h"
#import "UGAgentRefusedViewController.h"


@interface UGMineSkinViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString *skitType;
}
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIView *topupView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topupViewNSLayoutConstraintHight;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
//===================================================
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userVipLabel;
@property (weak, nonatomic) IBOutlet UILabel *userMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshFirstButton;
@property (weak, nonatomic) IBOutlet UILabel *moneyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moenyNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *fristVipLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondVipLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *taskButton;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *containerLayer;
//===================================================

@property (weak, nonatomic) IBOutlet UIButton *topupButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsButton;
@property (weak, nonatomic) IBOutlet UIButton *conversionButton;

//===================================================
@property (nonatomic, strong) NSMutableArray *menuNameArray;
@property (nonatomic, strong) NSMutableArray *menuSecondNameArray;

@property (nonatomic, strong) NSArray *lotteryGamesArray;

@end

@implementation UGMineSkinViewController
-(void)skin{
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    [self.userInfoView setBackgroundColor: [[UGSkinManagers shareInstance] setNavbgColor]];
    _progressLayer.strokeColor = [[UGSkinManagers shareInstance] setMineProgressViewColor].CGColor;
     [self.progressView.layer addSublayer:self.progressLayer];
    [self.myCollectionView reloadData];

}

- (void)viewWillAppear:(BOOL)animated {
    SANotificationEventPost(UGNotificationGetUserInfo, nil);
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.refreshFirstButton.layer removeAllAnimations];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (self.refreshFirstButton.selected) {
        [self startAnimation];
        
    }
    
}

- (void)showAvaterSelectView {
    UGAvaterSelectView *avaterView = [[UGAvaterSelectView alloc] initWithFrame:CGRectMake(0, UGScerrnH, UGScreenW, UGScreenW)];
    [avaterView show];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //注册通知
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    SANotificationEventSubscribe(UGNotificationUserLogout, self, ^(typeof (self) self, id obj) {
        [self getSystemConfig];
    });
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self getSystemConfig];
        [self.refreshFirstButton.layer removeAllAnimations];
        [self setupUserInfo:NO];
        [self.myCollectionView reloadData];
    });
    SANotificationEventSubscribe(UGNotificationUserAvatarChanged, self, ^(typeof (self) self, id obj) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UGUserModel currentUser].avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    });
    self.navigationItem.title = @"我的";
    self.headImageView.layer.cornerRadius = self.headImageView.height / 2 ;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAvaterSelectView)];
    [self.headImageView addGestureRecognizer:tap];
    [self.progressView.layer addSublayer:self.progressLayer];
    self.progressView.layer.cornerRadius = self.progressView.height / 2;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.backgroundColor = UGRGBColor(213, 224, 237);
    //初始化数据
    [self getDateSource];
    
    //设置皮肤
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    [self.userInfoView setBackgroundColor: [[UGSkinManagers shareInstance] setNavbgColor]];
    
  
    //test用
    [self addRightBtn];
    
    skitType = @"新年红";
    //初始化
     [self initCollectionView];
    
    [self getAllNextIssueData];
    [self getUserInfo];
}

- (void)addRightBtn {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}


BOOL isOk = NO;
- (void)onClickedOKbtn {
    NSLog(@"onClickedOKbtn");
    
    if (isOk) {
        self.topupView.hidden = YES;
        self.topupViewNSLayoutConstraintHight.constant = 0.1;
        skitType = @"新年红";
    }
    else{
        self.topupView.hidden = NO;
        self.topupViewNSLayoutConstraintHight.constant = 60;
        skitType = @"石榴红";
    }
    [self.myCollectionView reloadData];
            isOk = !isOk;
    
}

-(void)getDateSource{
    [self skinSeconddataSource];
    [self skinFirstdataSource];
}

-(void)skinFirstdataSource{
    //经典+石榴红
    self.menuNameArray = [NSMutableArray array];
     UGUserModel *user = [UGUserModel currentUser];
    NSLog(@"isAgent= %d",user.isAgent);
    if (user.isAgent) {

        [self.menuNameArray addObject:@{@"title" : @"存款" , @"imgName" : @"chongzhi"}];
        [self.menuNameArray addObject:@{@"title" : @"取款" , @"imgName" : @"tixian"}];
        [self.menuNameArray addObject:@{@"title" : @"额度转换" , @"imgName" : @"change"}];
        
        [self.menuNameArray addObject:@{@"title" : @"推荐收益" , @"imgName" : @"shouyi"}];
        [self.menuNameArray addObject:@{@"title" : @"活动彩金" , @"imgName" : @"zdgl"}];
        [self.menuNameArray addObject:@{@"title" : @"利息宝" , @"imgName" : @"lixibao"}];
        [self.menuNameArray addObject:@{@"title" : @"在线客服" , @"imgName" : @"zaixiankefu"}];
        
        [self.menuNameArray addObject:@{@"title" : @"彩票注单记录" , @"imgName" : @"zdgl"}];
        
        [self.menuNameArray addObject:@{@"title" : @"银行卡管理" , @"imgName" : @"yinhangqia"}];
        [self.menuNameArray addObject:@{@"title" : @"安全中心" , @"imgName" : @"ziyuan"}];
        [self.menuNameArray addObject:@{@"title" : @"个人信息" , @"imgName" : @"zdgl"}];
        
        [self.menuNameArray addObject:@{@"title" : @"长龙助手" , @"imgName" : @"zdgl"}];
        [self.menuNameArray addObject:@{@"title" : @"站内信" , @"imgName" : @"zhanneixin"}];
        [self.menuNameArray addObject:@{@"title" : @"建议反馈" , @"imgName" : @"jianyi"}];

       
    } else {
        
        [self.menuNameArray addObject:@{@"title" : @"存款" , @"imgName" : @"chongzhi"}];
        [self.menuNameArray addObject:@{@"title" : @"取款" , @"imgName" : @"tixian"}];
        [self.menuNameArray addObject:@{@"title" : @"额度转换" , @"imgName" : @"change"}];
        
        [self.menuNameArray addObject:@{@"title" : @"申请代理" , @"imgName" : @"shouyi"}];
        [self.menuNameArray addObject:@{@"title" : @"活动彩金" , @"imgName" : @"zdgl"}];
        [self.menuNameArray addObject:@{@"title" : @"利息宝" , @"imgName" : @"lixibao"}];
        [self.menuNameArray addObject:@{@"title" : @"在线客服" , @"imgName" : @"zaixiankefu"}];
        
        [self.menuNameArray addObject:@{@"title" : @"彩票注单记录" , @"imgName" : @"zdgl"}];
        
        [self.menuNameArray addObject:@{@"title" : @"银行卡管理" , @"imgName" : @"yinhangqia"}];
        [self.menuNameArray addObject:@{@"title" : @"安全中心" , @"imgName" : @"ziyuan"}];
        [self.menuNameArray addObject:@{@"title" : @"个人信息" , @"imgName" : @"zdgl"}];
        
        [self.menuNameArray addObject:@{@"title" : @"长龙助手" , @"imgName" : @"zdgl"}];
        [self.menuNameArray addObject:@{@"title" : @"站内信" , @"imgName" : @"zhanneixin"}];
        [self.menuNameArray addObject:@{@"title" : @"建议反馈" , @"imgName" : @"jianyi"}];
        
    }
 
}

-(void)skinSeconddataSource{
    //新年红
    self.menuSecondNameArray = [NSMutableArray array];
    {
         NSMutableArray *dataArrayOne = [NSMutableArray array];
        UGUserModel *user = [UGUserModel currentUser];
        NSLog(@"isAgent= %d",user.isAgent);
        if (user.isAgent) {
            [dataArrayOne addObject:@{@"title" : @"推荐收益" , @"imgName" : @"shouyi"}];
            [dataArrayOne addObject:@{@"title" : @"活动彩金" , @"imgName" : @"zdgl"}];
            [dataArrayOne addObject:@{@"title" : @"利息宝" , @"imgName" : @"lixibao"}];
            [dataArrayOne addObject:@{@"title" : @"在线客服" , @"imgName" : @"zaixiankefu"}];
        }
        else{
            [dataArrayOne addObject:@{@"title" : @"申请代理" , @"imgName" : @"shouyi"}];
            [dataArrayOne addObject:@{@"title" : @"活动彩金" , @"imgName" : @"zdgl"}];
            [dataArrayOne addObject:@{@"title" : @"利息宝" , @"imgName" : @"lixibao"}];
            [dataArrayOne addObject:@{@"title" : @"在线客服" , @"imgName" : @"zaixiankefu"}];
        }
        UGMineSkinModel *dic1 = [UGMineSkinModel new];
        
        [dic1 setName:@"我的"];
        [dic1 setDataArray:dataArrayOne];
        
        [self.menuSecondNameArray addObject:dic1];
    }
    
    //=======================================
    {
        NSMutableArray *dataArrayOne = [NSMutableArray array];
       
       
            [dataArrayOne addObject:@{@"title" : @"彩票注单记录" , @"imgName" : @"shouyi"}];
        
        UGMineSkinModel *dic1 = [UGMineSkinModel new];
        
        [dic1 setName:@"注单详情"];
        [dic1 setDataArray:dataArrayOne];
        
        [self.menuSecondNameArray addObject:dic1];
        
    }
    
    //=======================================
    {
        NSMutableArray *dataArrayOne = [NSMutableArray array];
        
        
        [dataArrayOne addObject:@{@"title" : @"银行卡管理" , @"imgName" : @"yinhangqia"}];
        [dataArrayOne addObject:@{@"title" : @"安全中心" , @"imgName" : @"ziyuan"}];
        [dataArrayOne addObject:@{@"title" : @"个人信息" , @"imgName" : @"ziyuan"}];
        

        
        UGMineSkinModel *dic1 = [UGMineSkinModel new];
        
        [dic1 setName:@"设置"];
        [dic1 setDataArray:dataArrayOne];
        
        [self.menuSecondNameArray addObject:dic1];
        
    }
    
    //=======================================
    {
        NSMutableArray *dataArrayOne = [NSMutableArray array];
        
        
        [dataArrayOne addObject:@{@"title" : @"长龙助手" , @"imgName" : @"yinhangqia"}];
        [dataArrayOne addObject:@{@"title" : @"安全中心" , @"imgName" : @"ziyuan"}];
        [dataArrayOne addObject:@{@"title" : @"个人信息" , @"imgName" : @"ziyuan"}];

        UGMineSkinModel *dic1 = [UGMineSkinModel new];
        
        [dic1 setName:@"网站资料"];
        [dic1 setDataArray:dataArrayOne];
        
        [self.menuSecondNameArray addObject:dic1];
        
    }
  
    
}

- (void)initCollectionView {
    

    
//    float itemW = (UGScreenW - 8) / 3;
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.itemSize = CGSizeMake(itemW, itemW );
//        layout.minimumInteritemSpacing = 1;
//        layout.minimumLineSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        if ([skitType isEqualToString:@"新年红"]) {
            layout.headerReferenceSize = CGSizeMake(UGScreenW, 50);
        }
        else  if([skitType isEqualToString:@"石榴红"]){
             layout.headerReferenceSize = CGSizeMake(UGScreenW, 80);
        }
        else  if([skitType isEqualToString:@"经典"]){
            layout.headerReferenceSize = CGSizeMake(UGScreenW, 0.1);
        }
        
        layout;
        
    });

        self.myCollectionView.backgroundColor = [UIColor clearColor];
        self.myCollectionView.dataSource = self;
        self.myCollectionView.delegate = self;
        [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGMineMenuCollectionViewCell"];
        [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineSkinCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGMineSkinCollectionViewCell"];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineSkinFirstCollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UGMineSkinFirstCollectionHeadView"];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGSkinSeconCollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UGSkinSeconCollectionHeadView"];
    
        [self.myCollectionView setShowsHorizontalScrollIndicator:NO];
    
 
}




#pragma mark UICollectionView datasource
//collectionView有几个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    
    int sections = 1;
//    NSString *skitType = [[UGSkinManagers shareInstance] skitType];
    if ([skitType isEqualToString:@"新年红"]) {
        sections = (int) self.menuSecondNameArray.count;
    }
    else  if([skitType isEqualToString:@"石榴红"]){
        sections = 1;
    }
    else  if([skitType isEqualToString:@"经典"]){
        sections = 1;
    }
    return sections;
    
}
//每个section有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    int rows = 1;
//    NSString *skitType = [[UGSkinManagers shareInstance] skitType];
    if ([skitType isEqualToString:@"新年红"]) {
       UGMineSkinModel *dic = [self.menuSecondNameArray objectAtIndex:section];
        rows = (int)  dic.dataArray.count;
    }
    else  if([skitType isEqualToString:@"石榴红"]){
          rows = (int) self.menuNameArray.count;
    }
    else  if([skitType isEqualToString:@"经典"]){
        rows = (int) self.menuNameArray.count;
    }
    return rows;
}
//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSString *skitType = [[UGSkinManagers shareInstance] skitType];
    if ([skitType isEqualToString:@"新年红"]) {
          UGMineSkinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGMineSkinCollectionViewCell" forIndexPath:indexPath];
        
        UGMineSkinModel *model = [self.menuSecondNameArray objectAtIndex:indexPath.section];
        NSDictionary *dic = [model.dataArray objectAtIndex:indexPath.row];
        
        [cell setMenuName: [dic objectForKey:@"title"]];
        
        [cell setImageName: [dic objectForKey:@"imgName"]];
        return cell;
    }
    else  {
         UGMineMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGMineMenuCollectionViewCell" forIndexPath:indexPath];
        NSDictionary *dic = [self.menuNameArray objectAtIndex:indexPath.row];
        
        [cell setMenuName: [dic objectForKey:@"title"]];
        
        [cell setImageName: [dic objectForKey:@"imgName"]];
        return cell;
    }
    
    return nil;

}

//头尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"234234");
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        if ([skitType isEqualToString:@"新年红"]) {
            UGMineSkinFirstCollectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UGMineSkinFirstCollectionHeadView" forIndexPath:indexPath];
            if(headerView == nil)
            {
                headerView = [[UGMineSkinFirstCollectionHeadView alloc] init];
            }
//            headerView.backgroundColor = [UIColor clearColor];
             UGMineSkinModel *model = [self.menuSecondNameArray objectAtIndex:indexPath.section];
            [headerView setMenuName :model.name];
            
            return headerView;
        }
        else  if([skitType isEqualToString:@"石榴红"]){
            UGSkinSeconCollectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UGSkinSeconCollectionHeadView" forIndexPath:indexPath];
            if(headerView == nil)
            {
                headerView = [[UGSkinSeconCollectionHeadView alloc] init];
            }
//            headerView.backgroundColor = [UIColor clearColor];
            
            return headerView;
        }
        
        
    }
    
    

    return nil;
}
#pragma mark - UICollectionViewDelegate
//头视图尺寸
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if ([skitType isEqualToString:@"新年红"]) {

        CGSize size = {UGScreenW, 50};
        return size;
    }
    else  if([skitType isEqualToString:@"石榴红"]){
      
        CGSize size = {UGScreenW, 80};
        return size;
    }
    else  if([skitType isEqualToString:@"经典"]){
        CGSize size = {UGScreenW, 0.1};
        return size;
    }
    else{
        CGSize size = {UGScreenW, 0.1};
        return size;
    }
    
    
}


//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
     float itemW = (UGScreenW - 24.0 )/ 3.0;

    if ([skitType isEqualToString:@"新年红"]) {
        
        CGSize size = {itemW, 100};
        return size;
    }
    else {
        
        CGSize size = {itemW, itemW};
        return size;
    }
   
    
}

//item边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section {
  
        return UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0);

}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
        return 1.0;
  
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSString *title;
    if ([skitType isEqualToString:@"新年红"]) {
      
        UGMineSkinModel *model = [self.menuSecondNameArray objectAtIndex:indexPath.section];
        NSDictionary *dic = [model.dataArray objectAtIndex:indexPath.row];
        
        title= [dic objectForKey:@"title"];
        
    }
    else  {
        
        NSDictionary *dic = [self.menuNameArray objectAtIndex:indexPath.row];
        
        title=  [dic objectForKey:@"title"];
    }
    
    if ([title isEqualToString:@"存款"]) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
            fundsVC.selectIndex = 0;
            [self.navigationController pushViewController:fundsVC animated:YES];
        }
        
    }else if ([title isEqualToString:@"取款"]) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UGFundsViewController *fundsVC = [[UGFundsViewController alloc] init];
            fundsVC.selectIndex = 1;
            [self.navigationController pushViewController:fundsVC animated:YES];
        }
        
    }else if ([title isEqualToString:@"在线客服"]) {
        SLWebViewController *webViewVC = [[SLWebViewController alloc] init];
        UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
        if (config.zxkfUrl) {
            
            webViewVC.urlStr = config.zxkfUrl;
        }
        [self.navigationController pushViewController:webViewVC animated:YES];
        
    }else if ([title isEqualToString:@"银行卡管理"]) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBindCardViewController" bundle:nil];
            if (user.hasBankCard) {
                UGBankCardInfoController *binkVC = [storyboard instantiateViewControllerWithIdentifier:@"UGBankCardInfoController"];
                [self.navigationController pushViewController:binkVC animated:YES];
            }else {
                if (user.hasFundPwd) {
                    
                    UGBindCardViewController *bankCardVC = [storyboard instantiateViewControllerWithIdentifier:@"UGBindCardViewController"];
                    [self.navigationController pushViewController:bankCardVC animated:YES];
                }else {
                    UGSetupPayPwdController *fundVC = [storyboard instantiateViewControllerWithIdentifier:@"UGSetupPayPwdController"];
                    [self.navigationController pushViewController:fundVC animated:YES];
                }
            }
        }
        
    }else if ([title isEqualToString:@"利息宝"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGYubaoViewController" bundle:nil];
        UGYubaoViewController *lixibaoVC = [storyboard instantiateInitialViewController];
        [self.navigationController pushViewController:lixibaoVC  animated:YES];
        
    }else if ([title isEqualToString:@"额度转换"]){
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UGBalanceConversionController *conversion = [self.storyboard instantiateViewControllerWithIdentifier:@"UGBalanceConversionController"];
            [self.navigationController pushViewController:conversion  animated:YES];
        }
        
    }else if ([title isEqualToString:@"推荐收益"]) {
        
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UGPromotionIncomeController *incomeVC = [[UGPromotionIncomeController alloc] init];
            [self.navigationController pushViewController:incomeVC animated:YES];
        }
    }else if ([title isEqualToString:@"申请代理"]) {
        
        UGUserModel *user = [UGUserModel currentUser];
        user.isTest = NO;
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
            
            if ([config.agent_m_apply isEqualToString:@"1"]) {
                //调接口
                [self teamAgentApplyInfoWithParams];
                
            } else {
                [self.navigationController.view makeToast:@"在线注册代理已经关闭"
                                                 duration:1.5
                                                 position:CSToastPositionCenter];
                
            }
            
            
        }
        
    }else if ([title isEqualToString:@"安全中心"]) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UGSecurityCenterViewController *securityCenterVC = [[UGSecurityCenterViewController alloc] init];
            [self.navigationController pushViewController:securityCenterVC animated:YES];
        }
        
    }else if ([title isEqualToString:@"站内信"]) {
        UGMailBoxTableViewController *mailBoxVC = [[UGMailBoxTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:mailBoxVC animated:YES];
        
    }else if([title isEqualToString:@"彩票注单记录"]) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UGBetRecordViewController *betRecordVC = [[UGBetRecordViewController alloc] init];
            [self.navigationController pushViewController:betRecordVC animated:YES];
        }
        
    }else if ([title isEqualToString:@"其他注单记录"]) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGRealBetRecordViewController" bundle:nil];
            UGRealBetRecordViewController *betRecordVC = [storyboard instantiateInitialViewController];
            betRecordVC.gameType = @"real";
            [self.navigationController pushViewController:betRecordVC animated:YES];
        }
        
    }else if ([title isEqualToString:@"个人信息"]) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGUserInfoViewController" bundle:nil];
            UGUserInfoViewController *userInfoVC = [storyboard instantiateInitialViewController];
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
        
    }
    else if ([title isEqualToString:@"建议反馈"]) {
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGFeedBackController" bundle:nil];
            UGFeedBackController *feedbackVC = [storyboard instantiateInitialViewController];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
    }
    else if ([title isEqualToString:@"活动彩金"]) {
        
        UGUserModel *user = [UGUserModel currentUser];
        if (user.isTest) {
            [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    SANotificationEventPost(UGNotificationShowLoginView, nil);
                }
            }];
        }else {
            
            
            UGMosaicGoldViewController *vc = [[UGMosaicGoldViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
}

#pragma mark - 其他方法
- (IBAction)showMissionVC:(id)sender {
    UGUserModel *user = [UGUserModel currentUser];
    if (user.isTest) {
        [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                SANotificationEventPost(UGNotificationShowLoginView, nil);
            }
        }];
    }else {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGMissionCenterViewController" bundle:nil];
        UGMissionCenterViewController *missionVC = [storyboard instantiateInitialViewController];
        [self.navigationController pushViewController:missionVC animated:YES];
    }
    
}
- (IBAction)showSign:(id)sender {
    UGUserModel *user = [UGUserModel currentUser];
    if (user.isTest) {
        [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                SANotificationEventPost(UGNotificationShowLoginView, nil);
            }
        }];
    }else {
        
        //
        //        UGSignInViewController *vc = [[UGSignInViewController alloc] initWithNibName:@"UGSignInViewController" bundle:nil];
        UGSigInCodeViewController *vc = [[UGSigInCodeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (IBAction)refreshBalance:(id)sender {

    [self getUserInfo];
    [self getAllNextIssueData];
 
}

//刷新余额动画
-(void)startAnimation
{
    
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshFirstButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
    
}

//刷新余额动画
-(void)stopAnimation
{
    
    [self.refreshFirstButton.layer removeAllAnimations];
    
}

- (CAShapeLayer *)containerLayer
{
    if (!_containerLayer) {
        _containerLayer = [self defaultLayer];
        CGRect rect = (CGRect){(self.progressView.bounds.size.width-self.progressView.bounds.size.height)/2,0,self.progressView.bounds.size.height,self.progressView.bounds.size.height};
        _containerLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5].CGPath;
    }
    return _containerLayer;
}

- (UIBezierPath *)progressPathWithProgress:(CGFloat)progress
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = (CGPoint){0,CGRectGetHeight(self.progressView.frame)/2};
    CGPoint endPoint = (CGPoint){CGRectGetWidth(self.progressView.frame)*progress,startPoint.y};
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path closePath];
    return path;
    
}
- (CAShapeLayer *)defaultLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor grayColor].CGColor;
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.frame = self.progressView.bounds;
    return layer;
}
- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [self defaultLayer];
        _progressLayer.lineWidth = self.progressView.height;
        _progressLayer.strokeColor = [[UGSkinManagers shareInstance] setMineProgressViewColor].CGColor;
    }
    return _progressLayer;
}

#pragma mark - UIS
- (void)setupUserInfo:(BOOL)flag  {
    UGUserModel *user = [UGUserModel currentUser];
    
    
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    if (config.checkinSwitch) {
        [self.signButton setHidden:NO];
    } else {
        [self.signButton setHidden:YES];
    }
    
    
    if ([config.missionSwitch isEqualToString:@"0"]) {
        [self.taskButton setHidden:NO];
    } else {
        [self.taskButton setHidden:YES];
    }
    
    
    if (flag) {
        
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    }
    
    self.userNameLabel.text = user.username;
    self.userVipLabel.text = user.curLevelGrade;
    
    NSString *imagerStr = [user.curLevelGrade lowercaseString];
    NSLog(@"imagerStr = %@",imagerStr);
    
    NSString *subStr = [user.curLevelGrade substringFromIndex:3];
    
    int levelsInt = [subStr intValue];
    NSString *imgStr = @"";
    if (levelsInt <11) {
        imgStr = [NSString stringWithFormat:@"vip%d",levelsInt];
    } else {
        imgStr = @"vip11";
    }
    
//    [self.vipImager setImage: [UIImage imageNamed:imgStr]];
    
    NSString *img2Str = @"";
    if (levelsInt <11) {
        img2Str = [NSString stringWithFormat:@"grade_%d",levelsInt];
    } else {
        img2Str = @"grade_11";
    }
    
//    [self.curLevelImageView setImage: [UIImage imageNamed:img2Str]];
    self.fristVipLabel.text = [NSString stringWithFormat:@"VIP%@",subStr];
    
    NSString *sub2Str = [user.nextLevelGrade substringFromIndex:3];
    
    int levels2Int = [sub2Str intValue];
    
    NSString *img2_1Str = @"";
    if (levels2Int <11) {
        img2_1Str = [NSString stringWithFormat:@"grade_%d",levels2Int];
    } else {
        img2_1Str = @"grade_11";
    }
    
//    [self.nextLevelImageView setImage: [UIImage imageNamed:img2_1Str]];
    self.secondVipLabel.text = [NSString stringWithFormat:@"VIP%@",sub2Str];
    
    int int1String = [user.taskRewardTotal intValue];
    NSLog(@"int1String = %d",int1String);
    int int2String = [user.nextLevelInt intValue];
    NSLog(@"int2String = %d",int2String);
    self.valueLabel.text = [NSString stringWithFormat:@"成长值（%d-%d）",int1String,int2String];
    
    if (![CMCommon stringIsNull:user.taskRewardTitle]) {
        self.moneyNameLabel.text = user.taskRewardTitle;
    }
    if (![CMCommon stringIsNull:user.taskRewardTotal]) {
        self.moenyNumberLabel.text = user.taskRewardTotal;
    }
    
    //进度条
    float floatProgress = (float)[user.taskRewardTotal doubleValue]/[user.nextLevelInt doubleValue];
    self.progressLayer.path = [self progressPathWithProgress:floatProgress].CGPath;
    
}

#pragma mark -- 网络请求

//用户签到（签到类型：0是签到，1是补签）
- (void)teamAgentApplyInfoWithParams{
    
    //    NSString *date = @"2019-09-04";
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork teamAgentApplyInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            UGagentApplyInfo *obj  = (UGagentApplyInfo *)model.data;
            
            NSLog(@"%@",obj.reviewStatus);
            
            NSNumber *numberStatus = obj.reviewStatus;
            int intStatus = [numberStatus intValue];
            //0 未提交  1 待审核  2 审核通过 3 审核拒绝
            
            if (intStatus == 0) {//==>
                //提交代理==》UGAgentViewController
                UGAgentViewController *incomeVC = [[UGAgentViewController alloc] init];
                incomeVC.item = obj;
                [self.navigationController pushViewController:incomeVC animated:YES];
            }
            else if (intStatus == 1) {
                //待审核==》UGAgentViewController
                UGAgentViewController *incomeVC = [[UGAgentViewController alloc] init];
                incomeVC.item = obj;
                [self.navigationController pushViewController:incomeVC animated:YES];
            }
            else if (intStatus == 2) {
                //审核通过==> 推荐
                UGPromotionIncomeController *incomeVC = [[UGPromotionIncomeController alloc] init];
                [self.navigationController pushViewController:incomeVC animated:YES];
            }
            else if (intStatus == 3) {
                //审核拒绝==》拒绝
                UGAgentRefusedViewController*incomeVC = [[UGAgentRefusedViewController alloc] init];
                incomeVC.item = obj;
                [self.navigationController pushViewController:incomeVC animated:YES];
            }
            //            "username": "ugtmac",
            //            "qq": "12345678",
            //            "mobile": "13707890978",
            //            "applyReason": "QWERTY",
            //            "reviewResult": "",
            //            "reviewStatus": 1
            
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

- (void)getUserInfo {
    [self startAnimation];
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            NSLog(@"签到==%d",[UGUserModel currentUser].checkinSwitch);
            
            [self getSystemConfig];
            
            
            
            
            
        } failure:^(id msg) {
            
            [self stopAnimation];
            
        }];
    }];
}

- (void)getSystemConfig {
    
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            
            
            NSLog(@"签到==%d",[UGSystemConfigModel  currentConfig].checkinSwitch);
            
            [[UGSkinManagers shareInstance] setSkin];
            
            [self setupUserInfo:YES];
            
            
            [self stopAnimation];
            
        } failure:^(id msg) {
            
        }];
    }];
}

- (void)getAllNextIssueData {
    [SVProgressHUD showWithStatus: nil];
    [CMNetwork getAllNextIssueWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [SVProgressHUD dismiss];
        [CMResult processWithResult:model success:^{
            
            self.lotteryGamesArray = model.data;
            
        } failure:^(id msg) {
            
        }];
    }];
    
}

- (void)userLogout {
    
    
    [self.tabBarController setSelectedIndex:0];
    
    SANotificationEventPost(UGNotificationUserLogout, nil);
    
    
}
@end
