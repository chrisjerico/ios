//
//  ChatListViewController.h
//  UGBWApp
//
//  Created by andrew on 2020/11/17.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatListViewController : UIViewController
@property (nonatomic, copy) void(^chatListelectBlock)(RoomChatModel *chat);
@end

NS_ASSUME_NONNULL_END
