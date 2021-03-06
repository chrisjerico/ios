//
//  STBarButtonItem.m
//  Copyright © 2016年 ST. All rights reserved.
//

#import "STBarButtonItem.h"
#import "IBButton.h"

@interface STBarButtonItem ()
@property (nonatomic) void (^block)(void);
@end


@implementation STBarButtonItem

+ (STBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    STBarButtonItem *barButtonItem = [[STBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
}

+ (STBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [button setImage:[[UIImage imageNamed:imageName] qmui_imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    button.imgSize = CGSizeMake(0, 24);
//    [button sizeToFit];
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    STBarButtonItem *barButtonItem = [[STBarButtonItem alloc]initWithCustomView:button];
//    return barButtonItem;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
    [button setImage:[UIImage imageNamed:imageName]
            forState:UIControlStateNormal];
    [button setTitle:@""
            forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateNormal];
    [button sizeToFit];
    [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    STBarButtonItem *barButtonItem = [[STBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
}

+ (STBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName
                                         target:(id)target
                                         action:(SEL)action
                                          badge:(BOOL)badge
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:imageName]
            forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    
    //新建小红点
    UIImageView *badgeView = [[UIImageView alloc]init];
    badgeView.image = [UIImage imageNamed:@"c_dot_red"];
    badgeView.tag = 888;
    CGRect tabFrame = button.frame;
    //确定小红点的位置
    CGFloat x = ceilf(button.frame.size.width);
    CGFloat y = ceilf(- 0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 8, 8);
    [button addSubview:badgeView];
    STBarButtonItem *barButtonItem = [[STBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
}

+ (STBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName
                                          title:(NSString *)title
                                         target:(id)target
                                         action:(SEL)action
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
    [button setImage:[UIImage imageNamed:imageName]
            forState:UIControlStateNormal];
    [button setTitle:title
            forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateNormal];
    [button sizeToFit];
    [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    STBarButtonItem *barButtonItem = [[STBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
    
}

+ (STBarButtonItem *)barButtonItemLeftWithImageName:(NSString *)imageName
                                          title:(NSString *)title
                                          target:(id)target
                                          action:(SEL)action
{
    STButton *button = [[STButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
    button.titleSideType = STButtonTypeTitleLeft;
    [button setImage:[UIImage imageNamed:imageName]
            forState:UIControlStateNormal];
    [button setTitle:title
            forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button sizeToFit];
    [button addTarget:target
               action:action
    forControlEvents:UIControlEventTouchUpInside];
    STBarButtonItem *barButtonItem = [[STBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
}


// ——————————————————————————————————————————
// Block 方法

+ (STBarButtonItem *)barButtonItemWithTitle:(NSString *)title block:(void (^)(UIButton *sender))block {
    STBarButtonItem *bbt = [STBarButtonItem barButtonItemWithTitle:title target:nil action:nil];
    UIButton *btn = bbt.customView;
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:block];
    return bbt;
}
+ (STBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName block:(void (^)(UIButton *sender))block {
    STBarButtonItem *bbt = [STBarButtonItem barButtonItemWithImageName:imageName target:nil action:nil];
    UIButton *btn = bbt.customView;
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:block];
    return bbt;
}
+ (STBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName title:(NSString *)title block:(void (^)(UIButton *sender))block {
    STBarButtonItem *bbt = [STBarButtonItem barButtonItemWithImageName:imageName title:title target:nil action:nil];
    UIButton *btn = bbt.customView;
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:block];
    return bbt;
}
+ (STBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName badge:(BOOL)badge block:(void (^)(UIButton *sender))block {
    STBarButtonItem *bbt = [STBarButtonItem barButtonItemWithImageName:imageName target:nil action:nil badge:badge];
    UIButton *btn = bbt.customView;
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:block];
    return bbt;
}
+ (STBarButtonItem *)barButtonItemLeftWithImageName:(NSString *)imageName title:(NSString *)title block:(void (^)(UIButton *sender))block {
    STBarButtonItem *bbt = [STBarButtonItem barButtonItemLeftWithImageName:imageName title:title target:nil action:nil];
    UIButton *btn = bbt.customView;
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:block];
    return bbt;
}
@end
