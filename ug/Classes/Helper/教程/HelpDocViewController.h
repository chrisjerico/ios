//
//  HelpDocViewController.h
//  UGBWApp
//
//  Created by fish on 2020/10/6.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpDocModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HelpDocViewController : UIViewController
@property (nonatomic, strong) NSMutableArray <HelpDocModel *> * itemArry;
@end

NS_ASSUME_NONNULL_END
