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
@property (weak) IBOutlet NSStackView *stackView;

@end

@implementation ImageItem

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setIm:(ImageModel *)im {
    _im = im;
    NSString *size = [[[im.size stringByReplacingOccurrencesOfString:@", " withString:@" x "] stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:im.originalURL]];
    self.textField.stringValue = [NSString stringWithFormat:@"%@\n标签：%@", size, [im.tags.allKeys componentsJoinedByString:@","]];
}

- (IBAction)onClick:(NSButton *)sender {
    if (_didClick)
        _didClick();
}

// 拷贝链接
- (IBAction)onCopyLinkBtnClick:(NSButton *)sender {
    [[NSPasteboard generalPasteboard] declareTypes:@[NSPasteboardTypeString] owner:nil];
    [[NSPasteboard generalPasteboard] setString:_im.originalURL forType:NSPasteboardTypeString];
    if (_didCopy)
        _didCopy();
}

@end
