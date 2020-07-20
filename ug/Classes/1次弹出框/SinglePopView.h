//
//  SinglePopView.h
//  UGBWApp
//
//  Created by andrew on 2020/7/20.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mYYLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SinglePopView : UIView
@property (weak, nonatomic) IBOutlet mYYLabel *yyLabel;

+ (SinglePopView *) sharedInstance;
@end

NS_ASSUME_NONNULL_END
