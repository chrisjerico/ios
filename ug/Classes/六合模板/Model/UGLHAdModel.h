//
//  UGLHAdModel.h
//  ug
//
//  Created by fish on 2019/11/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGLHAdModel : NSObject

@property (nonatomic, assign) NSInteger targetType;   /**<   广告跳转类型 1本窗口 2新窗口 */
@property (nonatomic, copy) NSString *pic;          /**<   广告图片 */
@property (nonatomic, copy) NSString *link;         /**<   广告调整链接 */

@end

NS_ASSUME_NONNULL_END
