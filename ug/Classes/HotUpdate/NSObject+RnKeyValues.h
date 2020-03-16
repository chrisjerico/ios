//
//  NSObject+RnKeyValues.h
//  ug
//
//  Created by fish on 2020/2/12.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (RnKeyValues)

- (id)rn_keyValues; /**<   模型转字典 */
- (id)rn_models;    /**<   字典转模型 */
@end

NS_ASSUME_NONNULL_END
