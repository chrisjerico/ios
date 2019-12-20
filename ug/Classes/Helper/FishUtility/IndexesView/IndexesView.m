//
//  IndexesView.m
//  Pwd
//
//  Created by xuzejia Joe on 2019/5/9.
//  Copyright © 2019 xuzejia Joe. All rights reserved.
//

#import "IndexesView.h"

@interface IndexesView ()
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UILabel *bigIndexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@end

@implementation IndexesView

- (void)awakeFromNib {
    [super awakeFromNib];
    _bigIndexLabel.superview.alpha = 0;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    [_stackView removeAllSubviews];
    for (NSString *title in titles) {
        UILabel *lb = [UILabel new];
        lb.text = title;
        lb.textColor = UIColorRGB(75, 75, 75);
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:12];
        [_stackView addArrangedSubview:lb];
    }
}

- (void)hideSearchIcon {
    _searchImageView.hidden = true;
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self onPan:(id)sender];
}

- (IBAction)onPan:(UIPanGestureRecognizer *)pan {
    UIStackView *sv = _stackView;
    CGFloat y1 = [pan locationInView:pan.view].y;
    NSInteger idx = -1;
    if (y1 < 0) {
        idx = -1;
    } else {
        idx = y1/pan.view.height * sv.arrangedSubviews.count;
        idx = MAX(MIN(idx, sv.arrangedSubviews.count-1), 0);
        UILabel *idxLabel = sv.arrangedSubviews[idx];
        
        _bigIndexLabel.text = idxLabel.text;
        _bigIndexLabel.superview.alpha = 1;
        _bigIndexLabel.superview.cc_constraints.top.constant = pan.view.y + idxLabel.y + idxLabel.height/2 - _bigIndexLabel.superview.height/2 + 2;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded ||
        pan.state == UIGestureRecognizerStateCancelled ||
        pan.state == UIGestureRecognizerStateFailed) {
        [UIView animateWithDuration:0.25 delay:0.25 options:UIViewAnimationOptionCurveLinear animations:^{
            self.bigIndexLabel.superview.alpha = 0;
        } completion:nil];
    }
    
    if (_didSelectedIndex)
        _didSelectedIndex(idx);
}

@end
