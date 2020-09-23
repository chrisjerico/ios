//
//  NewLotteryListController.m
//  UGBWApp
//
//  Created by fish on 2020/9/23.
//  Copyright © 2020 ug. All rights reserved.
//
#import "NewLotteryGameCollectionViewCell.h"
#import "NewLotteryListController.h"

@interface NewLotteryListController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *newLotteryGameCellID = @"NewLotteryGameCollectionViewCell";
@implementation NewLotteryListController


- (BOOL)允许未登录访问 { return ![@"c049,c008" containsString:APP.SiteId]; }
- (BOOL)允许游客访问 { return true; }
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
