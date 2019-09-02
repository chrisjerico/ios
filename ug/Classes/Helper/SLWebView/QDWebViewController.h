//
//  QDWebViewController.h

#import <JavaScriptCore/JavaScriptCore.h>
#import "DKProgressLayer.h"
@interface QDWebViewController : UIViewController

@property(nonatomic, retain)NSString *navigationTitle;
@property (nonatomic, strong) NSString *urlString;
@property(nonatomic, assign) DKProgressStyle style;
@property (nonatomic, assign) BOOL enterGame;
@end
