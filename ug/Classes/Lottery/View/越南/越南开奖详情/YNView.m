//
//  YNView.m
//  UGBWApp
//
//  Created by fish on 2020/10/13.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNView.h"
#import "CMLabelCommon.h"
@implementation YNView

-(void)setLabelColorForSelCode{
    FastSubViewCode(self)
    if ([[Global getInstanse].selCode isEqualToString:@"PIHAO2"]     ||
        [[Global getInstanse].selCode isEqualToString:@"DIDUAN2"]    ||
        [[Global getInstanse].selCode isEqualToString:@"PIANXIE2"]   ||
        [[Global getInstanse].selCode isEqualToString:@"PIANXIE3"]   ||
        [[Global getInstanse].selCode isEqualToString:@"PIANXIE4"]   ||
        [[Global getInstanse].selCode isEqualToString:@"CHUANSHAO4"] ||
        [[Global getInstanse].selCode isEqualToString:@"CHUANSHAO8"] ||
        [[Global getInstanse].selCode isEqualToString:@"CHUANSHAO10"]
        ) {//奖 后2位 红   PIHAO2 批号2 DIDUAN2 地段21k PIANXIE2 偏斜2 PIANXIE3偏斜3 PIANXIE4偏斜4 CHUANSHAO4串烧4 CHUANSHAO8串烧8 CHUANSHAO10串烧10
        [self length:2 isFront:MR_后面];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"PIHAO3"]) {//奖 后3位 红  批号3
        [self length:3 isFront:MR_后面];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"PIHAO4"]) {//批号4==== 奖 后4位 红
        [self length:3 isFront:MR_后面];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"LOT2FIRST"]) {//奖 前2位 红 （特—6）  第一个号码
        [CMLabelCommon messageAction:subLabel(@"特等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor] isMarkRangeType:MR_前面];
        [CMLabelCommon messageAction:subLabel(@"一等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor] isMarkRangeType:MR_前面];
        [CMLabelCommon messageAction:subLabel(@"二等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor] isMarkRangeType:MR_前面];
        [CMLabelCommon messageAction:subLabel(@"三等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor] isMarkRangeType:MR_前面];
        [CMLabelCommon messageAction:subLabel(@"四等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor] isMarkRangeType:MR_前面];
        [CMLabelCommon messageAction:subLabel(@"五等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor] isMarkRangeType:MR_前面];
        [CMLabelCommon messageAction:subLabel(@"六等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor] isMarkRangeType:MR_前面];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"ZHUANTI"]) {//专题====特等奖 后2位红
        [CMLabelCommon messageAction:subLabel(@"特等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor] isMarkRangeType:MR_后面];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"YIDENGJIANG"]) {//一等奖===一等奖的后两位
        [CMLabelCommon messageAction:subLabel(@"一等奖label") labStr:@"" separation:@"-" length:2 andMarkColor:[UIColor redColor] isMarkRangeType:MR_后面];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"ZHUZHANG7"]||
            [[Global getInstanse].selCode isEqualToString:@"3YINJIE"]) {
        //主张7===七等奖  3YINJIE 3个音 ==== 七等奖红
        [CMLabelCommon setRichNumberWithLabel:subLabel(@"七等奖label") Color:[UIColor redColor] FontSize:13.0];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"TOU"]) {//特别奖的倒数第二位红
        [CMLabelCommon messageLabel:subLabel(@"特等奖label") length:1 local:2 andMarkColor:[UIColor redColor]];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"WEI"]) {//特别奖的最后一位红
        [CMLabelCommon messageLabel:subLabel(@"特等奖label") length:1 local:1 andMarkColor:[UIColor redColor]];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"3GTEBIE"]) {//特别奖开奖号的后三位
        [CMLabelCommon messageLabel:subLabel(@"特等奖label") length:3 local:3 andMarkColor:[UIColor redColor]];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"3WBDJT"]) {//3WBDJT3尾巴 ==== 特别奖或者七等奖开奖号的后三位
        [CMLabelCommon messageLabel:subLabel(@"特等奖label") length:3 local:3 andMarkColor:[UIColor redColor]];
        [CMLabelCommon messageLabel:subLabel(@"七等奖label") length:3 local:3 andMarkColor:[UIColor redColor]];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"4GTEBIE"]) {//特别奖的后四位数字
        [CMLabelCommon messageLabel:subLabel(@"特等奖label") length:4 local:4 andMarkColor:[UIColor redColor]];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"BIAOTIWB"]) {//标题尾巴===第八等奖 后2位红 特等奖 后2位红
        [CMLabelCommon messageLabel:subLabel(@"特等奖label") length:2 local:2 andMarkColor:[UIColor redColor]];
        [CMLabelCommon messageLabel:subLabel(@"八等奖label") length:2 local:2 andMarkColor:[UIColor redColor]];
    }
    else if([[Global getInstanse].selCode isEqualToString:@"BIAOTI"]) {//标题尾巴===第八等奖 后2位红
        [CMLabelCommon messageLabel:subLabel(@"八等奖label") length:2 local:2 andMarkColor:[UIColor redColor]];
    }
    
    
}

-(void)length:(int)length isFront:(MarkRangeType)mrType{
    FastSubViewCode(self)
    [CMLabelCommon messageAction:subLabel(@"特等奖label") labStr:@"" separation:@"-" length:length andMarkColor:[UIColor redColor] isMarkRangeType:mrType];
    [CMLabelCommon messageAction:subLabel(@"一等奖label") labStr:@"" separation:@"-" length:length andMarkColor:[UIColor redColor] isMarkRangeType:mrType];
    [CMLabelCommon messageAction:subLabel(@"二等奖label") labStr:@"" separation:@"-" length:length andMarkColor:[UIColor redColor] isMarkRangeType:mrType];
    [CMLabelCommon messageAction:subLabel(@"三等奖label") labStr:@"" separation:@"-" length:length andMarkColor:[UIColor redColor] isMarkRangeType:mrType];
    [CMLabelCommon messageAction:subLabel(@"四等奖label") labStr:@"" separation:@"-" length:length andMarkColor:[UIColor redColor] isMarkRangeType:mrType];
    [CMLabelCommon messageAction:subLabel(@"五等奖label") labStr:@"" separation:@"-" length:length andMarkColor:[UIColor redColor] isMarkRangeType:mrType];
    [CMLabelCommon messageAction:subLabel(@"六等奖label") labStr:@"" separation:@"-" length:length andMarkColor:[UIColor redColor] isMarkRangeType:mrType];
    [CMLabelCommon messageAction:subLabel(@"七等奖label") labStr:@"" separation:@"-" length:length andMarkColor:[UIColor redColor] isMarkRangeType:mrType];
    [CMLabelCommon messageAction:subLabel(@"八等奖label") labStr:@"" separation:@"-" length:length andMarkColor:[UIColor redColor] isMarkRangeType:mrType];
}
@end
