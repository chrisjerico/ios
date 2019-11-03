//
//  UGBannerModel.h
//  ug
//
//  Created by ug on 2019/6/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGBannerCellModel <NSObject>

@end

// 首页轮播图
// {{LOCAL_HOST}}?c=system&a=banners
@interface UGBannerCellModel : UGModel<UGBannerCellModel>
@property (nonatomic, strong) NSString *pic;    /**<   图片 */
@property (nonatomic, strong) NSString *url;    /**<   链接地址 */
@property (nonatomic, strong) NSString *sort;   /**<   排序 */
@property (nonatomic) NSInteger linkCategory;   /**<   linkCategory: 跳转分类。1=彩票游戏；2=真人视讯；3=捕鱼游戏；4=电子游戏；5=棋牌游戏；6=体育赛事；7=导航链接 */
@property (nonatomic) NSInteger linkPosition;   /**<  linkPosition：跳转位置。linkCategory=1-6代表游戏ID，linkCategory=7, 导航链接明细：1=存取款；2=APP下载；3=聊天室；4=在线客服；5=长龙助手；6=推荐收益；7=开奖网；8=利息宝；9=优惠活动；10=游戏记录；11=QQ客服 13任务大厅 */
@end

@protocol UGBannerModel <NSObject>

@end
@interface UGBannerModel : UGModel<UGBannerModel>
@property (nonatomic, strong) NSArray<UGBannerCellModel> * list;
@property (nonatomic, strong) NSString * interval;  /**<   轮播时间间隔*/

@end

NS_ASSUME_NONNULL_END
