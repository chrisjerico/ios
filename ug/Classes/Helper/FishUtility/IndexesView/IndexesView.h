//
//  IndexesView.h
//  Pwd
//
//  Created by xuzejia Joe on 2019/5/9.
//  Copyright © 2019 xuzejia Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IndexesView : UIView

@property (nonatomic) void (^didSelectedIndex)(NSInteger idx, BOOL animated);

- (void)setTitles:(NSArray <NSString *>*)titles;
- (void)hideSearchIcon;     /**<    隐藏搜索图标 */
@end

NS_ASSUME_NONNULL_END
