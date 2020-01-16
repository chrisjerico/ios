//
//  HSC_TitleView.h
//  ug
//
//  Created by xionghx on 2020/1/14.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HSC_TitleViewDelegagte <NSObject>
-(void)loginButtonTaped;
-(void)registButtonnTaped;
-(void)avatarButtonTaped;
-(void)emailButtonTaped;


@end
@interface HSC_TitleView : UIView
@property(nonatomic, weak)id<HSC_TitleViewDelegagte> delegate;

@end

NS_ASSUME_NONNULL_END
