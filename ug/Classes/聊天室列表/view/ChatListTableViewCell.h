//
//  ChatListTableViewCell.h
//  UGBWApp
//
//  Created by andrew on 2020/11/17.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoomChatModel;
NS_ASSUME_NONNULL_BEGIN

@interface ChatListTableViewCell : UITableViewCell
@property (nonatomic, strong) RoomChatModel *item;
@end

NS_ASSUME_NONNULL_END
