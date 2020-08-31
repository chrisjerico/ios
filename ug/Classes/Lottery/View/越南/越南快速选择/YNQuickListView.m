//
//  YNQuickListView.m
//  UGBWApp
//
//  Created by andrew on 2020/8/2.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNQuickListView.h"
#import "YNQuickListCollectionViewCell.h"
@interface YNQuickListView()<UICollectionViewDelegate, UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
{
}
@property (nonatomic, strong) WSLWaterFlowLayout *flow;


@end
static NSString *ID=@"YNQuickListCollectionViewCell";
@implementation YNQuickListView

- (instancetype)initWithFrame:(CGRect)frame
{
    {
        self.flow = [[WSLWaterFlowLayout alloc] init];
        self.flow.delegate = self;
        self.flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
        self = [super initWithFrame:frame collectionViewLayout:self.flow];
    }
    if (self) {
        [self registerNib:[UINib nibWithNibName:@"YNQuickListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
        self.delegate = self;
        self.dataSource = self;
        if (APP.betBgIsWhite) {
            self.backgroundColor =  [UIColor whiteColor];
        } else {
            if (APP.isLight) {
                self.backgroundColor = [Skin1.skitString containsString:@"六合"] ? [Skin1.navBarBgColor colorWithAlphaComponent:0.8] :[Skin1.bgColor colorWithAlphaComponent:0.8];
                
            }
            else{
                self.backgroundColor = [Skin1.skitString containsString:@"六合"] ? Skin1.navBarBgColor : Skin1.bgColor;
                
            }
        }
    }
    return self;
    
}

-(void)setDataArry:(NSMutableArray<UGGameBetModel *> *)dataArry{
    _dataArry = dataArry;
    [self reloadData];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArry.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YNQuickListCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    UGGameBetModel *model = [_dataArry objectAtIndex:indexPath.row];
    cell.item = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.collectIndexBlock) {
        self.collectIndexBlock(collectionView,indexPath);
    }
    
}

#pragma mark - WSLWaterFlowLayoutDelegate

//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake((self.frame.size.width-10) / 5, 40);
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(self.frame.size.width - 1, 1);
}

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {

    return 1;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {

    return 1;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {

    return UIEdgeInsetsMake(1, 1, 1, 1);
}

@end
