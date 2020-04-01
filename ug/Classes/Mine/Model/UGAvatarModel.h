//
//  UGAvatarModel.h
//  ug
//
//  Created by ug on 2019/7/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAvatarModel : UGModel

@property (nonatomic, strong) NSString *filename;   /**<   头像文件名 */
@property (nonatomic, strong) NSString *url;        /**<   头像URL */

@end

NS_ASSUME_NONNULL_END
