//
//  PromotePopView.h
//  ug
//
//  Created by ug on 2020/2/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGPromoteModel;
NS_ASSUME_NONNULL_BEGIN

@interface PromotePopView : UIView
@property (nonatomic, strong) UGPromoteModel *item; /**<   二选一参数 */
- (void)setContent:(NSString *)content title:(NSString *)title;
- (void)show;
@end

NS_ASSUME_NONNULL_END
