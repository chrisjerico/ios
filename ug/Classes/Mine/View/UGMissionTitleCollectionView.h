//
//  UGMissionTitleCollectionView.h
//  ug
//
//  Created by ug on 2019/5/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MissionTitleSelectBlock)(NSInteger index,NSString *title);
@interface UGMissionTitleCollectionView : UIView
@property (nonatomic, copy) MissionTitleSelectBlock titleSelectBlock;
@property (nonatomic, assign) NSInteger selectIndex;
@end

NS_ASSUME_NONNULL_END
