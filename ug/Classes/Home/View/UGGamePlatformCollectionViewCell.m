//
//  UGGamePlateformCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGamePlatformCollectionViewCell.h"
#import "UGGameTypeColletionViewCell.h"
#import "UGPlatformGameModel.h"

@interface UGGamePlatformCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
	NSIndexPath * _selectedPath;
}
@property (nonatomic, strong) UICollectionView *gameCollectionView;

@property (nonatomic, strong) NSMutableArray * sectionedDataArray;


@end

static NSString *gameCellid = @"UGGameTypeColletionViewCell";
@implementation UGGamePlatformCollectionViewCell

static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor whiteColor];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.gameCollectionView convertPoint:point fromView:self];
        
        if (CGRectContainsPoint(self.gameCollectionView.bounds, newPoint)) {
            view = self.gameCollectionView;
        }
    }
    
    return view;
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
	
    [self initGameCollectionView];
    [self.gameCollectionView reloadData];
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

		return footerView;
	}
	
	return nil;
}


#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return (CGSize){100	,100};
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
	return (CGSize){UGScreenW,5};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
	if (_selectedPath && _selectedPath.section == section) {
		
		GameModel * model = self.sectionedDataArray[section][_selectedPath.item];
		
		return (CGSize){UGScreenW,((model.subType.count)/3 + 1) * 40};
	} else {
		return (CGSize){UGScreenW,0};
	}
	
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gameTypeSelectBlock) {
        self.gameTypeSelectBlock(indexPath.row);
    }
	if (!_selectedPath) {
		_selectedPath = indexPath;
	} else if (_selectedPath == indexPath ) {
		_selectedPath = nil;
	} else {
		_selectedPath = indexPath;
	}
	[collectionView reloadData];
}



- (NSMutableArray *)sectionedDataArray {
	if (!_sectionedDataArray) {
		_sectionedDataArray = [NSMutableArray array];
	}
	return  _sectionedDataArray;
}
- (void)initGameCollectionView {
    
    float itemW = (UGScreenW - 12 * 4) / 3;
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout;
    });
	
    UICollectionView *collectionView = ({
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, UGScreenW - 20, 1000) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGGameTypeColletionViewCell" bundle:nil] forCellWithReuseIdentifier:gameCellid];
		
		[collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
		[collectionView registerClass:[CollectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
		
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView;
    });
    
    self.gameCollectionView = collectionView;
    [self addSubview:collectionView];
    
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
		_gameSubCollectionView.backgroundColor = [UIColor whiteColor];
	}
	return _gameSubCollectionView;
}

-(void)setSourceData:(NSArray<GameSubModel *> *)sourceData {
	_sourceData = sourceData;
	self.gameSubCollectionView.sourceData = sourceData;
	[self.gameSubCollectionView reloadData];
}
@end
