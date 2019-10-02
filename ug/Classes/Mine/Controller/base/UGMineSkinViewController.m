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
//===================================================

@property (weak, nonatomic) IBOutlet UIButton *topupButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsButton;
@property (weak, nonatomic) IBOutlet UIButton *conversionButton;

//===================================================
@property (nonatomic, strong) NSMutableArray *menuNameArray;
@property (nonatomic, strong) NSMutableArray *menuSecondNameArray;

@end

@implementation UGMineSkinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getDateSource];
    
//     NSString *skitType = [[UGSkinManagers shareInstance] skitType];
//    if ([skitType isEqualToString:@"新年红"]) {
//        [self skinSeconddataSource];
//    }
//    else  if([skitType isEqualToString:@"石榴红"]){
//        [self skinFirstdataSource];
//    }
//    else  if([skitType isEqualToString:@"经典"]){
//        [self skinFirstdataSource];
//    }
    
    [self skinSeconddataSource];
    [self skinFirstdataSource];
    
    [self addRightBtn];
    
    skitType = @"新年红";
     [self initCollectionView];
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
        self.topupViewNSLayoutConstraintHight.constant = 90;
        skitType = @"石榴红";
    }
    [self.myCollectionView reloadData];
            isOk = !isOk;
    
}

-(void)getDateSource{
    NSString *skitType = [[UGSkinManagers shareInstance] skitType];
    
    if ([skitType isEqualToString:@"新年红"]) {
        [self skinSeconddataSource];
    }
    else{
        [self skinFirstdataSource];
    }
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
    

    
    float itemW = (UGScreenW - 8) / 3;
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemW );
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 2;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(UGScreenW, 80);
        layout;
        
    });

        self.myCollectionView.backgroundColor = [UIColor clearColor];
        self.myCollectionView.dataSource = self;
        self.myCollectionView.delegate = self;
        [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGMineMenuCollectionViewCell"];
        [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineSkinCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGMineSkinCollectionViewCell"];
    
    
//        [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineSkinFirstCollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UGMineSkinFirstCollectionHeadView"];
//        [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGSkinSeconCollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UGSkinSeconCollectionHeadView"];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGMineSkinFirstCollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UGMineSkinFirstCollectionHeadView"];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGSkinSeconCollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UGSkinSeconCollectionHeadView"];
    
        [self.myCollectionView setShowsHorizontalScrollIndicator:NO];
        [self.myCollectionView setCollectionViewLayout:layout animated:NO completion:nil];
    
    
   
    
}


#pragma mark UICollectionView datasource

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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSString *skitType = [[UGSkinManagers shareInstance] skitType];
    if ([skitType isEqualToString:@"新年红"]) {
          UGMineSkinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGMineSkinCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }
    else  {
         UGMineMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGMineMenuCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }
    
    return nil;

}

////3.添加header&footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"234234");
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        if ([skitType isEqualToString:@"新年红"]) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UGMineSkinFirstCollectionHeadView" forIndexPath:indexPath];
            if(headerView == nil)
            {
                headerView = [[UICollectionReusableView alloc] init];
            }
//            headerView.backgroundColor = [UIColor clearColor];
            
            return headerView;
        }
        else  if([skitType isEqualToString:@"石榴红"]){
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UGSkinSeconCollectionHeadView" forIndexPath:indexPath];
            if(headerView == nil)
            {
                headerView = [[UICollectionReusableView alloc] init];
            }
//            headerView.backgroundColor = [UIColor clearColor];
            
            return headerView;
        }
        
        
    }
    
    

    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
//    UGYYGames *listModel = self.dataArray[indexPath.row];
//
//    [self getGotoGameUrl:listModel];
    
}


@end
