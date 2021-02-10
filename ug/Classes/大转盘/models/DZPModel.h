//
//  DZPModel.h
//  UGBWApp
//
//  Created by ug on 2020/5/2.
//  Copyright © 2020 ug. All rights reserved.
//
//获取大转盘活动数据 : http://test28f.fhptcdn.com//wjapp/api.php?c=activity&a=turntableList&token=F9YhrIONRI8jrSbKFNiJrFBo
//方式 GET
//参数 token
//
//{
//    "code": 0,
//    "msg": "获取转盘活动数据成功",
//    "data": [
//        {
//            "id": "13",
//            "param": {
//                "buy": "1",消耗抽奖的货币类型 1为积分 2为彩金
//                "buy_amount": 10,消耗的金额
//                "check_in_user_levels": "", 可以参与的层级 没有则是全部
//                "content_turntable": [  活动藐视 每个逗号前代表一行
//                    "1",
//                    "2",
//                    "3"
//                ],
//                "membergame": "", 可以参与的游戏（目前没有）
//                "prize_time": 3, 抽奖间隔时间
//                "prizeArr": [  奖品参数
//                    {
//                        "prizeId": 0, 奖品id
//                        "prizeIcon": "https://cdn01.mayihong.cn/upload/t028/customise/images/15797648546prizeIconNew.jpg?v=1579764854",
//                        "prizeIconName": "15797648546prizeIconNew", 上面为奖品图标
//                        "prizeName": "1",奖品名字
//                        "prizeType": "1", 奖品类型 1为彩金 2为积分 3为其他 4为 未中奖
//                        "prizeAmount": "10" 奖品金额
//                    },
//                    {
//                        "prizeId": 1,
//                        "prizeIcon": "https://cdn01.mayihong.cn/upload/t028/customise/images/157976186360prizeIconNew.jpg?v=1579761863",
//                        "prizeIconName": "157976186360prizeIconNew",
//                        "prizeName": "2",
//                        "prizeType": "2",
//                        "prizeAmount": "20"
//                    },
//                    {
//                        "prizeId": 2,
//                        "prizeIcon": "https://cdn01.mayihong.cn/upload/t028/customise/images/157976179284prizeIconNew.jpg?v=1579761792",
//                        "prizeIconName": "157976179284prizeIconNew",
//                        "prizeName": "3",
//                        "prizeType": "4",
//                        "prizeAmount": "0"
//                    }
//                ]
//            },
//            "type": "turntable",
//            "start": "2020-01-23 00:00:00",
//            "end": "2021-01-23 23:59:59"
//        }
//    ]
//}
//}
#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol DZPprizeModel <NSObject>

@end
@interface DZPprizeModel : UGModel<DZPprizeModel>
@property (nonatomic, strong) NSNumber *prizeId;   /**<   奖品id*/
@property (nonatomic, strong) NSString *prizeIcon;   /**<  奖品图标 */
@property (nonatomic, strong) NSString *prizeIconName;   /**<  图标名字 */
@property (nonatomic, strong) NSString *prizeName;   /**<  奖品名字 */
@property (nonatomic, strong) NSString *prizeAmount;   /**<  奖品金额 */
@property (nonatomic, strong) NSString *prizeType;   /**<  奖品类型 1为彩金 2为积分 3为其他 4为 未中奖 */

@property (nonatomic, strong) NSString *prizeMsg;   /**<  信息*/
@property (nonatomic,strong) NSNumber * prizeflag;   /**<是否中奖标识 0为未中奖 1为中奖*/
@property (nonatomic,strong) NSNumber * integralOld;   /**<抽奖前积分*/
@property (nonatomic,strong) NSNumber * integral;   /**<抽奖后积分（算上中奖的）*/
@end

@protocol DZPparamModel <NSObject>

@end
@interface DZPparamModel : UGModel<DZPparamModel>

@property (nonatomic, strong) NSString *membergame; /**i可以参与的游戏*/
@property (nonatomic, strong) NSArray<DZPprizeModel> *prizeArr;

@property (nonatomic, strong) NSString *buy;   /**<   消耗抽奖的货币类型 1为积分 2为彩金*/
@property (nonatomic, strong) NSNumber *buy_amount;   /**<  消耗的金额 */
@property (nonatomic, assign) NSInteger golden_egg_times;
@property (nonatomic, strong) NSString *check_in_user_levels;   /**< 可以参与的层级 没有则是全部  */
@property (nonatomic, strong) NSArray<NSString*>  *content_turntable;   /**<  活动藐视 每个逗号前代表一行 */
@property (nonatomic, strong) NSString *chassis_img;   /*网络大转盘背景图 chassis_img*/
@property (nonatomic, strong) NSString *visitor_show;   /*试用是否可以访问  1 否   0 是*/
@end


@interface DZPModel : UGModel
@property (nonatomic, strong) NSString *DZPid;   /**id*/
@property (nonatomic, strong) DZPparamModel *param;   /**/
@property (nonatomic, strong) NSString *start; /**i*/
@property (nonatomic, strong) NSString *end;   /**/
@property (nonatomic, strong) NSString *type;   /**/

//获取转盘活动抽奖日志
@property (nonatomic, strong) NSString *prize_name; /**i奖品名字*/
@property (nonatomic, strong) NSString *prizeId; /**i抽奖编号*/

@property (nonatomic, strong) NSString *prizeName; /**i奖品名字*/

@property (nonatomic, strong) NSString *update_time;   /**< 抽奖时间戳  */
@property (nonatomic, strong) NSString *codeNum;  /**<   抽奖编号*/
@property (nonatomic, strong) NSNumber *freeNum;  /**<  剩余次数*/

@end

NS_ASSUME_NONNULL_END
