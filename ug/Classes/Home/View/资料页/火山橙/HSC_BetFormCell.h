//
//  HSC_BetFormCell.h
//  ug
//
//  Created by tim swift on 2020/1/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSC_BetFormCell : UITableViewCell
- (void)bindName: (NSString *)name
            time: (NSString *)time
   gameImageName: (NSString *)image
          number: (NSString *)number;


@end

NS_ASSUME_NONNULL_END
