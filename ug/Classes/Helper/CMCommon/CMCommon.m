//
//  CMCommon.m

#import "CMCommon.h"
#import <objc/runtime.h>
#import <SafariServices/SafariServices.h>
#import "SLWebViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UGMosaicGoldViewController.h"

@implementation CMCommon
/******************************************************************************
 函数名称 : + (BOOL)verifyPhoneNum:(NSString *)numStr
 函数描述 : 检测手机号码合法性
 输入参数 : 要检测的手机号码
 输出参数 : N/A
 返回参数 : (BOOL)
 备注信息 :
 ******************************************************************************/
+ (BOOL)verifyPhoneNum:(NSString *)numStr
{
    NSString * MOBILE = @"^1\\d{10}$";  // 简单的匹配，以1开头的11位数字
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (![regextestmobile evaluateWithObject:numStr])
    {
        return NO;
    }
    return YES;
}

+ (BOOL)stringIsNull:(id)str{
    if (str == nil) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([str isKindOfClass:[NSString class]]) {
        NSString *validateStr = str;
        if (validateStr.length == 0 || [validateStr isEqualToString:@"<null>"] || [validateStr isEqualToString:@""] || [validateStr isEqualToString:@"null"]) {
            return YES;
        }else
            return NO;
    }else{
        return NO;
    }
    
}


/**
 *判断是不是空数组，如果返回yes，代表该该数组为空
 */
+ (BOOL)arryIsNull:(NSArray *)array{
    if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0){
        //执行array不为空时的操作
        return NO;
    }else{
        return YES;
    }
}

static NSString *uuidKey =@"uuidKey";
+(NSString *)createUUID{
    NSString *uuid;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    uuid = [userDefaults objectForKey:uuidKey];
    
    if (uuid == nil || [uuid isEqualToString:@""]) {
        //NSMutableString *ss = [NSMutableString stringWithString: NSUUID.UUID.UUIDString];
       NSString *ss = [NSUUID.UUID.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
       NSMutableString *ms = [NSMutableString stringWithString:[ss substringFromIndex:19]];
        [ms deleteCharactersInRange:[ms rangeOfString:@"_"]];
        uuid = ms ;
        [userDefaults setObject:uuid forKey:uuidKey];
        [userDefaults synchronize];
    }
    
    return uuid;
}


//可以使用一下语句判断是否是刘海手机：
+ (BOOL)isPhoneX {
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
            
        }
    }
    return iPhoneX;
    
}

+ (NSString *)getNowTimeWithEndTimeStr:(NSString *)aTimeString currentTimeStr:(NSString *)currentTime {
//    NSLog(@"curCloseTime =%@",aTimeString);
//
//    NSLog(@"serverTime =%@",currentTime);
    
//    2020-04-15 16:23:13.868372+0800 UGBWApp[2076:128817] aTimeString =2020-04-15 21:30:00
//    2020-04-15 16:23:13.868545+0800 UGBWApp[2076:128817] currentTime =2020-04-15 16:23:12
    // 截止时间date格式
    NSDate  *expireDate = [aTimeString dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 当前时间date格式
    NSDate *nowDate = [NSDate new];
    NSTimeInterval timeInterval = [expireDate timeIntervalSinceDate:nowDate];
    
    // 时间不知道为什么快了一点点，这里手动加上，慢总比快好一点
    timeInterval += 0.2;
    
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval)/3600);
    int minutes = (int)(timeInterval-hours*3600)/60;
    int seconds = timeInterval-hours*3600-minutes*60;
    
    NSString *dayStr;
	NSString *hoursStr;NSString *minutesStr; NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    if (hours < 10) {
          hoursStr = [NSString stringWithFormat:@"0%d",hours];
    }else {
    
        if (days) {
             hoursStr = [NSString stringWithFormat:@"%d",hours - 24*days];
        } else {
             hoursStr = [NSString stringWithFormat:@"%d",hours];
        }
       
    }
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (days<=0&&hours<=0&&minutes<=0&&seconds<=0) {
        return nil;
    }
    
    if (days) {
        return [NSString stringWithFormat:@"%@天%@:%@:%@", dayStr,hoursStr, minutesStr,secondsStr];
    }
    if (hours) {
        return [NSString stringWithFormat:@"%@:%@:%@",hoursStr , minutesStr,secondsStr];
    }
    return [NSString stringWithFormat:@"%@:%@", minutesStr,secondsStr];

}

+ (UIColor *)getPreNumColor:(NSString *)num {
    NSInteger preNum = num.integerValue;
    if (preNum == 1) {
        return UGNumColor1;
    }else if (preNum == 2) {
        return UGNumColor2;
    }else if (preNum == 3) {
        return UGNumColor3;
    }else if (preNum == 4) {
        return UGNumColor4;
    }else if (preNum == 5) {
        return UGNumColor5;
    }else if (preNum == 6) {
        return UGNumColor6;
    }else if (preNum == 7) {
        return UGNumColor7;
    }else if (preNum == 8) {
        return UGNumColor8;
    }else if (preNum == 9){
        return UGNumColor9;
    }else {
        return UGNumColor10;
    }
    
}

