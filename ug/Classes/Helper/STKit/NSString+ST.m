//
//  NSString+ST.m


#import "NSString+ST.h"

@implementation NSString (ST)
/**
 *  1.返回字符串所占用的尺寸
 *
 *  @param fontSize     字体大小
 *  @param maxWidth     最大宽度
 *  @param maxHeight    最大高度
 */
//- (CGSize)sizeWithFont:(CGFloat)fontSize
//              maxWidth:(CGFloat)maxWidth
//             maxHeight:(CGFloat)maxHeight
//{
//    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
//    return [self boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
//                              options:NSStringDrawingUsesLineFragmentOrigin
//                           attributes:attrs
//                              context:nil].size;
//}

/**
 *  2.判断自己是否为空
 *
 *  @return <#return value description#>
 */
- (BOOL) isBlank
{
    if (!self.length ||
        self == nil ||
        self == NULL ||
        [self isEqual:[NSNull null]] ||
        [self isKindOfClass:[NSNull class]] ||
        [self isEqualToString:@"(null)"] ||
        [self isEqualToString:@"<null>"] ||
        [self isEqualToString:@"<nil>"] ||
        [self isEqualToString:@"null"] ||
        [self isEqualToString:@"NULL"]
        ) {
        return YES;
    }else {
        return NO;
    }
}

/**
 *  3.自身为空的替换字符串
 *
 *  @return 是空，返回替换字符串，不是空，返回自身
 */
- (NSString *)isBlankWithChangeString:(NSString *)changeString
{
    if ([self isBlank]) {
        return changeString;
    }else {
        return self;
    }
}

/**
 *  4.是否是手机号
 *
 *  @return <#return value description#>
 */
- (BOOL)isTelNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *  5.时间戳字符串,格式：2016年02月23日
 */
