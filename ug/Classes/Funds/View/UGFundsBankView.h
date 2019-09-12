//
//  UGFundsBankView.h
//  ug
//
//  Created by ug on 2019/9/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UGFundsBankViewBlock)(id model);

@interface UGFundsBankView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSString *nameStr;

@property (nonatomic, copy) UGFundsBankViewBlock signInHeaderViewnBlock;

- (void)show;

@end

NS_ASSUME_NONNULL_END
