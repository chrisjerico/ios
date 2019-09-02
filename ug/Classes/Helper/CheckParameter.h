//
//  CheckParameter.h
//

#ifndef ParameterCheck_h
#define ParameterCheck_h

#import <UIKit/UIKit.h>
//#import "NSString+ST.h"

static inline id __ck_parameter_exception(id e) {
    return [NSException exceptionWithName:@"__ck__" reason:e userInfo:nil];
}
static inline id __ck_parameter_get(id a) {
    if ([a isKindOfClass: UILabel.class] || [a isKindOfClass: UITextField.class] || [a isKindOfClass: UITextView.class])
        return [a text];
    return a;
}

static inline void ck_parameters(void (^handler)(void), void (^error)(id err), void (^success)(void)) {
    @try {
        if (handler != nil)
            handler();
        if (success != nil)
            success();
    } @catch (NSException *exception) {
        if (error != nil)
            error(exception.reason);
    }
}
static inline void ck_parameters_display(void (^handler)(void), void (^success)(void)) {
    ck_parameters(handler, ^(id err){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@""
                                        message:err
                                       delegate:nil
                              cancelButtonTitle:@"好"
                              otherButtonTitles:nil] show];
        });
    }, success);
}

static inline void ck_parameter_non(BOOL a, id e) {
    if (!a) @throw __ck_parameter_exception(e);
}

static inline void ck_parameter_non_empty(id a, id e) {
    a = __ck_parameter_get(a);
    if (a == nil) @throw __ck_parameter_exception(e);
    if ([a isKindOfClass:NSNull.class]) @throw __ck_parameter_exception(e);
    if ([a isKindOfClass:NSString.class] && [a length] == 0) @throw __ck_parameter_exception(e);
    // 集合
    if ([a isKindOfClass:NSSet.class] && [a count] == 0) @throw __ck_parameter_exception(e);
    if ([a isKindOfClass:NSArray.class] && [a count] == 0) @throw __ck_parameter_exception(e);
    if ([a isKindOfClass:NSDictionary.class] && [a count] == 0) @throw __ck_parameter_exception(e);
}
static inline void ck_parameter_non_zero(id a, id e) {
    a = __ck_parameter_get(a);
    if (a == nil) @throw __ck_parameter_exception(e);
    if ([a isKindOfClass: NSNull.class]) @throw __ck_parameter_exception(e);
    if ([a isKindOfClass: NSString.class] && [a doubleValue] == 0.0) @throw __ck_parameter_exception(e);
}
static inline void ck_parameter_non_equal(id a, id b, id e) {
    a = __ck_parameter_get(a);
    b = __ck_parameter_get(b);
    if ([a isEqualToString: b]) @throw __ck_parameter_exception(e);
}
static inline void ck_parameter_less_length(id a, id b, id e) {
    a = __ck_parameter_get(a);
    if (a == nil) @throw __ck_parameter_exception(e);
    if ([a length] < [b integerValue]) @throw __ck_parameter_exception(e);
}

static inline void ck_parameter_more_length(id a, id b, id e) {
    a = __ck_parameter_get(a);
    if (a == nil) @throw __ck_parameter_exception(e);
    if ([a length] > [b integerValue]) @throw __ck_parameter_exception(e);
}

static inline void ck_parameter_isEqual_length(id a, id b, id e) {
    a = __ck_parameter_get(a);
    if (a == nil) @throw __ck_parameter_exception(e);
    if ([a length] != [b integerValue]) @throw __ck_parameter_exception(e);
}

static inline void ck_parameter_isEqual(id a, id b, id e) {
    a = __ck_parameter_get(a);
    b = __ck_parameter_get(b);
    NSString *astr = a;
    NSString *bstr = b;
    if (![astr isEqualToString:bstr]) {
        @throw __ck_parameter_exception(e);
    }
//    if ([astr compare:bstr] == -1) @throw __ck_parameter_exception(e);
}

/**
 *  检查字符串是否包含空格
 *
 *  @param a 被查字符串
 *  @param e 结果提示语
 *
 */
static inline void ck_parameter_contant_space(id a,id e){
    a = __ck_parameter_get(a);
    NSRange _range = [a rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        @throw __ck_parameter_exception(e);
    }else {
        //没有空格
    }
}


#endif /* ParameterCheck_h */
