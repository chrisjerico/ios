//
//  YNCollectionFootView.m
//  UGBWApp
//
//  Created by andrew on 2020/8/5.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNCollectionFootView.h"
@interface YNCollectionFootView ()



@end
@implementation YNCollectionFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
    [self.allButton setBackgroundColor:Skin1.navBarBgColor];
    [self.bigButton setBackgroundColor:Skin1.navBarBgColor];
    [self.smallButton setBackgroundColor:Skin1.navBarBgColor];
    [self.pButton setBackgroundColor:Skin1.navBarBgColor];
    [self.accidButton setBackgroundColor:Skin1.navBarBgColor];
    [self.removeButton setBackgroundColor:Skin1.navBarBgColor];
    
    
    [self setBigButton:self.allButton];
    [self setBigButton:self.bigButton];
    [self setBigButton:self.smallButton];
    [self setBigButton:self.pButton];
    [self setBigButton:self.accidButton];
    [self setBigButton:self.removeButton];
}

-(void)setBtnradius:(UIButton *)btn{
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
}

@end
