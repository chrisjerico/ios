//
//  TKLCollectionViewCell.h
//  UGBWApp
//
//  Created by fish on 2020/11/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGpaymentModel;
NS_ASSUME_NONNULL_BEGIN

@interface TKLCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *headerImageStr;
@property (nonatomic, strong) UGpaymentModel *item;
@end

NS_ASSUME_NONNULL_END
