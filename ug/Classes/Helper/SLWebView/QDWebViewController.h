//
//  QDWebViewController.h

#import <JavaScriptCore/JavaScriptCore.h>
#import "DKProgressLayer.h"

// 第三方游戏
@interface QDWebViewController : UIViewController

@property (nonatomic) NSString *navigationTitle;
@property (nonatomic) NSString *urlString;
@property (nonatomic) DKProgressStyle style;
@property (nonatomic) BOOL enterGame;
@end
