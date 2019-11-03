//
//  UGPlatformTitleCollectionView.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformTitleCollectionView.h"
#import "UGPlatformTitleCollectionViewCell.h"
#import "UGPlatformGameModel.h"

@interface UGPlatformTitleCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end


static NSString *platformTitleCellid = @"UGPlatformTitleCollectionViewCell";


@implementation UGPlatformTitleCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float itemW = 90, itemH = 55;
        UICollectionViewFlowLayout *layout = ({
            layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize = CGSizeMake(itemW, itemH);
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 0;
            layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout;
        });
        
        UICollectionView *collectionView = ({
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, itemH) collectionViewLayout:layout];
            collectionView.backgroundColor = Skin1.homeContentColor;
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerNib:[UINib nibWithNibName:@"UGPlatformTitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:platformTitleCellid];
            [collectionView setShowsHorizontalScrollIndicator:NO];
            collectionView;
        });
        
        self.collectionView = collectionView;
        [self addSubview:collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
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
    _collectionView.backgroundColor = Skin1.homeContentColor;
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gameTypeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGPlatformTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:platformTitleCellid forIndexPath:indexPath];
    cell.item = self.gameTypeArray[indexPath.row];
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