- (NSString *)stringToDateString
{
    if (self.length < 10) {
        return @"";
    }
    NSString *dateString = [self substringWithRange:NSMakeRange(0, 10)];
    double time = [dateString doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%ld月%ld日", (long)components.month, (long)components.day];
}

/**
 *  6.时间戳字符串,格式：2016-02-23
 */
- (NSString *)stringToFormatDateString
{
    if (self.length < 10) {
        return @"";
    }
    NSString *dateString = [self substringWithRange:NSMakeRange(0, 10)];
    double time = [dateString doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    return [NSString stringWithFormat:@"%zd-%zd-%zd", components.year, components.month, components.day];
}

- (NSDateComponents *)stringToDateComponents
{
    if (self.length < 10) {
        return [NSDateComponents new];
    }
    NSString *dateString = [self substringWithRange:NSMakeRange(0, 10)];
    double time = [dateString doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    return components;
    
}

/**
 *  7.时间戳字符串,格式：2016.02.23
 */
- (NSString *)stringToFormat0DateString
{
    if (self.length < 10) {
        return @"";
    }
    NSString *dateString = [self substringWithRange:NSMakeRange(0, 10)];
    double time = [dateString doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    return [NSString stringWithFormat:@"%zd.%zd.%zd", components.year, components.month, components.day];
}

/**
 *  8.时间戳字符串,格式：YYYY-MM-dd HH:mm:ss
 */
- (NSString *)stringToFormatSecondDateString
{
    if (self.length < 10) {
        return @"";
    }
    NSString *dateString = [self substringWithRange:NSMakeRange(0, 10)];
    double time = [dateString doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |  NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    return [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld", (long)components.year, (long)components.month, (long)components.day, (long)components.hour, (long)components.minute, (long)components.second];
}

/**
 *  10.去除字符串中的符号，如 《》 【】 [] () \n \\ \
 */
- (NSString *)stringByReplaceSymbols{
    NSString *stringReplace = self;
    stringReplace = [stringReplace stringByReplacingOccurrencesOfString:@"[" withString:@""];
    stringReplace = [stringReplace stringByReplacingOccurrencesOfString:@"]" withString:@""];
    stringReplace = [stringReplace stringByReplacingOccurrencesOfString:@"(" withString:@""];
    stringReplace = [stringReplace stringByReplacingOccurrencesOfString:@")" withString:@""];
    stringReplace = [stringReplace stringByReplacingOccurrencesOfString:@" " withString:@""];
    stringReplace = [stringReplace stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    stringReplace = [stringReplace stringByReplacingOccurrencesOfString:@"n" withString:@""];
    stringReplace = [stringReplace stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    stringReplace = [stringReplace stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    stringReplace = [stringReplace stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    stringReplace = [stringReplace stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    return stringReplace;
}

- (NSDictionary *)stringJsonToDictionary{
    if ([self isBlank]) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    
    return dictionary;
}
/**
 *  时间转时间戳,YYYY年MM月dd日
 *
 *  @param NSString <#NSString description#>
 *
 *  @return <#return value description#>
 */

- (NSString *)stringTimeToTimeInterval{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
    
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:self];
    NSString *timeSp = [NSString stringWithFormat:@"%ld000", (long)[date timeIntervalSince1970]];
    return timeSp;
}

/**
 *  时间转时间戳,yyyy-HH-mm HH:mm:ss
 */

- (NSString *)timeStrToTimeInterval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-HH-mm HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
    
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:self];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

/**
 *  毫秒数转字符格式，TO HH:MM
 */
- (NSString *)stringToSecond
{
    if ([self isBlank]) {
        return @"";
    }
    
    if (self.integerValue<0) {
        return @"";
    }
    
    if (self.integerValue==0) {
        return @"00:00";
    }
    
    NSInteger number = self.integerValue/1000;
    NSInteger hour = number/3600;
    NSInteger min = number/60%60;
    return [NSString stringWithFormat:@"%02zd:%02zd",hour,min];

}

/**
 *  10.时间戳字符串,格式：MM-dd HH:mm
 */
- (NSString *)stringToFormatMMddHHmmDateString{
    if (self.length < 10) {
        return @"";
    }
    NSString *dateString = [self substringWithRange:NSMakeRange(0, 10)];
    double time = [dateString doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |  NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    return [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld", (long)components.month, (long)components.day, (long)components.hour, (long)components.minute];
    
}

/**
 *  是否金额格式
 *
 *  @return YES/NO
 */
-(BOOL)isMoneyNum{
    if ([self isBlank]) {
        return NO;
    }
    
    if ([self floatValue] <=0) {
        return NO;
    }
    
    NSString *CT = @"^(([0-9]|([1-9][0-9]{0,6}))((\\.[0-9]{1,2})?))$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if ([regextestct evaluateWithObject:self] == YES)
    {
        return YES;
    }else{
        return NO;
    }
}

/**
 *  是否是纯数字
 *
 *  @return YES/NO
 */
- (BOOL)isNumText{
    
    NSString * regex = @"^[0-9]*$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

//拼接服务器图片地址
-(NSString *)cloudfsImageUrl{
    
    //NSDictionary* infoDictionary = NSBundle.mainBundle.infoDictionary;
    NSString* url = [self serverURL];//[infoDictionary valueForKeyPath: @"SAROPServer.SAROPServerURL"];
    url = [url stringByAppendingString:@"/cloudfs/api/fs/view/"];
    NSString *s =[url stringByAppendingString:self];
    return s;
}

//拼接服务器地址
-(NSString *)appendServerURL{
    NSString* url = [self serverURL];
    NSString *s =[url stringByAppendingString:self];
    return s;
}

//服务器地址
-(NSString *)serverURL{
    NSDictionary* infoDictionary = NSBundle.mainBundle.infoDictionary;
    NSString* url = [infoDictionary valueForKeyPath: @"SAROPServer.SAROPServerURL"];
    return url;
}

//校验身份证格式
- (BOOL)isVerifyIDCardNumber
{
    NSString *value = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;

}

//去除前后空格
- (NSString *)stringByTrimming {
    
    //去空格和回车
    //如果仅仅是去前后空格，用whitespaceCharacterSet
    NSCharacterSet  *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return  [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)stringToRestfulUrlWithFlag:(BOOL )flag {
    if (flag) {
        if ([self containsString:@"?c="]) {
         NSString *str = [self stringByReplacingOccurrencesOfString:@"?c=" withString:@"/"];
         NSString *result = [str stringByReplacingOccurrencesOfString:@"&a=" withString:@"/"];
        return result;;
        }
        return self;
        
    }else {
        
        return self;
    }
    
}

- (NSString *)removeFloatAllZero {
    if ([self containsString:@"/"])
        return self;
    else
        return _FloatString4(self.doubleValue);
}

@end
