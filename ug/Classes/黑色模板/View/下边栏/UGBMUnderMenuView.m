//
//  UGBMUnderMenuView.m
//  ug
//
//  Created by ug on 2019/11/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBMUnderMenuView.h"
#import "UGGameTypeColletionViewCell.h"
#import "UGAllNextIssueListModel.h"

@interface UGBMUnderMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, assign) CGRect oldFrame; /**<   老的fram */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
@implementation UGBMUnderMenuView

-(instancetype)initView{
    return [self initWithFrame:CGRectMake(0 , UGScerrnH-(36)-IPHONE_SAFEBOTTOMAREA_HEIGHT, UGScreenW, 151)];
}

-(instancetype)initViewWithStatusBar{
    return [self initWithFrame:CGRectMake(0 , UGScerrnH-(36)-IPHONE_SAFEBOTTOMAREA_HEIGHT-k_Height_StatusBar, UGScreenW, 151)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGBMUnderMenuView" owner:self options:nil].firstObject;
        self.frame = frame;
        [self setOldFrame:frame];
        [self setBackgroundColor: Skin1.bgColor];
        [self initCollectionView];
         FastSubViewCode(self);
          __block BOOL isok = YES;
          __weak __typeof(self)weakSelf = self;
          [subButton(@"按钮") handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
             if (isok) {
                 [UIView animateWithDuration:0.35 animations:^{
                     weakSelf.y =   weakSelf.oldFrame.origin.y -(151-36);
//                     weakSelf.frame. = CGRectMake(0 , UGScerrnH-(151)-IPHONE_SAFEBOTTOMAREA_HEIGHT, UGScreenW, 151);
                     CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*1);
                     subImageView(@"箭头图片").transform = transform;//旋转
                 } completion:^(BOOL finished) {
                     isok = NO;
                 }];
             } else {
                 [UIView animateWithDuration:0.35 animations:^{
                      weakSelf.y =   weakSelf.oldFrame.origin.y;
                     CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*2);
                     subImageView(@"箭头图片").transform = transform;//旋转
                 } completion:^(BOOL finished) {
                     isok = YES;
                 }];
             }
          }];
    }
    return self;
    
}

- (void)initCollectionView {
    
    self.collectionView.backgroundColor = Skin1.bgColor;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"UGGameTypeColletionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGGameTypeColletionViewCell"];
    self.collectionView.contentSize = CGSizeMake(10*104, 0);
    self.collectionView.showsHorizontalScrollIndicator = NO;//显示水平滚动条->NO
    //滚动的时候快速衰弱
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGGameTypeColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGGameTypeColletionViewCell" forIndexPath:indexPath];
//    cell.item = ((NSArray *)self.sectionedDataArray[indexPath.section])[indexPath.row];
    [cell setBackgroundColor: Skin1.homeContentColor];
    return cell;
}

//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float itemW = 104;
    float itemH = 115;
    CGSize size = {itemW, itemH};
    return size;
}

//item偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{    //将要停止前的坐标
//
//    CGFloat velocityFloat = velocity.x;
//    CGFloat screenFloat = self.bounds.size.width/2;
//    CGFloat currentCenter = screenFloat-scrollView.contentOffset.x;//当前中心点偏移
//
//    CGPoint currentPoint = [self convertPoint:self.collectionView.center toView:self.collectionView];
//    NSIndexPath *idxPath = [self.collectionView indexPathForItemAtPoint:currentPoint];
//
//    CGFloat collectionWidth = self.bounds.size.width - 16 - 29;
//    CGFloat nextX = idxPath.row*collectionWidth;
//
//    if (velocityFloat > 0 || velocityFloat < 0) {
//        targetContentOffset->x = nextX;
//        targetContentOffset->y = 0;
//    }else{
//        targetContentOffset->x = targetContentOffset->x;
//        targetContentOffset->y = 0;
//    }
//}
@end
