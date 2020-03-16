//
//  cc_objc_msgSend.h
//  D
//
//  Created by fish on 16/9/23.
//  Copyright © 2016年 fish. All rights reserved.
//

#ifndef cc_objc_msgSend_h
#define cc_objc_msgSend_h
#import <objc/runtime.h>

// ———————————— 这里是声明 ————————————

//BOOL cc_hasMethod(id self, SEL op);
//void * cc_objc_msgSend(id self, const char *op, ...);
//void * cc_objc_msgSendv(id self, const char *op, va_list argList);



// 用于代替 respondsToSelector:
BOOL cc_hasMethod(id self, SEL op) {
    if (object_isClass(self))
        return class_getClassMethod(self, op) != NULL;
    else
        return class_getInstanceMethod([self class], op) != NULL;
}


// ———————————— 以下是实现 ————————————

id getReturnFromInv(NSInvocation *inv, NSMethodSignature *sig) {
    NSUInteger length = [sig methodReturnLength];
    if (length == 0) return nil;
    
    char *type = (char *)[sig methodReturnType];
    while (*type == 'r' || // const
           *type == 'n' || // in
           *type == 'N' || // inout
           *type == 'o' || // out
           *type == 'O' || // bycopy
           *type == 'R' || // byref
           *type == 'V') { // oneway
        type++; // cutoff useless prefix
    }
    
#define return_with_number(_type_) \
do { \
_type_ ret; \
[inv getReturnValue:&ret]; \
return @(ret); \
} while (0)
    
    switch (*type) {
        case 'v': return nil; // void
        case 'B': return_with_number(bool);
        case 'c': return_with_number(char);
        case 'C': return_with_number(unsigned char);
        case 's': return_with_number(short);
        case 'S': return_with_number(unsigned short);
        case 'i': return_with_number(int);
        case 'I': return_with_number(unsigned int);
        case 'l': return_with_number(int);
        case 'L': return_with_number(unsigned int);
        case 'q': return_with_number(long long);
        case 'Q': return_with_number(unsigned long long);
        case 'f': return_with_number(float);
        case 'd': return_with_number(double);
        case 'D': { // long double
            long double ret;
            [inv getReturnValue:&ret];
            return [NSNumber numberWithDouble:ret];
        };
            
        case '@': { // id
            void *ret = nil;
            [inv getReturnValue:&ret];
            return (__bridge id)(ret);
        };
            
        case '#': { // Class
            Class ret = nil;
            [inv getReturnValue:&ret];
            return ret;
        };
            
        default: { // struct / union / SEL / void* / unknown
            const char *objCType = [sig methodReturnType];
            char *buf = calloc(1, length);
            if (!buf) return nil;
            [inv getReturnValue:buf];
            NSValue *value = [NSValue valueWithBytes:buf objCType:objCType];
            free(buf);
            return value;
        };
    }
#undef return_with_number
}

