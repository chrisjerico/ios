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
    __weakSelf_(__self);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:im.thumbURL] completed:^(NSImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __self.stackView.arrangedSubviews[2].hidden = [NSStringFromSize(image.size) isEqualToString:im.size];
    }];
    self.textField.stringValue = [NSString stringWithFormat:@"尺寸：%@\n标签：%@", im.size, [im.tags.allKeys componentsJoinedByString:@","]];
    self.stackView.arrangedSubviews[1].hidden = !im.mediumURL || [im.mediumURL isEqualToString:im.originalURL];
    self.stackView.arrangedSubviews[2].hidden = !im.thumbURL || [im.thumbURL isEqualToString:im.originalURL];
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
