//
//  TKLFPView.m
//  UGBWApp
//
//  Created by andrew on 2020/11/16.
//  Copyright © 2020 ug. All rights reserved.
//

#import "TKLFPView.h"
#import "CMLabelCommon.h"
@implementation TKLFPView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    FastSubViewCode(self);
    [subLabel(@"温馨提示label") setBackgroundColor:Skin1.navBarBgColor];
    [subButton(@"关闭button") setBackgroundColor:Skin1.navBarBgColor];
    [CMLabelCommon messageSomeAction:subLabel(@"内容label") changeString:@"已封盘" andMarkColor:[UIColor redColor] andMarkFondSize:17];
    
    subButton(@"关闭button").layer.cornerRadius = 8;
}

- (IBAction)close:(id)sender {
    if (self.closeBlock) self.closeBlock();
}



@end
