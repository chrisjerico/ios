//
//  UGLotterySelectController.m
//  ug
//
//  Created by xionghx on 2019/10/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotterySelectController.h"
#import "UGhomeRecommendCollectionViewCell.h"
@interface UGLotterySelectController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation UGLotterySelectController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview:self.collectionView];
	[self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
    // Do any additional setup after loading the view.
}

- (UICollectionView *)collectionView {
	if (!_collectionView) {
		
		float itemW = (UGScreenW - 15) / 2;

		

		UICollectionViewFlowLayout *layout = ({
		
			layout = [[UICollectionViewFlowLayout alloc] init];
			layout.itemSize = CGSizeMake(itemW, itemW / 2);
			layout.minimumInteritemSpacing = 5;
			layout.minimumLineSpacing = 5;
			layout.scrollDirection = UICollectionViewScrollDirectionVertical;
			layout.headerReferenceSize = CGSizeMake(UGScreenW, 10);
			layout;
		
		});
		
		UICollectionView *collectionView = ({
			float collectionViewH;
		
			collectionViewH = UGScerrnH - k_Height_NavBar -k_Height_StatusBar+20;
		
			collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 10, UGScreenW - 10, collectionViewH) collectionViewLayout:layout];
			collectionView.backgroundColor = [UIColor clearColor];
			collectionView.layer.cornerRadius = 10;
			collectionView.layer.masksToBounds = YES;
			collectionView.dataSource = self;
			collectionView.delegate = self;
			[collectionView registerNib:[UINib nibWithNibName:@"UGhomeRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGhomeRecommendCollectionViewCell"];
			[collectionView setShowsHorizontalScrollIndicator:NO];
			collectionView;
		
		});
		_collectionView = collectionView;
	}
	return _collectionView;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath { 
	UGhomeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGhomeRecommendCollectionViewCell" forIndexPath:indexPath];
	  UGYYPlatformGames *model = self.dataArray[indexPath.row];
	  cell.item = model;
	  
	  [cell setBackgroundColor: [[UGSkinManagers shareInstance] sethomeContentColor]];
	   cell.layer.borderColor = [[[UGSkinManagers shareInstance] sethomeContentColor] CGColor];
	  
	  return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
	return self.dataArray.count;
}


@end
