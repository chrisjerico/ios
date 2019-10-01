//
//  UGBackToastView.h
//  ugqp
//
//  Created by ug on 2019/8/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef  void(^BackHomeSureBlock)(void);
@interface UGBackToastView : UGView
@property (nonatomic, copy) BackHomeSureBlock backHomeBlock;
@end

NS_ASSUME_NONNULL_END
