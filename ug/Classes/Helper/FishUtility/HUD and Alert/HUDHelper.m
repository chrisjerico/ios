//
//  HUDHelper.m
//  C
//
//  Created by fish on 2017/10/30.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "HUDHelper.h"

@implementation HUDHelper

#pragma mark - ViewPointers （保存HUD的弱引用指针）

+ (NSPointerArray *)viewPointers {
    NSPointerArray *obj = objc_getAssociatedObject(self, @selector(viewPointers));
    if (!obj) {
        obj = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
        objc_setAssociatedObject(self, @selector(viewPointers), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

+ (NSArray <__kindof UIView *>*)views {
    return self.viewPointers.allObjects;
}

+ (void)saveViewPointer:(UIView *)view {
    if (view && ![self.views containsObject:view])
        [self.viewPointers addPointer:(__bridge void * _Nullable)(view)];
}

+ (void)removeViewPointer:(UIView *)view {
    NSUInteger index = [self.views indexOfObject:view];
    if (view && index < self.views.count)
        [self.viewPointers removePointerAtIndex:index];
}


#pragma mark - 请先选择一个PPT开始播放

+ (void)showPlayerTips {
    NSLog(@"请先选择一个PPT开始播放");
    
    CGFloat waitSecs = 2;              // 消息展示时间
    CGFloat animationDuration = 0.5;     // 动画时间
    
    UIView *v = _LoadView_from_nib_(@"PlayerTipsView");
    v.frame = APP.Window.frame;
    [NavController1.topView addSubview:v];
    
    // 展示消息
    v.alpha = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        v.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        // 等待 waitSecs 秒
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:waitSecs];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 退出消息
                [UIView animateWithDuration:animationDuration animations:^{
                    v.alpha = 0;
                } completion:^(BOOL finished) {
                    [v removeFromSuperview];
                }];
            });
        });
    }];
}


#pragma mark - Show MsgView

+ (MsgView *)showMsg:(NSString *)msg {
    return [self showMsg:msg duration:2.0];
}

+ (MsgView *)showMsg:(NSString *)msg duration:(CGFloat)dur {
    return [self showMsg:msg duration:dur superview:nil];
}

+ (MsgView *)showMsg:(NSString *)msg duration:(CGFloat)dur superview:(UIView *)superview {
    NSLog(@"showMsg : \"%@\"", msg);
    
    CGFloat waitSecs = dur;              // 消息展示时间
    CGFloat animationDuration = 0.5;     // 动画时间
    
    MsgView *v = [MsgView msgView:msg];
    if (!superview) 
        superview = APP.Window;
    [superview addSubview:v];
    
    // 展示消息
    [UIView animateWithDuration:animationDuration animations:^{
        v.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        // 等待 waitSecs 秒
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:waitSecs];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 退出消息
                [UIView animateWithDuration:animationDuration animations:^{
                    v.alpha = 0;
                } completion:^(BOOL finished) {
                    [v removeFromSuperview];
                }];
            });
        });
    }];
    [self saveViewPointer:v];
    return v;
}

+ (void)hideMsg {
    [self removeView:[MsgView class] superview:nil tagString:nil];
}

+ (void)hideMsg:(UIView *)superview {
    [self removeView:[MsgView class] superview:superview tagString:nil];
}


#pragma mark - Show LoadingView

+ (LoadingView *)showLoadingView {
    return [self showLoadingViewWithSuperview:nil];
}

+ (LoadingView *)showLoadingViewWithSuperview:(UIView *)superview {
    if (!superview)
        superview = NavController1.topView;
    
    LoadingView *loadingView = nil;
    for (UIView *view in superview.subviews) {
        if ([view isKindOfClass:[LoadingView class]]) {
            loadingView = (id)view;
            break;
        }
    }
    if (!loadingView) {
        loadingView = _LoadView_from_nib_(@"LoadingView1");
        loadingView.frame = superview.bounds;
        loadingView.duration = 30;  // 存活30秒
        [superview addSubview:loadingView];
        [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superview);
        }];
        [self saveViewPointer:loadingView];
    }
    return loadingView;
}

