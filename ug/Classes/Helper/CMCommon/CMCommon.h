//
//  CMCommon.h

#import <Foundation/Foundation.h>

@interface CMCommon : NSObject

/******************************************************************************
 函数名称 : + (BOOL)verifyPhoneNum:(NSString *)numStr
 函数描述 : 检测手机号码合法性
 输入参数 : 要检测的手机号码
 输出参数 : N/A
 返回参数 : (BOOL)
 备注信息 :
 ******************************************************************************/
+ (BOOL)verifyPhoneNum:(NSString *)numStr;

/// 判断字符串是否为空
+ (BOOL)stringIsNull:(id)str;

/**
 *判断是不是空数组，如果返回yes，代表该该数组为空
 */
+ (BOOL)arryIsNull:(NSArray *)array;

/**
 *  手机唯一码
 *
 *  @return <#return value description#>
 */
+(NSString *)createUUID;

//可以使用一下语句判断是否是刘海手机：
+ (BOOL)isPhoneX;

//获取倒计时时间
+ (NSString *)getNowTimeWithEndTimeStr:(NSString *)aTimeString currentTimeStr:(NSString *)currentTime;

+ (UIColor *)getPcddNumColor:(NSString *)num;

+ (UIColor *)getPreNumColor:(NSString *)num;

+ (UIColor *)getHKLotteryNumColor:(NSString *)num;

+ (NSString *)getHKLotteryNumColorString:(NSString *)num;

+ (NSString *)getDateStringWithLastDate:(NSInteger)date;

/**
 计算出所有的排列组合方式
 例如从11个中选取5个，totalNum就是11，pickNum就是5
 
 @param pickNum  目标个数
 @param totalNum  抽取对象个数
 
 @return 所有的排列组合方式
 */
+ (NSArray *)pickPermutation:(NSInteger)pickNum totalNum:(NSInteger)totalNum;

/**
 计算出排列组合个数
 例如从11个中选取5个，totalNum就是11，pickNum就是5
 @param pickNum  目标个数
 @param totalNum  抽取对象个数
 
 @return 所有的排列组合的个数
 */
+ (NSInteger)pickNum:(NSInteger)pickNum totalNum:(NSInteger)totalNum;

// #pragma mark ---------------------------------------------- 判断邮箱格式
+ (BOOL)isValidateEmail:(NSString *)email;

// #pragma mark ---------------------------------------------- 判断手机号码
+ (BOOL)CheckPhoneNumInput:(NSString *)phone;

//判断密码强度
+ (NSInteger)judgePasswordStrength:(NSString*) _password;

/**
 比较两个日期的大小
 日期格式为:yyyy-MM-dd
 [self compareDate:@"2019-09-06" withDate:@"2019-09-02" withFormat:@"yyyy-MM-dd"]
 返回：//小  -1 一样  0 大   1
 */
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02  withFormat:(NSString *)format;

/*
 [self judgeStr:9 with:3]
 返回：
 */
+(BOOL)judgeStr:(int )number1 with:(int )number2;

/*
 有时候需要让view显示某一侧的边框线，这时设置layer的border是达不到效果的。在网上查阅资料发现有一个投机取巧的办法，原理是给view的layer再添加一个layer，让这个layer充当边框线的角色。
 返回：
 */
+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

/**
 *  根据内容自动算高度
 *
 *  @param text 内容 font height
 *
 *  @return 高度
 */
+ (CGFloat)getLabelWidthWithText:(NSString *)text stringFont:(UIFont *)font allowHeight:(CGFloat)height;

/**
 *  UIImageView 加载含有汉字的url处理方法
 *
 */
+ (NSString *)imgformat:(NSString *)string;

/**
 *  //压缩图片
 *
 */
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
