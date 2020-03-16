//
//  UGRankModel.h
//  ug
//
//  Created by ug on 2019/6/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGRankModel <NSObject>

@end
// 首页排行榜
// {{LOCAL_HOST}}?c=system&a=rankingList
@interface UGRankModel : UGModel<UGRankModel>
@property (nonatomic, strong) NSString *username;   /**<   用户名 */
@property (nonatomic, strong) NSString *coin;       /**<   中奖/投注金额 */
@property (nonatomic, strong) NSString *type;       /**<   彩种名称 */
@property (nonatomic, strong) NSString *actionTime; /**<   投注时间 */

@end

@interface UGRankListModel : UGModel
@property (nonatomic, strong) NSArray<UGRankModel> *list;
@property (nonatomic, assign) BOOL show;            /**<   开关：true=开启，false=关闭 */

@end

NS_ASSUME_NONNULL_END
