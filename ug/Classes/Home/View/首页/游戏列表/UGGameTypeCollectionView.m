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
            BOOL isGPK = Skin1.isGPK ;
            BOOL isTKL = Skin1.isTKL;
            _titleView = [[UGPlatformTitleCollectionView alloc] initWithFrame:CGRectZero];
            _titleView.backgroundColor = [UIColor clearColor];
            _titleView.platformTitleSelectBlock = ^(NSInteger selectIndex) {
             NSLog(@"selectIndex ===============%lu",(unsigned long)selectIndex);
                __self.contentScrollView.contentOffset = CGPointMake(__self.width * selectIndex, 0);
                [__self refreshHeight];
    
            };
            [self addSubview:_titleView];
            
            [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                if ([@"h005" containsString:APP.SiteId]) {
                    // 隐藏标题栏
                    make.top.left.right.equalTo(self);
                    make.height.equalTo(@0);
                }
                else if (isGPK) {
                    make.top.left.right.equalTo(self);
                    make.height.equalTo(@140);
                }
                else if (isTKL) {
                    make.top.left.right.equalTo(self);
                    make.height.equalTo(@90);
                }
				else if (self.gameTypeArray.count == 1) {
					/**
					 117167
					 "修改分类排序" 新增逻辑"当分类仅开启一个时，前台默认不显示分类标签" 【普通】
					 */
					 make.top.left.right.equalTo(self);
					 make.height.equalTo(@0);
				}
                else {
                    make.top.equalTo(self);
					if ([@"金沙主题" containsString:Skin1.skitType]) {
						make.left.equalTo([self superview]);
						make.width.mas_equalTo(UGScreenW);
						make.height.equalTo(@50);
						_titleView.backgroundColor = [UIColor colorWithHex:0xeeeeee];

					}
                    else {
						make.left.equalTo(self).offset(APP.isShowLogo ? 0 : 5);
						make.right.equalTo(self).offset(APP.isShowLogo ? 0 : -5);
						make.height.equalTo(APP.isShowLogo ? @60 : @50 );
					}
                }
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
    
    // TitleView
    _titleView.gameTypeArray = gameTypeArray;
    _titleView.selectIndex = 0;
    _contentScrollView.contentOffset = CGPointZero;
    
    
    // 清空_collectionViews
    for (UGPlatformCollectionView *pcv in _contentStackView.arrangedSubviews)
        [pcv removeFromSuperview];
    
    // 添加 UGPlatformCollectionView到_contentStackView
	NSInteger i = 0;
    for (GameCategoryModel *gcm in gameTypeArray) {
        UGPlatformCollectionView *pcv = [[UGPlatformCollectionView alloc] initWithFrame:CGRectZero];
 
        pcv.style = gcm.style;
		pcv.typeIndex = i;
		pcv.dataArray = gcm.list;
        pcv.subType = gcm.subType;
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
		i ++;
    }
}

- (void)refreshHeight {
    NSInteger idx = _titleView.selectIndex;
    UGPlatformCollectionView *pcv = _contentStackView.arrangedSubviews[idx];
    CGFloat h ;
    
    //subType  是否有2级分类

    if (Skin1.isJY||Skin1.isTKL) {
        GameCategoryModel *ob =  [self.gameTypeArray objectAtIndex:idx];
        if (ob.subType.count){
            h = pcv.contentSize.height + _titleView.height + 5 +40;
            _contentScrollView.cc_constraints.height.constant = h;
        } else {
            h = pcv.contentSize.height + _titleView.height + 5 ;
        }
         self.cc_constraints.height.constant = h;
    }
    else{
        h = pcv.contentSize.height + _titleView.height + 5;
         self.cc_constraints.height.constant = h;
    }
   NSLog(@"h ==== = %f",h);
   
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
