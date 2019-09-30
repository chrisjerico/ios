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

@property(nonatomic, strong)NSString * title;
@property(nonatomic, strong)NSString * header;
@property(nonatomic, strong)NSString * content;
@property(nonatomic, strong)NSString * footer;
@property(nonatomic, strong)NSString * hasPayTip;
@property(nonatomic, strong)NSString * notPayTip;
@property(nonatomic, assign)BOOL  hasPay;
@property(nonatomic, assign)BOOL  canRead;
@property(nonatomic, strong)NSString * reason;
@property(nonatomic, assign)CGFloat  amount;
@property(nonatomic, assign)int code;


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
