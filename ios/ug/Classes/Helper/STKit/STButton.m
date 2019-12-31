//
//  STButton.m

#import "STButton.h"
#import "UIView+ST.h"
@implementation STButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    UIView *viewImage, *viewLabel;
    for (UIView *subview in  self.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            viewImage = subview;
        } else {
            viewLabel = subview;
        }
    }
    [viewLabel sizeToFit];
    
    
    switch (self.titleSideType) {
        case STButtonTypeTitleUp:{
            viewLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2-5);
            viewImage.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2+10);
        }break;
        case STButtonTypeTitleLeft: {
            CGFloat rightButton = viewLabel.right;
            viewLabel.left = viewImage.left;
            viewImage.right = rightButton+3;
        }break;
        case STButtonTypeTitleBottom: {
            viewImage.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - 10);
            viewLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + 18);
        }break;
        case STButtonTypeTitleRight: {
        }break;
        default:break;
    }
}

@end
