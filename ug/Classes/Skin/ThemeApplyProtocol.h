//
//  ThemeApplyProtocol.h
//  ug
//
//  Created by xionghx on 2020/1/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGSkinManagers.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ThemeApplyProtocol <NSObject>
-(void)apply: (UGSkinManagers *)skin;
@end

NS_ASSUME_NONNULL_END
