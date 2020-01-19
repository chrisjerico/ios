//
//  LotteryTrendVC.m
//  ug
//
//  Created by xionghx on 2020/1/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LotteryTrendVC.h"
#import "LotteryTrendContentCell.h"
#import "LotteryContentCollectionVM.h"

@interface LotteryTrendVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *headCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (nonatomic, strong) LotteryContentCollectionVM * lotteryContentCollectionVM;
@end

@implementation LotteryTrendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"开奖走势";
    self.lotteryContentCollectionVM = [LotteryContentCollectionVM new];
    [self.lotteryContentCollectionVM bindCollection:self.contentCollectionView];
    [SVProgressHUD showWithStatus:nil];
    [self.lotteryContentCollectionVM reloadDataWith:@"jsxingyu" isOfficial:false completionHandel:^{
        [SVProgressHUD dismiss];
    }];
  
}

- (IBAction)refreshButtonTaped:(id)sender {
    [self.lotteryContentCollectionVM reloadDataWith:@"jsxingyu" isOfficial:false completionHandel:^{
        [SVProgressHUD dismiss];
    }];
}
- (IBAction)lotterySelectButtonTaped:(id)sender {
    [CMNetwork getOwnLotteryList:@{} completion:^(CMResult<id> *model, NSError *err) {
        if (err) {
            [SVProgressHUD showErrorWithStatus:err.localizedDescription];
        } else {

        }
    }];
}
- (IBAction)goBetButtonTaped:(id)sender {
}


@end

