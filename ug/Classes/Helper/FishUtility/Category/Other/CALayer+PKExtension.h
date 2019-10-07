//
//  CALayer+PKExtension.h
//  pk
//
//  Created by Jack on 2019/6/24.
//  Copyright © 2019 fish. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (PKExtension)

- (void)pk_pauseAnimation;
- (void)pk_resumeAnimation;

@end

NS_ASSUME_NONNULL_END
