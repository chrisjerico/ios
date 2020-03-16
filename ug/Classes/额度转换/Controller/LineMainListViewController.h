//
//  LineMainListViewController.h
//  ug
//
//  Created by ug on 2020/2/21.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGPlatformGameModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LineMainListViewController : UIViewController
@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *dataArray ;    /**<  数据*/

-(void)dataReLoad;
@end

NS_ASSUME_NONNULL_END
