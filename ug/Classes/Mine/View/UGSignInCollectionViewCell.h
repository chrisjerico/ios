//
//  UGSignInCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGCheckinListModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SignInBlock)(void);

@interface UGSignInCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSString *weekStr;
@property (nonatomic, strong) NSString *number_gold_Str;
@property (nonatomic, strong) NSString *stateStr;
@property (nonatomic, strong) NSString *stateImageStr;
@property (nonatomic, strong) NSString *bgImageStr;

@property (nonatomic, strong) UGCheckinListModel *item;

@property (nonatomic, copy) SignInBlock signInBlock;

@end

NS_ASSUME_NONNULL_END
