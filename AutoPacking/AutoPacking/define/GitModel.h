//
//  GitModel.h
//  AutoPacking
//
//  Created by fish on 2020/6/26.
//  Copyright © 2020 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 当前git信息
@interface GitModel : NSObject
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *branch;
@property (nonatomic, copy) NSString *commitId;
@property (nonatomic, copy) NSString *log;
@property (nonatomic, copy) NSString *number;
@end



NS_ASSUME_NONNULL_END
