//
//  HomeFloatingButtonsView.h
//  UGBWApp
//
//  Created by fish on 2020/10/21.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeFloatingButtonsView : UIView

- (void)reloadData:(void (^)(BOOL succ))completion;
@end

NS_ASSUME_NONNULL_END
