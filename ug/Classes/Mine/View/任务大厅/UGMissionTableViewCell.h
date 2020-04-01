//
//  UGMissionTableViewCell.h
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGMissionModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^ReceiveMissionBlock)(id );
typedef void(^ReceiveBlock)(id );
@interface UGMissionTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (nonatomic, strong) UGMissionModel *item;
@property (nonatomic, copy) ReceiveMissionBlock receiveMissionBlock;
@property (nonatomic, copy) ReceiveBlock receiveBlock;//cell类似 行点击
@end

NS_ASSUME_NONNULL_END
