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

@property (nonatomic, strong) UICollectionView *gameCollectionView;

@end

static NSString *gameCellid = @"UGGameTypeColletionViewCell";
@implementation UGGamePlatformCollectionViewCell

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

- (void)setTitle:(NSString *)title {
    _title = title;
//    [self.gameCollectionView reloadData];
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    [self.gameCollectionView reloadData];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    if (self.gameCollectionView) {
        [self.gameCollectionView removeFromSuperview];
        self.gameCollectionView = nil;
    }
    [self initGameCollectionView];
    [self.gameCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGGameTypeColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameCellid forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gameTypeSelectBlock) {
        self.gameTypeSelectBlock(indexPath.row);

    }
    
}

- (void)initGameCollectionView {
    
    float itemW = (UGScreenW - 10 * 4) / 3;
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout;
    });
    
    float itemH = UGScreenW / 3;
    NSInteger count = 0;
    for (UGPlatformModel *model in self.gameTypeArray) {
        count = model.games.count > count ? model.games.count : count;
    }
    float collectionViewH = ((count - 1) / 3 + 1) * itemH;
    
    UICollectionView *collectionView = ({
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, UGScreenW - 20, collectionViewH) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGGameTypeColletionViewCell" bundle:nil] forCellWithReuseIdentifier:gameCellid];
        
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView;
    });
    
    self.gameCollectionView = collectionView;
    [self addSubview:collectionView];
    
}

@end
