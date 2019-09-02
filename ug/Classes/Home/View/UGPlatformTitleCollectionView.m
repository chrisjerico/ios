//
//  UGPlatformTitleCollectionView.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformTitleCollectionView.h"
#import "UGPlatformTitleCollectionViewCell.h"
#import "UGPlatformGameModel.h"

@interface UGPlatformTitleCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *platformTitleCellid = @"UGPlatformTitleCollectionViewCell";
@implementation UGPlatformTitleCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initGameCollectionView];
        
    }
    return self;
}

- (void)layoutSubviews {

    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];

}

- (void)setSelectIndex:(NSInteger)selectIndex {
     [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
}

- (void)setGameTypeArray:(NSArray *)gameTypeArray {
    _gameTypeArray = gameTypeArray;
    if (self.collectionView) {
        [self.collectionView removeFromSuperview];
        self.collectionView = nil;
    }
    [self initGameCollectionView];
    [self.collectionView reloadData];
}

- (void)initGameCollectionView {
    if (!self.gameTypeArray.count) {
        return;
    }
    float itemW = self.width / self.gameTypeArray.count;
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout;
        
    });
    
    UICollectionView *collectionView = ({
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, itemW) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGPlatformTitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:platformTitleCellid];
        
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView;
        
    });
    
    self.collectionView = collectionView;
    [self addSubview:collectionView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.gameTypeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UGPlatformTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:platformTitleCellid forIndexPath:indexPath];
    cell.item = self.gameTypeArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.platformTitleSelectBlock) {
        self.platformTitleSelectBlock(indexPath.row);
    }
}



@end
