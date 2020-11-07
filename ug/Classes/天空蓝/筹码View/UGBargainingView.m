//
//  UGBargainingView.m
//  UGBWApp
//
//  Created by fish on 2020/11/6.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGBargainingView.h"
#import "UGBargainingCollectionViewCell.h"
@interface UGBargainingView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray <HelpDocModel *> *dataArray;
@end
@implementation UGBargainingView

//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self = [[NSBundle mainBundle] loadNibNamed:@"UGBargainingView" owner:self options:0].firstObject;
//        self.frame = frame;
//        [self setBackgroundColor:Skin1.bgColor];
//        [self organizData];
//        [self initCollectionView];
//    }
//    return self;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    [self organizData];
    [self initCollectionView];
}

- (void)initCollectionView {
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"UGBargainingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGBargainingCollectionViewCell"];
//
//    self.collectionView.contentSize = CGSizeMake(7*46,0 );
    self.collectionView.showsHorizontalScrollIndicator = NO;//显示水平滚动条->NO
    //滚动的时候快速衰弱
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;

    ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize = CGSizeMake(44, 44);
    ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).scrollDirection = UICollectionViewScrollDirectionHorizontal;// 设置UICollectionView为横向滚动
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGBargainingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGBargainingCollectionViewCell" forIndexPath:indexPath];
    cell.item = _dataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.itemSelectBlock)
        self.itemSelectBlock(_dataArray[indexPath.row]);
    
    
}
- (void)organizData {
    _dataArray = [NSMutableArray new];
    [_dataArray addObject:[[HelpDocModel alloc] initWithBtnTitle:@"1" WebName:@"money_1"]];
    [_dataArray addObject:[[HelpDocModel alloc] initWithBtnTitle:@"10" WebName:@"money_10"]];
    [_dataArray addObject:[[HelpDocModel alloc] initWithBtnTitle:@"100" WebName:@"money_100"]];
    [_dataArray addObject:[[HelpDocModel alloc] initWithBtnTitle:@"500" WebName:@"money_500"]];
    [_dataArray addObject:[[HelpDocModel alloc] initWithBtnTitle:@"1000" WebName:@"money_1000"]];
    [_dataArray addObject:[[HelpDocModel alloc] initWithBtnTitle:@"5000" WebName:@"money_5000"]];
    [_dataArray addObject:[[HelpDocModel alloc] initWithBtnTitle:@"10000" WebName:@"money_1w"]];
    [_dataArray addObject:[[HelpDocModel alloc] initWithBtnTitle:@"50000" WebName:@"money_5w"]];
}

@end
