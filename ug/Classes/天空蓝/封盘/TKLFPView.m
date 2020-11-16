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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self = [[NSBundle mainBundle] loadNibNamed:@"TKLFPView" owner:self options:0].firstObject;
        self.frame = frame;

        FastSubViewCode(self);
        subView(@"提示View").layer.cornerRadius = 10;
        subView(@"提示View").layer.masksToBounds = YES;
        [subLabel(@"温馨提示label") setBackgroundColor:Skin1.navBarBgColor];
        [subButton(@"关闭button") setBackgroundColor:Skin1.navBarBgColor];
        [CMLabelCommon messageSomeAction:subLabel(@"内容label") changeString:@"已封盘" andMarkColor:[UIColor redColor] andMarkFondSize:17];
        
        subButton(@"关闭button").layer.cornerRadius = 8;

    }
    return self;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

- (IBAction)close:(id)sender {
    [self setHidden:YES];
    if (self.closeBlock) self.closeBlock();
}



@end
