//
//  UGredEnvelopeView.m
//  ug
//
//  Created by ug on 2019/9/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGredEnvelopeView.h"
#import "UGRedEnvelopeModel.h"

@interface UGredEnvelopeView ()


@end


@implementation UGredEnvelopeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGredEnvelopeView" owner:self options:0].firstObject;
        self.frame = frame;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (IBAction)cancelButtonClick:(id)sender {
    if (self.cancelClickBlock)
        self.cancelClickBlock();
}

- (IBAction)redButtonClick:(id)sender {
    if (self.redClickBlock)
        self.redClickBlock();
}

- (void)setItem:(UGRedEnvelopeModel *)item {
    _item = item;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.redBagLogo]];
}


- (void)setItemSuspension:(UGhomeAdsModel *)item {
    _itemSuspension = item;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.image]];
}
@end
