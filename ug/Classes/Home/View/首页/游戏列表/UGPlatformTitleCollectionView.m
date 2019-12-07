//
//  UGPlatformTitleCollectionView.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformTitleCollectionView.h"

#import "UGPlatformTitleCollectionViewCell.h"
#import "UGPlatformTitleBlackCell.h"

#import "UGPlatformGameModel.h"

@interface UGPlatformTitleCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) BOOL isBlack;
@end


@implementation UGPlatformTitleCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isBlack = Skin1.isBlack;
        UICollectionViewFlowLayout *layout = ({
            layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 0;
            layout.sectionInset = _isBlack ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, 8, 0, 8);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout;
        });
        
        UICollectionView *collectionView = ({
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 55) collectionViewLayout:layout];
            collectionView.backgroundColor = _isBlack ? Skin1.bgColor : Skin1.homeContentColor;
            collectionView.dataSource = self;
            collectionView.delegate = self;
            collectionView.layer.cornerRadius = _isBlack ? 0 : 10;
            collectionView.layer.masksToBounds = true;
            [collectionView registerNib:[UINib nibWithNibName:@"UGPlatformTitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"默认Cell"];
            [collectionView registerNib:[UINib nibWithNibName:@"UGPlatformTitleBlackCell" bundle:nil] forCellWithReuseIdentifier:@"黑色模板Cell"];
            [collectionView setShowsHorizontalScrollIndicator:NO];
            collectionView;
        });
        
        self.collectionView = collectionView;
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        // 背景
        {
            UIView *left = [UIView new];
            left.backgroundColor = _isBlack ? Skin1.bgColor : Skin1.homeContentColor;
            [self insertSubview:left atIndex:0];
            [left mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.equalTo(self);
                make.width.height.mas_equalTo(20);
            }];
            
            UIView *rifht = [UIView new];
            rifht.backgroundColor = _isBlack ? Skin1.bgColor : Skin1.homeContentColor;
            [self insertSubview:rifht atIndex:0];
            [rifht mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.equalTo(self);
                make.width.height.mas_equalTo(20);
            }];
        }
        
        __weakSelf_(__self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [__self.collectionView.collectionViewLayout invalidateLayout];
        });
        [self xw_addNotificationForName:UGNotificationWithSkinSuccess block:^(NSNotification * _Nonnull noti) {
            __self.isBlack = Skin1.isBlack;
            [__self mas_updateConstraints:^(MASConstraintMaker *make) {
                if (__self.isBlack) {
                    make.top.left.right.equalTo(self).offset(0);
                    make.height.equalTo(@140);
                } else {
                    make.top.equalTo(self);
                    make.left.equalTo(self).offset(5);
                    make.right.equalTo(self).offset(-5);
                    make.height.equalTo(@55);
                }
            }];
            __self.collectionView.layer.cornerRadius = __self.isBlack ? 0 : 10;
            [__self.collectionView.collectionViewLayout invalidateLayout];
            [__self.collectionView reloadData];
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:selectIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:ip atScrollPosition:UICollectionViewScrollPositionNone animated:true];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView selectItemAtIndexPath:ip animated:true scrollPosition:UICollectionViewScrollPositionNone];
    });
}

- (void)setGameTypeArray:(NSArray<GameCategoryModel *> *)gameTypeArray {
    _gameTypeArray = gameTypeArray;
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gameTypeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isBlack) {
        UGPlatformTitleBlackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"黑色模板Cell" forIndexPath:indexPath];
        cell.gcm = _gameTypeArray[indexPath.row];
        return cell;
    }
    UGPlatformTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"默认Cell" forIndexPath:indexPath];
    cell.item = _gameTypeArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.platformTitleSelectBlock)
        self.platformTitleSelectBlock(_selectIndex = indexPath.row);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isBlack) {
        return CGSizeMake(92, 140);
    }
    GameCategoryModel *gcm = _gameTypeArray[indexPath.row];
    CGFloat w = [gcm.name widthForFont:[UIFont systemFontOfSize:18]] + 18;
    return CGSizeMake(w, 55);
}

@end
