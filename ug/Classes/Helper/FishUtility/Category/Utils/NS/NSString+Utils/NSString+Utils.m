//
//  NSString+Utils.m
//  AAA
//
//  Created by fish on 16/8/17.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "NSString+Utils.h"
#import "RegExCategories.h"
#import "CommonCrypto/CommonDigest.h"


@implementation NSString (Utils)

#pragma mark - （public）验证类型

- (BOOL)hasNumber            {return [self isMatch:RX(@"\\d")]; }
- (BOOL)hasFloat             {return [self isMatch:RX(@"\\d\\.")]; }
- (BOOL)hasASCII             {return [self isMatch:RX(@"[\\x00-\\xFF]")]; }
- (BOOL)hasChinese           {return [self isMatch:RX(@"[\\u4e00-\\u9fff]")]; }
- (BOOL)hasLetter            {return [self isMatch:RX(@"[A-Za-z]")]; }
- (BOOL)hasLowercaseLetter   {return [self isMatch:RX(@"[a-z]")]; }
- (BOOL)hasUppercaseLetter   {return [self isMatch:RX(@"[A-Z]")]; }
- (BOOL)hasSpecialCharacter  {return [self isMatch:RX(@"[^\\da-zA-Z\\u4e00-\\u9fff]")]; }
- (BOOL)isHtmlStr            {return [self isMatch:RX(@"<[^>]+>")]; }

- (BOOL)isNumber             {return [self isMatch:RX(@"^[+-]?((\\d*\\.?\\d+)|(\\d+\\.?\\d*))$")]; }
- (BOOL)isFloat              {return [self isMatch:RX(@"^[+-]?((\\d*\\.\\d+)|(\\d+\\.\\d*))$")]; }
- (BOOL)isInteger            {return [self isMatch:RX(@"^-?\\d+$")]; }
- (BOOL)isASCII              {return [self isMatch:RX(@"^[\\x00-\\xFF]+$")]; }
- (BOOL)isChinese            {return [self isMatch:RX(@"^[\\u4e00-\\u9fff]+$")]; }
- (BOOL)isLetter             {return [self isMatch:RX(@"^[A-Za-z]+$")]; }
- (BOOL)isLowercaseLetter    {return [self isMatch:RX(@"^[a-z]+$")]; }
- (BOOL)isUppercaseLetter    {return [self isMatch:RX(@"^[A-Z]+$")]; }
- (BOOL)isSpecialCharacter   {return [self isMatch:RX(@"^[^\\da-zA-Z\\u4e00-\\u9fff]+$")]; }



//- (BOOL (^)(NSString *))isDate {
//    __weak NSString *__self = self;
//    return [^(NSString *format) {
//        return !![__self dateWithFormat:format];
//    } copy];
//}

- (BOOL)isEmail              {return [self isMatch:RX(@"^(([^<>()\\[\\]\\\\.,;:\\s@\"]+(\\.[^<>()\\[\\]\\\\.,;:\\s@\"]+)*)|(\".+\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$")]; }

- (BOOL)isQQ                 {return [self isMatch:RX(@"^[1-9][0-9]{4,9}$")] && self.integerValue < 5000000000; }  // 2016年8月 腾讯只有3730000000+个Q号

- (BOOL)isTel                {return [self isMatch:RX(@"^(0(((2|31|35|47|51|53|55|57|71|75|77|79|83|87|93|99)[0-9])|(10|335|349|37[0-79]|39[1-68]|41[125-9]|42[179]|43[1-9]|45[1-9]|46[4789]|48[23]|52[37]|54[36]|56[12346]|580|59[1-9]|63[1-5]|66[0238]|69[12]|72[248]|73[014-9]|74[3456]|76[023689]|701|81[23678]|82[567]|85[14-9]|88[03678]|89[1-8]|90[123689]|91[1-79]|94[13]|95[1-5]|97[0-79])))?-?\\d{8}$")]; }

- (BOOL)isMobile             {return [self isMatch:RX(@"^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\\d{8}$")]; }





//- (BOOL)isZipcode            {return [self isMatch:RX(@"")]; }


- (BOOL)isNull               {return [self isMatch:RX(@"^(Null|null|NULL)$")]; }
- (BOOL)isURL                {return [self isMatch:RX(@"^((/|file:///)[^/]|[a-z]{3,6}://([0-9a-zA-Z-]+\\.){1,}[0-9a-zA-Z-]+([/]|$))")]; }
- (BOOL)isHexColor           {return [self isMatch:RX(@"^(#|0x)?([0-9a-fA-F]{3}){1,2}$")]; }
- (BOOL)isIP                 {return [self isIPv4] || [self isIPv6]; }
- (BOOL)isIPv4               {return [self isMatch:RX(@"^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$")]; }
- (BOOL)isIPv6               {return [self isMatch:RX(@"^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){5}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$")]; }


