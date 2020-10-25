//
//  UGMessagePopView.h
//  UGBWApp
//
//  Created by fish on 2020/10/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^UGMessagePopViewClickBlcok)(void);
@interface UGMessagePopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic)  NSString *content;
@property (nonatomic, copy) UGMessagePopViewClickBlcok clickBllock;
- (void)show;
@end

NS_ASSUME_NONNULL_END
