//
//  JSPatchHelper.h
//  ug
//
//  Created by fish on 2020/1/8.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotVersionModel : NSObject
@property (nonatomic) NSString *version;        /**<   版本号 */
@property (nonatomic) NSString *file_link;      /**<   文件下载地址 */
@property (nonatomic) NSString *detail;         /**<   更新日志 */
@property (nonatomic) NSString *release_time;   /**<   发布时间 */
@property (nonatomic) NSString *add_time;       /**<   提交时间 */
@property (nonatomic) NSString *username;       /**<   提交者 */
@property (nonatomic) BOOL is_force_update;     /**<   是否强制更新 */
@property (nonatomic) NSInteger type;           /**<  1 ios ，2 android */
@property (nonatomic) BOOL status;              /**<   是否已发布 */
@end



@interface JSPatchHelper : NSObject

+ (void)install;
+ (void)checkUpdate:(NSString *)rnVersion completion:(void (^)(NSError *err, HotVersionModel *hvm))completion;    /**<   查找新版本 */
+ (void)updateVersion:(NSString *)rnVersion progress:(void (^)(CGFloat progress))progress completion:(void (^)(BOOL ok))completion;  /**<   版本更新 */
+ (void)waitUpdateFinish:(void (^)(void))finishBlock;
@end

NS_ASSUME_NONNULL_END
