//
//  UGBMLotteryHomeViewController.m
//  ug
//
//  Created by ug on 2019/11/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBMLotteryHomeViewController.h"
#import "UGBMHeaderView.h"
#import "UGhomeRecommendCollectionViewCell.h"
#import "UGYYPlatformGames.h"
#import "UGYYLotterySecondHomeViewController.h"
#import "UGLotteryHomeController.h"
@interface UGBMLotteryHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
     UGBMHeaderView *headView;                /**<   导航头 */
}
@property (weak, nonatomic) IBOutlet UIView *titleView;                 /**<   会员View*/
@property (weak, nonatomic) IBOutlet UIView *titleLineView;              /**<   会员下面的线 */
@property (weak, nonatomic) IBOutlet UIView *titleUpLineView;              /**<  会员上面的线 */
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;   /**<   */
@property (nonatomic, strong) NSMutableArray *dataArray;                    /**<  数据源*/
@end

@implementation UGBMLotteryHomeViewController

- (BOOL)允许游客访问 { return true; }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];//强制隐藏NavBar
    [headView.leftwardMarqueeView start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [headView.leftwardMarqueeView pause];//fixbug  发热  掉电快
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"购彩大厅";
    self.fd_prefersNavigationBarHidden = YES;
    [self.view setBackgroundColor: Skin1.bgColor];
    if ([Skin1.skitString isEqualToString:@"GPK版香槟金"]) {
        _titleLineView.backgroundColor = Skin1.bgColor;
        _titleUpLineView.backgroundColor = Skin1.bgColor;
       
    }
    NSMutableArray <UIColor *> *colors = @[].mutableCopy;
    [colors addObject:Skin1.navBarBgColor];
    [colors addObject:Skin1.bgColor];
    self.titleView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage gradientImageWithBounds:self.titleView.bounds andColors:colors andGradientType:GradientDirectionTopToBottom]];
    [self creatView];
    _dataArray = [NSMutableArray array];
    //初始化
    [self initCollectionView];
    
    WeakSelf
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getPlatformGamesWithParams];
    }];

    //初始化数据
    [self getPlatformGamesWithParams];
}

-(void)creatView{
    //===============导航头布局=================
       headView = [[UGBMHeaderView alloc] initView];
       [self.view addSubview:headView];
       [headView mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
           make.top.equalTo(self.view.mas_top).with.offset(k_Height_StatusBar);
           make.left.equalTo(self.view.mas_left).offset(0);
           make.height.equalTo([NSNumber numberWithFloat:110]);
           make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
       }];
}

- (void)initCollectionView {

    float itemW = (UGScreenW - 15) / 2;
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemW / 2);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(UGScreenW, 10);
        layout;
    });
    self.myCollectionView.backgroundColor = Skin1.bgColor;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.delegate = self;
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGhomeRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGhomeRecommendCollectionViewCell"];
    [self.myCollectionView setShowsHorizontalScrollIndicator:NO];
    [self.myCollectionView setCollectionViewLayout:layout];
    
}

#pragma mark UICollectionView datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGhomeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGhomeRecommendCollectionViewCell" forIndexPath:indexPath];
    UGYYPlatformGames *model = self.dataArray[indexPath.row];
    cell.item = model;
    [cell setBackgroundColor: Skin1.homeContentColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UGYYPlatformGames *listModel = self.dataArray[indexPath.row];
    if ([@"lottery" isEqualToString:listModel.category]) {//彩票
        [NavController1 pushViewController:[UGLotteryHomeController new] animated:YES];
        return;
    }
    
    UGYYLotterySecondHomeViewController *vc = [[UGYYLotterySecondHomeViewController alloc] init];
    vc.title = _NSString(@"%@系列", listModel.categoryName);
    vc.dataArray = [UGYYGames arrayOfModelsFromDictionaries:listModel.games error:nil];
    [NavController1 pushViewController:vc animated:YES];
}


#pragma mark 网络请求

- (void)getPlatformGamesWithParams {
    WeakSelf;
    [CMNetwork getPlatformGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [self.myCollectionView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            weakSelf.dataArray = model.data;
            [weakSelf.myCollectionView reloadData];
        } failure:^(id msg) {
        }];
    }];
}

@end
