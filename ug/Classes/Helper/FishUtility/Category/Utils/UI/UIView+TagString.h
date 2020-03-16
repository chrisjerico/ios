//
//  UIView+TagString.h
//  C
//
//  Created by fish on 2018/9/13.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>


#define FastSubViewCode(rootView)  \
__weak UIView *__tsRootView1a = rootView;   \
UIView *(^subView)(NSString *) = ^(NSString *tagString) {\
    return [__tsRootView1a viewWithTagString:tagString];\
};\
UILabel *(^subLabel)(NSString *) = (id)subView;\
UIButton *(^subButton)(NSString *) = (id)subView;\
UIImageView *(^subImageView)(NSString *) = (id)subView;\
UITextField *(^subTextField)(NSString *) = (id)subLabel;\
UITextView *(^subTextView)(NSString *) = (id)subLabel;\
subLabel(nil);subButton(nil);subImageView(nil);subTextField(nil);subTextView(nil);


@interface UIView (TagString)

@property (nonatomic, copy) IBInspectable NSString *tagString;  /**<   tag字符串 */

- (NSArray <__kindof UIView *> *)viewsWithMemberOfClass:(Class)cls;                     /**<   获取所有cls类型的子视图 */
- (__kindof UIView *)viewWithTagString:(NSString *)tagString;                           /**<    根据TagString获取子视图 */
- (__kindof UIView *)superviewWithTagString:(NSString *)tagString;                      /**<    根据TagString获取父视图 */
- (__kindof UIGestureRecognizer *)gestureRecognizerWithTagString:(NSString *)tagString; /**<    根据TagString获取手势 */
- (NSLayoutConstraint *)constraintWithIdentifier:(NSString *)identifier;                /**<    根据identifier获取约束 */

@end
