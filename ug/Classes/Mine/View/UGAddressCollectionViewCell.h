//
//  UGAddressCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/7/13.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddressDelectBlock)(void);
NS_ASSUME_NONNULL_BEGIN
@class UGLoginAddressModel;
@interface UGAddressCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) AddressDelectBlock delBlock;
@property (nonatomic, strong) UGLoginAddressModel *item;

@end

NS_ASSUME_NONNULL_END
