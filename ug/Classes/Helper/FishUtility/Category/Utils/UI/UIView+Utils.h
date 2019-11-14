//
//  UIView+Utils.h
//  FishUtility
//
//  Created by fish on 2016/12/1.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGestureRecognizer+Utils.h"

@interface CCGetConstraint : NSObject

@property (nonatomic, assign) id owner;
@property (nonatomic) NSArray<__kindof NSLayoutConstraint *>*constraints;
@property (nonatomic) NSUInteger count;

@property (nonatomic, readonly) NSLayoutConstraint *top;
@property (nonatomic, readonly) NSLayoutConstraint *left;
@property (nonatomic, readonly) NSLayoutConstraint *bottom;
@property (nonatomic, readonly) NSLayoutConstraint *right;
@property (nonatomic, readonly) NSLayoutConstraint *width;
@property (nonatomic, readonly) NSLayoutConstraint *height;
@property (nonatomic, readonly) NSLayoutConstraint *centerX;
@property (nonatomic, readonly) NSLayoutConstraint *centerY;

- (NSLayoutConstraint *)top:(id)item;
- (NSLayoutConstraint *)left:(id)item;
- (NSLayoutConstraint *)bottom:(id)item;
- (NSLayoutConstraint *)right:(id)item;
- (NSLayoutConstraint *)width:(id)item;
- (NSLayoutConstraint *)height:(id)item;
- (NSLayoutConstraint *)centerX:(id)item;
- (NSLayoutConstraint *)centerY:(id)item;
@end



@interface UIView (Utils)

@property (readonly) CCGetConstraint *cc_constraints;               /**<   获取约束 */
- (void)cc_updateConstraints:(void (^)(CCGetConstraint *gc))block;  /**<    更新约束 */

- (BOOL)existSubview:(UIView *)view;    /**<    是否存在子视图 */
- (BOOL)existSuperview:(UIView *)view;  /**<    是否存在父视图 */

- (void)removeAllConstraints;           /**<    移除所有约束 */

- (UIImage *)screenshot;                /**<    截图 */

@end







@interface UIStackView (CCUtils)

- (void)addArrangedSubviews:(NSArray <UIView *> *)views;
@end
