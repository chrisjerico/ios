//
//  UGNoticeTypeModel.h
//  UGBWApp
//
//  Created by xionghx on 2020/5/29.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGNoticeModel.h"
@protocol UGNoticeTypeModel <NSObject>

@end
@interface UGNoticeTypeModel : UGModel

@property (nonatomic, strong) NSArray<UGNoticeModel> *popup;    /**<   弹窗公告 */
@property (nonatomic, strong) NSArray<UGNoticeModel> *scroll;   /**<   滚动公告 */

@property (nonatomic, strong) NSString *popupSwitch;            /**<   1 弹窗。0 不弹窗 */

@end
