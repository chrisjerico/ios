//
//  cc_runtime_property.h
//  AAA
//
//  Created by fish on 16/6/23.
//  Copyright © 2016年 fish. All rights reserved.
//

#ifndef cc_runtime_property_h
#define cc_runtime_property_h

#import <objc/runtime.h>


// Getter方法
#define _CCRuntimeGetter(class, getterName)   \
- (class)getterName {                                         \
return objc_getAssociatedObject(self, @selector(getterName)); \
}

// Getter方法
#define _CCRuntimeGetterDoubleValue(class, getterName)   \
- (class)getterName {                                         \
    class i = [objc_getAssociatedObject(self, @selector(getterName)) doubleValue]; \
    return i;\
} \

// Setter方法
#define _CCRuntimeSetter(class, getterName, setterName) \
- (void)setterName:(class)getterName                                    {\
objc_setAssociatedObject(self, @selector(getterName), getterName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

// CopySetter方法
#define _CCRuntimeCopySetter(class, getterName, setterName) \
- (void)setterName:(class)getterName                                        {\
objc_setAssociatedObject(self, @selector(getterName), getterName, OBJC_ASSOCIATION_COPY_NONATOMIC);\
}

// Property_Assign
#define _CCRuntimeProperty_Assign(class, getterName, setterName) \
- (class)getterName {                                         \
class i = [objc_getAssociatedObject(self, @selector(getterName)) doubleValue]; \
return i;\
} \
- (void)setterName:(class)getterName                                        {\
objc_setAssociatedObject(self, @selector(getterName), @(getterName), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

// Property_Retain
#define _CCRuntimeProperty_Retain(class, getterName, setterName) \
_CCRuntimeGetter(class, getterName)\
_CCRuntimeSetter(class, getterName, setterName)

// Property_Copy
#define _CCRuntimeProperty_Copy(class, getterName, setterName) \
_CCRuntimeGetter(class, getterName)\
_CCRuntimeCopySetter(class, getterName, setterName)

// Property_Readonly
#define _CCRuntimeProperty_Readonly(class, getterName, defaultValue)    \
- (class)getterName {   \
    id obj = objc_getAssociatedObject(self, @selector(getterName));   \
    if (!obj) { \
        obj = ({(defaultValue);});  \
        objc_setAssociatedObject(self, @selector(getterName), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);    \
    }   \
    return obj; \
}


#endif /* cc_runtime_property.h */
