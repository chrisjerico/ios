//
//  STButton.h

#import <UIKit/UIKit.h>
   
typedef NS_ENUM(NSInteger, STButtonType)
{
    STButtonTypeTitleUp,
    STButtonTypeTitleLeft,
    STButtonTypeTitleBottom,
    STButtonTypeTitleRight
};
@interface STButton : UIButton
@property (nonatomic, assign)STButtonType  titleSideType; //
@end
