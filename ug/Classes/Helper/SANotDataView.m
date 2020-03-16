//
//  SANotDataView.m

#import "SANotDataView.h"
#import <objc/runtime.h>

@interface SANotDataView ()

@property (nonatomic, weak) UIView* contentView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UIImageView* imageView;

@property (nonatomic, strong) void(^handler)(void);

@end

@implementation SANotDataView

+ (instancetype)viewWithImage:(UIImage*)image handler:(void(^)(void))handler  {
    return [self viewWithImage:image title:nil subtitle:nil handler:handler];
}
+ (instancetype)viewWithImage:(UIImage*)image title:(NSString*)title handler:(void(^)(void))handler  {
    return [self viewWithImage:image title:title subtitle:nil handler:handler];
}
+ (instancetype)viewWithImage:(UIImage*)image title:(NSString*)title subtitle:(NSString*)subtitle handler:(void(^)(void))handler {
    SANotDataView* v = [[self alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    v.handler = handler;
    v.imageView.image = image;
    v.titleLabel.text = title;
    v.subtitleLabel.text = subtitle;
    
    [v.titleLabel sizeToFit];
    [v.subtitleLabel sizeToFit];
    
    return v;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self _init];
    return self;
}

- (void)_init {
    
//    self.backgroundColor = [UIColor opacityColorWithHex:0xf1f5f7];
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.font = [UIFont systemFontOfSize:20];
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    
    self.titleLabel.textColor = [UIColor colorWithHex:0xadb6c2];
    self.subtitleLabel.textColor = [UIColor colorWithHex:0xc3cad6];
    
    [self addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handler2)]];
}

- (void)_handler2 {
    if (self.handler != nil) {
        self.handler();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.imageView.image.size;
    CGFloat height = size.height;
    
    if (self.titleLabel.text.length != 0) {
        height += self.titleLabel.frame.size.height;
    }
    if (self.subtitleLabel.text.length != 0) {
        height += self.subtitleLabel.frame.size.height + 10;
    }
    
    CGFloat y = (self.frame.size.height - height) / 2 + self.offset;
    
    if (self.imageView != nil) {
        CGFloat x = (self.frame.size.width - size.width) / 2;
        self.imageView.frame = CGRectMake(x, y, size.width, size.height);
        y += size.height;
    }
    
    if (self.titleLabel != nil) {
        CGRect nframe = self.titleLabel.frame;
        nframe.origin.x = (self.frame.size.width - nframe.size.width) / 2;
        nframe.origin.y = y;
        self.titleLabel.frame = nframe;
        y += nframe.size.height;
    }
    if (self.subtitleLabel != nil) {
        CGRect nframe = self.subtitleLabel.frame;
        
        nframe.origin.x = (self.frame.size.width - nframe.size.width) / 2;
        nframe.origin.y = y + 10;
        
        self.subtitleLabel.frame = nframe;
        
        y += nframe.size.height + 10;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if ([(id)self.superview isKindOfClass:UIScrollView.class]) {
        [(id)self.superview setScrollEnabled:true];
    }
    [super willMoveToSuperview:newSuperview];
    if ([(id)newSuperview isKindOfClass:UIScrollView.class]) {
        [(id)newSuperview setScrollEnabled:false];
    }
    self.frame = newSuperview.bounds;

}

- (void)show {
    self.frame = self.contentView.bounds;
    [self.contentView addSubview:self];
    //self.contentView.clipsToBounds = YES;
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end


@implementation UIView (NotData)

- (void)setSa_accessoryView:(SANotDataView *)sa_accessoryView {
    sa_accessoryView.contentView = self;
    return objc_setAssociatedObject(self, @selector(sa_accessoryView), sa_accessoryView, OBJC_ASSOCIATION_RETAIN);
}
- (SANotDataView*)sa_accessoryView {
    return objc_getAssociatedObject(self, @selector(sa_accessoryView));
}

@end
