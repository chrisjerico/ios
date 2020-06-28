//
//  NSTask+Block.h
//  AutoPacking
//
//  Created by fish on 2020/1/15.
//  Copyright © 2020 fish. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OutputModel : NSObject
@property (nonatomic, copy) NSString *output1;
@property (nonatomic, copy) NSString *output2;
@property (nonatomic, copy) NSString *output3;
@property (nonatomic, copy) NSString *output4;
@end




@interface NSTask (Block)

+ (NSTask *)launchedTaskWithLaunchPath:(NSString *)path arguments:(NSArray<NSString *> *)arguments completion:(void (^)(OutputModel *om))completion;
@end

NS_ASSUME_NONNULL_END
