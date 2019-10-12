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
    BOOL isLogin = UGLoginIsAuthorized();
    if (isLogin) {
        
        if ([UGUserModel currentUser].isTest) {
                   [QDAlertView showWithTitle:@"温馨提示" message:@"请先登录您的正式账号" cancelButtonTitle:@"取消" otherButtonTitle:@"马上登录" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                       if (buttonIndex == 1) {
                           
                           NSDictionary *dict = @{@"token":[UGUserModel currentUser].sessid};
                           [CMNetwork userLogoutWithParams:dict completion:^(CMResult<id> *model, NSError *err) {
                               [CMResult processWithResult:model success:^{
                                   UGUserModel.currentUser = nil;
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       SANotificationEventPost(UGNotificationShowLoginView, nil);
                                   });
                               } failure:^(id msg) {
                                   [SVProgressHUD showErrorWithStatus:msg];
                               }];
                           }];
                           
                          
                       }
                   }];
               }else {
                   
                         [[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName:@"gameNavigationItemTaped" object: self.sourceData[indexPath.item]]];
            }

    }
    else{
        
        
        SANotificationEventPost(UGNotificationShowLoginView, nil);
    }
 
}
#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return (CGSize){(UGScreenW - 20)/4,80};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	return 0;
}


@end


@interface UGGameNavigationViewCell()
{
	YYAnimatedImageView * _iconImage;
	UILabel * _titleLabel;
     UIImageView * _hotImage;
}

@end

@implementation UGGameNavigationViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		
        
        _hotImage = [UIImageView new];
		_iconImage = [YYAnimatedImageView new];
		_titleLabel = [UILabel new];
		_titleLabel.textColor = [UIColor blackColor];
		_titleLabel.font = [UIFont systemFontOfSize:14];
		[self addSubview:_iconImage];
		[_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(5);
			make.centerX.equalTo(self);
			make.width.height.equalTo(@40);
		}];
        [self addSubview:_hotImage];
        [_hotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self->_iconImage.mas_left).offset(20);
            make.right.equalTo(self->_iconImage.mas_right);
            make.width.equalTo(@24);
            make.height.equalTo(@12);
        }];
		[self addSubview:_titleLabel];
		[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.bottom.equalTo(self).offset(-10);
		}];

		
	}
	return self;
}

-(void)setModel:(GameModel *)model {
	_model = model;
    _iconImage.yy_imageURL = [NSURL URLWithString:model.icon];
//	[_iconImage sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    NSLog(@"model.icon = %@",model.icon);
//    [_iconImage startAnimating];
	_titleLabel.text = model.name;
    if ([model.tipFlag isEqualToString:@"1"]) {
        [_hotImage setHidden:NO];
    } else {
          [_hotImage setHidden:YES];
    }
    [_hotImage setImage:[UIImage imageNamed:@"icon_remen"]];
}




@end
