//
//  UGSegmentView.h
//  ug
//
//  Created by ug on 2019/7/4.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SegmentIndexBlock)(NSInteger row);
@interface UGSegmentView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) SegmentIndexBlock segmentIndexBlock;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
