//
//  UGPlatformTitleCollectionView.m
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformTitleCollectionView.h"

#import "UGPlatformTitleCollectionViewCell.h"
#import "UGPlatformTitleBlackCell.h"

#import "UGPlatformGameModel.h"

#define CollectionViewW (APP.Width-16)

@interface UGPlatformTitleCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>{
    float btnwight;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) BOOL isGPK;
@property (nonatomic) BOOL isTKL;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property(nonatomic, strong)UIButton * scrollRightButton;
@end


@implementation UGPlatformTitleCollectionView

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
    
    NSInteger FrameWidth = UGScreenW - 20;
    NSInteger contentWidth = self.gameTypeArray.count > 5 ? ((UGScreenW - 20)/5) * self.gameTypeArray.count :FrameWidth;
    
    NSInteger oldContentOffSet_X = self.collectionView.contentOffset.x;
    NSInteger distance = contentWidth - FrameWidth;
    if (distance > 0) {
        CGFloat newContenOffSet_X = (oldContentOffSet_X + (NSInteger)(distance)/5) % distance;
        [self.collectionView setContentOffset:CGPointMake(newContenOffSet_X, 0)];
        
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isGPK = Skin1.isGPK  ;
        _isTKL = Skin1.isTKL ;
        UICollectionViewFlowLayout *layout = ({
            layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 0;
            layout.sectionInset = _isGPK || _isTKL ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, 2, 0, 2);
			if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
				layout.sectionInset = UIEdgeInsetsZero;
			}
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout;
        });
        
        UICollectionView *collectionView = ({
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CollectionViewW, 55) collectionViewLayout:layout];
            collectionView.backgroundColor = Skin1.isGPK ? Skin1.bgColor : Skin1.homeContentColor;

			if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
				collectionView.backgroundColor = UIColor.clearColor;
			}
            if (_isTKL) {
               collectionView.backgroundColor = RGBA(246, 246, 246, 1);
            }
 
            collectionView.dataSource = self;
            collectionView.delegate = self;
            collectionView.layer.cornerRadius = (_isGPK ||_isTKL || [Skin1.skitType isEqualToString:@"金沙主题"]) ? 0 : 10;
            collectionView.layer.masksToBounds = true;
            [collectionView registerNib:[UINib nibWithNibName:@"UGPlatformTitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"默认Cell"];
            [collectionView registerNib:[UINib nibWithNibName:@"UGPlatformTitleBlackCell" bundle:nil] forCellWithReuseIdentifier:@"GPK版Cell"];
            [collectionView setShowsHorizontalScrollIndicator:NO];
            
            if (APP.isWhite) {
                 collectionView.layer.borderWidth = 1;
                 collectionView.layer.borderColor = [UIColor whiteColor].CGColor;
             }
    
           
            collectionView;
            
  
        });
        
        self.collectionView = collectionView;
        [self addSubview:collectionView];
        
        if (Skin1.isTKL) {
              [self addSubview: self.scrollRightButton];
              [self.scrollRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.centerY.equalTo(self).offset(-5);
                  make.right.equalTo(self).offset(-5);
                  make.width.equalTo(@15);
                  make.height.equalTo(@40);
              }];
              UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 15, 40) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(3,3)];
              CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
              maskLayer.frame = CGRectMake(0, 0, 15, 40);
              maskLayer.path = maskPath.CGPath;
              _scrollRightButton.layer.mask = maskLayer;
            [self.scrollRightButton setHidden:!Skin1.isTKL];
            [self bringSubviewToFront :self.scrollRightButton];
        }
        
        btnwight = 15;
        _leftBtn = ({
            UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(100, 100, btnwight, 40);
            // 按钮的正常状态
            [button setImage: [UIImage imageNamed:@"jiantouzuo"] forState:UIControlStateNormal];
            button;
        });
