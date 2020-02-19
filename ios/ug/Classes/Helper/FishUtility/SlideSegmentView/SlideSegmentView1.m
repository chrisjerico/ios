//
//  SlideSegmentView1.m
//  C
//
//  Created by fish on 2018/4/13.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "SlideSegmentView1.h"


@interface SlideSegmentBar1 ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSInteger numberOfItems;
@property (nonatomic) void (^didSelectItem)(NSInteger idx);
@end

@implementation SlideSegmentBar1

- (void)awakeFromNib {
    [super awakeFromNib];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    // 导航条分割线
    UIView *line = [self viewWithTagString:@"导航条下滑线View"];
    [_collectionView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.collectionView);
        make.height.mas_equalTo(0.5);
    }];
    
    // 标题下划线
    [_collectionView addSubview:({
        _underlineView = [UIView new];
        _underlineView.backgroundColor = APP.TextColor1;
        _underlineView.height = 1.5;
        _underlineView;
    })];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_collectionView.indexPathsForSelectedItems.count) {
        CGFloat w = [self collectionView:_collectionView layout:_collectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].width;
        _underlineView.frame = CGRectMake(0, self.height-2, w, 2);
    }
}

- (void)reloadData {
    [_collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, _insetLeft, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_widthForItemAtIndex)
        return CGSizeMake(_widthForItemAtIndex(indexPath.item), self.height);
    
    return CGSizeMake(self.width / _numberOfItems, self.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _numberOfItems;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *label = [cell viewWithTagString:@"label"];
    if (!label) {
        label = [UILabel new];
        if (APP.isChatWhite && !APP.betBgIsWhite) {
            label.textColor = [UIColor whiteColor];
        }
        else{
            label.textColor = [UIColor grayColor];
        }
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.tagString = @"label";
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell);
        }];
    }
    
    if (_updateCellForItemAtIndex) {
        _updateCellForItemAtIndex(cell, label, indexPath.item);
    }
    else if (_titleForItemAtIndex) {
        label.text = _titleForItemAtIndex(indexPath.item);
        label.hidden = false;
    }
    
    __weakSelf_(__self);
    [cell setDidSelectedChange:^(UICollectionViewCell *cell, BOOL selected) {
        if (__self.didSelectItemAtIndexPath)
            __self.didSelectItemAtIndexPath(cell, label, indexPath.item,  selected);
        
        else if (selected) {
            // 下划线的默认动画
            [UIView animateWithDuration:0.25 animations:^{
                __self.underlineView.frame = CGRectMake(cell.left, cell.height-2, cell.width, 2);
            }];
        }
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_didSelectItem)
        _didSelectItem(indexPath.item);
}

@end



// ——————————————————————
// ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
// ——————————————————————

@interface SlideSegmentView1 ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIStackView *bigStackView;
@end

@implementation SlideSegmentView1

- (void)awakeFromNib {
    [super awakeFromNib];
    _bigScrollView.delegate = self;
    _bigScrollView.scrollEnabled = NO;
    _scrollViews = [NSMutableArray array];
}


#pragma mark - Public

- (void)setContentViews:(NSArray<__kindof UIView *> *)contentViews {
    _viewControllers = nil;
    _contentViews = [contentViews copy];
    [self addContentViewsToBigStackView:_contentViews];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    _viewControllers = [viewControllers copy];
    _contentViews = ({
        NSMutableArray *views = [NSMutableArray array];
        for (UIViewController *vc in viewControllers) {
            [views addObject:vc.view];
        }
        [views copy];
    });
    [self addContentViewsToBigStackView:_contentViews];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:false];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated {
    _selectedIndex = selectedIndex;
    
    // TitleBar
    {
        UICollectionView *cv = _titleBar.collectionView;
        // 滚动至指定Cell
        if (_titleBar.widthForItemAtIndex) {
            CGFloat left = 0;
            CGFloat right = 0;
            
            for (int i=0; i<selectedIndex; i++)
                left += _titleBar.widthForItemAtIndex(i);
            right = left + _titleBar.widthForItemAtIndex(selectedIndex);
            
            if (left < cv.contentOffset.x) {
                [cv setContentOffset:CGPointMake(left, 0) animated:animated];
            }
            else if (right - cv.width > cv.contentOffset.x) {
                [cv setContentOffset:CGPointMake(right-cv.width, 0) animated:animated];
            }
        }
        
        // 选中指定item
        [cv selectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] animated:animated scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    // BigScrollView
    {
        CGFloat x = self.width * selectedIndex;
        animated &= fabs(_bigScrollView.contentOffset.x - x) <= self.width;
        [_bigScrollView setContentOffset:CGPointMake(x, 0) animated:animated];
    }
    
    if (_didSelectedIndex)
        _didSelectedIndex(selectedIndex);
}


#pragma mark - Private

- (void)addContentViewsToBigStackView:(NSArray<__kindof UIView *> *)contentViews {
    
    // bigStackView
    _bigStackView.cc_constraints.width.constant = contentViews.count * self.width;
    [_bigStackView removeAllSubviews];
    for (UIView *view in contentViews) {
        UIScrollView *sv = (id)view;
        if (![view isKindOfClass:[UIScrollView class]]) {
            sv = [UIScrollView new];
            [sv addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(sv);
            }];
        }
        sv.bounces = false;
        sv.alwaysBounceVertical = true;
        sv.alwaysBounceHorizontal = false;
        [_scrollViews addObject:sv];
        [_bigStackView addArrangedSubview:sv];
    }
    
    // TitleBar
    __weakSelf_(__self);
    _titleBar.numberOfItems = contentViews.count;
    _titleBar.didSelectItem = ^(NSInteger idx) {
        [__self setSelectedIndex:idx animated:false];
    };
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == _bigScrollView) {
        NSUInteger idx = targetContentOffset->x/self.width;
        [self setSelectedIndex:idx animated:true];
    }
}

@end
