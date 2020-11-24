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
    SYFlatButton *button = [[SYFlatButton alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
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

- (IBAction)onClick:(SYFlatButton *)sender {
    self.selected = !self.selected;
    _button.backgroundNormalColor = self.selected ? [[NSColor lightGrayColor] colorWithAlphaComponent:0.5] : [NSColor whiteColor];
    _button.font = self.selected ? [NSFont boldSystemFontOfSize:13] : [NSFont systemFontOfSize:11];
    if (_didClick)
        _didClick(self.selected);
}

@end
