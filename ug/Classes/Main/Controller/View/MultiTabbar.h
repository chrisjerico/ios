//
//  MultiTabbar.h
//  UGBWApp
//
//  Created by fish on 2021/1/16.
//  Copyright © 2021 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGSystemConfigModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface MultiTabbar : UIView

@property (nonatomic, strong) NSArray <UGMobileMenu *>*items;
@property (nonatomic, readonly) NSInteger selectedIndex;

@property (nonatomic, strong) BOOL (^didClick)(UGMobileMenu *mm, NSInteger idx);

- (void)setSelectedIndex:(NSInteger)selectedIndex willCallback:(BOOL)willCallback;
@end

NS_ASSUME_NONNULL_END
