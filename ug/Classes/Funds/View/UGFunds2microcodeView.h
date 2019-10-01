//
//  UGFunds2microcodeView.h
//  ug
//
//  Created by ug on 2019/9/13.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^Funds2microcodelBlock)(void);

@interface UGFunds2microcodeView : UGView
@property (nonatomic, strong) NSString *headerImageStr;
@property (nonatomic, copy) Funds2microcodelBlock showBlock;

@end

NS_ASSUME_NONNULL_END
