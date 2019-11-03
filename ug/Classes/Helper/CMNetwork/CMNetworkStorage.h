//
//  CMNetworkStorage.h

//

#import "SAROPSessionStorage.h"
#import "UGAllNextIssueListModel.h"

@interface CMNetworkStorage : SAROPSessionStorage
/// 用户名
@property (nonatomic, copy) NSString *account;
/// 是否调用登录接口进入大厅
@property (nonatomic, assign) BOOL isLogined;
@property (nonatomic, assign) BOOL fastRegister;
@property (nonatomic, assign) BOOL wechatRegister;

@property (nonatomic, strong) NSString *serverName;
@property (nonatomic, strong) NSArray<UGAllNextIssueListModel *> *lotteryGamesArray;


@end
