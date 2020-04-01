//
//  UGSignInCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGSignInModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGSignInCollectionViewCell : UICollectionViewCell

@property (nonatomic) UGCheckinListModel *item;

@property (nonatomic) void(^signInBlock)(void) ;
@end

NS_ASSUME_NONNULL_END
