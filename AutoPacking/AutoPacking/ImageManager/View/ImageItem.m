//
//  ImageItem.m
//  AutoPacking
//
//  Created by fish on 2020/11/24.
//  Copyright © 2020 fish. All rights reserved.
//

#import "ImageItem.h"
#import "NSButton+WebCache.h"

@interface ImageItem ()
@property (weak) IBOutlet NSButton *imageView;
@property (weak) IBOutlet NSTextField *textField;

@end

@implementation ImageItem

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setIm:(ImageModel *)im {
    _im = im;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:im.thumbURL]];
    self.textField.stringValue = [NSString stringWithFormat:@"尺寸：%@\n标签：%@", im.size, [im.tags.allKeys componentsJoinedByString:@","]];
}

- (IBAction)onClick:(NSButton *)sender {
    if (_didClick)
        _didClick();
}

// 拷贝链接
- (IBAction)onCopyLinkBtnClick:(NSButton *)sender {
    [[NSPasteboard generalPasteboard] declareTypes:@[NSPasteboardTypeString] owner:nil];
    switch (sender.tag) {
        case 1:
            [[NSPasteboard generalPasteboard] setString:_im.mediumURL forType:NSPasteboardTypeString];
            break;
        case 2:
            [[NSPasteboard generalPasteboard] setString:_im.thumbURL forType:NSPasteboardTypeString];
            break;
        default:
            [[NSPasteboard generalPasteboard] setString:_im.originalURL forType:NSPasteboardTypeString];
    }
}

@end
