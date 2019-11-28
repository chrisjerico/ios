//
//  UGScratchMusicView.h
//  ug
//
//  Created by ug on 2019/10/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UGScratchMusicView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
-(instancetype)initView;
@end

NS_ASSUME_NONNULL_END