+ (NSString *)getDLTColor:(NSInteger )num {
    NSInteger preNum = num;
    if (preNum == 1) {
        return @"red";
    }else if (preNum == 2) {
        return @"red";
    }else if (preNum == 3) {
        return @"red";
    }else if (preNum == 4) {
        return @"red";
    }else if (preNum == 5) {
        return @"red";
    }else if (preNum == 6) {
        return @"blue";
    }else if (preNum == 7) {
        return @"blue";
    }else {
        return @"blue";
    }
    
}

+ (UIColor *)getPcddNumColor:(NSString *)num {
    NSSet *graySet = [NSSet setWithObjects:@"0",@"13",@"14",@"27", nil];
    NSSet *redSet = [NSSet setWithObjects:@"3",@"6",@"9",@"12",@"15",@"18",@"21",@"24", nil];
    NSSet *blueSet = [NSSet setWithObjects:@"2",@"5",@"8",@"11",@"17",@"20",@"23",@"26", nil];
    NSSet *greenSet = [NSSet setWithObjects:@"1",@"4",@"7",@"10",@"16",@"19",@"22",@"25", nil];
    if (num.length == 0) {
        num = [NSString stringWithFormat:@"0%@",num];
    }
    if ([redSet containsObject:num]) {
        return UGRGBColor(210, 69, 61);
    }else if ([blueSet containsObject:num]) {
        return UGRGBColor(96, 179, 225);
    }else if ([graySet containsObject:num]) {
        return UGRGBColor(213, 213, 213);
        
    }else {
        return UGRGBColor(119, 226, 134);
    }
    
}

+ (UIColor *)getHKLotteryNumColor:(NSString *)num {

    NSSet *redSet = [NSSet setWithObjects:@"01",@"02",@"07",@"08",@"12",@"13",@"18",@"19",@"23",@"24",@"29",@"30",@"34",@"35",@"40",@"45",@"46", nil];
    NSSet *blueSet = [NSSet setWithObjects:@"03",@"04",@"09",@"10",@"14",@"15",@"20",@"25",@"26",@"31",@"36",@"37",@"41",@"42",@"47",@"48", nil];
    NSSet *greenSet = [NSSet setWithObjects:@"05",@"06",@"11",@"16",@"17",@"21",@"22",@"27",@"28",@"32",@"33",@"38",@"39",@"43",@"44",@"49", nil];
    
    if (num.length == 1) {
        num = [NSString stringWithFormat:@"0%@",num];
    }
    if ([redSet containsObject:num]) {
       return UGRGBColor(197, 52, 60);
    }else if ([blueSet containsObject:num]) {
        return UGRGBColor(86, 170, 236);
    }else {
        return UGRGBColor(96, 174, 108);
    }
    
}

+ (NSString *)getHKLotteryNumColorString:(NSString *)num {
    //    1、红波:1.2.7.8.12.13.18.19.23.24.29.30.34.35.40.45.46
    //
    //    2、蓝波:3.4.9.10.14.15.20.25.26.31.36.37.41.42.47.48
    //
    //    3、绿波:5.6.11.16.17.21.22.27.28.32.33.38.39.43.44.49
    NSSet *redSet = [NSSet setWithObjects:@"01",@"02",@"07",@"08",@"12",@"13",@"18",@"19",@"23",@"24",@"29",@"30",@"34",@"35",@"40",@"45",@"46", nil];
    NSSet *blueSet = [NSSet setWithObjects:@"03",@"04",@"09",@"10",@"14",@"15",@"20",@"25",@"26",@"31",@"36",@"37",@"41",@"42",@"47",@"48", nil];
    NSSet *greenSet = [NSSet setWithObjects:@"05",@"06",@"11",@"16",@"17",@"21",@"22",@"27",@"28",@"32",@"33",@"38",@"39",@"43",@"44",@"49", nil];
    if (num.length == 0) {
        num = [NSString stringWithFormat:@"0%@",num];
    }
    if ([redSet containsObject:num]) {
        return @"red";
    }else if ([blueSet containsObject:num]) {
        return @"blue";
    }else {
        return @"greed";
    }
    
}

+ (UIImage *)getHKLotteryNumColorImg:(NSString *)num {
    //    1、红波:1.2.7.8.12.13.18.19.23.24.29.30.34.35.40.45.46
    //
    //    2、蓝波:3.4.9.10.14.15.20.25.26.31.36.37.41.42.47.48
    //
    //    3、绿波:5.6.11.16.17.21.22.27.28.32.33.38.39.43.44.49
    NSSet *redSet = [NSSet setWithObjects:@"01",@"02",@"07",@"08",@"12",@"13",@"18",@"19",@"23",@"24",@"29",@"30",@"34",@"35",@"40",@"45",@"46", nil];
    NSSet *blueSet = [NSSet setWithObjects:@"03",@"04",@"09",@"10",@"14",@"15",@"20",@"25",@"26",@"31",@"36",@"37",@"41",@"42",@"47",@"48", nil];
    NSSet *greenSet = [NSSet setWithObjects:@"05",@"06",@"11",@"16",@"17",@"21",@"22",@"27",@"28",@"32",@"33",@"38",@"39",@"43",@"44",@"49", nil];
    if (num.length == 0) {
        num = [NSString stringWithFormat:@"0%@",num];
    }
    if ([redSet containsObject:num]) {
        return [UIImage imageNamed:@"lhc_red"];
    }else if ([blueSet containsObject:num]) {
        return [UIImage imageNamed:@"lhc_blue"];
    }else {
        return [UIImage imageNamed:@"lhc_green"];
    }
    
}