- (BOOL)isPhoto              {return [self checkFileTypeWithFormat:@"bmp|jpg|jpeg|png|tiff|gif|pcx|tga|exif|fpx|svg|psd|cdr|pcd|dxf|ufo|eps|ai|raw|hdri"]; }
- (BOOL)isVideo              {return [self checkFileTypeWithFormat:@"avi|rmvb|rm|asf|divx|mpg|mpeg|mpe|wmv|mp4|mkv|vob|flv|3gp|mov|rm|dv|viv"]; }
- (BOOL)isRAR                {return [self checkFileTypeWithFormat:@"7z|jar|zip|rar|iso|dmg|gz|gzip|tar|cab|hfs|arj|tgz|tpz|xzr|rpm|bz2|bzip2|tbz2|tbz|deb|z|taz|xpi|lzma|lzma86|lzh|lha|wim|swm|uue|ace|isz|split|xz|img"]; }


- (BOOL)isIDCardNumber {
    if (![self isMatch:RX(@"^[0-9]{17}[0-9xX]$")])
        return false;
    
    int  a[17] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
    char *b = "10X98765432";
    const char *s = self.UTF8String;
    
    NSUInteger num = 0;
    for (int i=0; i<17; i++)
        num += (s[i] - 48) * a[i];
    
    return b[num%11] == s[17];
}

- (BOOL)isBankCardNumber {
    if (![self isMatch:RX(@"^\\d{15,19}$")])
        return false;
    
    const char *s = self.UTF8String;
    NSInteger i = self.length;
    NSInteger sum = 0;
    NSInteger j = 0;
    
    while (i--) {
        int v = s[i] - 48;
        if (j % 2) {
            v *= 2;
            if(v > 9)
                v -= 9;
        }
        j++;
        sum += v;
    }
    return !(sum % 10);
}

- (NSDictionary *)bankCardInfo {
    if (!self.isBankCardNumber)
        return false;
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BankCardList" ofType:@"plist"]];
    return dic[self];
}


#pragma mark - （private）

- (BOOL)checkFileTypeWithFormat:(NSString *)format {
    // 包含路径的图片，或纯图片名（以图片名结尾）
    NSString *rx1 = [NSString stringWithFormat:@"^.+\\.(%@|%@)$", format, format.uppercaseString];
    // 包含参数的URL图片（末尾可能带参数）
    NSString *rx2 = [NSString stringWithFormat:@"^[a-z]{3,6}://([0-9a-zA-Z-]+\\.){1,}[0-9a-zA-Z-]+/.+\\.(%@|%@)($|/+.*$|\\?)", format, format.uppercaseString];
    return [self isMatch:RX(rx1)] || [self isMatch:RX(rx2)];
}


#pragma mark - （public）拓展

- (NSString *)urlEncodedString {
    NSDictionary *marks = @{@"%":@"h6bF1",
                            @"#":@"h6bF2",
//                            @"&":@"h6bF3",
                            };
    NSString *string = self;
    for (NSString *key in marks.allKeys)
        string = [string stringByReplacingOccurrencesOfString:key withString:marks[key]];
    
//    static NSString * const kAFCharactersGeneralDelimitersToEncode = @"#[]@";
//    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$'()*+;";
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @"";
    static NSString * const kAFCharactersSubDelimitersToEncode = @"";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    for (NSString *key in marks.allKeys)
        escaped = [escaped stringByReplacingOccurrencesOfString:marks[key] withString:key];
    return escaped;
}

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (NSDictionary *)urlParams {
    if (!self.isURL || ![self containsString:@"?"])
        return nil;
    
    NSMutableDictionary *dic = [@{} mutableCopy];
    NSArray *params = [[self substringFromIndex:[self rangeOfString:@"?"].location+1] componentsSeparatedByString:@"&"];
    
    for (NSString *str in params) {
        NSArray *arr = [str componentsSeparatedByString:@"="];
        if (arr.count == 1)
            [dic setValue:@"" forKey:arr[0]];
        else if (arr.count == 2)
            [dic setValue:arr[1] forKey:arr[0]];
    }
    return [dic copy];
}

- (NSArray *)ipSections {
    return self.isIP ? [self componentsSeparatedByString:@"."] : nil;
}

- (BOOL)isDateWithFormat:(NSString *)format {
    return !![self dateWithFormat:format];
}

