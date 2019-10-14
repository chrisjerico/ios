//
//  UGChatViewController.h
//  ug
//
//  Created by ug on 2019/9/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import "TGWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGChatViewController : TGWebViewController
@property (nonatomic, copy) NSString *gameId;   /**<   从下注页面进入传入的彩种ID */
@end

NS_ASSUME_NONNULL_END