+ (NSString *)getDateStringWithLastDate:(NSInteger)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval oneDay = 24 * 60 * 60;
    NSDate *startDay = [currentDate initWithTimeIntervalSinceNow:-(oneDay * date)];
    NSString *startDateStr = [formatter stringFromDate:startDay];
    return startDateStr;
}

+ (NSArray *)pickPermutation:(NSInteger)pickNum totalNum:(NSInteger)totalNum
{
    NSAssert(pickNum <= totalNum, @"选择数不能比总数大");
    
    NSArray * result = [self localArrayIndex:0 andLength:totalNum countIndex:0 count:pickNum];
    
    // comment two lines for Increase speed
    NSInteger count = [self pickNum:pickNum totalNum:totalNum];
    NSLog(@"%@选%@预期个数：%@",@(totalNum),@(pickNum),@(count));
    
    return result;
}

//幸运农场 连码公式
+ (NSInteger)combination:(NSInteger)m Num:(NSInteger)n
{
    if (m <= n) {
        NSInteger num1 = [self factorialWithNumber:n];
        NSInteger num2 = [self factorialWithNumber:(n-m)];
        return  num1/num2;
    }
    else{
        return  0;
    }
}

+ (NSInteger)pickNum:(NSInteger)pickNum totalNum:(NSInteger)totalNum
{
    if (pickNum > totalNum) {
        return 0;
    }
    else{
        NSInteger num1 = [self factorialWithStartNumber:totalNum - pickNum + 1 endNumber:totalNum];
        NSInteger num2 = [self factorialWithStartNumber:1 endNumber:pickNum];
        return  num1/num2;
    }
}

#pragma mark - 核心计算公式
/**
 
 核心计算公式
 
 跑位    o1  o2  o3  o4
 对象    A   B   C   D   E F G H I J
 序号    0   1   2   3   4 5 6 7 8 9
 
 o1 到 o4 是代表目标数值
 目标长度是4，o1是最高位。
 当前跑序点的位置分别为 0 - 3
 
 A 到 J 是代表对象 长度是 10
 
 @param location 最高位的起点
 @param length   对象长度
 @param index    当前跑序点的位置
 @param count    目的长度
 
 @return 0 - 1
 */

+ (NSArray * )localArrayIndex:(int)location
                    andLength:(int)length
                   countIndex:(int)index
                        count:(int)count
{
    NSMutableArray * arr = [NSMutableArray array];
    int rightPadding = count - 1 - index;
    if (rightPadding == 0) {
        for (; location < length ; location ++) {
            [arr addObject:[NSString stringWithFormat:@"%@",@(location)]];
        }
    }
    else {
        for (; location < length - rightPadding; location ++) {
            NSArray * subs = [self localArrayIndex:location + 1 andLength:length countIndex:index + 1 count:count];
            for (NSString * string in subs) {
                [arr addObject:[NSString stringWithFormat:@"%@,%@",@(location),string]];
            }
        }
    }
    return [arr copy];
}


#pragma mark - 辅助转换&数学计算


/**
 阶乘
 
 @param startNumber 起始数
 @param endNumber   结束数
 
 @return 阶乘结果
 */
+ (NSInteger)factorialWithStartNumber:(NSInteger)startNumber
                            endNumber:(NSInteger)endNumber
{
    NSInteger result = 1;
    for (; startNumber <= endNumber; startNumber ++) {
        result = result * startNumber;
    }
    return  result;
}

/**
 阶乘
 
 @param n
 
 @return 阶乘结果
 */
+ (NSInteger)factorialWithNumber:(NSInteger)n
{
    NSInteger sum = 1;
    while (n>0) {
        sum = sum*n--;
    }
    return  sum;
}

// #pragma mark ---------------------------------------------- 判断邮箱格式
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
// #pragma mark ---------------------------------------------- 判断手机号码
+ (BOOL)CheckPhoneNumInput:(NSString *)phone
{
    NSString *Regex = @"(13[0-9]|14[57]|15[012356789]|18[012356789])\\d{8}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:phone];
}


#pragma mark - 判断密码强度函数
/*
 声明：包含大写/小写/数字/特殊字符
 两种以下密码强度低
 两种密码强度中
 大于两种密码强度高
 密码强度标准根据需要随时调整
 */
//判断是否包含
+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password
{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}

