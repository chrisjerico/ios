//
//  UGMissionTitleCollectionView.m
//  ug
//
//  Created by ug on 2019/5/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionTitleCollectionView.h"
#import "UGMissionTitleCell.h"

@interface UGMissionTitleCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@end

static NSString *titleCellid = @"UGMissionTitleCell";
@implementation UGMissionTitleCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleArray = @[@"任务大厅",@"积分兑换",@"积分账变",@"VIP等级"];
        self.imageArray = @[@"missions.27015d78",@"integral.ffe5f6cf",@"integralChange.a5a00618",@"vipGrade.d4d2d844"];
        [self initGameCollectionView];
        
    }
    return self;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
}

- (void)initGameCollectionView {
    
    float itemW = (UGScreenW - 40) / 3;
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, 48);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 3;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout;
        
    });
    
    UICollectionView *collectionView = ({
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 0, self.width , self.height) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGMissionTitleCell" bundle:nil] forCellWithReuseIdentifier:titleCellid];

        collectionView;
        
    });
    
    self.collectionView = collectionView;
    [self addSubview:collectionView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UGMissionTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:titleCellid forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    cell.imgName = self.imageArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.titleSelectBlock) {
        self.titleSelectBlock(indexPath.row);
    }
}



@end
