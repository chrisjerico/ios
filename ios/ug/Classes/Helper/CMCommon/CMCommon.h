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
/**

@param num  数字
@return 根据规则返回球图
*/
+ (UIImage *)getHKLotteryNumColorImg:(NSString *)num ;

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

//幸运农场 连码公式
+ (NSInteger)combination:(NSInteger)m Num:(NSInteger)n;

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
+ (CGFloat)getLabelWidthWithText:(NSString *)text stringFont:(UIFont *)font allowWidth:(CGFloat)width;

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


/******************************************************************************
 函数名称 : yyUrlConversionParameter;
 函数描述 :把类似
    http://test10.6yc.com/wjapp/api.php?c=real&a=gameUrl&id=53&game=&token=2k8cseq2TqQQ2PP2QDz428z3的URL里面的参数取出来以字典返回
     {
     token = "2k8cseq2TqQQ2PP2QDz428z3",
     id = "53",
     c = "real",
     a = "gameUrl",
     game = "",
     }
 
 输入参数 : NSString
 输出参数 : NSMutableDictionary
 返回参数 : NSMutableDictionary
 备注信息 :
 ******************************************************************************/
+ (NSMutableDictionary *)yyUrlConversionParameter:(NSString *)urlStr;

//ios 指定范围内的随机数
+(int)getRandomNumber:(int)from to:(int)to;

/**
 *  @author zhengju, 16-06-29 10:06:05
 *
 *  @brief 检测字符串中是否含有中文，备注：中文代码范围0x4E00~0x9FA5，
 *
 *  @param string 传入检测到中文字符串
 *
 *  @return 是否含有中文，YES：有中文；NO：没有中文
 */
+ (BOOL)checkIsChinese:(NSString *)string;

/**
 *  url 加载含有汉字的url处理方法
 *
 */
+ (NSString *)urlformat:(NSString *)string ;

/**
 *  "通过KVC修改占位文字的颜色""
 *  NSGenericException" - reason: "Access to UITextField's _placeholderLabel ivar is prohibited. This is an application bug"
 *
 */
+ (void )textFieldSetPlaceholderLabelColor:(UIColor *)color TextField:(UITextField *)txtF;

/**
 *  ios 自带//语音播报 默认
 *
 utterance.pitchMultiplier= 0.8;//设置语调
 utterance.volume = 1.0f;//设置音量（0.0--1.0）
 utterance.rate = 0.5f;//设置语速
 *
 */
+ (void )speakUtteranceWithString:(NSString *)string;

/**
*  ios 判断两个数组中的NSString元素是否相同，但不判断顺序
*
*
*/
+ (BOOL)array:(NSArray *)array1 isEqualTo:(NSArray *)array2 ;

/**
*  ios 判断两个数组中的NSString元素是否相同，同时也判断顺序
*
*
*/
+ (BOOL)array:(NSArray *)array1 isOrderEqualTo:(NSArray *)array2 ;

/**
*  ios 比较两个数组,并除去相同元素
*
*
*/
+ (NSArray*)arrayfilter:(NSArray *)array1 array2:(NSArray *)array2 ;

/**
*  ios 数组,并除去相同元素    isOrder    有序  yes 无序 no
*
*
*/
+ (NSArray*)killRepeatNoOrderly:(NSArray *)array Orderly:(BOOL)isOrder;

/**
*  ios 数组,逆序
*
*
*/
+ (NSArray*) arrrayReverse:(NSArray *)array ;
/**
*  ios是否是链接的判断方法
*
*
*/
+(BOOL)hasLinkUrl:(NSString * )linkStr;
/**
*  ios调用QQ发起临时会话
*由于qq区分个人qq和营销qq，故 chat_type 要正确配置。chat_type=crm 代表的是营销qq， chat_type=wpa 代表的是个人qq。
chat_type=wpa 设置意味着个人qq，不能和陌生人发临时会话，除非是好友，或者有共同的群，
chat_type=crm 设置意味着营销qq，可以和陌生人发起临时会话。
*
*/
+(void)goQQ:(NSString * )qqStr;

/**
*   简单，ios 提示
*
*
*/
+(void)showTitle:(NSString * )str;
/**
*   简单，ios Toast提示
*
*
*/
+(void)showToastTitle:(NSString * )str;

/**
*   SVProgressHUD showErrorWithStatus
*
*
*/
+(void)showErrorTitle:(NSString * )str;
/**
*   简单系统，ios 提示
*
*
*/
+(void)showSystemTitle:(NSString * )str;
/**
*   系统web
*
*
*/
+(void)goUrl:(NSString *)url;
/**
*   自定义web
*
*
*/
+(void)goTGWebUrl:(NSString *)url title :(NSString *)title;

/**
*   自定义web
*
*
*/
+(void)goSLWebUrl:(NSString *)url ;
/**
*   给float类型的NSString 返回 float; 长度==0 返回0
*
*
*/
+(float)floatForNSString:(NSString * )str;

/**
*   针对与iOS7.0、iOS8.0、iOS9.0 WebView的缓存
*
*
*/
+(void)clearWebCache;

/**
*   针对与iOS9.0 WebView的缓存
*
*
*/
+(void)deleteWebCache;
//自定义清除缓存
+ (void)deleteCustomWebCache;

#pragma mark -隐藏TabBar
+ (void)hideTabBar ;

#pragma mark -显示TabBar
+ (void)showTabBar;

/**
*   改变View的高度
*
*
*/
+(UIView *)changeHeight:(UIView *)mView  Height:(CGFloat)h;

/**
*   系统分享
*    Text 文本  分享图片，不能传url；
*    image 图片   url ：链接
     type :1 :图片，2 url   3：带icon的url
*/
+(UIActivityViewController *)sysSharText:(NSString *)text  Image:(UIImage *)image URL:(NSURL *)url  type:(NSString *)type;

/**
*   NavigationController返回上一层界面
*
*
*/
+(void )goPreviousVC;

/**
*   NavigationController返回上一层界面
*
*
*/
+(void )disPreviousVC;
@end
