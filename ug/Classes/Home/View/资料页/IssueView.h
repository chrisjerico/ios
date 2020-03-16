//
//  IssueView.h
//  UGBWApp
//
//  Created by fish on 2020/3/15.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 资料页顶部View（上期开奖号码+搜索栏）
@interface IssueView : UIView
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) void(^searchBlock)(NSString * text);
@property (nonatomic, strong) UITextField * searchField;
@property (nonatomic, strong) NSString * preText;

@end

NS_ASSUME_NONNULL_END
