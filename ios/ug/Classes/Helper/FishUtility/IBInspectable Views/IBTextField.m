//
//  IBTextField.m
//  C
//
//  Created by fish on 2018/1/5.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "IBTextField.h"
#import "IBView.h"

@implementation IBTextField

- (void)layoutSubviews {
    [super layoutSubviews];
    [IBView refreshIBEffect:self];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    CGFloat l = [[self valueForKey:@"insetLeft"] doubleValue];
    CGFloat r = [[self valueForKey:@"insetRight"] doubleValue];
    return CGRectMake(l, 0, rect.size.width - l - r, rect.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    CGFloat l = [[self valueForKey:@"insetLeft"] doubleValue];
    CGFloat r = [[self valueForKey:@"insetRight"] doubleValue];
    return CGRectMake(l, 0, rect.size.width - l - r, rect.size.height);
}

@end
