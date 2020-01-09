//
//  UGPlatformCollectionView.m
//  ug
//
//  Created by xionghx on 2019/9/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformCollectionView.h"
#import "UGGameTypeColletionViewCell.h"
#import "UGPlatformGameModel.h"
#import "UGDocumentVC.h"
#import "JS_HomeGameCollectionCell.h"
#import "JS_HomeGameColletionCell_1.h"



@interface UGPlatformCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>
{
	NSIndexPath * _selectedPath;
}
@property (nonatomic, strong) UICollectionView *gameCollectionView;

@property (nonatomic, strong) NSMutableArray <NSArray *> *sectionedDataArray;

@end

static NSString *gameCellid = @"UGGameTypeColletionViewCell";
@implementation UGPlatformCollectionView

static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";


- (instancetype)initWithFrame:(CGRect)frame
{
	UICollectionViewFlowLayout *layout = ({
		layout = [[UICollectionViewFlowLayout alloc] init];
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		layout;
	});
	self = [super initWithFrame:frame collectionViewLayout:layout];
	if (self) {
        [self registerNib:[UINib nibWithNibName:@"UGGameTypeColletionViewCell" bundle:nil] forCellWithReuseIdentifier:gameCellid];
        [self registerNib:[UINib nibWithNibName:@"JS_HomeGameCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"JS_HomeGameCollectionCell"];
        [self registerNib:[UINib nibWithNibName:@"JS_HomeGameColletionCell_1" bundle:nil] forCellWithReuseIdentifier:@"JS_HomeGameColletionCell_1"];


		
		[self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
		[self registerClass:[CollectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
		self.delegate = self;
		self.dataSource = self;
		if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
			self.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
		} else {
			self.backgroundColor = UIColor.clearColor;
		}
	}
	return self;
}


- (void)setDataArray:(NSArray<GameModel *> *)dataArray {
    _dataArray = dataArray;
	_selectedPath = nil;
	if (dataArray.count <= 0) {
		return;
	}
    if (self.gameCollectionView) {
        [self.gameCollectionView removeFromSuperview];
        self.gameCollectionView = nil;
    }
	[self.sectionedDataArray removeAllObjects];
	
	NSMutableArray * tempArray = [NSMutableArray array];
	if ([Skin1.skitType isEqualToString:@"金沙主题"] && self.typeIndex == 0) {
		for (int i=0; i<dataArray.count; i++) {
			[tempArray addObject:dataArray[i]];
			if (((i + 1) % 4 == 0) || (i == dataArray.count - 1)) {
				[self.sectionedDataArray addObject: [tempArray mutableCopy]];
				[tempArray removeAllObjects];
			}
		}
	} else if ([Skin1.skitType isEqualToString:@"金沙主题"] && self.typeIndex != 0) {
		for (GameModel * game in dataArray) {
			[self.sectionedDataArray addObject:@[game] ];
		}
	} else {
		for (int i=0; i<dataArray.count; i++) {
			[tempArray addObject:dataArray[i]];
			if (((i + 1) % 3 == 0) || (i == dataArray.count - 1)) {
				[self.sectionedDataArray addObject: [tempArray mutableCopy]];
				[tempArray removeAllObjects];
			}
		}
	}
	
	
    [self.gameCollectionView reloadData];
	
	NSMutableArray * documentArray = [NSMutableArray array];
	for (GameModel * model in dataArray) {
		if ([model.docType isEqualToString:@"1"]) {
			[documentArray addObject:model];
		}
	}
	[DocumentTypeList setAllGames:documentArray];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionedDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ((NSArray *)self.sectionedDataArray[section]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([Skin1.skitType isEqualToString:@"金沙主题"] && self.typeIndex == 0) {
		JS_HomeGameCollectionCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"JS_HomeGameCollectionCell" forIndexPath:indexPath];
		[cell bind:((NSArray *)self.sectionedDataArray[indexPath.section])[indexPath.row]];
		return cell;
	} else if ([Skin1.skitType isEqualToString:@"金沙主题"] && self.typeIndex != 0) {
		JS_HomeGameColletionCell_1 *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"JS_HomeGameColletionCell_1" forIndexPath:indexPath];
		[cell bind:((NSArray *)self.sectionedDataArray[indexPath.section])[indexPath.row]];
		return cell;
	} else {
		UGGameTypeColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameCellid forIndexPath:indexPath];
		 cell.item = ((NSArray *)self.sectionedDataArray[indexPath.section])[indexPath.row];
		 
		 return cell;
	}
 
}


////3.添加header&footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	
	if([kind isEqualToString:UICollectionElementKindSectionHeader])
	{
		UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
		if(headerView == nil)
		{
			headerView = [[UICollectionReusableView alloc] init];
		}
		headerView.backgroundColor = [UIColor clearColor];
		
		return headerView;
	}
	else if([kind isEqualToString:UICollectionElementKindSectionFooter])
	{
		CollectionFooter *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];

		footerView.sourceData = ((GameModel*)self.sectionedDataArray[_selectedPath.section][_selectedPath.row]).subType;

		footerView.gameItemSelectBlock = self.gameItemSelectBlock;
		return footerView;
	}
	
	return nil;
}


