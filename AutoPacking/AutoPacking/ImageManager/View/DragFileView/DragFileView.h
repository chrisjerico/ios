//
//  DragLabel.h
//  AutoPacking
//
//  Created by fish on 2020/11/25.
//  Copyright © 2020 fish. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DragFileView : NSView

@property (nonatomic, strong) void (^didDragging)(BOOL inOrOut);
@property (nonatomic, strong) void (^didDragFiles)(NSArray <NSString *>*urls);
@end

NS_ASSUME_NONNULL_END
