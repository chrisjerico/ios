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
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, strong) void (^didSelectItemAtIndex)(NSInteger idx);
@property (nonatomic, strong) UIView *underlineView;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat space;
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

- (void)setBarHeight:(CGFloat)barHeight {
    self.cc_constraints.height.constant = _barHeight = barHeight;
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    _underlineView.backgroundColor = _underlineColor = underlineColor;
}

- (void)cellWidthAdaptiveTitleWithFontSize:(CGFloat)fontSize space:(CGFloat)space {
    _fontSize = fontSize;
    _space = space;
    if (_titles) {
        [_collectionView reloadData];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated {
    UICollectionView *cv = _collectionView;
    
    // 滚动至指定Cell
    CGFloat left = _insetVertical;
    CGFloat right = 0;
    
    for (int i=0; i<selectedIndex; i++)
        left += [self collectionView:cv layout:cv.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]].width;
    right = left + [self collectionView:cv layout:cv.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0]].width;
    
    if (left < cv.contentOffset.x) {
        [cv setContentOffset:CGPointMake(left, 0) animated:animated];
    }
    else if (right - cv.width > cv.contentOffset.x) {
        [cv setContentOffset:CGPointMake(right-cv.width, 0) animated:animated];
    }

    // 选中指定item
    [cv selectItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0] animated:animated scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)reloadData {
    [_collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, _insetVertical, 0, _insetVertical);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_widthForItemAtIndex)
        return CGSizeMake(_widthForItemAtIndex(indexPath.item), self.height);
    if (_fontSize < 1 || !_titles.count) {
        return CGSizeMake((self.width-_insetVertical*2) / _numberOfItems, self.height);
    }
    
    CGFloat titleW = [_titles[indexPath.item] widthForFont:[UIFont systemFontOfSize:_fontSize]];
    return CGSizeMake(titleW + _space + 2, self.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _numberOfItems;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *label = [cell viewWithTagString:@"label"];
    if (!label) {
        label = [UILabel new];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = _titles[indexPath.item];
        label.tagString = @"label";
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell);
        }];
    }
    
    if (_updateCellForItemAtIndex) {
        _updateCellForItemAtIndex(self, cell, label, indexPath.item, cell.selected);
    }
    
    __weakSelf_(__self);
    [cell setDidSelectedChange:^(UICollectionViewCell *cell, BOOL selected) {
        if (__self.updateCellForItemAtIndex)
            __self.updateCellForItemAtIndex(__self, cell, label, indexPath.item, selected);
        else {
            label.font = selected ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:16];
        }
        
        if (selected) {
            // 下划线动画
            [UIView animateWithDuration:0.25 animations:^{
                if (__self.underlineFrameForItemAtIndex) {
                    CGRect rect = __self.underlineFrameForItemAtIndex(cell.size, label.width, indexPath.item);
                    __self.underlineView.frame = CGRectMake(cell.left + rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
                } else {
                    __self.underlineView.frame = CGRectMake(cell.left, cell.height-2, cell.width, 2);
                }
            }];
        }
    }];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView && _didSelectItemAtIndex)
        _didSelectItemAtIndex(indexPath.item);
}

@end



// ——————————————————————
// ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
// ——————————————————————

@interface SlideSegmentView1 ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIStackView *bigStackView;
@property (nonatomic, readwrite) IBOutlet SlideSegmentBar1 *titleBar;
@property (nonatomic, readwrite) IBOutlet UIScrollView *bigScrollView;
@property (nonatomic, readwrite) NSMutableArray <UIScrollView *>*scrollViews;
@end

@implementation SlideSegmentView1

- (void)awakeFromNib {
    [super awakeFromNib];
    _bigScrollView.delegate = self;
    _bigScrollView.scrollEnabled = NO;
    _scrollViews = [NSMutableArray array];
}


#pragma mark - Public

- (void)setupTitles:(NSArray<NSString *> *)titles contents:(NSArray *)viewsOrViewControllers {
    _titleBar.titles = titles;
    
    if ([viewsOrViewControllers.firstObject isKindOfClass:[UIView class]]) {
        _viewControllers = nil;
        _contentViews = [viewsOrViewControllers copy];
        [self addContentViewsToBigStackView:_contentViews];
    } else {
        _viewControllers = [viewsOrViewControllers copy];
        _contentViews = ({
            NSMutableArray *views = [NSMutableArray array];
            for (UIViewController *vc in viewsOrViewControllers) {
                [views addObject:vc.view];
            }
            [views copy];
        });
        [self addContentViewsToBigStackView:_contentViews];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:false];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated {
    _selectedIndex = selectedIndex;
    
    // TitleBar
    [_titleBar setSelectedIndex:selectedIndex animated:animated];
    
    // BigScrollView
    {
        CGFloat x = self.width * selectedIndex;
        animated &= fabs(_bigScrollView.contentOffset.x - x) <= self.width;
        [_bigScrollView setContentOffset:CGPointMake(x, 0) animated:animated];
    }
    
    if (_didSelectedIndexChange)
        _didSelectedIndexChange(self, selectedIndex);
}


#pragma mark - Private

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat bigStackViewWidth = _scrollViews.count * self.width;
    if (_bigStackView.cc_constraints.width.constant != bigStackViewWidth) {
        _bigStackView.cc_constraints.width.constant = bigStackViewWidth;
    }
    if (OBJOnceToken(self)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setSelectedIndex:self.selectedIndex animated:true];
        });
    }
}

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
    _titleBar.didSelectItemAtIndex = ^(NSInteger idx) {
        [__self setSelectedIndex:idx animated:true];
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
