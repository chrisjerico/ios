//
//  UGRightMenuView.h
//  ug
//
//  Created by ug on 2019/5/9.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RightMenuSelectBlock)(NSInteger index);
@interface UGRightMenuView : UIView
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageNameArray;

@property (nonatomic, copy) RightMenuSelectBlock menuSelectBlock;
- (void)show;
@end

NS_ASSUME_NONNULL_END
