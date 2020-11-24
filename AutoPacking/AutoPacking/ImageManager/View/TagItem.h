//
//  TagItem.h
//  AutoPacking
//
//  Created by fish on 2020/11/24.
//  Copyright © 2020 fish. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagItem : NSCollectionViewItem
@property (nonatomic, strong) IBOutlet SYFlatButton *button;
@property (nonatomic, assign) BOOL aSelected;
@property (nonatomic, strong) void (^didClick)(BOOL selected);

@end

NS_ASSUME_NONNULL_END
