//
//  UGSignInScrFootView.h
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SignInScrFootFiveBlock)(void);

typedef void(^SignInScrFootSevenBlock)(void);

@interface UGSignInScrFootView : UIView

@property (nonatomic, strong) NSString *fiveStr;

@property (nonatomic, strong) NSString *sevenStr;

@property (weak, nonatomic) IBOutlet UIButton *fiveButton;

@property (weak, nonatomic) IBOutlet UIButton *sevenButtton;

@property (weak, nonatomic) IBOutlet UIView *fiveView;

@property (weak, nonatomic) IBOutlet UIView *sevenView;

-(instancetype)initView;

@property (nonatomic, copy) SignInScrFootFiveBlock signInScrFootFiveBlock;

@property (nonatomic, copy) SignInScrFootSevenBlock signInScrFootSevenBlock;

@end

NS_ASSUME_NONNULL_END
