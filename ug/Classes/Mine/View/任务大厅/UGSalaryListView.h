//
//  UGSalaryListView.h
//  UGBWApp
//
//  Created by ug on 2020/4/11.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "UGSignInHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGSalaryListView : UIView

@property (nonatomic, strong) NSArray <UGSignInHistoryModel *> *dataArray;

@property (weak, nonatomic) IBOutlet UIView *bgView;

- (void)show;

@end

NS_ASSUME_NONNULL_END
