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
#import "UGPlatformCollectionView.h"


@interface UGGameTypeCollectionView ()

@property (nonatomic, strong) UGPlatformTitleCollectionView *titleView;
@property (nonatomic, strong) UGPlatformCollectionView * collectionView;
@end

static NSString *platformCellid = @"UGGamePlatformCollectionViewCell";
@implementation UGGameTypeCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleView];
		[self addSubview:self.collectionView];

        WeakSelf
        self.titleView.platformTitleSelectBlock = ^(NSInteger selectIndex) {
			weakSelf.selectIndex = selectIndex;
            if (weakSelf.platformSelectBlock) {
                weakSelf.platformSelectBlock(selectIndex);
            }
        };
		self.collectionView.gameItemSelectBlock = ^(GameModel * model) {
			weakSelf.gameItemSelectBlock(model);
		};
    }
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self addSubview:self.titleView];
	[self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.equalTo(self);
		make.height.equalTo(@80);
	}];
	[self addSubview:self.collectionView];
	[self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.equalTo(self);
		make.top.equalTo(self.titleView.mas_bottom);
	}];
	  WeakSelf
	  self.titleView.platformTitleSelectBlock = ^(NSInteger selectIndex) {
		  weakSelf.selectIndex = selectIndex;
		  if (weakSelf.platformSelectBlock) {
			  weakSelf.platformSelectBlock(selectIndex);
		  }
	  };
	  self.collectionView.gameItemSelectBlock = ^(GameModel * model) {
		  weakSelf.gameItemSelectBlock(model);
	  };
}

- (void)setSelectIndex:(NSInteger)selectIndex {
	_selectIndex = selectIndex;
	
	self.collectionView.dataArray =  self.gameTypeArray[selectIndex].list;
    [self.collectionView reloadData];
	

}

- (void)setGameTypeArray:(NSArray *)gameTypeArray {
    _gameTypeArray = gameTypeArray;
    self.titleView.gameTypeArray = gameTypeArray;
	self.titleView.selectIndex = 0;
	self.selectIndex = 0;
    [self.collectionView reloadData];
    
}


#pragma mark - Get方法
- (UGPlatformTitleCollectionView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UGPlatformTitleCollectionView alloc] initWithFrame:CGRectZero];
        
    }
    return _titleView;
}

- (UGPlatformCollectionView *)collectionView {
	if (!_collectionView) {
		_collectionView = [[UGPlatformCollectionView alloc] initWithFrame:CGRectZero];
	}
	return  _collectionView;
}

- (CGFloat)totalHeight {
	CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
	return height + 80;
}
@end