//条件
+ (NSInteger)judgePasswordStrength:(NSString*) _password
{
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
    
//    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
//    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
//    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
//    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
//    int intResult=0;
//    for (int j=0; j<[resultArray count]; j++)
//    {
//        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
//        {
//            intResult++;
//        }
//    }
//    NSInteger result = 0;
//    if (intResult < 2)
//    {
//        result = 0;
//    }
//    else if (intResult == 2)
//    {
//        result = 1;
//    }
//    if (intResult > 2)
//    {
//        result = 2;
//    }
    
    if (result1.integerValue == 1 & result2.integerValue == 1 ||
        result1.integerValue == 1 & result3.integerValue == 1 ||
        result1.integerValue == 1 & result2.integerValue == 1 & result3.integerValue == 1) {
        return 1;
    }
    if (result1.integerValue == 1 & result2.integerValue == 1 & result4.integerValue == 1 ||
        result1.integerValue == 1 & result3.integerValue == 1 & result4.integerValue == 1 ||
        result1.integerValue == 1 & result2.integerValue == 1 &result3.integerValue == 1 & result4.integerValue == 1) {
        return 2;
    }
    return 0;
}

/**
 比较两个日期的大小
 日期格式为:yyyy-MM-dd
 [self compareDate:@"2019-09-06" withDate:@"2019-09-02" withFormat:@"yyyy-MM-dd"]
 返回：//小  -1 一样  0 大   1
 */
+ (int)compareDate:(NSString *)date01 withDate:(NSString *)date02  withFormat:(NSString *)format{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}


#pragma mark: - 判断是否能够被整除
/*
 [self judgeStr:9 with:3]
 返回：
 */
+(BOOL)judgeStr:(int )number1 with:(int )number2
{
    
    
    if (fmod(number1, number2)== 0) {
        
        return YES;
    }
    else{
        return NO;
    }
    
}

/*
 有时候需要让view显示某一侧的边框线，这时设置layer的border是达不到效果的。在网上查阅资料发现有一个投机取巧的办法，原理是给view的layer再添加一个layer，让这个layer充当边框线的角色。
 返回：
 */
+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

/**
 *  根据内容自动算高度
 *
 *  @param 内容
 *
 *  @return 高度
 */
+ (CGFloat)getLabelWidthWithText:(NSString *)text stringFont:(UIFont *)font allowWidth:(CGFloat)width{
    CGFloat height;
    CGSize basetipSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize rect  = [text
             boundingRectWithSize:basetipSize
             options:NSStringDrawingUsesLineFragmentOrigin
             attributes:@{NSFontAttributeName:font}
             context:nil].size;
    height = rect.height +20;
    return height;
}

/**
 *  UIImageView 加载含有汉字的url处理方法
 *
 */
+ (NSString *)imgformat:(NSString *)string {
    NSString *url = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return url;
}
/**
 *  //压缩图片
 *
 */
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


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
+ (NSMutableDictionary *)yyUrlConversionParameter:(NSString *)urlStr{
    NSArray*array = [urlStr componentsSeparatedByString:@"?"];//从字符A中分隔成2个元素的数组
    NSLog(@"lastObject ==== %@",[array lastObject]);
    NSString * memberStr = (NSString *)[array lastObject];
    NSArray *params =[memberStr componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    
    NSLog(@"tempDic:%@",tempDic);
    return tempDic;
}

//ios 指定范围内的随机数
+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
    
}

/**
 *  @author zhengju, 16-06-29 10:06:05
 *
 *  @brief 检测字符串中是否含有中文，备注：中文代码范围0x4E00~0x9FA5，
 *
 *  @param string 传入检测到中文字符串
 *
 *  @return 是否含有中文，YES：有中文；NO：没有中文
 */
+ (BOOL)checkIsChinese:(NSString *)string{
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}

/**
 *  url 加载含有汉字的url处理方法
 *
 */
+ (NSString *)urlformat:(NSString *)string {
     //中文转码处理
      NSString * encodedString =  [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
      NSLog(@"中文转码处理encodedString: %@", encodedString);


    return encodedString;
}

/**
 *  "通过KVC修改占位文字的颜色""
 *  NSGenericException" - reason: "Access to UITextField's _placeholderLabel ivar is prohibited. This is an application bug"
 *
 */
+ (void )textFieldSetPlaceholderLabelColor:(UIColor *)color TextField:(UITextField *)txtF {
     // "通过KVC修改占位文字的颜色"
     Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
     UILabel *placeholderLabel = object_getIvar(txtF, ivar);
     placeholderLabel.textColor = color;
}

/**
 *  ios 自带//语音播报 默认
 *
 utterance.pitchMultiplier= 0.8;//设置语调
 utterance.volume = 1.0f;//设置音量（0.0--1.0）
 utterance.rate = 0.5f;//设置语速
 *
 */
+ (void )speakUtteranceWithString:(NSString *)string{
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:string];
//    utterance.pitchMultiplier= 0.8;//设置语调
//    utterance.volume = 1.0f;//设置音量（0.0--1.0）
//    utterance.rate = 0.5f;//设置语速
    //中式发音
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice = voice;
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc]init];
    [synth speakUtterance:utterance];
}

