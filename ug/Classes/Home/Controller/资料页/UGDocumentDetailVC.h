//
//  UGDocumentDetailVC.h
//  ug
//
//  Created by xionghx on 2019/9/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGDocumentDetailData : UGModel

@property(nonatomic) NSString *title;       /**<   标题 */
@property(nonatomic) NSString *header;
@property(nonatomic) NSString *content;     
@property(nonatomic) NSString *footer;
@property(nonatomic) NSString *hasPayTip;
@property(nonatomic) NSString *notPayTip;
@property(nonatomic) BOOL hasPay;
@property(nonatomic) BOOL canRead;
@property(nonatomic) NSString *reason;
@property(nonatomic) CGFloat amount;
@property(nonatomic) int code;


@end

@interface UGDocumentDetailVC : UIViewController

@property(nonatomic, strong)UGDocumentDetailData * model;


@end




@interface UILabel (HTML)

@property(nonatomic, strong)NSString * htmlString;
@end
@interface UITextView (HTML)

@property(nonatomic, strong)NSString * htmlString;
@end


NS_ASSUME_NONNULL_END
