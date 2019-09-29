//
//  UGYYRightMenuTableViewCell.h
//  ug
//
//  Created by ug on 2019/9/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGYYRightMenuTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *imageIconName;

-(void)letArrowHidden;
-(void)letIconHidden;
@end

NS_ASSUME_NONNULL_END
