//
//  zj_runtime_property.h
//  AAA
//
//  Created by fish on 16/6/23.
//  Copyright © 2016年 fish. All rights reserved.
//

#ifndef zj_runtime_property_h
#define zj_runtime_property_h

#import <objc/runtime.h>


// Getter方法
#define _ZJRuntimeGetter(class, getterName)   \
- (class)getterName {                                         \
return objc_getAssociatedObject(self, @selector(getterName)); \
}

// Getter方法
#define _ZJRuntimeGetterDoubleValue(class, getterName)   \
- (class)getterName {                                         \
    class i = [objc_getAssociatedObject(self, @selector(getterName)) doubleValue]; \
    return i;\
} \

// Setter方法
#define _ZJRuntimeSetter(class, getterName, setterName) \
- (void)setterName:(class)getterName                                    {\
objc_setAssociatedObject(self, @selector(getterName), getterName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

// CopySetter方法
#define _ZJRuntimeCopySetter(class, getterName, setterName) \
- (void)setterName:(class)getterName                                        {\
objc_setAssociatedObject(self, @selector(getterName), getterName, OBJC_ASSOCIATION_COPY_NONATOMIC);\
}

// Property_Assign
#define _ZJRuntimeProperty_Assign(class, getterName, setterName) \
- (class)getterName {                                         \
class i = [objc_getAssociatedObject(self, @selector(getterName)) doubleValue]; \
return i;\
} \
- (void)setterName:(class)getterName                                        {\
objc_setAssociatedObject(self, @selector(getterName), @(getterName), OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

// Property_Retain
#define _ZJRuntimeProperty_Retain(class, getterName, setterName) \
_ZJRuntimeGetter(class, getterName)\
_ZJRuntimeSetter(class, getterName, setterName)

// Property_Copy
#define _ZJRuntimeProperty_Copy(class, getterName, setterName) \
_ZJRuntimeGetter(class, getterName)\
_ZJRuntimeCopySetter(class, getterName, setterName)

// Property_Readonly
#define _ZJRuntimeProperty_Readonly(class, getterName, defaultValue)    \
- (class)getterName {   \
    id obj = objc_getAssociatedObject(self, @selector(getterName));   \
    if (!obj) { \
        obj = ({(defaultValue);});  \
        objc_setAssociatedObject(self, @selector(getterName), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);    \
    }   \
    return obj; \
}


#endif /* zj_runtime_property.h */
