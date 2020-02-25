//
//  UGNoticePopView.h
//  ug
//
//  Created by ug on 2019/6/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGNoticePopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSString *content;

- (void)show;
@end

NS_ASSUME_NONNULL_END
