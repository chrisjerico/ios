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
@end


@implementation UGPlatformTitleCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        BOOL isBlack = [Skin1.skitType isEqualToString:@"黑色模板"];
        UICollectionViewFlowLayout *layout = ({
            layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 0;
            layout.sectionInset = isBlack ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, 15, 0, 15);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout;
        });
        
        UICollectionView *collectionView = ({
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 55) collectionViewLayout:layout];
            collectionView.backgroundColor = isBlack ? Skin1.bgColor : Skin1.homeContentColor;
            collectionView.dataSource = self;
            collectionView.delegate = self;
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
        
        __weakSelf_(__self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ((UICollectionViewFlowLayout *)__self.collectionView.collectionViewLayout).itemSize = CGSizeMake(90, __self.height);
        });
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
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
