//
//  LotteryContentCollectionVM.m
//  ug
//
//  Created by tim swift on 2020/1/19.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LotteryContentCollectionVM.h"
#import "LotteryTrendContentCell.h"

@interface LotteryContentCollectionVM()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong)NSArray * items;
@property(nonatomic, weak)UICollectionView * collectionView;
@end
@implementation LotteryContentCollectionVM

- (void)reloadDataWith: (NSString *) gameMark
            isOfficial: (BOOL) official
      completionHandel: (void(^)(void)) handel {
    
    [SVProgressHUD showWithStatus:nil];
    void (^complectionHandle)(CMResult<id>* model, NSError* err) = ^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            NSDictionary * resutltDictionary = model.data;
            NSLog(@"%@  data: %@", resutltDictionary[gameMark], model.data);
            
        }];
        if (handel) {
            handel();
        }
    };
    // jsxingyu
    if (official) {
        [CMNetwork getOfficialLotteryTrend:@{@"gameMark": gameMark} completion: complectionHandle];
    } else {
        [CMNetwork getLotteryTrend:@{@"gameMark": gameMark} completion: complectionHandle];
    }
    
    
}
- (void)bindCollection:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:@"LotteryTrendContentCell" bundle:nil] forCellWithReuseIdentifier:@"LotteryTrendContentCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    LotteryTrendContentCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LotteryTrendContentCell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

@end
