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

@interface UGPlatformCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>
{
	NSIndexPath * _selectedPath;
}
@property (nonatomic, strong) UICollectionView *gameCollectionView;

@property (nonatomic, strong) NSMutableArray * sectionedDataArray;

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
		[self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
		[self registerClass:[CollectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
		self.delegate = self;
		self.dataSource = self;
		self.backgroundColor = UIColor.clearColor;
	}
	return self;
}


- (void)setDataArray:(NSArray *)dataArray {
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
	for (int i = 0; i < dataArray.count; i ++) {
		
		[tempArray addObject:dataArray[i]];

		if (((i + 1) % 3 == 0) || (i == dataArray.count - 1)) {
			[self.sectionedDataArray addObject: [tempArray mutableCopy]];
			[tempArray removeAllObjects];
		}
		
	}
	
    [self.gameCollectionView reloadData];
	[self postHeight];
	
	
	
	NSMutableArray * documentArray = [NSMutableArray array];
	for (GameModel * model in dataArray) {
		if ([model.docType isEqualToString:@"1"]) {
			[documentArray addObject:model];
		}
	}
	[DocumentTypeList setAllGames: documentArray];
	
}
- (void) postHeight {
	if (self.dataArray.count == 0) {
		return;
	}
	
	CGFloat height = 95 * self.sectionedDataArray.count;
	if (_selectedPath) {
		GameModel * model = self.sectionedDataArray[_selectedPath.section][_selectedPath.item];
		if (model.subType.count > 0) {
			height += ((model.subType.count - 1)/3 + 1) * 40;
		}
	}
	
	[[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName:@"UGPlatformCollectionViewContentHeight" object:[NSNumber numberWithFloat:height]]];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.sectionedDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return ((NSArray *)self.sectionedDataArray[section]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGGameTypeColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameCellid forIndexPath:indexPath];
    cell.item = ((NSArray *)self.sectionedDataArray[indexPath.section])[indexPath.row];
//    if (_selectedPath == indexPath) {
//        cell.backgroundColor = UIColor.blueColor;
//    }
//    cell.backgroundColor =  _selectedPath == indexPath ? [UIColor colorWithWhite:0.9 alpha:1.0] : UIColor.whiteColor;

    return cell;
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return (CGSize){UGScreenW/3 - 10,80};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	return 5.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
	return (CGSize){UGScreenW, 0};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
	if (_selectedPath && _selectedPath.section == section) {
		
		GameModel * model = self.sectionedDataArray[section][_selectedPath.item];
		
		return (CGSize){UGScreenW,((model.subType.count - 1)/3 + 1) * 40};
	} else {
		return (CGSize){UGScreenW,0};
	}
	
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gameTypeSelectBlock) {
        self.gameTypeSelectBlock(indexPath.row);
    }
	
	
	GameModel * model = self.sectionedDataArray[indexPath.section][indexPath.item];
	
	if (_selectedPath == indexPath ) {
		_selectedPath = nil;
	} else if (model.subType.count > 0 ) {
		_selectedPath = indexPath;
	} else {
		self.gameItemSelectBlock(model);
	}
	[collectionView reloadData];
	[self postHeight];

	
}



- (NSMutableArray *)sectionedDataArray {
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
