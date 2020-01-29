//
//  UGDepositDetailsCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/9/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGDepositDetailsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (strong, nonatomic) NSString *myStr;
@end

NS_ASSUME_NONNULL_END
