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
@property (nonatomic, copy) NSString *roomId;           /**<   从下注页面进入传入的彩种ID，也是roomId */
@property (nonatomic, copy) NSString *shareBetJson;     /**<   从下注页面返回的分享下注 */
@property (nonatomic, copy) NSString *changeRoomJson;   /**<   切换聊天室的json */
@property (nonatomic, assign) BOOL hideHead;            /**<   是否隐藏h5 头*/
@property (nonatomic, assign) BOOL showChangeRoomTitle; /**<   显示标题栏，点击能切换房间 */


@end

NS_ASSUME_NONNULL_END
