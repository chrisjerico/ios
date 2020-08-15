//
//  YNCollectionFootView.m
//  UGBWApp
//
//  Created by andrew on 2020/8/5.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNCollectionFootView.h"
@interface YNCollectionFootView ()
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *bigButton;
@property (weak, nonatomic) IBOutlet UIButton *smallButton;
@property (weak, nonatomic) IBOutlet UIButton *pButton;
@property (weak, nonatomic) IBOutlet UIButton *accidButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;


@end
@implementation YNCollectionFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (Skin1.isBlack||Skin1.is23) {
        self.allButton.titleLabel.textColor = [UIColor whiteColor];
        self.bigButton.titleLabel.textColor = [UIColor whiteColor];
        self.smallButton.titleLabel.textColor = [UIColor whiteColor];
        self.pButton.titleLabel.textColor = [UIColor whiteColor];
        self.accidButton.titleLabel.textColor = [UIColor whiteColor];
        self.removeButton.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.allButton.titleLabel.textColor = Skin1.textColor1;
        self.bigButton.titleLabel.textColor = Skin1.textColor1;
        self.smallButton.titleLabel.textColor = Skin1.textColor1;
        self.pButton.titleLabel.textColor = Skin1.textColor1;
        self.accidButton.titleLabel.textColor = Skin1.textColor1;
        self.removeButton.titleLabel.textColor = Skin1.textColor1;
    }
    
    [self.allButton setBackgroundColor:Skin1.navBarBgColor];
    [self.bigButton setBackgroundColor:Skin1.navBarBgColor];
    [self.smallButton setBackgroundColor:Skin1.navBarBgColor];
    [self.pButton setBackgroundColor:Skin1.navBarBgColor];
    [self.accidButton setBackgroundColor:Skin1.navBarBgColor];
    [self.removeButton setBackgroundColor:Skin1.navBarBgColor];
}

@end
