//
//  UGMenuTableViewCell.h
//  ug
//
//  Created by ug on 2019/5/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGMenuTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *unreadMsg;

@end

NS_ASSUME_NONNULL_END
