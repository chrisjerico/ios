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
@property(nonatomic, strong)UIButton * scrollRightButton;
@end

@implementation UGGameNavigationView
-(UIButton *)scrollRightButton {
    if (!_scrollRightButton) {
        _scrollRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _scrollRightButton.backgroundColor = [UIColor colorWithHex:0x4981de];
        [_scrollRightButton setImage: [[UIImage imageNamed:@"jiantouyou"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_scrollRightButton setTintColor:UIColor.whiteColor];
        [_scrollRightButton addTarget:self action:@selector(scrollRight)];
        
    }
    return _scrollRightButton;
}
- (void)scrollRight {
    
    NSInteger FrameWidth = UGScreenW - 40;
    NSInteger contentWidth = self.sourceData.count > 5 ?  self.sourceData.count * (FrameWidth/5) : FrameWidth;
    
    NSInteger oldContentOffSet_X = self.contentOffset.x;
    NSInteger distance = contentWidth - FrameWidth;
    if (distance > 0) {
        CGFloat newContenOffSet_X = (oldContentOffSet_X + (NSInteger)(distance)/_sourceData.count) % distance;
        [self setContentOffset:CGPointMake(newContenOffSet_X, 0)];
        
    }
}
- (void)setSourceData:(NSArray<GameModel *> *)sourceData {
    _sourceData = sourceData;
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        if (([SysConf.mobileTemplateCategory isEqualToString:@"9"] && [@"c190" containsString:APP.SiteId]) || [Skin1 isJY]) {
            
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
        } else {
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            
        }
        layout;
    });
    self = [super initWithFrame:frame collectionViewLayout:layout];
    //    self.alwaysBounceHorizontal=YES;
    if (self) {
        [self registerClass: [UGGameNavigationViewCell class] forCellWithReuseIdentifier:@"UGGameNavigationViewCell"];
        self.delegate = self;
        self.dataSource = self;
    }
    [self setBackgroundColor:[UIColor redColor]];
    return self;
}
- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    [self.superview addSubview: self.scrollRightButton];
    [self.scrollRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.width.equalTo(@15);
        make.height.equalTo(@40);
    }];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 15, 40) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(3,3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, 15, 40);
    maskLayer.path = maskPath.CGPath;
    _scrollRightButton.layer.mask = maskLayer;
    
    if (([SysConf.mobileTemplateCategory isEqualToString:@"9"] && [@"c190" containsString:APP.SiteId]) || [Skin1 isJY]) {
        
        [self.scrollRightButton setHidden:false];
    } else {
        [self.scrollRightButton setHidden:true];
    }
}
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    CGRect frame = CGRectMake(0, 0, UGScreenW, 100);
    [self initWithFrame:frame];
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
        
        //        [_titleLabel setBackgroundColor:[UIColor redColor]];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
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
