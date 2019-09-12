//
//  YLEdgeLabel.h
//  ug
//
//  Created by ug on 2019/9/11.
//  Copyright © 2019 ug. All rights reserved.
// 

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLEdgeLabel : UILabel

@property (nonatomic, assign) IBInspectable CGFloat topEdge;
@property (nonatomic, assign) IBInspectable CGFloat leftEdge;
@property (nonatomic, assign) IBInspectable CGFloat bottomEdge;
@property (nonatomic, assign) IBInspectable CGFloat rightEdge;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@end

NS_ASSUME_NONNULL_END
