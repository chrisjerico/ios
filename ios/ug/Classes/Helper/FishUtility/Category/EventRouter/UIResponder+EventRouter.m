//
//  UIResponder+EventRouter.m
//  MediaViewer
//
//  Created by fish on 2018/3/1.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "UIResponder+EventRouter.h"
#import "cc_runtime_property.h"


@interface EventRouteModel ()
@property (nonatomic, readonly) NSPointerArray *responderPointers;
@end

@implementation EventRouteModel

- (NSPointerArray *)viewPointers {
    if (!_responderPointers)
        _responderPointers = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
    return _responderPointers;
}

+ (instancetype)modelWithFirstResponder:(__kindof UIResponder *)responder userInfo:(NSDictionary *)userInfo {
    EventRouteModel *erm = [EventRouteModel new];
    erm.firstResponder = responder;
    erm.userInfo = [userInfo mutableCopy];
    [erm.responderPointers addPointer:(__bridge void * _Nullable)(responder)];
    return erm;
}
@end



@implementation UIResponder (EventRouter)

_CCRuntimeProperty_Readonly(NSMutableArray <NSString *>*, eventNames,  [NSMutableArray new])
_CCRuntimeProperty_Readonly(NSMutableArray <void (^)(EventRouteModel *)>*, eventRouteBlocks,  [NSMutableArray new])

- (void)eventRouteWithName:(NSString *)eventName erm:(EventRouteModel *)erm {
    [erm.responderPointers addPointer:(__bridge void * _Nullable)(self)];
    
    for (int i=0; i<self.eventNames.count; i++) {
        if ([self.eventNames[i] isEqualToString:eventName])
            self.eventRouteBlocks[i](erm);
    }
    
    [[self nextResponder] eventRouteWithName:eventName erm:erm];
}

- (void)handleEventRouteWithName:(NSString *)eventName block:(void (^)(EventRouteModel *))block {
    [self.eventNames addObject:eventName];
    [self.eventRouteBlocks addObject:block];
}

@end
