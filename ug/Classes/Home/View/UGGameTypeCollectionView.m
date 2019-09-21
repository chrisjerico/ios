//
//  UGGameTypeCollectionView.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGameTypeCollectionView.h"
#import "UGGamePlatformCollectionViewCell.h"
#import "UGPlatformGameModel.h"
#import "WSLWaterFlowLayout.h"
#import "UGPlatformTitleCollectionView.h"
#import "GameCategoryDataModel.h"


@interface UGGameTypeCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UGPlatformTitleCollectionView *titleView;
@end

static NSString *platformCellid = @"UGGamePlatformCollectionViewCell";
@implementation UGGameTypeCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleView];
        WeakSelf
        self.titleView.platformTitleSelectBlock = ^(NSInteger selectIndex) {
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            if (weakSelf.platformSelectBlock) {
                weakSelf.platformSelectBlock(selectIndex);
            }
        };
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.collectionView convertPoint:point fromView:self];
        
        if (CGRectContainsPoint(self.collectionView.bounds, newPoint)) {
            view = self.collectionView;
        }
    }
    
    return view;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

}

- (void)setGameTypeArray:(NSArray *)gameTypeArray {
    _gameTypeArray = gameTypeArray;
    if (self.collectionView) {
        self.titleView.selectIndex = 0;
        [self.collectionView removeFromSuperview];
        self.collectionView = nil;
    }
    self.titleView.gameTypeArray = gameTypeArray;
    [self initCollectionView];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}

#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gameTypeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGGamePlatformCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:platformCellid forIndexPath:indexPath];
    GameCategoryModel *model = self.gameTypeArray[indexPath.row];
    cell.dataArray = model.list;
    WeakSelf
    cell.gameTypeSelectBlock = ^(NSInteger index) {
        if (weakSelf.gameItemSelectBlock) {
            weakSelf.gameItemSelectBlock(model.list[index]);
        }
    };
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    NSInteger row = x / UGScreenW;
    self.titleView.selectIndex = row;
    if (self.platformSelectBlock) {
        self.platformSelectBlock(row);
    }
}

- (void)initCollectionView {
    float itemH = UGScreenW / 3;
//    NSInteger count = 0;
//    for (NSDictionary *model in self.gameTypeArray) {
//        count = model.games.count > count ? model.games.count : count;
//    }
    float collectionViewH = ((10 - 1) / 3 + 1) * itemH;
    UICollectionViewFlowLayout *layout = ({

        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.estimatedItemSize = CGSizeMake(self.width, collectionViewH);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout;

    });
    
    UICollectionView *collectionView = ({
    
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.titleView.height, self.width, collectionViewH) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        [collectionView registerNib:[UINib nibWithNibName:@"UGGamePlatformCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:platformCellid];
        
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView;
        
    });
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
}

#pragma mark - Get方法
- (UGPlatformTitleCollectionView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UGPlatformTitleCollectionView alloc] initWithFrame:CGRectMake(0, 0,UGScreenW, 80)];
        
    }
    return _titleView;
}


@end
