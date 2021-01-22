//
//  MultiTabbar.m
//  UGBWApp
//
//  Created by fish on 2021/1/16.
//  Copyright © 2021 ug. All rights reserved.
//

#import "MultiTabbar.h"

#import "LotteryBetAndChatVC.h"

@interface MultiTabbar ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<UGMobileMenu *> *dataArray;
@property (nonatomic, assign) NSInteger maxItemCount;
@end


@implementation MultiTabbar

- (void)awakeFromNib {
    [super awakeFromNib];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"MultiTabItem" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    _maxItemCount = 6;
    
    __weakSelf_(__self);
    void (^block1)(NSNotification *) = ^(NSNotification *noti) {
        __self.backgroundColor = Skin1.tabBarBgColor;
    };
    if (OBJOnceToken(self)) {
        [self xw_addNotificationForName:UGNotificationWithSkinSuccess block:block1];
    }
    // 刷新红点
    [self xw_addNotificationForName:@"UGRefreshTabbarBadge" block:^(NSNotification * _Nonnull noti) {
        [__self.collectionView reloadData];
    }];
    [self xw_addNotificationForName:UGNotificationLoginComplete block:^(NSNotification * _Nonnull noti) {
        [__self refreshDataArray];
    }];
    [self xw_addNotificationForName:UGNotificationUserLogout block:^(NSNotification * _Nonnull noti) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [__self refreshDataArray];
        });
    }];
    block1(nil);
}

- (void)setItems:(NSArray<UGMobileMenu *> *)items {
    _items = items;
    [self refreshDataArray];
}

- (void)refreshDataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    UGMobileMenu *mm = _dataArray[_selectedIndex];
    if (UGLoginIsAuthorized()) {
        [_dataArray setArray:_items];
    } else {
        [_dataArray setArray:[_items objectsWithValue:@"all" keyPath:@"roles"]];
    }
    [_dataArray setArray:[_dataArray subarrayWithRange:NSMakeRange(0, MIN(_dataArray.count, _maxItemCount))]];
    _selectedIndex = [_dataArray indexOfValue:mm.path keyPath:@"path"];
    [_collectionView reloadData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex willCallback:(BOOL)willCallback {
    _selectedIndex = selectedIndex;
    if (willCallback && _didClick)
        _didClick(_dataArray[selectedIndex], selectedIndex);
    
    __weakSelf_(__self);
    NSIndexPath *ip = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
    [_collectionView scrollToItemAtIndexPath:ip atScrollPosition:UICollectionViewScrollPositionNone animated:false];
    UICollectionViewCell *cell = [__self.collectionView cellForItemAtIndexPath:ip];
    ((UIButton *)[cell viewWithTagString:@"点击Button"]).selected = true;
    if (!willCallback)
        [self scrollToIndex:ip];
}

- (void)scrollToIndex:(NSIndexPath *)indexPath {
    UICollectionView *collectionView = _collectionView;
    [collectionView setContentOffset:({
        CGFloat x = 2;
        for (int i=0; i<indexPath.item; i++) {
            x += [self collectionView:collectionView layout:collectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]].width;
        }
        CGFloat w = [self collectionView:collectionView layout:collectionView.collectionViewLayout sizeForItemAtIndexPath:indexPath].width;;
        x = x - collectionView.width/2 + w/2;
        x = MAX(x, 0);
        x = MIN(x, collectionView.contentSize.width - collectionView.width);
        CGPointMake(x, 0);
    }) animated:true];
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 45;
    if (_dataArray.count < 7) {
        return CGSizeMake(APP.Width/_dataArray.count, h);
    }
    CGFloat w1 = APP.Width/6;
    return CGSizeMake(MIN(w1, 100), h);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UGMobileMenu *mm = _dataArray[indexPath.item];
    __weakSelf_(__self);
    FastSubViewCode(cell);
    // 图标
    [subImageView(@"图标ImageView") sd_setImageWithURL:[NSURL URLWithString:mm.icon_logo] placeholderImage:[[UIImage imageNamed:mm.defaultImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            subImageView(@"图标ImageView").image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    }];
    
    // 热门图标
    subImageView(@"热门ImageView").hidden = !mm.isHot;
    if (APP.isTabHot && [mm.clsName isEqualToString:[LotteryBetAndChatVC className]]) {
        [subImageView(@"热门ImageView") sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"redbag_act" withExtension:@"gif"]];
    } else {
        [subImageView(@"热门ImageView") sd_setImageWithURL:[NSURL URLWithString:mm.icon_hot] placeholderImage:[UIImage imageNamed:@"icon_remen"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error)
               [subImageView(@"热门ImageView") sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"hot_act" withExtension:@"gif"]];
        }];
    }
    // 标题
    subLabel(@"标题Label").text = mm.name;
    
    // 点击事件
    [subButton(@"点击Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"点击Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        if (__self.didClick && __self.didClick(mm, indexPath.item)) {
            sender.selected = true;
            __self.selectedIndex = indexPath.item;
            [__self scrollToIndex:indexPath];
        }
    }];
    // 选中非选中样式
    static UIButton *lastSelectedButton = nil;
    if (OBJOnceToken(cell)) {
        [subButton(@"点击Button") xw_addObserverBlockForKeyPath:@"selected" block:^(UIButton *obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            if (obj.selected && lastSelectedButton != obj) {
                lastSelectedButton.selected = false;
                lastSelectedButton = obj;
            }
            subLabel(@"标题Label").textColor = obj.selected ? Skin1.tabSelectedColor : Skin1.tabNoSelectColor;
            subImageView(@"图标ImageView").tintColor = obj.selected ? Skin1.tabSelectedColor : Skin1.tabNoSelectColor;
        }];
    }
    subButton(@"点击Button").selected = indexPath.item == _selectedIndex;
    // GPK模板才有的边框
    subButton(@"点击Button").layer.borderColor = APP.TextColor2.CGColor;
    subButton(@"点击Button").layer.borderWidth = Skin1.isGPK ? 0.7 : 0;
    
    // 红点
    subLabel(@"红点Label").hidden = !(APP.isTabMassageBadge && [@"/message,/user" containsString:mm.path] && UserI.unreadMsg);
    subLabel(@"红点Label").text = @(UserI.unreadMsg).stringValue;
    return cell;
}

@end
