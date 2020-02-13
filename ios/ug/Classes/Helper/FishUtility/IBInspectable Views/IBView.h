//
//  IBView.h
//  IBInspectable
//
//  Created by fish on 16/6/1.
//  Copyright © 2016年 aduu. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE
@interface IBView : UIView
@property (nonatomic) IBInspectable CGFloat 圆角偏移量;
@property (nonatomic) IBInspectable CGPoint 圆角倍数;
@property (nonatomic) IBInspectable BOOL maskToBounds;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;



+ (void)refreshIBEffect:(UIView *)view;             /**<    刷新 IBInspectable 的效果 */
@end


@interface IBLabel : UILabel
@property (nonatomic) IBInspectable CGFloat 圆角偏移量;
@property (nonatomic) IBInspectable CGPoint 圆角倍数;
@property (nonatomic) IBInspectable BOOL maskToBounds;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;

@property (nonatomic) IBInspectable CGFloat kern;           /**<    字间距 */
@end


@interface IBImageView : UIImageView
@property (nonatomic) IBInspectable CGFloat 圆角偏移量;
@property (nonatomic) IBInspectable CGPoint 圆角倍数;
@property (nonatomic) IBInspectable BOOL maskToBounds;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@end


@interface IBTextView : UITextView
@property (nonatomic) IBInspectable CGFloat 圆角偏移量;
@property (nonatomic) IBInspectable CGPoint 圆角倍数;
@property (nonatomic) IBInspectable BOOL maskToBounds;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@end
