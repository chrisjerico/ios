//
//  category.h
//  C
//
//  Created by fish on 2018/12/4.
//  Copyright © 2018 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// —————————— IBInspectableUtils 类别
// ——————————————————————————————————————————————————
//IB_DESIGNABLE
@interface UILabel (IBInspectableUtils)
@property (nonatomic) IBInspectable CGFloat lineSpacing1;   /**<    行间距 */
@property (nonatomic) IBInspectable CGPoint 内边距;          /**<    x=left=right，y=top=bottom */
@end

@interface UITextField (IBInspectableUtils)
@property (nonatomic) IBInspectable NSUInteger 限制长度;       /**<    最大输入文本长度限制 */
@property (nonatomic) IBInspectable BOOL 仅数字;
@property (nonatomic) IBInspectable BOOL 仅数字含小数;
@property (nonatomic) IBInspectable BOOL 仅数字加字母;
@property (nonatomic) IBInspectable BOOL 仅可见的ASCII;
@property (nonatomic) IBInspectable NSString *额外允许的字符;
@end

@interface UITextView (IBInspectableUtils)
@property (nonatomic) IBInspectable NSUInteger 限制长度;       /**<    最大输入文本长度限制 */
@property (nonatomic) IBInspectable BOOL 仅数字;
@property (nonatomic) IBInspectable BOOL 仅数字含小数;
@property (nonatomic) IBInspectable BOOL 仅数字加字母;
@property (nonatomic) IBInspectable BOOL 仅可见的ASCII;
@property (nonatomic) IBInspectable NSString *额外允许的字符;
@property (nonatomic) IBInspectable BOOL 内容紧贴边框;        /**<    边缘 */
@property (nonatomic) IBInspectable NSString *placeholder;
@end


@interface UISearchBar (IBInspectableUtils)
@property (nonatomic) IBInspectable UIColor *textColor;
@property (nonatomic) IBInspectable CGFloat fontSize;

@property (nonatomic, readonly) UITextField *textField;
@end


@interface UISegmentedControl (IBInspectableUtils)
@property (nonatomic) IBInspectable UIColor *textColor1;
@end

NS_ASSUME_NONNULL_END
