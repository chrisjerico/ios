//
//  TKLMainListViewController.h
//  UGBWApp
//
//  Created by fish on 2020/10/23.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGPlatformGameModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TKLMainListViewController : UIViewController
@property (nonatomic, strong)NSMutableArray <UGPlatformGameModel *> *dataArray ;    /**<  数据*/

-(void)dataReLoad;
@end

NS_ASSUME_NONNULL_END