#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([Skin1.skitType isEqualToString:@"金沙主题"] && self.typeIndex == 0) {
		CGFloat itemW = (UGScreenW - 9)/4.0;
		return CGSizeMake(itemW, 110);
	} else if ([Skin1.skitType isEqualToString:@"金沙主题"] && self.typeIndex != 0) {
		return CGSizeMake(UGScreenW, 80);
	} else {
		return CGSizeMake(UGScreenW/3-10, 110);

	}
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
		return UIEdgeInsetsZero;
	} else {
		return UIEdgeInsetsMake(6, 5, 0, 5);

	}
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
		return 1.0;
	} else {
		return 0.f;

	}
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
		return 1.0;
	} else {
		return 0.f;

	}}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	return CGSizeMake(UGScreenW, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	if (_selectedPath && _selectedPath.section == section) {
		GameModel * model = self.sectionedDataArray[section][_selectedPath.item];
		return (CGSize){UGScreenW,((model.subType.count - 1)/3 + 1) * 40};
	} else if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
		return (CGSize){UGScreenW,1};
	} else {
		return (CGSize){UGScreenW,0};
	}
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gameTypeSelectBlock)
        self.gameTypeSelectBlock(indexPath.row);
	
	GameModel * model = self.sectionedDataArray[indexPath.section][indexPath.item];
	
	if (_selectedPath == indexPath ) {
		_selectedPath = nil;
	} else if (model.subType.count > 0 ) {
		_selectedPath = indexPath;
	} else {
		self.gameItemSelectBlock(model);
	}
	[collectionView reloadData];
}

- (NSMutableArray<NSArray *> *)sectionedDataArray {
	if (!_sectionedDataArray) {
		_sectionedDataArray = [NSMutableArray array];
	}
	return  _sectionedDataArray;
}

@end


@implementation CollectionFooter

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self addSubview:self.gameSubCollectionView];
		[self.gameSubCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
	}
	return self;
}
- (UGGameSubCollectionView *)gameSubCollectionView {
	if (!_gameSubCollectionView) {
		_gameSubCollectionView = [[UGGameSubCollectionView alloc] initWithFrame:self.bounds];
		_gameSubCollectionView.backgroundColor = [UIColor clearColor];
		WeakSelf
		_gameSubCollectionView.gameItemSelectBlock = ^(GameModel * model) {
			weakSelf.gameItemSelectBlock(model);
		};
	}
	return _gameSubCollectionView;
}

-(void)setSourceData:(NSArray<GameSubModel *> *)sourceData {
	_sourceData = sourceData;
	self.gameSubCollectionView.sourceData = sourceData;
	[self.gameSubCollectionView reloadData];
}
@end
