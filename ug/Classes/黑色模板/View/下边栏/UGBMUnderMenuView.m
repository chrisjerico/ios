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
#import "UGCommonLotteryController.h"

@interface UGBMUnderMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, assign) CGRect oldFrame; /**<   老的fram */

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray <GameModel *> *dataArray;

@end

@implementation UGBMUnderMenuView

- (instancetype)initView {
    return [self initWithFrame:CGRectMake(0 , UGScerrnH-(36)-IPHONE_SAFEBOTTOMAREA_HEIGHT, UGScreenW, 151)];
}

- (instancetype)initViewWithStatusBar {
    return [self initWithFrame:CGRectMake(0 , UGScerrnH-(40)-IPHONE_SAFEBOTTOMAREA_HEIGHT-k_Height_StatusBar, UGScreenW, 170)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGBMUnderMenuView" owner:self options:nil].firstObject;
        self.frame = frame;
        [self setOldFrame:frame];
        [self organizData];
        [self initCollectionView];
        
        NSLog(@"%@",UGAllNextIssueListModel.lotteryGamesArray);
        FastSubViewCode(self);
        __block BOOL isok = YES;
        __weak __typeof(self)weakSelf = self;
        subImageView(@"箭头图片").transform = CGAffineTransformMakeRotation(M_PI*1);//旋转
        subButton(@"按钮").backgroundColor = Skin1.bgColor;
        [subButton(@"按钮") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            if (isok) {
                [UIView animateWithDuration:0.35 animations:^{
                    weakSelf.y = weakSelf.oldFrame.origin.y -(weakSelf.height-36);
                    subLabel(@"展开Label").text = @"收起";
                    subImageView(@"箭头图片").transform = CGAffineTransformMakeRotation(M_PI*2);//旋转
                } completion:^(BOOL finished) {
                    isok = NO;
                }];
            } else {
                [UIView animateWithDuration:0.35 animations:^{
                    weakSelf.y = weakSelf.oldFrame.origin.y;
                    subLabel(@"展开Label").text = @"展开";
                    subImageView(@"箭头图片").transform = CGAffineTransformMakeRotation(M_PI*1);//旋转
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
    self.collectionView.layer.borderWidth = 0.7;
    self.collectionView.layer.borderColor = Skin1.tabBarBgColor.CGColor;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"UGGameTypeColletionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGGameTypeColletionViewCell"];
    self.collectionView.contentSize = CGSizeMake(10*104, 0);
    self.collectionView.showsHorizontalScrollIndicator = NO;//显示水平滚动条->NO
    //滚动的时候快速衰弱
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize = CGSizeMake(120, 114);
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGGameTypeColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGGameTypeColletionViewCell" forIndexPath:indexPath];
    cell.item = _dataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [NavController1 pushViewControllerWithGameModel:_dataArray[indexPath.row]];
}

- (void)organizData {
    _dataArray = [NSMutableArray new];
    NSMutableArray <GameModel *> *temp = @[].mutableCopy;
    for (GameCategoryModel *gcm in GameCategoryDataModel.gameCategoryData.icons) {
        for (GameModel *gm in gcm.list) {
            if (gm.subType.count) {
                [temp addObjectsFromArray:gm.subType];
            } else {
                [temp addObject:gm];
            }
        }
    }
    for (int i = 0; i<10; i++) {
        GameModel *gm = temp[[CMCommon getRandomNumber:0 to:(int)(temp.count-1)]];
        if (![_dataArray containsObject:gm]) {
            [_dataArray addObject:gm];
        }
    }
//        for (int i = 0; i<temp.count; i++) {
//            GameModel *gm = temp[i];
//            NSLog(@"i = %d,mode = %@",i,gm);
//            NSLog(@"======================");
//            if (![_dataArray containsObject:gm]) {
//                [_dataArray addObject:gm];
//            }
//        }
}

@end
