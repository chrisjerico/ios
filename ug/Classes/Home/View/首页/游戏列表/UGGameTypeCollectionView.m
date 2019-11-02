//
//  UGGameTypeCollectionView.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGameTypeCollectionView.h"
#import "UGPlatformTitleCollectionView.h"
#import "UGPlatformCollectionView.h"


@interface UGGameTypeCollectionView ()<UIScrollViewDelegate>

@property (nonatomic) UGPlatformTitleCollectionView *titleView;
@property (nonatomic) UIScrollView *contentScrollView;
@property (nonatomic) UIStackView *contentStackView;
@end

static NSString *platformCellid = @"UGGamePlatformCollectionViewCell";


@implementation UGGameTypeCollectionView

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)setGameTypeArray:(NSArray<GameCategoryModel *> *)gameTypeArray {
    _gameTypeArray = gameTypeArray;
    
    // 初始化
    __weakSelf_(__self);
    if (OBJOnceToken(self)) {
        // _titleView
        {
            _titleView = [[UGPlatformTitleCollectionView alloc] initWithFrame:CGRectZero];
            _titleView.platformTitleSelectBlock = ^(NSInteger selectIndex) {
                __self.contentScrollView.contentOffset = CGPointMake(__self.width * selectIndex, 0);
                [__self refreshHeight];
            };
            [self addSubview:_titleView];
            [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.equalTo(@80);
            }];
        }
        
        // _contentStackView
        {
            _contentScrollView = [UIScrollView new];
            _contentScrollView.delegate = self;
            _contentScrollView.pagingEnabled = true;
            _contentScrollView.showsVerticalScrollIndicator = false;
            _contentScrollView.showsHorizontalScrollIndicator = false;
            [self addSubview:_contentScrollView];
            [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.top.equalTo(_titleView.mas_bottom);
            }];
            
            _contentStackView = [UIStackView new];
            [_contentScrollView addSubview:_contentStackView];
            [_contentStackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo(_contentScrollView);
                make.centerY.equalTo(_contentScrollView);
            }];
        }
    }
    
    [_titleView setBackgroundColor: Skin1.homeContentColor];
    
    // TitleView
    _titleView.gameTypeArray = gameTypeArray;
    _titleView.selectIndex = 0;
    _contentScrollView.contentOffset = CGPointZero;
    
    // 清空_collectionViews
    for (UGPlatformCollectionView *pcv in _contentStackView.arrangedSubviews)
        [pcv removeFromSuperview];
    
    // 添加 UGPlatformCollectionView到_contentStackView
    for (GameCategoryModel *gcm in gameTypeArray) {
        UGPlatformCollectionView *pcv = [[UGPlatformCollectionView alloc] initWithFrame:CGRectZero];
        pcv.dataArray = gcm.list;
        [pcv xw_addObserverBlockForKeyPath:@"contentSize" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            [__self refreshHeight];
        }];
        pcv.gameItemSelectBlock = ^(GameModel * _Nonnull game) {
            if (__self.gameItemSelectBlock)
                __self.gameItemSelectBlock(game);
        };
        [_contentStackView addArrangedSubview:pcv];
        [pcv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
        }];
    }
}

- (void)refreshHeight {
    NSInteger idx = _titleView.selectIndex;
    UGPlatformCollectionView *pcv = _contentStackView.arrangedSubviews[idx];
    CGFloat h = pcv.contentSize.height + _titleView.height + 5;
    self.cc_constraints.height.constant = h;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == _contentScrollView) {
        NSUInteger idx = targetContentOffset->x/self.width;
        _titleView.selectIndex = idx;
        [self refreshHeight];
    }
}

@end
