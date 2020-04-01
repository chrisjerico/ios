//
//  UGDocumentView.h
//  ug
//
//  Created by xionghx on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGDocumentDetailVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGDocumentView : UIView
@property(nonatomic, strong)UGDocumentDetailData * model;
+ (void)showWith: (UGDocumentDetailData *) model;
+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
