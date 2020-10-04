

//
//  UGMissionCollectionView.m
//  ug
//
//  Created by ug on 2019/5/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMissionCollectionView.h"
#import "UGMissionListController.h"
#import "UGIntegralConvertController.h"
#import "UGIntegralConvertRecordController.h"
#import "UGMissionLevelController.h"
#import "UGMissionMainViewController.h"
@interface UGMissionCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <UIViewController *> *viewConterllers;

@end

static NSString *missionCellid = @"missionCellid";
@implementation UGMissionCollectionView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        
            UGMissionMainViewController *missionListVC = [[UGMissionMainViewController alloc] init];
        
            UIStoryboard *storyboard0 = [UIStoryboard storyboardWithName:@"UGIntegralConvertController" bundle:nil];
            UGIntegralConvertController *convertVC = [storyboard0 instantiateInitialViewController];
        
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGIntegralConvertRecordController" bundle:nil];
            UGIntegralConvertRecordController *recordVC = [storyboard instantiateInitialViewController];
        
            UGMissionLevelController *levelVC = [[UGMissionLevelController alloc] initWithStyle:UITableViewStyleGrouped];
        
        self.viewConterllers = @[missionListVC,convertVC,recordVC,levelVC];
        [self initCollectionView];
        
        if (Skin1.isBlack) {
            [self setBackgroundColor: [UIColor clearColor]];
        }
        else {
            [self setBackgroundColor: [UIColor whiteColor]];
        }

        
    }
    return self;
    
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    CGFloat x = APP.Width * selectIndex;
    BOOL animated = fabs(_collectionView.contentOffset.x - x) <= APP.Width;
    [_collectionView setContentOffset:CGPointMake(x, 0) animated:animated];
}

- (void)initCollectionView {
    
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(UGScreenW, UGScerrnH);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout;
        
    });
    
    UICollectionView *collectionView = ({
        
        collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:missionCellid];
        
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView;
        
    });
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.viewConterllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:missionCellid forIndexPath:indexPath];
    // 移除之前子控制器View
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *vc = self.viewConterllers[indexPath.row];
    if ([CMCommon isPhoneX]) {
        
        vc.view.frame = CGRectMake(0, 128, UGScreenW, UGScerrnH - 370);
    }else {
        vc.view.frame = CGRectMake(0, 128, UGScreenW, UGScerrnH - 320);
    }
    // 往contentView添加子控件
    [cell.contentView addSubview:vc.view];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    NSInteger row = x / UGScreenW;
    if (self.selectIndexBlock) {
        self.selectIndexBlock(row);
    }
}



@end
