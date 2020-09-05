//
//  UGGameSubCollectionView.m
//  ug
//
//  Created by xionghx on 2019/9/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGameSubCollectionView.h"
@interface UGGameSubCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation UGGameSubCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
	
	UICollectionViewFlowLayout *layout = ({
		layout = [[UICollectionViewFlowLayout alloc] init];
		layout.itemSize = CGSizeMake(UGScreenW/3 - 10 , 40);
		layout.minimumInteritemSpacing = 0;
		layout.minimumLineSpacing = 0;
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		layout;
	});
	self = [super initWithFrame:frame collectionViewLayout:layout];
	if (self) {
		[self registerClass: [CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
		self.delegate = self;
		self.dataSource = self;
	}
	return self;
}

- (NSInteger)numberOfSections {
	return 1;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
	CollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
	cell.model = self.sourceData[indexPath.item];
	return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.sourceData.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	GameSubModel * model = self.sourceData[indexPath.item];
	self.gameItemSelectBlock(model);
	
}
-(void)setSourceData:(NSArray<GameSubModel *> *)sourceData {
	_sourceData = sourceData;
	[self reloadData];
}
@end


@interface CollectionCell()


@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation CollectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		UIImageView *imageView = [UIImageView new];
		imageView.image = [[UIImage imageNamed:@"subgame_bg"] qmui_imageWithTintColor:Skin1.homeContentSubColor];
		if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
			imageView.image = [[UIImage imageNamed:@"subgame_bg"] qmui_imageWithTintColor:Skin1.navBarBgColor];

		}
        [self xw_addNotificationForName:UGNotificationWithSkinSuccess block:^(NSNotification * _Nonnull noti) {
            imageView.image = [[UIImage imageNamed:@"subgame_bg"] qmui_imageWithTintColor:Skin1.homeContentSubColor];
        }];
		[self addSubview:imageView];
		[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self);
			make.width.equalTo(self).with.multipliedBy(0.9);
			make.height.equalTo(self.mas_width).with.multipliedBy(14/43.6 * 0.8);
		}];
		
		[self addSubview:self.titleLabel];
		[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(imageView);
		}];
		
	}
	return self;
}

-(void)setModel:(GameSubModel *)model {
	self.titleLabel.text = model.title;
	
}
- (UILabel *)titleLabel {
	
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] init];
		_titleLabel.textColor = UIColor.whiteColor;
		_titleLabel.font = [UIFont boldSystemFontOfSize:13];
		_titleLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleLabel;
}

@end
