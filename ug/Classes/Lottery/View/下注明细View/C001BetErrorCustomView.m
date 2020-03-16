//
//  C001BetErrorCustomView.m
//  ug
//
//  Created by xionghx on 2020/1/6.
//  Copyright © 2020 ug. All rights reserved.
//

#import "C001BetErrorCustomView.h"
@interface C001BetErrorCustomView()
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;


@end
@implementation C001BetErrorCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)bind:(NSString *)msg {
	self.msgLabel.text = msg;
}
- (IBAction)confirButtonTaped:(id)sender {
	[self removeFromSuperview];
}
- (IBAction)closeButtonTaped:(id)sender {
	[self removeFromSuperview];

}

@end
