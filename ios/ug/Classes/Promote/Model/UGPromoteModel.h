//
//  UGPromoteModel.h
//  ug
//
//  Created by ug on 2019/6/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGPromoteModel <NSObject>


@end

// 优惠活动Model
@interface UGPromoteModel : UGModel<UGPromoteModel>
@property (nonatomic, strong) NSString *promoteId;  /**<   优惠ID */
@property (nonatomic, strong) NSString *title;      /**<   优惠标题 */
@property (nonatomic, strong) NSString *content;    /**<   优惠内容 */
@property (nonatomic, strong) NSString *pic;        /**<   浮动按钮图片 */
@property (nonatomic, strong) NSString *linkUrl;    /**<   浮动按钮链接 */
@property (nonatomic) NSInteger category;           /**<   优惠分类:0=未分类;1=综合活动;2=棋牌活动;3=视讯活动;4=体育活动;5=电子活动;6=捕鱼活动 */
@property (nonatomic) NSInteger linkCategory;       /**<   linkCategory: 跳转分类。1=彩票游戏；2=真人视讯；3=捕鱼游戏；4=电子游戏；5=棋牌游戏；6=体育赛事；7=导航链接 */
@property (nonatomic) NSInteger linkPosition;       /**<  linkPosition：跳转位置。linkCategory=1-6代表游戏ID，linkCategory=7, 导航链接明细：1=存取款；2=APP下载；3=聊天室；4=在线客服；5=长龙助手；6=推荐收益；7=开奖网；8=利息宝；9=优惠活动；10=游戏记录；11=QQ客服 13任务大厅 */

//自定义参数
@property (nonatomic) float cellHeight;             /**<   优惠cell 高*/
@property (nonatomic, strong) NSString *style;      /**<   优惠图片样式。slide=折叠式,popup=弹窗式 page = 内页*/
@end


// 优惠活动列表Model
@interface UGPromoteListModel : UGModel

@property (nonatomic, strong) NSString *style;      /**<   优惠图片样式。slide=折叠式,popup=弹窗式 page = 内页*/
@property (nonatomic, strong) NSArray<UGPromoteModel> *list;

@end

// 优惠活动列表Cell Model
@interface UGPromoteTitleCellModel : UGModel

@property (nonatomic, strong) NSString *title;      /**<   分类名称 */
@property (nonatomic, strong) NSString *key;      /**<   分类key */

@end

NS_ASSUME_NONNULL_END
