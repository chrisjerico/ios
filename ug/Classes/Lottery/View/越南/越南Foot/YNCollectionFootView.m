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
 
    [self.allButton setBackgroundColor:[UIColor redColor]];
    [self.bigButton setBackgroundColor:Skin1.homeContentColor];
    [self.smallButton setBackgroundColor:Skin1.homeContentColor];
    [self.pButton setBackgroundColor:Skin1.homeContentColor];
    [self.accidButton setBackgroundColor:Skin1.homeContentColor];
    [self.removeButton setBackgroundColor:Skin1.homeContentColor];
}

@end
