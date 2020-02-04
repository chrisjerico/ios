//
//  LHHornView.h
//  ug
//
//  Created by ug on 2020/2/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface LHHornView : UIView
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgGif1;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgGif2;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgGif3;

@property (weak, nonatomic) IBOutlet UILabel *titleLab1;
@property (weak, nonatomic) IBOutlet UILabel *titleLab2;
@property (weak, nonatomic) IBOutlet UILabel *titleLab3;

-(instancetype)initView;
@end

NS_ASSUME_NONNULL_END
