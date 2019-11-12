//
//  UGBMBrowseViewController.m
//  ug
//
//  Created by ug on 2019/11/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBMBrowseViewController.h"

// ViewController
#import "UGPromoteDetailController.h"

// View
#import "UGBMHeaderView.h"
#import "UGGameTypeColletionViewCell.h"

// Model
#import "UGAllNextIssueListModel.h"
#import "UGPromoteModel.h"

@interface UGBMBrowseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
     UGBMHeaderView *headView;                /**<   导航头 */
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
    [self.view setBackgroundColor:Skin1.bgColor];
    [self creatView];

    // CollectionView
    {
        
        _myCollectionView.collectionViewLayout = ({
            UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
            layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
            layout.itemSize = CGSizeMake(UGScreenW/3-10, 110);;
            layout;
        });
        [_myCollectionView registerNib:[UINib nibWithNibName:@"UGGameTypeColletionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
//        ((UICollectionViewFlowLayout *)_myCollectionView.collectionViewLayout).itemSize = CGSizeMake(UGScreenW/3-8, 110);
        [_myCollectionView reloadData];
    }

    // TableView
    {
        __weakSelf_(__self);
        _tableView.hidden = true;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [CMNetwork getPromoteListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
                [__self.tableView.mj_header endRefreshing];
                [CMResult processWithResult:model success:^{
                    UGPromoteListModel *listModel = model.data;
                    [__self.tableView.dataArray setArray:listModel.list];
                    [__self.tableView reloadData];
                } failure:nil];
            }];
        }];
    }
    
    //    [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
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


#pragma mark UICollectionView datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGGameTypeColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [NavController1 pushViewControllerWithGameModel:_dataArray[indexPath.row]];
}

- (IBAction)segmentedChanged:(UISegmentedControl *)sender {
    _myCollectionView.hidden = sender.selectedSegmentIndex;
    _tableView.hidden = !sender.selectedSegmentIndex;
    if (!_tableView.dataArray.count) {
        [_tableView.mj_header beginRefreshing];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = Skin1.cellBgColor;
    UGPromoteModel *pm = tableView.dataArray[indexPath.row];
    FastSubViewCode(cell);
    subLabel(@"标题Label").textColor = Skin1.textColor1;
    subLabel(@"标题Label").text = pm.title;
    __weakSelf_(__self);
    [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:pm.pic] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            subImageView(@"图片ImageView").cc_constraints.height.constant = image.height/image.width * (APP.Width - 48);
            [__self.tableView beginUpdates];
            [__self.tableView endUpdates];
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPromoteModel *pm = tableView.dataArray[indexPath.row];
    BOOL ret = [NavController1 pushViewControllerWithLinkCategory:pm.linkCategory linkPosition:pm.linkPosition];
    if (!ret) {
        // 去优惠详情
        UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
        detailVC.item = pm;
        [NavController1 pushViewController:detailVC animated:YES];
    }
}

@end
