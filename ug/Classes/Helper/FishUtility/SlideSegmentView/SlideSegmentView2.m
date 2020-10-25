//
//  SlideSegmentView2.m
//  MediaViewer
//
//  Created by fish on 2018/1/6.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "SlideSegmentView2.h"

@interface SlideSegmentBar2 ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSInteger numberOfItems;
@property (nonatomic) void (^didSelectItemAtIndex)(NSUInteger idx);
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *underlineView;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat space;
@end

@implementation SlideSegmentBar2

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // CollectionView
        [self addSubview:({
            UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumLineSpacing = 0;
            layout.minimumInteritemSpacing = 0;
            
            UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            [cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
            cv.backgroundColor = [UIColor whiteColor];
            cv.delegate = self;
            cv.dataSource = self;
            _collectionView = cv;
        })];
        [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // 导航条下滑线
        UIView *line = [UIView new];
        [_collectionView addSubview:({
            line.backgroundColor = APP.LineColor;
            line.tagString = @"导航条下滑线View";
            line;
        })];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        // _underlineView 标题下划线
        [_collectionView addSubview:({
            _underlineView = [UIView new];
            _underlineView.backgroundColor = APP.TextColor1;
            _underlineView.height = 2;
            _underlineView;
        })];
    }
    return self;
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
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = _titles[indexPath.item];
        label.tagString = @"label";
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell);
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





@interface SlideSegmentView2 ()<UIScrollViewDelegate>

@property (nonatomic) UIScrollView *bigScrollView;
@property (nonatomic) UIStackView *bigStackView;
@property (nonatomic) UIStackView *headerStackView;
@property (nonatomic) NSMutableArray <UIScrollView *>*scrollViews;
@end

@implementation SlideSegmentView2

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (OBJOnceToken(self)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setSelectedIndex:self.selectedIndex animated:true];
        });
    }
}

- (void)setupUI {
    _scrollViews = [NSMutableArray array];
    
    // _headerStackView
    {
        [self addSubview:({
            // 初始化临时放在self子视图，刷新后放在contentViews的子视图
            _headerStackView = [UIStackView new];
            _headerStackView.distribution = UIStackViewDistributionEqualSpacing;
            _headerStackView.axis = UILayoutConstraintAxisVertical;
            _headerStackView;
        })];
        [_headerStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(self);
        }];
        
        // _titleBar
        __weakSelf_(__self);
        [_headerStackView addArrangedSubview:({
            _titleBar = [[SlideSegmentBar2 alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
            [_titleBar setDidSelectItemAtIndex:^(NSUInteger idx) {
                [__self setSelectedIndex:idx animated:true];
            }];
            _titleBar;
        })];
        [_titleBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
        }];
    }
    
    // _bigScrollView
    {
        [self addSubview:({
            _bigScrollView = [UIScrollView new];
            _bigScrollView.pagingEnabled = true;
            _bigScrollView.showsVerticalScrollIndicator = false;
            _bigScrollView.showsHorizontalScrollIndicator = false;
            _bigStackView.clipsToBounds = false;
            _bigScrollView.delegate = self;
            _bigScrollView.bounces = false;
            _bigScrollView;
        })];
        [_bigScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // _bigStackView
        [_bigScrollView addSubview:({
            _bigStackView = [UIStackView new];
            _bigStackView.distribution = UIStackViewDistributionFillEqually;
            _bigStackView;
        })];
        [_bigStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_bigScrollView);
            make.height.equalTo(_bigScrollView);
            make.width.mas_equalTo(300);
        }];
    }
}

- (void)setupTitles:(NSArray<NSString *> *)titles contents:(NSArray *)viewsOrViewControllers {
    _titleBar.titles = titles;
    
    if ([viewsOrViewControllers.firstObject isKindOfClass:[UIView class]]) {
        _viewControllers = nil;
        _contentViews = [viewsOrViewControllers copy];
        [self reloadData];
    } else {
        _viewControllers = [viewsOrViewControllers copy];
        _contentViews = ({
            NSMutableArray *views = [NSMutableArray array];
            for (UIViewController *vc in viewsOrViewControllers) {
                [views addObject:vc.view];
            }
            [views copy];
        });
        [self reloadData];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:false];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated {
    _selectedIndex = selectedIndex;
    
    // HeaderStackView
    {
        UIScrollView *sv = _scrollViews[selectedIndex];
        sv.contentOffset = CGPointMake(0, -_headerStackView.cc_constraints.top.constant);
        [sv addSubview:_headerStackView];
        [_bigStackView bringSubviewToFront:sv];
        
        // 重设一遍约束，否则会 _headerStackView位置异常
        CGFloat top = _headerStackView.cc_constraints.top.constant;
        [_headerStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_offset(top);
            make.left.equalTo(self);
            make.width.equalTo(self);
        }];
    }
    
    // TitleBar
    [_titleBar setSelectedIndex:selectedIndex animated:animated];
    
    // BigScrollView
    {
        if (animated) {
            _bigScrollView.userInteractionEnabled = false;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.bigScrollView.userInteractionEnabled = true;
            });
        }
        CGFloat x = self.width * selectedIndex;
        animated &= fabs(_bigScrollView.contentOffset.x - x) <= self.width;
        [_bigScrollView setContentOffset:CGPointMake(x, 0) animated:animated];
        _bigScrollView.clipsToBounds = false;
    }
    
    if (_didSelectedIndexChange)
        _didSelectedIndexChange(self, selectedIndex);
}

- (void)reloadData {
    if (!self.superview || !_contentViews.count)
        return;
    
    [_bigStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bigScrollView);
        make.height.equalTo(_bigScrollView);
        make.width.equalTo(self).multipliedBy(_contentViews.count);
    }];
    
    // ScrollViews
    [_bigStackView removeAllSubviews];
    for (UIView *view in _contentViews) {
        UIScrollView *sv = (id)view;
        if (![view isKindOfClass:[UIScrollView class]]) {
            sv = [UIScrollView new];
            [sv addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(sv);
            }];
        } else if ([view isKindOfClass:[UITableView class]]) {
            ((UITableView *)view).tableHeaderView.backgroundColor = [UIColor clearColor];
        }
        sv.clipsToBounds = false;
        sv.showsVerticalScrollIndicator = false;
        sv.showsHorizontalScrollIndicator = false;
        [_scrollViews addObject:sv];
        [_bigStackView addArrangedSubview:sv];
        
        if (OBJOnceToken(sv)) {
            __weakSelf_(__self);
            [sv xw_addObserverBlockForKeyPath:@"contentOffset" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                [__self scrollViewDidScroll:obj];
            }];
        }
    }
    
    // HeaderView
    if (_headerView) {
        [_headerView removeFromSuperview];
        [_headerStackView insertArrangedSubview:_headerView atIndex:0];
    }
    
    // TitleBar
    _titleBar.numberOfItems = _contentViews.count;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != _scrollViews[_selectedIndex])
        return;
    
    // 更新HeaderView位置
    CGFloat h = MAX(_headerStackView.height - _titleBar.height, 0);
    if (scrollView.contentOffset.y > h) {
        _headerStackView.cc_constraints.top.constant = -h;
    } else {
        _headerStackView.cc_constraints.top.constant = -scrollView.contentOffset.y;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == _bigScrollView) {
        for (UIScrollView *sv in _scrollViews)
            if (sv != _scrollViews[_selectedIndex])
                sv.contentOffset = CGPointMake(0, -_headerStackView.cc_constraints.top.constant);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == _bigScrollView) {
        NSUInteger idx = targetContentOffset->x/self.width;
        [self setSelectedIndex:idx animated:true];
    }
}

@end
