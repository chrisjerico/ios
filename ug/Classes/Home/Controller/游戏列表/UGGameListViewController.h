//
//  UGGameListViewController.h
//  ug
//
//  Created by ug on 2019/6/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGPlatformGameModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGGameListViewController :UGViewController

@property (nonatomic, strong) UGPlatformGameModel *game;

@end

NS_ASSUME_NONNULL_END
