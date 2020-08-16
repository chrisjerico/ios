//
//  YNCollectionFootView.h
//  UGBWApp
//
//  Created by andrew on 2020/8/5.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YNCollectionFootView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *bigButton;
@property (weak, nonatomic) IBOutlet UIButton *smallButton;
@property (weak, nonatomic) IBOutlet UIButton *pButton;
@property (weak, nonatomic) IBOutlet UIButton *accidButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@end

NS_ASSUME_NONNULL_END
