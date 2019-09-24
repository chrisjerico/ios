//
//  UGGamePlateformCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGGameSubCollectionView.h"

NS_ASSUME_NONNULL_BEGIN
@class UGPlatformModel;
typedef void(^GameTypeSelectBlock)(NSInteger index);
@interface UGGamePlatformCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) GameTypeSelectBlock gameTypeSelectBlock;

@property (nonatomic, strong) NSArray *dataArray;

@end


//
//@interface CollectionFooter : UICollectionReusableView
//
//@property (nonatomic, strong) UGGameSubCollectionView * gameSubCollectionView;
//@property(nonatomic, strong)NSArray<GameSubModel*> *sourceData;
//
//
//
//@end
NS_ASSUME_NONNULL_END