void setInv(NSInvocation *inv, NSMethodSignature *sig, NSArray *args) {
    NSUInteger count = [sig numberOfArguments];
    for (int index = 2; index < count; index++) {
        id obj = args[index-2];
        char *type = (char *)[sig getArgumentTypeAtIndex:index];
        while (*type == 'r' || // const
               *type == 'n' || // in
               *type == 'N' || // inout
               *type == 'o' || // out
               *type == 'O' || // bycopy
               *type == 'R' || // byref
               *type == 'V') { // oneway
            type++; // cutoff useless prefix
        }
        
        BOOL unsupportedType = NO;
        switch (*type) {
            case 'v': // 1: void
            case 'B': // 1: bool
            case 'c': // 1: char / BOOL
            case 'C': // 1: unsigned char
            case 's': // 2: short
            case 'S': // 2: unsigned short
            case 'i': // 4: int / NSInteger(32bit)
            case 'I': // 4: unsigned int / NSUInteger(32bit)
            case 'l': // 4: long(32bit)
            case 'L': // 4: unsigned long(32bit)
            { // 'char' and 'short' will be promoted to 'int'.
                int arg = [obj intValue];
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'q': // 8: long long / long(64bit) / NSInteger(64bit)
            case 'Q': // 8: unsigned long long / unsigned long(64bit) / NSUInteger(64bit)
            {
                long long arg = [obj longLongValue];
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'f': // 4: float / CGFloat(32bit)
            { // 'float' will be promoted to 'double'.
                double arg = [obj doubleValue];
                float argf = arg;
                [inv setArgument:&argf atIndex:index];
            } break;
                
            case 'd': // 8: double / CGFloat(64bit)
            {
                double arg = [obj doubleValue];
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'D': // 16: long double
            {
                long double arg = [obj doubleValue];
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '*': // char *
            {
                const char *arg = [obj UTF8String];
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '^': // pointer
            {
                void *arg = (__bridge void *)(obj);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case ':': // SEL
            {
                SEL arg = NSSelectorFromString(obj);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '#': // Class
            {
                Class arg = obj;
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '@': // id
            {
                id arg = obj;
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '{': // struct
            {
                if (strcmp(type, @encode(CGPoint)) == 0) {
                    CGPoint arg = [obj CGPointValue];
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGSize)) == 0) {
                    CGSize arg = [obj CGSizeValue];
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGRect)) == 0) {
                    CGRect arg = [obj CGRectValue];
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGVector)) == 0) {
                    CGVector arg = [obj CGVectorValue];
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
                    CGAffineTransform arg = [obj CGAffineTransformValue];
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CATransform3D)) == 0) {
                    CATransform3D arg = [obj CATransform3DValue];
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(NSRange)) == 0) {
                    NSRange arg = [obj rangeValue];
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(UIOffset)) == 0) {
                    UIOffset arg = [obj UIOffsetValue];
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
                    UIEdgeInsets arg = [obj UIEdgeInsetsValue];
                    [inv setArgument:&arg atIndex:index];
                } else {
                    unsupportedType = YES;
                }
            } break;
                
            case '(': // union
            {
                unsupportedType = YES;
            } break;
                
            case '[': // array
            {
                unsupportedType = YES;
            } break;
                
            default: // what?!
            {
                unsupportedType = YES;
            } break;
        }
        
        if (unsupportedType) {
            // Try with some dummy type...
            
            NSUInteger size = 0;
            NSGetSizeAndAlignment(type, &size, NULL);
            
#define case_size(_size_) \
else if (size <= 4 * _size_ ) { \
struct dummy { char tmp[4 * _size_]; }; \
struct dummy arg; \
[obj getValue:&arg]; \
[inv setArgument:&arg atIndex:index]; \
}
            if (size == 0) { }
            case_size( 1) case_size( 2) case_size( 3) case_size( 4)
            case_size( 5) case_size( 6) case_size( 7) case_size( 8)
            case_size( 9) case_size(10) case_size(11) case_size(12)
            case_size(13) case_size(14) case_size(15) case_size(16)
            case_size(17) case_size(18) case_size(19) case_size(20)
            case_size(21) case_size(22) case_size(23) case_size(24)
            case_size(25) case_size(26) case_size(27) case_size(28)
            case_size(29) case_size(30) case_size(31) case_size(32)
            case_size(33) case_size(34) case_size(35) case_size(36)
            case_size(37) case_size(38) case_size(39) case_size(40)
            case_size(41) case_size(42) case_size(43) case_size(44)
            case_size(45) case_size(46) case_size(47) case_size(48)
            case_size(49) case_size(50) case_size(51) case_size(52)
            case_size(53) case_size(54) case_size(55) case_size(56)
            case_size(57) case_size(58) case_size(59) case_size(60)
            case_size(61) case_size(62) case_size(63) case_size(64)
            else {
                /*
                 Larger than 256 byte?! I don't want to deal with this stuff up...
                 Ignore this argument.
                 */
                struct dummy {char tmp;};
                for (int i = 0; i < size; i++) {
                    struct dummy arg;
                    [obj getValue:&arg];
                }
                NSLog(@"YYCategories performSelectorWithArgs unsupported type:%s (%lu bytes)", [sig getArgumentTypeAtIndex:index], (unsigned long)size);
            }
#undef case_size
            
        }
    }
}

id cc_objc_msgSendv2(id self, const char *_op, NSArray *args) {
    SEL op = sel_registerName(_op);
    NSMethodSignature *signature;
    if (!cc_hasMethod(self, op) || !(signature = [self methodSignatureForSelector:op]))
        return nil;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:op];
    setInv(invocation, signature, args);
    [invocation invokeWithTarget:self];
    
    return getReturnFromInv(invocation, signature);
//    void *ret = nil;
//    if (signature.methodReturnLength)
//        [invocation getReturnValue:&ret];
//    return ret;
}

void * cc_objc_msgSendv1(id self, const char *_op, va_list argList) {
    SEL op = sel_registerName(_op);
    NSMethodSignature *signature;
    if (!cc_hasMethod(self, op) || !(signature = [self methodSignatureForSelector:op]))
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

void * cc_objc_msgSend(id self, const char *op, ...) {
    va_list argList;
    va_start(argList, op);
    
    void *result = cc_objc_msgSendv1(self, op, argList);
    va_end(argList);
    
    return result;
}

#endif /* cc_objc_msgSend_h */
