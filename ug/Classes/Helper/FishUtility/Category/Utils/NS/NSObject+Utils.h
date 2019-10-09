//
//  NSObject+Utils.h
//  FishUtility
//
//  Created by fish on 16/8/15.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>


static unsigned long OBJTokenIndex = 0;
#define OBJOnceToken(obj) ({BOOL ok = false; static unsigned long onceToken = 0; if (onceToken == 0) {onceToken = OBJTokenIndex++;} if (![(id)obj cc_onceToken][@(onceToken)]) {[(id)obj cc_onceToken][@(onceToken)] = @true; ok = true;} ok;})// 返回bool值，每个对象，在一个地方，只会为true一次


@interface NSObject (Utils)

@property (nonatomic, readonly, copy, class) NSArray <NSString *>*methodList;   /**<    获取函数列表 */
@property (nonatomic, readonly, copy, class) NSArray <NSString *>*propertyList; /**<    获取属性列表 */
@property (nonatomic, readonly, copy, class) NSArray <NSString *>*ivarList;     /**<    获取成员变量列表 */

@property (readonly, nonatomic) BOOL isClass;           /**<    是否是Class，而非对象 */
@property (readonly, nonatomic) BOOL classIsCustom;     /**<    所属类是否是自定义的类 */

- (void *)performSelector:(SEL)aSelector arguments:(va_list)argList;
- (void *)performSelector:(const char *)methodName, ...;
+ (void *)performSelector:(const char *)methodName, ...;

- (void)setValuesWithObject:(NSObject *)obj;
- (void)setValuesWithDictionary:(NSDictionary <NSString *, id>*)dict;   /**<    此函数使用MJExtension做参数类型转换，比原生setValuesForKeysWithDictionary: 函数更安全 */

@property (nonatomic, copy) NSString *tagString;
@property (nonatomic, readonly) NSMutableDictionary *cc_userInfo;
@property (nonatomic, readonly) NSMutableDictionary *cc_onceToken;
@end