//        Skin1.textColor1
        _rightBtn = ({
            UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(100, 100, btnwight, 40);
            [button setImage: [UIImage imageNamed:@"jiantouyou"] forState:UIControlStateNormal];
            button;
        });
        __weakSelf_(__self);


        [self addSubview:_leftBtn];
        [self addSubview:_rightBtn];
        
        [_leftBtn setHidden:!APP.isShowArrow];
        [_rightBtn setHidden:!APP.isShowArrow];
        
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.top.equalTo(self.mas_top);
            make.width.mas_equalTo(btnwight);
            make.height.mas_equalTo(self.mas_height);
        }];
        
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.equalTo(self.mas_right).offset(-10);
             make.top.equalTo(self.mas_top);
             make.width.mas_equalTo(btnwight);
             make.height.mas_equalTo(self.mas_height);
         }];
        
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
         
            make.top.equalTo(self.mas_top);
            if (APP.isShowLogo) {
                make.width.mas_equalTo(APP.Width-20);
                make.left.equalTo(self.mas_left).offset(5);
            } else {
                make.width.mas_equalTo(APP.Width - 15);
                make.left.equalTo(self.mas_left);
            }
            make.height.mas_equalTo(self.mas_height);
        }];

		if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
			[collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.edges.equalTo(self);
			}];
		}

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [__self.collectionView.collectionViewLayout invalidateLayout];
        });
        [self xw_addNotificationForName:UGNotificationWithSkinSuccess block:^(NSNotification * _Nonnull noti) {
            __self.isGPK = Skin1.isGPK;
            [__self mas_updateConstraints:^(MASConstraintMaker *make) {
                if (__self.isGPK) {
                    make.top.left.right.offset(0);
                    make.height.equalTo(@140);
                } else {
                    make.left.offset(APP.isShowLogo ? 0 : 5);
                    make.right.offset( APP.isShowLogo ? 0 : -5);
                    make.height.equalTo(@55);
                }
            }];
             __self.collectionView.layer.cornerRadius = __self.isGPK ? 0 : 10;
            if (APP.isWhite) {
                __self.collectionView.layer.borderWidth = 1;
                __self.collectionView.layer.borderColor = [UIColor whiteColor].CGColor;
            }
            [__self.collectionView.collectionViewLayout invalidateLayout];
            [__self.collectionView reloadData];
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:selectIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:ip atScrollPosition:UICollectionViewScrollPositionNone animated:true];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView selectItemAtIndexPath:ip animated:true scrollPosition:UICollectionViewScrollPositionNone];
    });
}

- (void)setGameTypeArray:(NSArray<GameCategoryModel *> *)gameTypeArray {
    _gameTypeArray = gameTypeArray;
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gameTypeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isGPK || _isTKL) {
        UGPlatformTitleBlackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GPK版Cell" forIndexPath:indexPath];
        cell.gcm = _gameTypeArray[indexPath.row];
        return cell;
    }

    UGPlatformTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"默认Cell" forIndexPath:indexPath];
    cell.item = _gameTypeArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView setContentOffset:({
        CGFloat x = 2;
        for (int i=0; i<indexPath.item; i++) {
            x += [self collectionView:collectionView layout:collectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]].width;
        }
        CGFloat w = [self collectionView:collectionView layout:collectionView.collectionViewLayout sizeForItemAtIndexPath:indexPath].width;;
        x = x - collectionView.width/2 + w/2;
        x = MAX(x, 0);
        x = MIN(x, collectionView.contentSize.width - collectionView.width);
        CGPointMake(x, 0);
    }) animated:true];
    
    if (self.platformTitleSelectBlock)
        self.platformTitleSelectBlock(_selectIndex = indexPath.row);
}

- (CGFloat)collectionViewCellWith:(NSInteger )row{
    CGFloat space = ({
        space = 20;
        CGFloat totalW = 0;
        for (GameCategoryModel *gcm in _gameTypeArray) {
            totalW += [gcm.name widthForFont:[UIFont systemFontOfSize:18]] + space;
        }
        if (totalW < CollectionViewW-4) {
            space += (CollectionViewW-4 - totalW)/_gameTypeArray.count;
        }
        space;
    });
    GameCategoryModel *gcm = _gameTypeArray[row];
    CGFloat w = [gcm.name widthForFont:[UIFont systemFontOfSize:18]] + space;
    if (APP.isShowLogo) {
        return 92.0;
    } else {
        return w;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isGPK) {
        return CGSizeMake(92, 140);
    }
    else if (_isTKL){
        return CGSizeMake(((UGScreenW - 20)/5) , 90);
    }
    CGFloat w = 0;
    
    if (Skin1.isJY) {
        if (self.gameTypeArray.count >=7) {
            w = CollectionViewW/7;
        }
        else{
            w = CollectionViewW/self.gameTypeArray.count;
        }
    }
    else{
        w = [self collectionViewCellWith:indexPath.row];
    }
    
    return CGSizeMake(w, APP.isShowLogo ? 60 : 50);
}
//(IOS)监听scrollView是否滚动到了顶部／底部
-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollViewHeight = scrollView.frame.size.width;
    float scrollContentSizeHeight = scrollView.contentSize.width;
    float scrollOffset = scrollView.contentOffset.x;
    if(scrollOffset < [self collectionViewCellWith:0])
    {
        // 滚动到了顶部
        NSLog(@"滚动到了顶部");
       [_leftBtn setImage: nil forState:UIControlStateNormal];
    
    }
    else{
            [_leftBtn setImage: [UIImage imageNamed:@"jiantouzuo"] forState:UIControlStateNormal];

    }
    
    if(scrollOffset + scrollViewHeight >= (scrollContentSizeHeight - [self collectionViewCellWith:0]))
    {
        // 滚动到了底部
        NSLog(@"滚动到了底部");

           [_rightBtn setImage: nil forState:UIControlStateNormal];
    }
    else{

         [_rightBtn setImage: [UIImage imageNamed:@"jiantouyou"] forState:UIControlStateNormal];
    }
    
}
@end
