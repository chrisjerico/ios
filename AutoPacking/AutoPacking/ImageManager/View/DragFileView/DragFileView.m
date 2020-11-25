//
//  DragFileView.m
//  AutoPacking
//
//  Created by fish on 2020/11/25.
//  Copyright © 2020 fish. All rights reserved.
//

#import "DragFileView.h"

@interface DragFileView ()
@end

@implementation DragFileView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSPasteboardTypeFileURL, nil]];
}

- (NSDragOperation)draggingEntered:(id)sender {
    if (_didDragging)
        _didDragging(true);
    return NSDragOperationCopy;
}

-(void)draggingExited:(id)sender {
    if (_didDragging)
        _didDragging(false);
}

-(BOOL)prepareForDragOperation:(id)sender {
    if (_didDragging)
        _didDragging(false);
    return YES;
}

- (BOOL)performDragOperation:(id)sender {
    if ([sender draggingSource] != self) {
        NSArray *filePaths = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
        if (_didDragFiles)
            _didDragFiles(filePaths);
    }
    return YES;
}

@end
