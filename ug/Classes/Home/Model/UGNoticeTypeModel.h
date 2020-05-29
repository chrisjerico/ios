//
//  UGNoticeTypeModel.h
//  UGBWApp
//
//  Created by xionghx on 2020/5/29.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UGNoticeTypeModel : UGModel

@property (nonatomic, strong) NSArray<UGNoticeModel> *popup;    /**<   弹窗公告 */
@property (nonatomic, strong) NSArray<UGNoticeModel> *scroll;   /**<   滚动公告 */

@end
