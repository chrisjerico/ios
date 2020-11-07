//
//  UGMessagePopView.h
//  UGBWApp
//
//  Created by fish on 2020/10/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGMessagePopView : UIView
@property (strong, nonatomic)  NSString *content;
@property (nonatomic , copy ) void (^closeBlock)(void);

@end

NS_ASSUME_NONNULL_END
