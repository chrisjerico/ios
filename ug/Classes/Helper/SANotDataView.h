//
//  SANotDataView.h

#import <UIKit/UIKit.h>

@interface SANotDataView : UIControl

@property (nonatomic, assign) CGFloat offset;

+ (instancetype)viewWithImage:(UIImage*)image handler:(void(^)(void))handler;
+ (instancetype)viewWithImage:(UIImage*)image title:(NSString*)title handler:(void(^)(void))handler;;
+ (instancetype)viewWithImage:(UIImage*)image title:(NSString*)title subtitle:(NSString*)subtitle handler:(void(^)(void))handler;

- (void)show;
- (void)dismiss;

@end

@interface UIView (NotData)

@property (nonatomic, strong) SANotDataView* sa_accessoryView;

@end
