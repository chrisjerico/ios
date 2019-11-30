//
//  LHJournalDetailVC.m
//  ug
//
//  Created by fish on 2019/11/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "LHJournalDetailVC.h"
#import "UGPostDetailVC.h"

#import "STBarButtonItem.h"

@interface LHJournalModel : NSObject
@property (nonatomic, copy) NSString *lhcNo;    /**<   期数 */
@property (nonatomic, copy) NSString *jid;      /**<   期数ID */
// 自定义参数
@property (nonatomic, assign) BOOL selected;
@end

@implementation LHJournalModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"jid":@"id"};
}
@end





@interface LHJournalDetailVC ()<UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;  /**<   期数列表 */
@property (nonatomic, strong) NSMutableArray <LHJournalModel *>*dataArray;  /**<   期数列表数据 */
@property (nonatomic, strong) UIView *lineView;  /**<   当前期数下划线 */
@property (nonatomic, strong) UGPostDetailVC *contentVC;
@end

@implementation LHJournalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[].mutableCopy;
    
    __weakSelf_(__self);
    // 六合图库的收藏按钮
    if (_gm.gid) {
        self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithTitle:@"收藏" block:^(UIButton *sender) {
            if (!UGLoginIsAuthorized()) {
                SANotificationEventPost(UGNotificationShowLoginView, nil);
                return;
            }
            BOOL fav = !__self.contentVC.pm.isBigFav;
            __weakSelf_(__self);
            [NetworkManager1 lhcdoc_doFavorites:__self.gm.gid type:1 favFlag:fav].successBlock = ^(id responseObject) {
                __self.contentVC.pm.isBigFav = fav;
                sender.selected = fav;
                [sender setTitle:fav ? @"取消收藏" : @"收藏" forState:UIControlStateNormal];
                sender.width = 60;
            };
        }];
        self.navigationItem.rightBarButtonItem.customView.alpha = 0;
    }
    
    // 下划线
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 48, 80, 2)];
        line.backgroundColor = Skin1.navBarBgColor;
        [_collectionView addSubview:_lineView = line];
    }
    
    // 获取期数列表
    [NetworkManager1 lhdoc_lhcNoList:_clm.cid type2:_gm.gid].completionBlock = ^(CCSessionModel *sm) {
        if (!sm.error) {
            for (NSDictionary *dict in sm.responseObject[@"data"]) {
                [__self.dataArray addObject:[LHJournalModel mj_objectWithKeyValues:dict]];
            }
            [__self.collectionView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [__self collectionView:__self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            });
        }
    };
}

- (void)reloadContentViewController:(NSInteger)idx {
    if (_dataArray.count <= idx) {
        return;
    }
    
    [_contentVC.view removeFromSuperview];
    _contentVC = _LoadVC_from_storyboard_(@"UGPostDetailVC");
    _contentVC.pm = ({
        UGLHPostModel *pm = [UGLHPostModel new];
        pm.cid = _dataArray[idx].jid;
        pm;
    });
    [self.view addSubview:_contentVC.view];
    [_contentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_collectionView.mas_bottom).offset(1);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    // 图库更新收藏状态
    __weakSelf_(__self);
    [_contentVC xw_addObserverBlockForKeyPath:@"pm" block:^(UGPostDetailVC *obj, UGLHPostModel *oldVal, UGLHPostModel *newVal) {
        UIButton *btn = __self.navigationItem.rightBarButtonItem.customView;
        btn.selected = newVal.isBigFav;
        [btn setTitle:newVal.isBigFav ? @"取消收藏" : @"收藏" forState:UIControlStateNormal];
        btn.width = 60;
        btn.alpha = 1;
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    LHJournalModel *jm = _dataArray[indexPath.item];
    UILabel *lb = [cell viewWithTagString:@"期数Label"];
    lb.text = _NSString(@"%@期", jm.lhcNo);
    lb.textColor = jm.selected ? Skin1.navBarBgColor : Skin1.textColor2;
    lb.font = jm.selected ? [UIFont boldSystemFontOfSize:20] : [UIFont systemFontOfSize:20];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (LHJournalModel *jm in _dataArray) {
        jm.selected = false;
    }
    _dataArray[indexPath.item].selected = true;
    _lineView.centerX = [collectionView cellForItemAtIndexPath:indexPath].centerX;
    [self reloadContentViewController:indexPath.item];
    [collectionView reloadData];
}

@end
