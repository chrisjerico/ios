//
//  LineMainListCollectionViewCell.h
//  ug
//
//  Created by ug on 2020/2/21.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LineMainListBlock)(void);
@class UGPlatformGameModel;
@interface LineMainListCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UGPlatformGameModel *item;
@property (nonatomic, copy) LineMainListBlock refreshBlock;   /**<   刷新按钮被点击 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
