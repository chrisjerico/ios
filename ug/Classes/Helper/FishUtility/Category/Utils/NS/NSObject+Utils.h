//
//  NSObject+Utils.h
//  FishUtility
//
//  Created by fish on 16/8/15.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>


#define zj_once_block(obj, _block) [(id)(obj) onceToken:({static unsigned long onceToken = 0;&onceToken;}) block:_block]; // 每个对象，在一个地方，只会调用一次的block
#define ZJOnceToken ({static unsigned long onceToken = 0;&onceToken;})


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
- (void)onceToken:(unsigned long *)onceToken block:(void (^)(void))block;   /**<    每个对象，在一个地方，只会调用一次的block */

@property (nonatomic, copy) NSString *tagString;
@property (nonatomic, readonly) NSMutableDictionary *zj_userInfo;
@end
