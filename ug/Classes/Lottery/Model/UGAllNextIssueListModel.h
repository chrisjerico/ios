//
//  UGNextIssueModel.h
//  ug
//
//  Created by ug on 2019/5/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UGNextIssueModel <NSObject>

@end
@interface UGNextIssueModel : UGModel<UGNextIssueModel>

@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, assign) NSInteger fromType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *serverTime;
@property (nonatomic, assign) BOOL isSeal;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) bool isInstant;
@property (nonatomic, strong) NSString *customise;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *openCycle;

@property (nonatomic, strong) NSString *curIssue;
@property (nonatomic, strong) NSString *curCloseTime;
@property (nonatomic, strong) NSString *curOpenTime;
@property (nonatomic, strong) NSString *nums;
@property (nonatomic, strong) NSString *preIssue;
@property (nonatomic, strong) NSString *preOpenTime;
@property (nonatomic, strong) NSString *preNum;
@property (nonatomic, strong) NSString *preNumColor;
@property (nonatomic, strong) NSString *preNumSx;
@property (nonatomic, strong) NSArray *winningPlayers;
@property (nonatomic, strong) NSString *preNumStringWin;
@property (nonatomic, assign) BOOL preIsOpen;
@property (nonatomic, strong) NSString *dataNum;
@property (nonatomic, strong) NSString *totalNum;

//弹窗广告
@property (nonatomic, strong) NSString *adPic;
@property (nonatomic, strong) NSString *adLink;
@property (nonatomic, assign) BOOL adEnable;

@end

@protocol UGAllNextIssueListModel <NSObject>

@end
@interface UGAllNextIssueListModel : UGModel<UGAllNextIssueListModel>

@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, strong) NSString *gameTypeName;
@property (nonatomic, strong) NSArray<UGNextIssueModel> *list;

@end

NS_ASSUME_NONNULL_END
