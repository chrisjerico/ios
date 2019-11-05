//
//  CMCommon.m

#import "CMCommon.h"

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
    // 截止时间date格式
    NSDate  *expireDate = [aTimeString dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 当前时间date格式
    NSDate *nowDate = [NSDate new];
    NSTimeInterval timeInterval = [expireDate timeIntervalSinceDate:nowDate];
    
    // 时间不知道为什么快了一点点，这里手动加上，慢总比快好一点
    timeInterval += 0.2;
    
//    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval)/3600);
    int minutes = (int)(timeInterval-hours*3600)/60;
    int seconds = timeInterval-hours*3600-minutes*60;
    
//    NSString *dayStr;
	NSString *hoursStr;NSString *minutesStr; NSString *secondsStr;
    //天
//    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    if (hours < 10) {
          hoursStr = [NSString stringWithFormat:@"0%d",hours];
    }else {
    
        hoursStr = [NSString stringWithFormat:@"%d",hours];
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
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return nil;
    }
    
//    if (days) {
//        return [NSString stringWithFormat:@"%@天%@:%@:%@", dayStr,hoursStr, minutesStr,secondsStr];
//    }
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
+ (CGFloat)getLabelWidthWithText:(NSString *)text stringFont:(UIFont *)font allowHeight:(CGFloat)width{
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
+ (NSString *)imgformat:(NSString *)string{
    NSString *url = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
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
@end
