//
//  UIResponder+EventRouter.h
//  MediaViewer
//
//  Created by fish on 2018/3/1.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventRouteModel : NSObject

@property (nonatomic, weak) __kindof UIResponder *firstResponder;
@property (nonatomic) NSMutableDictionary *userInfo;

@property (readonly, copy) NSArray <__kindof UIResponder *>*responders;

+ (instancetype)modelWithFirstResponder:(__kindof UIResponder *)responder userInfo:(NSDictionary *)userInfo;
@end


@interface UIResponder (EventRouter)

- (void)eventRouteWithName:(NSString *)eventName erm:(EventRouteModel *)erm;

 - (void)handleEventRouteWithName:(NSString *)eventName block:(void (^)(EventRouteModel *erm))block;
@end

