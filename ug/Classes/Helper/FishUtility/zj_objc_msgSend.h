//
//  zj_objc_msgSend.h
//  D
//
//  Created by fish on 16/9/23.
//  Copyright © 2016年 fish. All rights reserved.
//

#ifndef zj_objc_msgSend_h
#define zj_objc_msgSend_h
#import <objc/runtime.h>

// ———————————— 这里是声明 ————————————

//BOOL zj_hasMethod(id self, SEL op);
//void * zj_objc_msgSend(id self, const char *op, ...);
//void * zj_objc_msgSendv(id self, const char *op, va_list argList);



// 用于代替 respondsToSelector:
BOOL zj_hasMethod(id self, SEL op) {
    if (object_isClass(self))
        return class_getClassMethod(self, op) != NULL;
    else
        return class_getInstanceMethod([self class], op) != NULL;
}


// ———————————— 以下是实现 ————————————

void * zj_objc_msgSendv(id self, const char *_op, va_list argList) {
    SEL op = sel_registerName(_op);
    NSMethodSignature *signature;
    if (!zj_hasMethod(self, op) || !(signature = [self methodSignatureForSelector:op]))
        return nil;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:op];
    
    void *arg;
    
    NSUInteger i = 2;
    NSUInteger len = signature.numberOfArguments-i;
    while (len--) {
        arg = va_arg(argList, void *);
        [invocation setArgument:&arg atIndex:i++];
    }
    [invocation invokeWithTarget:self];
    
    void *result = nil;
    if (signature.methodReturnLength)
        [invocation getReturnValue:&result];
    return result;
}

void * zj_objc_msgSend(id self, const char *op, ...) {
    va_list argList;
    va_start(argList, op);
    
    void *result = zj_objc_msgSendv(self, op, argList);
    va_end(argList);
    
    return result;
}



#endif /* zj_objc_msgSend_h */
