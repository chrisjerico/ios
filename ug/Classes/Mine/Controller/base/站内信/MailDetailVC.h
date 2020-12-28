//
//  MailDetailVC.h
//  UGBWApp
//
//  Created by xionghx on 2020/12/26.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MailDetailVC : UGViewController
@property (strong, nonatomic)  NSString *content;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
