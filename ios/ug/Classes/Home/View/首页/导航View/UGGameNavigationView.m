//
//  UGGameNavigationView.m
//  ug
//
//  Created by xionghx on 2019/10/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGameNavigationView.h"
#import "YYWebImage.h"

@interface UGGameNavigationView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation UGGameNavigationView

- (void)setSourceData:(NSArray<GameModel *> *)sourceData {
	_sourceData = sourceData;
	[self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	UICollectionViewFlowLayout *layout = ({
		layout = [[UICollectionViewFlowLayout alloc] init];
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		layout;
	});
	self = [super initWithFrame:frame collectionViewLayout:layout];
	if (self) {
		[self registerClass: [UGGameNavigationViewCell class] forCellWithReuseIdentifier:@"UGGameNavigationViewCell"];
		self.delegate = self;
		self.dataSource = self;
		self.scrollEnabled = false;
	}
	return self;
}

- (void)awakeFromNib {
	
	[super awakeFromNib];

	[self initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UGGameNavigationViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGGameNavigationViewCell" forIndexPath:indexPath];
	cell.model = self.sourceData[indexPath.item];
	return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.sourceData.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GameModel *gm = self.sourceData[indexPath.item];
    [NavController1 pushViewControllerWithGameModel:gm];
}


#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat oneLineCnt = 5;
    if (_sourceData.count%5 && !(_sourceData.count%4)) {
        oneLineCnt = 4;
    }
	return (CGSize){(UGScreenW - 40)/MIN(oneLineCnt, self.sourceData.count), 75};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(5, 0, 0, 4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

@end


@interface UGGameNavigationViewCell()
{
	YYAnimatedImageView * _iconImage;
	UILabel * _titleLabel;
    UIImageView * _hotImage;
    UILabel *_unreadLabel;
}

@end

@implementation UGGameNavigationViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        _hotImage = [UIImageView new];
		_iconImage = [YYAnimatedImageView new];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
		_titleLabel = [UILabel new];
        _titleLabel.textColor = Skin1.textColor1;
		_titleLabel.font = [UIFont systemFontOfSize:14];
		[self addSubview:_iconImage];
		[_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(5);
			make.centerX.equalTo(self);
			make.width.height.equalTo(@37);
		}];
        
//        _iconImage.layer.cornerRadius = 20;
//        _iconImage.layer.masksToBounds = YES;
        [self addSubview:_hotImage];
        _hotImage.contentMode = UIViewContentModeScaleAspectFit;
        [_hotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.width.height.mas_equalTo(27);
        }];
		[self addSubview:_titleLabel];
		[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.bottom.equalTo(self).offset(-10);
		}];
        
        UILabel *unreadCnt = _unreadLabel = [UILabel new];
        unreadCnt.textAlignment = NSTextAlignmentCenter;
        unreadCnt.font = [UIFont systemFontOfSize:12];
        unreadCnt.内边距 = CGPointMake(1, 0);
        unreadCnt.textColor = [UIColor whiteColor];
        unreadCnt.backgroundColor = [UIColor redColor];
        unreadCnt.layer.cornerRadius = 10;
        unreadCnt.layer.masksToBounds = true;
        [self addSubview:unreadCnt];
        [unreadCnt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.width.mas_greaterThanOrEqualTo(20);
            make.centerX.equalTo(self).offset(20);
            make.top.equalTo(self);
        }];
	}
	return self;
}

-(void)setModel:(GameModel *)model {
	_model = model;
    
    // 站内信未读消息数量
    _unreadLabel.hidden = !(model.seriesId==7 && model.subId==14 && UserI.unreadMsg);
    _unreadLabel.text = _NSString(@"%d", (int)UserI.unreadMsg);
    __weak_Obj_(_unreadLabel, __unreadLabel);
    [self xw_removeNotificationForName:UGNotificationGetUserInfoComplete];
    [self xw_addNotificationForName:UGNotificationGetUserInfoComplete block:^(NSNotification * _Nonnull noti) {
        __unreadLabel.hidden = !(model.seriesId==7 && model.subId==14 && UserI.unreadMsg);
        __unreadLabel.text = _NSString(@"%d", (int)UserI.unreadMsg);
    }];
    
    // 热门图标
    __weak_Obj_(_hotImage, __hotImageView);
    _hotImage.hidden = !model.tipFlag;
    [_hotImage sd_setImageWithURL:[NSURL URLWithString:model.hotIcon] placeholderImage:[UIImage imageNamed:@"icon_remen"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error)
            __hotImageView.image = [UIImage imageNamed:@"icon_remen"];
    }];
    
    [_iconImage yy_setImageWithURL:[NSURL URLWithString:model.icon] placeholder:[UIImage imageNamed:@"zwt"]];
    [_iconImage startAnimating];
    _titleLabel.text = model.name.length ? model.name : model.title;
}




@end