/**
*  ios 判断两个数组中的NSString 元素是否相同，但不判断顺序
*
*
*/
+ (BOOL)array:(NSArray *)array1 isEqualTo:(NSArray *)array2 {
    if (array1.count != array2.count) {
        return NO;
    }
    for (NSString *str in array1) {
        if (![array2 containsObject:str]) {
            return NO;
        }
    }
    return YES;
    
}

/**
*  ios 判断两个数组中的NSString 元素是否相同，同时也判断顺序
*
*
*/
+ (BOOL)array:(NSArray *)array1 isOrderEqualTo:(NSArray *)array2 {

    bool bol = false;
    //创建俩新的数组
    NSMutableArray *oldArr = [NSMutableArray arrayWithArray:array1];
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:array2];
     
    [oldArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           //        将数组中的对象升序排列
           return NSOrderedAscending;
    }];
    
    [newArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           //        将数组中的对象升序排列
           return NSOrderedAscending;
    }];

    if (newArr.count == oldArr.count) {
        
        bol = true;
        for (int16_t i = 0; i < oldArr.count; i++) {
            
            id c1 = [oldArr objectAtIndex:i];
            id newc = [newArr objectAtIndex:i];
            
            if (![newc isEqualToString:c1]) {
                bol = false;
                break;
            }
        }
    }
     
    if (bol) {
        NSLog(@"两个数组的内容相同！");
    }
    else {
        NSLog(@"两个数组的内容不相同！");
    }
    return bol;
}

/**
*  ios 比较两个数组,并除去相同元素
*
*
*/
+ (NSArray*)arrayfilter:(NSArray *)array1 array2:(NSArray *)array2 {
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",array1];
    NSArray * filter = [array2 filteredArrayUsingPredicate:filterPredicate];
    NSLog(@"%@",filter);
    return filter;
}

/**
*  ios 数组,并除去相同元素    isOrder    有序  yes 无序 no
*
*
*/
+ (NSArray*)killRepeatNoOrderly:(NSArray *)array Orderly:(BOOL)isOrder {
    if (isOrder) {
        NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:array];
        NSArray *resultArray = set.array;
        NSLog(@"%@", resultArray);
        return resultArray;
    } else {
        NSSet *set = [NSSet setWithArray:array];
        NSArray *resultArray = [set allObjects];
        NSLog(@"%@", resultArray);
        return resultArray;
    }
}

/**
*  ios 数组,逆序
*
*
*/
+ (NSArray*) arrrayReverse:(NSArray *)array  {
    NSArray *strRevArray = [[array reverseObjectEnumerator] allObjects];
    return strRevArray;
}

/**
*  ios是否是链接的判断方法
*
*
*/
+(BOOL)hasLinkUrl:(NSString * )linkStr{
    NSString*emailRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES  %@",emailRegex];
    return [predicate evaluateWithObject:linkStr];
}


/**
*  ios调用QQ发起临时会话
*
*
*/
+(void)goQQ:(NSString * )qqStr{
    NSURL *url = [NSURL URLWithString:@"mqq://"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqStr];
        NSURL *url = [NSURL URLWithString:qq];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_10_0
       [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:^(BOOL success) {}];
#else
        [[UIApplication sharedApplication] openURL:url];
#endif
    }else {
        [LEEAlert alert].config
        .LeeTitle(@"不能打开QQ,请确保QQ可用")
        .LeeContent(@"")
        .LeeAction(@"确认", ^{
        })
        .LeeShow(); // 设置完成后 别忘记调用Show来显示
    }

}

/**
*   简单，ios 提示
*
*
*/
+(void)showTitle:(NSString * )str{
    [LEEAlert alert].config
    .LeeTitle(str)
    .LeeContent(@"")
    .LeeAction(@"确认", ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
    })
    .LeeShow(); // 设置完成后 别忘记调用Show来显示

}

/**
*   简单，ios Toast提示
*
*
*/
+(void)showToastTitle:(NSString * )str{
    [NavController1.view makeToast:str
    duration:1.5
    position:CSToastPositionCenter];
}

/**
*   SVProgressHUD showErrorWithStatus
*
*
*/
+(void)showErrorTitle:(NSString * )str{
    [SVProgressHUD showErrorWithStatus:str];
}

/**
*   简单系统，ios 提示  专门调试用
*
*
*/
+(void)showSystemTitle:(NSString * )str{
    #ifdef DEBUG
    NSMutableArray *titles = @[].mutableCopy;
    [titles addObject:@"复制"];
    UIAlertController *ac = [AlertHelper showAlertView:nil msg:str  btnTitles:titles];
    [ac setActionAtTitle:@"复制" handler:^(UIAlertAction *aa) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
    }];
    #endif

}

