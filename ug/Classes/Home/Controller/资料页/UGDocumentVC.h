//
//  UGDocumentVC.h
//  ug
//
//  Created by xionghx on 2019/9/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCategoryDataModel.h"
#import "UGAllNextIssueListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGDocumentVC :UGViewController

- (instancetype)initWithModel: (GameModel *)model;



@end


@interface IssueView : UIView
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) void(^searchBlock)(NSString * text);
@property (nonatomic, strong) UITextField * searchField;
@property (nonatomic, strong) NSString * preText;


@end

@protocol DocumentModel <NSObject>

@end
@interface DocumentModel : UGModel

@property(nonatomic, strong) NSString * title;
@property(nonatomic, strong) NSString * articleID;
@property(nonatomic, strong) NSString * title_color;
@property(nonatomic, strong) NSString * title_b;
@property(nonatomic, strong) NSString * title_i;
@property(nonatomic, strong) NSString * title_u;
@property(nonatomic, strong) NSString * amount;
@property(nonatomic, strong) NSString * accessRule;
@property(nonatomic, strong) NSString * belongDate;
@property(nonatomic, strong) NSString * createTime;
@property(nonatomic, strong) NSString * updateTime;



@end

@interface DocumentListModel : UGModel

@property(nonatomic, strong) NSArray<DocumentModel> *list;

@end

@interface DocumentCell : UITableViewCell

@end

@interface DocumentTypeList : UIView
@property(nonatomic, assign)int selectedIndex;
+(NSArray<GameModel *> *) allGames;
+(void)setAllGames:(NSArray<GameModel *> *) allGames;
+(void)showIn: (UIView *)supperView
completionHandle: (void(^)(GameModel * model)) block;
@property(nonatomic, strong) void(^completionHandle)(GameModel * selectedModel);

@end

@interface DocumentTypeListCell : UICollectionViewCell
@property(nonatomic, strong)UILabel * titleLabel;

@end
NS_ASSUME_NONNULL_END
