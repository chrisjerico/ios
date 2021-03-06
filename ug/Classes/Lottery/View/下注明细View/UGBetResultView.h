//
//  UGBetResultView.h
//  ug
//
//  Created by xionghx on 2019/9/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGBetDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGBetResultView : UIView

- (instancetype)initWithShowSecondLine :(BOOL)showSecondLine;

-(void)showWith:(UGBetDetailModel *)model showSecondLine:(BOOL)show timerAction:(void(^)(dispatch_source_t timer))timerAction;

- (void)closeButtonTaped;

-(void)betWith:(NSDictionary *) params
		gameId:(NSString *)gameId
	  betBlock: (void(^)(void)) betClickBlock;
@end

NS_ASSUME_NONNULL_END