/**
*   系统web
*
*
*/
+(void)goUrl:(NSString *)url{
    // 这段话是为了加载<SafariServices/SafariServices.h>库，不然打包后会无法联网（DEBUG可以是因为LogVC里面加载了）
    SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    sf.view.backgroundColor = APP.BackgroundColor;
    sf.允许未登录访问 = true;
    sf.允许游客访问 = true;
    [NavController1 presentViewController:sf animated:YES completion:nil];
}

/**
*   自定义web
*
*
*/
+(void)goTGWebUrl:(NSString *)url title :(NSString *)title{
    TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
    webViewVC.允许未登录访问 = true;
    webViewVC.允许游客访问 = true;
    webViewVC.url = url;
    if (title) {
        webViewVC.webTitle = title;
    }
    [NavController1 pushViewController:webViewVC animated:YES];
}

/**
*   自定义web
*
*
*/
+(void)goSLWebUrl:(NSString *)url {
    SLWebViewController *webViewVC = [SLWebViewController new];
    webViewVC.urlStr = url;
    [NavController1 pushViewController:webViewVC animated:YES];
}


/**
*   给float类型的NSString 返回 float; 长度==0 返回0
*
*
*/
+(float)floatForNSString:(NSString * )str{
    float n = 0.0;
    if (str.length) {
        if ( str.isNumber) {
             n = [str floatValue];
        }
    }
    return n;
}


/**
*   针对与iOS7.0、iOS8.0、 WebView的缓存
*
*
*/
+(void)clearWebCache{
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
    NSUserDomainMask, YES)[0];
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
    objectForKey:@"CFBundleIdentifier"];
    NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
    NSString *webKitFolderInCaches = [NSString
    stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
     NSString *webKitFolderInCachesfs = [NSString
     stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];

    NSError *error;
    /* iOS8.0 WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];

    /* iOS7.0 WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
}

/**
*   针对与iOS9.0 WebView的缓存
*
*
*/
+(void)deleteWebCache{
 //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];

       NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];

       [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
           
       }];
}
//自定义清除缓存
+ (void)deleteCustomWebCache {
/*
     在磁盘缓存上。
     WKWebsiteDataTypeDiskCache,
     
     html离线Web应用程序缓存。
     WKWebsiteDataTypeOfflineWebApplicationCache,
     
     内存缓存。
     WKWebsiteDataTypeMemoryCache,
     
     本地存储。
     WKWebsiteDataTypeLocalStorage,
     
     Cookies
     WKWebsiteDataTypeCookies,
     
     会话存储
     WKWebsiteDataTypeSessionStorage,
     
     IndexedDB数据库。
     WKWebsiteDataTypeIndexedDBDatabases,
     
     查询数据库。
     WKWebsiteDataTypeWebSQLDatabases
     */
    NSArray * types=@[WKWebsiteDataTypeCookies,WKWebsiteDataTypeLocalStorage,WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeOfflineWebApplicationCache];
    
    NSSet *websiteDataTypes= [NSSet setWithArray:types];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];

    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{

    }];
}


