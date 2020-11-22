//
//  UGBargainingView.h
//  UGBWApp
//
//  Created by fish on 2020/11/6.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpDocModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGBargainingView : UIView
@property (nonatomic) void(^itemSelectBlock)(HelpDocModel *itme);
@end

NS_ASSUME_NONNULL_END
