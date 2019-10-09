//
//  UGFundsTransferView.h
//  ug
//
//  Created by ug on 2019/9/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  UGchannelModel;

NS_ASSUME_NONNULL_BEGIN

@interface UGFundsTransferView : UIView


@property (nonatomic, strong) UGchannelModel *item;


-(instancetype)initView;

@end

NS_ASSUME_NONNULL_END
