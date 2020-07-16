//
//  SitesView.h
//  UGBWApp
//
//  Created by fish on 2020/6/24.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SitesView : UIView

@property (nonatomic, strong) void (^didClick)(NSString *title);

+ (SitesView *)show;
@end

NS_ASSUME_NONNULL_END
