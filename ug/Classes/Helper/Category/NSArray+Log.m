//
//  NSArray+Log.m


#import "NSArray+Log.h"

@implementation NSArray (Log)
- (NSString *)description
{
    // 1.定义一个可变的字符串, 保存拼接结果
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"(\n"];
    // 2.迭代字典中所有的key/value, 将这些值拼接到字符串中
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")\n"];
    
    // 删除最后一个逗号
    if (self.count > 0) {
        NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
        [strM deleteCharactersInRange:range];
    }
    
    // 3.返回拼接好的字符串
    return strM;
}


@end
