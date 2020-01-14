//
//  RememberPass.h
//  ug
//
//  Created by ug on 2020/1/10.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RememberPass : NSObject
@property (nonatomic, strong) NSString *roomId;         /**<   房间id */
@property (nonatomic, strong) NSString *roomName;       /**<   房间名 */
@property (nonatomic, strong) NSString *password;       /**<  密码 */
@end

NS_ASSUME_NONNULL_END