#pragma mark -隐藏TabBar
+ (void)hideTabBar {
    if (TabBarController1.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[TabBarController1.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [TabBarController1.view.subviews objectAtIndex:1];
    else
        contentView = [TabBarController1.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + TabBarController1.tabBar.frame.size.height);
    TabBarController1.tabBar.hidden = YES;
    
}

#pragma mark -显示TabBar
+ (void)showTabBar {
    if (TabBarController1.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[TabBarController1.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        contentView = [TabBarController1.view.subviews objectAtIndex:1];
    
    else{
         contentView = [TabBarController1.view.subviews objectAtIndex:0];
    }
        
       
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - TabBarController1.tabBar.frame.size.height);
    TabBarController1.tabBar.hidden = NO;
    
}

/**
*   改变View的高度
*
*
*/
+(UIView *)changeHeight:(UIView *)mView  Height:(CGFloat)h{
    CGRect frame  =  mView.frame;
    frame.size.height =  h ;
    mView.frame = frame;
    
    return mView;
}

/**
*   系统分享
*    Text 文本  分享图片，不能传url；
*    image 图片   url ：链接
     type :1 :图片，2 url   3：带icon的url
*/
+(UIActivityViewController *)sysSharText:(NSString *)text  Image:(UIImage *)image URL:(NSURL *)url  type:(NSString *)type{
    NSString *shareText = text;
    UIImage *shareImage = image;
    NSURL *shareURL = url;
    NSArray *activityItems;
    
    
    if ([type  isEqualToString:@"1"]) {
        activityItems = [[NSArray alloc] initWithObjects:shareText, shareImage, nil];
        
    }
    else if([type  isEqualToString:@"2"]){
        activityItems = [[NSArray alloc] initWithObjects:shareText, shareURL, nil];
        
    }
    else if([type  isEqualToString:@"3"]){
        activityItems = [[NSArray alloc] initWithObjects:shareText, shareImage,shareURL, nil];
        
    }
    

    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    vc.modalInPopover = YES;
    //去除特定的分享功能 不需要展现的Activity类型
    vc.excludedActivityTypes = @[
        UIActivityTypePostToFacebook,
        UIActivityTypePostToTwitter,
        UIActivityTypePostToWeibo,
        UIActivityTypeMessage,
        UIActivityTypeMail,
        UIActivityTypePrint,
        UIActivityTypeCopyToPasteboard,
        UIActivityTypeAssignToContact,
        UIActivityTypeSaveToCameraRoll,
        UIActivityTypeAddToReadingList,
        UIActivityTypePostToFlickr,
        UIActivityTypePostToVimeo,
        UIActivityTypePostToTencentWeibo,
        UIActivityTypeAirDrop,
        UIActivityTypeOpenInIBooks
    ];
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        NSLog(@"%@",activityType);
        if (completed) {
            NSLog(@"分享成功");
        } else {
            NSLog(@"分享失败");
        }
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    
    vc.completionWithItemsHandler = myBlock;
    
    return vc;

}


/**
*   NavigationController返回上一层界面
*
*
*/
+(void )goPreviousVC{
    [NavController1 popViewControllerAnimated:YES];
}

/**
*   NavigationController返回上一层界面
*
*
*/
+(void )disPreviousVC{
    [NavController1 dismissViewControllerAnimated:YES completion:nil];
}

/**
*   加边框
*
*
*/
+(void )addBordeView:(UIView *)view Width:(float ) width Color:(UIColor *)color{
    view.layer.borderWidth = width;
    view.layer.borderColor = [color CGColor];
}

/**
*   返回下注界面边框颜色
*
*
*/
+(UIColor * )bordeColor{
    UIColor *borderColor;
    if (Skin1.isBlack) {
        borderColor = Skin1.textColor3;
    }
    else{
        if (APP.betBgIsWhite) {
            borderColor =  APP.LineColor;
        } else {
            borderColor =  [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        }
    }
    return borderColor;
}

/**
*   iOS 阿拉伯数字转汉字(1转一)
*原值:2.7999999999
typedef CF_ENUM(CFIndex, CFNumberFormatterRoundingMode) {
    kCFNumberFormatterRoundCeiling = 0,//四舍五入,直接输出3
    kCFNumberFormatterRoundFloor = 1,//保留小数输出2.8
    kCFNumberFormatterRoundDown = 2,//加上了人民币标志,原值输出￥2.8
    kCFNumberFormatterRoundUp = 3,//本身数值乘以100后用百分号表示,输出280%
    kCFNumberFormatterRoundHalfEven = 4,//输出2.799999999E0
    kCFNumberFormatterRoundHalfDown = 5,//原值的中文表示,输出二点七九九九。。。。
    kCFNumberFormatterRoundHalfUp = 6//原值中文表示,输出第三
};
*
*/
+(NSString * )switchNumber:(int )number{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:number]];
    NSLog(@"str = %@", string);
    return string;
}

/**
 *  读取本地JSON文件
 *
 */
+ (NSDictionary *)readLocalFileWithName:(NSString *)name{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


/**
* 计算新的赔率，公式： 新賠率 = 原始賠率 - ( 原始賠率無條件進位至整數位 * 退水)，
* 如 退水是 0.4% 就应该是 0.0004，公式就是：48.8 - （49 * 0.0004）= 新赔率
*
* ogOdds: 原始賠率
* rebate: 退水
 
 小数向上取整，指小数部分直接进1：

  x = 2.222，ceilf(x) = 3。

 小数向下取整，指直接去掉小数部分：

  x = 2.222，floor(x) = 2。

 小数四舍五入，指>0.5向上加1 ，小于0.5去掉小数部分 ：

 x = 2.222，round(x) = 2;

 y = 2.555，round(y) = 3。

*/
+(float )newOgOdds:(float)ogOdds rebate:(float)rebate{
//    NSLog(@"ceilf(ogOdds) = %f",ceilf(ogOdds));
//    NSLog(@"rebate = %f",rebate);
//    NSLog(@"ogOdds- (ceilf(ogOdds) * rebate) = %f",ogOdds- (ceilf(ogOdds) * rebate));
    
  return   ogOdds- (ceilf(ogOdds) * rebate);
}


/**
* 判断该彩种是否绑定聊天室没
*
*/
+(BOOL )getRoomMode:(NSString *)gameId{

    UGChatRoomModel *obj  = [UGChatRoomModel new];
    
    for (UGChatRoomModel *object in SysConf.chatRoomAry) {
        
        NSLog(@"object.typeIds = %@",object.typeIds);
        if ( [object.typeIds containsObject:gameId]) {
            
            obj.roomName = object.roomName;
            obj.roomId  = object.roomId;
    
            return YES;
        }
    }
    
    return NO;
}


/**
* 当传入nim 为空时，各个站点默认的彩种
*
*/
+(UGNextIssueModel * )getBetAndChatModel:(UGNextIssueModel *)nim{
    if (!nim) {
           
           if ([@"c084" containsString:APP.SiteId]) {
               UGNextIssueModel * oc = [UGNextIssueModel new];
               oc.gameId = @"164";
               oc.gameType = @"lhc";
               oc.name = @"jslhc";
               oc.title = @"分分六合彩";
               nim = oc;
           }
           else if ([@"c208" containsString:APP.SiteId]) {
               UGNextIssueModel * oc = [UGNextIssueModel new];
               oc.gameId = @"78";
               oc.gameType = @"lhc";
               oc.name = @"lhc";
               oc.title = @"一分六合彩";
               nim = oc;
           }
           else if ([@"c217" containsString:APP.SiteId]) {
               UGNextIssueModel * oc = [UGNextIssueModel new];
               oc.gameId = @"98";
               oc.gameType = @"pk10";
               oc.name = @"pk10";
               oc.title = @"极速赛车";
               nim = oc;
           }
           else if ([@"c126" containsString:APP.SiteId]) {
               UGNextIssueModel * oc = [UGNextIssueModel new];
               oc.gameId = @"55";
               oc.gameType = @"xyft";
               oc.name = @"xyft";
               oc.title = @"幸运飞艇";
               nim = oc;
           }
           else {
               UGNextIssueModel * oc = [UGNextIssueModel new];
               oc.gameId = @"70";
               oc.gameType = @"lhc";
               oc.name = @"lhc";
               oc.title = @"香港六合彩";
               nim = oc;
           }
           
       }
    return nim;
       
}


/**
* webView 内部url 统一跳转
*
*/
+(void)goVCWithUrl:(NSString *)url{
    
    NSArray *params =[url componentsSeparatedByString:@"?"];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    NSLog(@"tempDic:%@",tempDic);
    NSString *app_params = [tempDic objectForKey:@"app_params"];
    
    if ([app_params isEqualToString:@"goto_act_file"]) {//申请优惠
        [NavController1 pushViewController:[UGMosaicGoldViewController new] animated:YES];
    }
    else if ([app_params isEqualToString:@"goto_coupon_list"]) {//优惠活动
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController") animated:YES];
    }
    
    
}

/**
*删除本地保存的最后一次选择的房间
*
*/
+(void)removeLastRoom{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"roomName"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"roomId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/**
*本地保存的最后一次选择的房间
*
*/

+(NSDictionary *)LastRoom{
    NSString *roomId = [[NSUserDefaults standardUserDefaults]objectForKey:@"roomId"];
    NSString *roomName = [[NSUserDefaults standardUserDefaults]objectForKey:@"roomName"];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          roomId,@"roomId",
                          roomName,@"roomName",
                          nil];
    return dic;
}
/**
*本地i是否保存的最后一次选择的房间
*
*/
+(BOOL )hasLastRoom{
    
    NSDictionary *dic = [self LastRoom];
    if ([CMCommon stringIsNull:dic[@"roomId"]]) {
        return NO;
    } else {
        return YES;
    }
}
/**
*  判断本地最后一次房间是否在网络房间列表中，没有删除保存的最后一次选择的房间
*
*/
+(void)removeLastRoomAction:(NSMutableArray *)chatIdAry{
    if ([CMCommon hasLastRoom]) {
        NSDictionary *roomDic = [CMCommon LastRoom];
        NSString *roomId  = [roomDic objectForKey:@"roomId"];
        
        BOOL isbool = [chatIdAry containsObject: roomId];
        
        if (!isbool) {
            [CMCommon removeLastRoom];
        }
    }
    
}


/**
*删除本地保存的最后一次跟号信息
*
*/
+(void)removeLastGengHao{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"gameId"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"selCode"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"array"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/**
*本地保存的最后一次跟号信息
*
*/

+(NSDictionary *)LastGengHao{
    NSString *gameId = [[NSUserDefaults standardUserDefaults]objectForKey:@"gameId"];
    NSString *selCode = [[NSUserDefaults standardUserDefaults]objectForKey:@"selCode"];
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"array"];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          gameId,@"gameId",
                          selCode,@"selCode",
                          array,@"array",
                          nil];
    return dic;
}

/**
*若之前未有投注，或上一注与当前计划投注的彩种不一致，则“追号”按钮为禁用状态。
*
*/
+(BOOL )hasGengHao:(NSString *)mgameId{
    
    NSDictionary *dic = [self LastGengHao];
    NSString *gameId = dic[@"gameId"];
    NSMutableArray  *array = dic[@"array"];
    if ([CMCommon stringIsNull:gameId]) {
        return NO;
    }
    if ([CMCommon arryIsNull:array]) {
        return NO;
    } else {
        if ([gameId isEqualToString:mgameId]) {
            return YES;
        } else {
            return NO;
        }
    }
}


/**
*保存本地保存的最后一次跟号信息
*
*/
+(void)saveLastGengHao:(NSArray *)array gameId:(NSString  *)gameId selCode:(NSString *)selCode{
    [[NSUserDefaults standardUserDefaults]setObject:gameId forKey:@"gameId"];
    [[NSUserDefaults standardUserDefaults]setObject:selCode forKey:@"selCode"];
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"array"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


@end
