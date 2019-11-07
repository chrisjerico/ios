//
//  UGBMBrowseViewController.m
//  ug
//
//  Created by ug on 2019/11/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBMBrowseViewController.h"
#import "UGBMHeaderView.h"
#import "UGGameTypeColletionViewCell.h"
#import "UGAllNextIssueListModel.h"
#import "UGCommonLotteryController.h"

@interface UGBMBrowseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
     UGBMHeaderView *headView;                /**<   导航头 */
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray <GameModel *> *dataArray;  /**<   数据源 */
@end
@implementation UGBMBrowseViewController

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = UGNavigationController.browsingHistoryArray;
    
    self.navigationItem.title = @"会员中心";
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = true;
    [self.view setBackgroundColor: Skin1.bgColor];
    [self creatView];

    //初始化
    [self initCollectionView];
    [self.myCollectionView reloadData];
//    [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    FastSubViewCode(self.view);
    subView(@"状态栏背景色View").backgroundColor = Skin1.navBarBgColor;
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
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout;
    });
    [self.myCollectionView setCollectionViewLayout:layout];
        self.myCollectionView.backgroundColor = Skin1.bgColor;
        self.myCollectionView.dataSource = self;
        self.myCollectionView.delegate = self;
        [self.myCollectionView registerNib:[UINib nibWithNibName:@"UGGameTypeColletionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGGameTypeColletionViewCell"];
    [self.myCollectionView setShowsHorizontalScrollIndicator:NO];
}

#pragma mark UICollectionView datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGGameTypeColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGGameTypeColletionViewCell" forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   return CGSizeMake(UGScreenW/3-8, 110);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(UGScreenW, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [NavController1 pushViewControllerWithGameModel:_dataArray[indexPath.row]];
}

- (IBAction)segmentedChanged:(id)sender {
    UISegmentedControl *sc = (UISegmentedControl*)sender;
    if (sc.selectedSegmentIndex == 0) {
        NSLog(@"最近浏览");
        _dataArray = UGNavigationController.browsingHistoryArray;
        [self.myCollectionView reloadData];
    } else {
        NSLog(@"最近活动");
        _dataArray = nil;
        [self.myCollectionView reloadData];
        [self.view makeToast:@"敬请期待！" duration:1.5 position:CSToastPositionCenter];
    }
}

@end
