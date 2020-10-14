//
//  UGAPPVersionModel.h
//  ug
//
//  Created by ug on 2019/8/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

// APP版本Model
// {{LOCAL_HOST}}?c=system&a=version&device=androidPlus
@interface UGAPPVersionModel : UGModel
@property (nonatomic, strong) NSString *versionCode;    /**<   版本号 */
@property (nonatomic, strong) NSString *versionName;    /**<   强制更新版本号 */
@property (nonatomic, assign) BOOL switchUpdate;        /**<   是否启用强制更新*/
@property (nonatomic, strong) NSString *updateContent;  /**<   更新日志 */
@property (nonatomic, strong) NSString *file;           /**<   APP文件 */
@property (nonatomic, strong) NSString *downloadUrl;    /**<   下载页面地址 */


@property (nonatomic, readonly) BOOL hasUpdate;         /**<   是否存在新版本 */
@property (nonatomic, readonly) BOOL needForce;         /**<   是否需要强制更新 */
@end

NS_ASSUME_NONNULL_END
