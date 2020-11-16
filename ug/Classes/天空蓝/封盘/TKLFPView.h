//
//  TKLFPView.h
//  UGBWApp
//
//  Created by andrew on 2020/11/16.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKLFPView : UIView
@property (nonatomic , copy ) void (^closeBlock)(void);
@end

NS_ASSUME_NONNULL_END
