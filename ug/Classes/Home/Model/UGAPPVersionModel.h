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
@property (nonatomic, strong) NSString *versionName;    /**<   版本名称 */
@property (nonatomic, assign) BOOL switchUpdate;        /**<   是否更新：1=是；0=否 */
@property (nonatomic, strong) NSString *updateContent;  /**<   更新日志 */
@property (nonatomic, strong) NSString *file;           /**<   APP文件 */

@end

NS_ASSUME_NONNULL_END
