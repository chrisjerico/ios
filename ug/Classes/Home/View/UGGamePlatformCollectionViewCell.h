//
//  UGGamePlateformCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UGPlatformModel;
typedef void(^GameTypeSelectBlock)(NSInteger index);
@interface UGGamePlatformCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) GameTypeSelectBlock gameTypeSelectBlock;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *gameTypeArray;

@end

NS_ASSUME_NONNULL_END
