//
//  JS_TitleView.h
//  ug
//
//  Created by xionghx on 2020/1/9.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JS_TitleViewDelegagte <NSObject>
-(void)loginButtonTaped;
-(void)registButtonnTaped;
-(void)moreButtonTaped;
@end
@interface JS_TitleView : UIView
@property(nonatomic, weak)id<JS_TitleViewDelegagte> delegate;
@end

NS_ASSUME_NONNULL_END
