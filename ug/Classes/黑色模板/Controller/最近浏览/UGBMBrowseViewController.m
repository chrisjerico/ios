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
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *myDataArray;  /**<   数据源 */
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
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"会员中心";
    self.fd_prefersNavigationBarHidden = YES;
    [self.view setBackgroundColor: Skin1.bgColor];
    [self creatView];

    //初始化
    [self initCollectionView];
    [self organizData ];
    [self.myCollectionView reloadData];
}

-(void)creatView{
    //===============导航头布局=================
       headView = [[UGBMHeaderView alloc] initView];
       [self.view addSubview:headView];
       [headView mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
           make.top.equalTo(self.view.mas_top).with.offset(k_Height_StatusBar);
           make.left.equalTo(self.view.mas_left).offset(0);
           make.height.equalTo([NSNumber numberWithFloat:100]);
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
//collectionView有几个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    int sections = 1;
    return sections;
}
//每个section有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger rows = self.myDataArray.count;
    return rows;
}

//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        UGGameTypeColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGGameTypeColletionViewCell" forIndexPath:indexPath];
        UGNextIssueModel * object = [self.myDataArray objectAtIndex:indexPath.row];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:object.pic] placeholderImage:[UIImage imageNamed:@"zwt"]];
        cell.nameLabel.text = object.title;
        [cell.hotImageView setHidden:YES];
        [cell.hasSubSign setHidden:YES];
        [cell setBackgroundColor: Skin1.homeContentColor];
        return cell;
}

//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   return CGSizeMake(UGScreenW/3-8, 110);
}

//item偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(6, 5, 0, 5);
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(UGScreenW, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    UGNextIssueModel *nextModel = _myDataArray[indexPath.row];
    [NavController1 pushViewControllerWithNextIssueModel:nextModel];
}

-(void)organizData{
    _myDataArray = [NSMutableArray new];
    for (int i = 0; i< UGAllNextIssueListModel.lotteryGamesArray.count; i++) {
        UGAllNextIssueListModel *model = [UGAllNextIssueListModel.lotteryGamesArray objectAtIndex:i];
        UGNextIssueModel * object = [model.list objectAtIndex:[CMCommon getRandomNumber:0 to:(int)(model.list.count-1)]];
        [_myDataArray addObject:object];
    }

}
- (IBAction)segmentedChanged:(id)sender {
    UISegmentedControl *sc = (UISegmentedControl*)sender;
    if (sc.selectedSegmentIndex == 0) {
        NSLog(@"最近浏览");
        [self organizData ];
        [self.myCollectionView reloadData];
        
    } else {
        NSLog(@"最近活动");
        [_myDataArray removeAllObjects];
        [self.myCollectionView reloadData];
        [self.view makeToast:@"敬请期待！"
                                                  duration:1.5
                                                  position:CSToastPositionCenter];

    }
}

@end
