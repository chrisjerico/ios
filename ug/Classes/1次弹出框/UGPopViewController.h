//
//  UGPopViewController.h
//  UGBWApp
//
//  Created by ug on 2020/7/20.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mYYLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGPopViewController : UIViewController
@property (strong, nonatomic)  NSString *content;
@property (weak, nonatomic) IBOutlet mYYLabel *remarkLbl;/**<   内容*/
@end

NS_ASSUME_NONNULL_END
