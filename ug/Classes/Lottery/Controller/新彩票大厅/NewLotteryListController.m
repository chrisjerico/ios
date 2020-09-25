//
//  NewLotteryListController.m
//  UGBWApp
//
//  Created by fish on 2020/9/23.
//  Copyright © 2020 ug. All rights reserved.
//

#import "NewLotteryListController.h"
#import "NewLotteryGameCollectionViewCell.h"
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
    [self.view setBackgroundColor:Skin1.bgColor];
    
    if (!self.title) {
        self.title = @"彩票大厅";
    }
    
    [self initCollectionView];
}

#pragma mark UICollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewLotteryGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:newLotteryGameCellID forIndexPath:indexPath];
    cell.item = self.list[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UGNextIssueModel *nextModel = self.list[indexPath.row];
    [NavController1 pushViewControllerWithNextIssueModel:nextModel isChatRoom:NO];
}

- (void)initCollectionView {
    
    float itemW = (APP.Width - 48) / 2;
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemW *5 / 7);
        layout.minimumInteritemSpacing = 16;
        layout.minimumLineSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout;
    });
    
    UICollectionView *collectionView = ({
        float collectionViewH = UGScerrnH - k_Height_NavBar -k_Height_StatusBar- 10;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, UGScreenW, collectionViewH) collectionViewLayout:layout];
        collectionView.backgroundColor = Skin1.bgColor;
        collectionView.layer.cornerRadius = 10;
        collectionView.layer.masksToBounds = YES;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"NewLotteryGameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:newLotteryGameCellID];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView;
    });
    
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    
    [self.collectionView  mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view.mas_top).with.offset(10);
         make.left.equalTo(self.view.mas_left);
         make.right.equalTo(self.view.mas_right);
         make.bottom.equalTo(self.view.mas_bottom).offset(-IPHONE_SAFEBOTTOMAREA_HEIGHT);
    }];
}

@end
