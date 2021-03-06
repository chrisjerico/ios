//
//  TagItem.m
//  AutoPacking
//
//  Created by fish on 2020/11/24.
//  Copyright © 2020 fish. All rights reserved.
//

#import "TagItem.h"

@interface TagItem ()

@end

@implementation TagItem

- (void)viewDidLoad {
    [super viewDidLoad];
    SYFlatButton *button = [[SYFlatButton alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    button.title = @"Code";
    button.momentary = YES;
    button.cornerRadius = 4.0;
    button.target = self;
    button.action = @selector(onClick:);
    [self.view addSubview:_button = button];
    
    _button.cornerRadius = 10;
    _button.borderWidth = 1;
    _button.borderNormalColor = [NSColor blackColor];
}

- (void)setASelected:(BOOL)aSelected {
    _aSelected = aSelected;
    _button.backgroundNormalColor = aSelected ? [[NSColor lightGrayColor] colorWithAlphaComponent:0.5] : [NSColor whiteColor];
    _button.font = aSelected ? [NSFont boldSystemFontOfSize:11.5] : [NSFont systemFontOfSize:11];
}

- (IBAction)onClick:(SYFlatButton *)sender {
    self.aSelected = !_aSelected;
    if (_didClick)
        _didClick(_aSelected);
}

@end