+ (void)hideLoadingView {
    [self hideLoadingView:nil];
}
+ (void)hideLoadingView:(UIView *)superview {
    [self hideLoadingView:superview tagString:nil];
}
+ (void)hideLoadingView:(UIView *)superview tagString:(NSString *)tagString {
    [self removeView:[LoadingView class] superview:superview tagString:tagString];
}

#pragma mark - Remove HUD

+ (void)removeView:(nonnull Class)viewClass superview:(UIView *)superview tagString:(NSString *)tagString {
    void (^removeView)(UIView *) = ^(UIView *view) {
        [view.layer removeAllAnimations];
        [view removeFromSuperview];
        [HUDHelper removeViewPointer:view];
    };
    
    NSInteger len = self.views.count;
    while (len--) {
        UIView *v = self.views[len];
        if ([v isKindOfClass:viewClass] && (tagString==nil || [v.tagString isEqualToString:tagString])) {
            if (!superview || superview == v.superview) {
                removeView(v);
                return;
            }
        }
    }
}

@end





#pragma mark - MsgView 和 LoadingView

@implementation MsgView

+ (instancetype)msgView:(NSString *)msg {
    UIFont *font = [UIFont systemFontOfSize:15];                    //字体
    CGPoint center =  CGPointMake(APP.Width/2, APP.Height/2); //消息展示位置
    
    //Label的高宽
    CGFloat height = 20;
    CGFloat width = [msg boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil].size.width;
    if (width > _CalWidth(300)) {
        width = _CalWidth(300);
        height = [msg boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:@{NSFontAttributeName:font}
                                   context:nil].size.height;
    }
    
    //创建 MsgView
    MsgView *v = [[MsgView alloc] initWithFrame:CGRectMake(0, 0, width+20, height+20)];
    v.layer.cornerRadius = 6;
    v.layer.masksToBounds = YES;
    v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    v.center = center;
    v.alpha = 0;
    [v addSubview:({
        //创建Label
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        lb.center = CGPointMake(v.width/2, v.height/2);
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = [UIColor whiteColor];
        lb.numberOfLines = 0;
        lb.font = font;
        lb.text = msg;
        lb;
    })];
    return v;
}
@end

@interface LoadingView ()
@property (nonatomic) NSTimeInterval countdown;     /**<   倒计时 */
@property (nonatomic) BOOL hasBegunCountdown;       /**<   已经开始倒计时 */
@end

@implementation LoadingView

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconWidth = 84;
    _iconOffset = CGPointZero;
    _duration = 30;
    _icon = [UIImage imageNamed:@"loading"];
    
    // 添加旋转动画
    UIImageView *imgView = [self viewWithTagString:@"ImageView"];
    [imgView.layer addAnimation:({
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 0.95;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 999;
        rotationAnimation.removedOnCompletion = false;
        rotationAnimation;
    }) forKey:@"rotationAnimation"];
}

- (void)setIconWidth:(CGFloat)iconWidth {
    _iconWidth = iconWidth;
    [self viewWithTagString:@"ImageBgView"].zj_constraints.width.constant = iconWidth;
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    [(UIImageView *)[self viewWithTagString:@"ImageView"] setImage:icon];
}

- (void)setIconOffset:(CGPoint)iconOffset {
    _iconOffset = iconOffset;
    UIImageView *imgView = [self viewWithTagString:@"ImageBgView"];
    imgView.zj_constraints.centerX.constant = iconOffset.x;
    imgView.zj_constraints.centerY.constant = iconOffset.y;
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    _countdown = duration;
    
    if (!_hasBegunCountdown) {
        __weakSelf_(__self);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            while (__self.countdown > 0) {
                __self.countdown -= 0.25;
                [NSThread sleepForTimeInterval:0.25];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [__self.layer removeAllAnimations];
                [__self removeFromSuperview];
            });
        });
    }
    _hasBegunCountdown = true;
}

- (void)moveBelowToNavigationBar {
    self.y += 64;
    self.zj_constraints.top.constant = 64;
    self.iconOffset = CGPointMake(0, -32);
}

@end
