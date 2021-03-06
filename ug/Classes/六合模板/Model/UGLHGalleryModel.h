//
//  UGLHGalleryModel.h
//  ug
//
//  Created by fish on 2019/11/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGLHAdModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface UGLHGalleryModel : NSObject

// 《六合图库列表接口》
// c=lhcdoc&a=tkList
@property (nonatomic, copy) NSString *gid;           /**<   图库ID */
@property (nonatomic, copy) NSString *name;         /**<   名称 */
@property (nonatomic, copy) NSString *alias;        /**<   别名 */
@property (nonatomic, copy) NSString *desc;         /**<   简介 */
@property (nonatomic, assign) double priceMax;     /**<   收费帖子最大金额，为0则不是收费帖子 */
@property (nonatomic, assign) double priceMin;     /**<   收费帖子最小金额 */
@property (nonatomic, copy) NSString *topAdPc;      /**<   pc端顶部广告 */
@property (nonatomic, copy) NSString *bottomAdPc;   /**<   pc端底部广告 */
@property (nonatomic, copy) NSString *topAdWap;     /**<   手机端顶部广告 */
@property (nonatomic, copy) NSString *bottomAdWap;  /**<   手机端底部广告 */
@property (nonatomic, assign) BOOL isUpdate;     /**<   今日是否已更新 */
@property (nonatomic, copy) NSString *cover;        /**<   封面图 */

@end

// 热门图库
@interface UGLHHotModel : NSObject
@property (nonatomic, copy) NSString *gid;           /**<   图库ID */
@property (nonatomic, copy) NSString *name;         /**<   名称 */
@property (nonatomic, copy) NSString *alias;        /**<   别名 */
@property (nonatomic, copy) NSString *desc;         /**<   简介 */
@property (nonatomic, copy) NSString *priceMax;     /**<   收费帖子最大金额，为0则不是收费帖子 */
@property (nonatomic, copy) NSString *priceMin;     /**<   收费帖子最小金额 */
@property (nonatomic, copy) NSString *appLinkCode;      /**<  */
@property (nonatomic, copy) NSString *appLink;      /**<   */
@property (nonatomic, copy) NSString *content_id;      /**<    */
@property (nonatomic, copy) NSString *cover;      /**<   */
@property (nonatomic, assign) BOOL isUpdate;     /**<    */
@property (nonatomic, assign) BOOL isBidFav;     /**<    */
@end

NS_ASSUME_NONNULL_END