- (NSDate *)dateWithFormat:(NSString *)format {
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:format];
    return [df dateFromString:self];
}

- (UIColor *)hexColor {
    if (!self.isHexColor)
        return nil;
    
    NSString *str = self;
    str = [str stringByReplacingOccurrencesOfString:@"#" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    
    if (str.length == 3)
        str = [NSString stringWithFormat:@"%@%@%@%@%@%@", str[0], str[0], str[1], str[1], str[2], str[2]];
    
    return UIColorFromHex(strtoul(str.UTF8String, 0, 16));
}

- (NSString *)pinyin {
    if (!self.length)
        return nil;
    
    NSMutableString *temp = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)temp, NULL, kCFStringTransformToLatin, false);
    temp = (NSMutableString *)[temp stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [temp stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

- (UIImage *)qrCodeWithWidth:(CGFloat)w {
    return [self qrCodeWithWidth:w color:[UIColor blackColor]];
}

- (UIImage *)qrCodeWithWidth:(CGFloat)w color:(UIColor *)color {
    if (!self.length)
        return nil;
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:[self dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];  //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];            //拿到二维码图片
    
    // 绘制一个更清晰的图片，设置二维码颜色
    {
        // 4.获取二维码的图片
        CIImage *ciimage = outPutImage;
        // 放大图片的比例
        CGFloat scale = w/39 * 2;
        ciimage = [ciimage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
        
        // 5.创建颜色过滤器
        CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
        // 6.设置默认值
        [colorFilter setDefaults];
        /*
         inputImage,     需要设定颜色的图片
         inputColor0,    前景色 - 二维码的颜色
         inputColor1     背景色 - 二维码背景的颜色
         */
        NSLog(@"%@",colorFilter.inputKeys);
        // 7.给颜色过滤器添加信息
        // 设定图片
        [colorFilter setValue:ciimage forKey:@"inputImage"];
        // 设定前景色
        [colorFilter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:@"inputColor0"];
        // 设定背景色
        [colorFilter setValue:[CIColor colorWithCGColor:[UIColor clearColor].CGColor] forKey:@"inputColor1"];
        // 获取图片
        ciimage = colorFilter.outputImage;
        // 5.给imageView赋值
        return [UIImage imageWithCIImage:ciimage];
    }
}

- (NSString *)stringByAppendingURLParams:(NSDictionary *)dict {
    NSMutableString *string = self.mutableCopy;
    if (![string containsString:@"?"])
        [string appendString:@"?"];
    for (NSString *key in dict.allKeys)
        [string appendFormat:@"&%@=%@", key, dict[key]];
    return [string copy];
}

- (NSString *)substringWithSize:(CGSize)size font:(UIFont *)font {
    CGFloat h = [self boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:@{NSFontAttributeName:font}
                                   context:nil].size.height;
    if (h <= size.height)
        return [self copy];
    
    NSInteger len = self.length/2;
    NSInteger correct = 2;
    NSString *string = nil;
    NSString *temp = [self substringToIndex:len];
    while (true) {
        h = [temp boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT)
                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                            attributes:@{NSFontAttributeName:font}
                               context:nil].size.height;
        if (h <= size.height)
            string = temp;
        
        len /= 2;
        if (!len) {
            if (correct--)
                len = 1;
            else
                return string;
        }
        temp = [self substringToIndex:temp.length + (h > size.height ? -len : len)];
    }
    return nil;
}

- (NSString *)objectAtIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0) {
    if (self.length > idx)
        return [self substringWithRange:NSMakeRange(idx, 1)];
    return nil;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id  _Nullable [])buffer count:(NSUInteger)len {
    NSUInteger count = 0;
    
    unsigned long countOfItemsAlreadyEnumerated = state->state;
    
    if (countOfItemsAlreadyEnumerated == 0) {
        state->mutationsPtr = &state->extra[0];
    }
    
    if (countOfItemsAlreadyEnumerated < [self length]) {
        state->itemsPtr = buffer;
        while ((countOfItemsAlreadyEnumerated < [self length]) && (count < len)) {
            buffer[count] = [self objectAtIndexedSubscript:countOfItemsAlreadyEnumerated];
            countOfItemsAlreadyEnumerated++;
            count++;
        }
    } else {
        count = 0;
    }
    
    state->state = countOfItemsAlreadyEnumerated;
    return count;
}

@end


@implementation NSMutableString (Utils)

- (void)setObject:(NSString *)str atIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0) {
    [self replaceCharactersInRange:NSMakeRange(idx, 1) withString:str];
}

@end
