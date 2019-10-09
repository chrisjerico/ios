//
//  UGSegmentView.m
//  ug
//
//  Created by ug on 2019/7/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSegmentView.h"
#import "UGSegmentCollectionViewCell.h"
@interface UGSegmentView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *segmentCellId = @"UGSegmentCollectionViewCell";

@implementation UGSegmentView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = array;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGSegmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:segmentCellId forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count < 5) {
        return CGSizeMake((self.width - 5)/self.dataArray.count, self.height);
    }
    return CGSizeMake((self.width - 5)/5 + 5, self.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.segmentIndexBlock) {
        self.segmentIndexBlock(indexPath.row);
    }
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake((self.width - 5)/5 + 5, self.height);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"UGSegmentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:segmentCellId];
    }
    
    return _collectionView;
}

@end
