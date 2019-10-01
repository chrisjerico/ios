//
//  UGMissionCollectionView.h
//  ug
//
//  Created by ug on 2019/5/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MenuSelectBlock)(NSInteger selectIndex);
@interface UGMissionCollectionView : UGView

@property (nonatomic, copy) MenuSelectBlock selectIndexBlock;
@property (nonatomic, assign) NSInteger selectIndex;
@end

NS_ASSUME_NONNULL_END
