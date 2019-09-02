//
//  UGPK10SubResultCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/6/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class UGGameBetModel;
@interface UGPK10SubResultCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSString *result;
@property (nonatomic, assign) BOOL win;

@end

NS_ASSUME_NONNULL_END
