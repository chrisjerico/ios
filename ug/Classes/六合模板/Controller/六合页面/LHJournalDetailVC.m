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
@property (nonatomic, assign) int lhcNo;        /**<   期数名 */
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
@property (nonatomic, strong) UGPostDetailVC *contentVC;
@end

@implementation LHJournalDetailVC

- (BOOL)允许游客访问   {
    if ([self.clm.read_pri isEqualToString:@"1"]) {//0是全部  1是正式会员
        return false;
    } else {
        return true;
    }
}
- (BOOL)允许未登录访问 {
    if ([self.clm.read_pri isEqualToString:@"1"]) {
        return false;
    } else {
        return true;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[].mutableCopy;
    self.title = _clm.name;
    
    __weakSelf_(__self);
    // 六合图库的收藏按钮
    if (_gm.gid.intValue) {
        self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithTitle:@"收藏" block:^(UIButton *sender) {
            if (!UGLoginIsAuthorized()) {
                SANotificationEventPost(UGNotificationShowLoginView, nil);
                return;
            }
            BOOL fav = !__self.contentVC.pm.isBigFav;
            __weakSelf_(__self);
            [NetworkManager1 lhcdoc_doFavorites:__self.gm.gid type:1 favFlag:fav].successBlock = ^(CCSessionModel *sm, id responseObject) {
                __self.contentVC.pm.isBigFav = fav;
                sender.selected = fav;
                [sender setTitle:fav ? @"取消收藏" : @"收藏" forState:UIControlStateNormal];
                sender.width = 80;
            };
        }];
        UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
        btn.alpha = 0;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    
    // 获取期数列表
    [NetworkManager1 lhdoc_lhcNoList:_clm.cid type2:_gm.gid].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        if (!sm.error) {
            NSArray *array = sm.resObject[@"data"];
            if ([array isKindOfClass:[NSDictionary class]]) {
                __self.title = sm.resObject[@"data"][@"title"] ? : __self.title;
                array = sm.resObject[@"data"][@"list"];
            }
            for (NSDictionary *dict in array) {
                [__self.dataArray addObject:[LHJournalModel mj_objectWithKeyValues:dict]];
            }
            __self.collectionView.collectionViewLayout = ({
                UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
                layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                layout;
            });
            [__self.collectionView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSIndexPath *ip = [NSIndexPath indexPathForItem:[__self.dataArray indexOfValue:__self.pid keyPath:@"jid"] inSection:0];
                [__self collectionView:__self.collectionView didSelectItemAtIndexPath:ip];
                [__self.collectionView scrollToItemAtIndexPath:ip atScrollPosition:UICollectionViewScrollPositionNone animated:false];
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
        pm.link = _clm.link;
        pm.baoma_type = _clm.baoma_type;
        pm.read_pri = _clm.read_pri;
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
    FastSubViewCode(cell);
    LHJournalModel *jm = _dataArray[indexPath.item];
    subLabel(@"期数Label").text = _NSString(@"%03d期", jm.lhcNo);
    subLabel(@"期数Label").textColor = jm.selected ? Skin1.navBarBgColor : Skin1.textColor2;
    subLabel(@"期数Label").font = jm.selected ? [UIFont boldSystemFontOfSize:20] : [UIFont systemFontOfSize:20];
    subView(@"下滑线View").hidden = !jm.selected;
    subView(@"下滑线View").backgroundColor = Skin1.navBarBgColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (LHJournalModel *jm in _dataArray) {
        jm.selected = false;
    }
    _dataArray[indexPath.item].selected = true;
    [self reloadContentViewController:indexPath.item];
    [collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    LHJournalModel *jm = _dataArray[indexPath.item];
    return CGSizeMake([_NSString(@"%03d期", jm.lhcNo) widthForFont:[UIFont systemFontOfSize:20]] + 15, 50);
}

@end
