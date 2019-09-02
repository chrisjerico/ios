//
//  WKProxy.m

#import "WKProxy.h"

@implementation WKProxy {
    __weak id object;
}

+ (instancetype)proxyWithObject:(id)object {
    WKProxy* ss = self.new;
    ss->object = object;
    return ss;
}
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self->object;
}
- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
}

@end
