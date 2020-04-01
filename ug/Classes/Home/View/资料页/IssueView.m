//
//  IssueView.m
//  UGBWApp
//
//  Created by fish on 2020/3/15.
//  Copyright © 2020 ug. All rights reserved.
//

#import "IssueView.h"
#import "UGLotteryResultCollectionViewCell.h"
#import "UGLotterySubResultCollectionViewCell.h"
#import "UGFastThreeOneCollectionViewCell.h"

/// 开奖信息
@interface IssueView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UILabel *currentIssueLabel;
@property (strong, nonatomic) UILabel *nextIssueLabel;
@property (strong, nonatomic) UILabel *closeTimeLabel;
@property (strong, nonatomic) UILabel *openTimeLabel;
@property (strong, nonatomic) UIView *nextIssueView;
@property (nonatomic, strong) NSArray <NSString *> *preNumArray;
@property (nonatomic, strong) NSArray <NSString *> *subPreNumArray;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation IssueView
static NSString *leftTitleCellid = @"UGTimeLotteryLeftTitleCell";
static NSString *lottryBetCellid = @"UGTimeLotteryBetCollectionViewCell";
static NSString *oneimgCellid = @"UGFastThreeTwoCollectionViewCell";
static NSString *twoImgCellid = @"UGFastThreeThreeCollectionViewCell";
static NSString *threeImgCellid = @"UGFastThreeFourCollectionViewCell";
static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
static NSString *lotteryResultCellid = @"UGFastThreeOneCollectionViewCell";
static NSString *lotterySubResultCellid = @"UGLotterySubResultCollectionViewCell";
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *bgView = [UIView new];


        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(200);
        }];
        
        [self addSubview:self.currentIssueLabel];
        [self.currentIssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.left.equalTo(self).offset(10);
        }];
        
        [self addSubview: self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.currentIssueLabel.mas_right).offset(10);
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self);
            make.height.equalTo(@80);
        }];
        
        UIView * line = ({
            UIView * view = [UIView new];
            view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
            view;
        });
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@0.5);
            make.top.equalTo(self.currentIssueLabel.mas_bottom).offset(50);
        }];
        
        [self addSubview:self.nextIssueLabel];
        [self.nextIssueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.currentIssueLabel);
            make.top.equalTo(line.mas_bottom).offset(15);
        }];
        
        [self addSubview:self.closeTimeLabel];
        [self.closeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.collectionView);
            make.top.equalTo(self.nextIssueLabel);
        }];
        [self addSubview:self.openTimeLabel];
        [self.openTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nextIssueLabel);
            make.left.equalTo(self.closeTimeLabel.mas_right).offset(10);
        }];
        UIButton * searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(searchButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchButton];
        searchButton.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        searchButton.contentMode = UIViewContentModeCenter;
        [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.nextIssueLabel.mas_bottom).offset(20);
            make.width.equalTo(@60);
            make.height.equalTo(@40);
        }];
        
        
        [self addSubview:self.searchField];
        [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchButton.mas_right);
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(searchButton);
            make.top.equalTo(searchButton);
            
        }];
        
        UIView * bottomLine = ({
            UIView * view = [UIView new];
            view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
            view;
        });
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        if (Skin1.isBlack) {
            bgView.backgroundColor = Skin1.bgColor;
            [self.currentIssueLabel setTextColor:[UIColor whiteColor]];
            [self.nextIssueLabel setTextColor:[UIColor whiteColor]];
            [self.closeTimeLabel setTextColor:[UIColor whiteColor]];
            [self.openTimeLabel setTextColor:[UIColor whiteColor]];
        } else {
            bgView.backgroundColor = [UIColor whiteColor];
        }
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        __block int i = 0;
        WeakSelf
        dispatch_source_set_event_handler(self.timer, ^{
            i ++ ;
            [weakSelf updateCloseLabelText];
            [weakSelf updateOpenLabelText];
        });
        dispatch_resume(self.timer);
    }
    return self;
}


- (void)dealloc
{
    dispatch_source_cancel(self.timer);
}
- (void) searchButtonTaped: (UIButton *) sender {
    if (self.searchBlock) {
        self.searchBlock(self.searchField.text);
    }
}
- (dispatch_source_t)timer {
    
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    }
    return _timer;
}
- (void)setNextIssueModel:(UGNextIssueModel *)nextIssueModel {
    _nextIssueModel = nextIssueModel;
    if (nextIssueModel == nil) {
        return;
    }
    self.preNumArray = [nextIssueModel.preNum componentsSeparatedByString:@","];
    if (nextIssueModel.preNumSx.length) {
        self.subPreNumArray = [nextIssueModel.preNumSx componentsSeparatedByString:@","];
    }
    
    if ([@"pcdd" isEqualToString:nextIssueModel.gameType]) {
        NSInteger total = 0;
         for (NSString *num in self.preNumArray) {
             total += num.integerValue;
         }
        NSMutableArray * tempArray = self.preNumArray.mutableCopy;
         [tempArray addObject:@"="];
         [tempArray addObject:[NSString stringWithFormat:@"%ld",total]];
        self.preNumArray = tempArray;
    
    }
    

    
    self.currentIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.preIssue];
    self.nextIssueLabel.text = [NSString stringWithFormat:@"%@期",self.nextIssueModel.curIssue];
    [self updateCloseLabelText];
    [self updateOpenLabelText];
    
}

- (UILabel*)currentIssueLabel {
    if (!_currentIssueLabel) {
        _currentIssueLabel = [UILabel new];
        _currentIssueLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _currentIssueLabel;
}

- (UILabel*)nextIssueLabel {
    if (!_nextIssueLabel) {
        _nextIssueLabel = [UILabel new];
        _nextIssueLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _nextIssueLabel;
}
- (UILabel*)closeTimeLabel {
    if (!_closeTimeLabel) {
        _closeTimeLabel = [UILabel new];
        _closeTimeLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _closeTimeLabel;
}
- (UILabel*)openTimeLabel {
    if (!_openTimeLabel) {
        _openTimeLabel = [UILabel new];
        _openTimeLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _openTimeLabel;
}
- (UITextField *)searchField {
    
    if (!_searchField) {
        _searchField = [UITextField new];
        _searchField.placeholder = @"请输入关键字搜索资料";
        _searchField.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
    }
    return _searchField;
}

- (void)updateCloseLabelText{
    NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curCloseTime currentTimeStr:self.nextIssueModel.serverTime];
    if (self.nextIssueModel.isSeal || timeStr == nil) {
        timeStr = @"封盘中";
    }
    self.closeTimeLabel.text = [NSString stringWithFormat:@"封盘:%@",timeStr];
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.closeTimeLabel.text];
    [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, self.closeTimeLabel.text.length - 3)];
    self.closeTimeLabel.attributedText = abStr;
    
}


- (void)updateOpenLabelText {
    NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curOpenTime currentTimeStr:self.nextIssueModel.serverTime];
    if (timeStr == nil) {
        timeStr = @"获取下一期";
        
    } else {
        
    }
    self.openTimeLabel.text = [NSString stringWithFormat:@"开奖:%@",timeStr];
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.openTimeLabel.text];

    if (Skin1.isBlack) {
        [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3, self.openTimeLabel.text.length - 3)];
    } else {
        [abStr addAttribute:NSForegroundColorAttributeName value:Skin1.navBarBgColor range:NSMakeRange(3, self.openTimeLabel.text.length - 3)];
    }
    self.openTimeLabel.attributedText = abStr;

}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = ({
            layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize = CGSizeMake(24, 24);
            layout.minimumInteritemSpacing = 1;
            layout.minimumLineSpacing = 1;
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            layout.headerReferenceSize = CGSizeMake(300, 3);
            layout;
            
        });
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(120 , 5, UGScreenW - 120 , 100) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"UGLotteryResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGLotteryResultCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"UGLotterySubResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGLotterySubResultCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"UGFastThreeOneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotteryResultCellid];
    }
    return _collectionView;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if ([@"bjkl8" isEqualToString:self.nextIssueModel.gameType]) {
        return 1;
    }
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([@"lhc" isEqualToString:self.nextIssueModel.gameType]) {
        return self.preNumArray.count ? (self.preNumArray.count + 1) : 0;
        
    } else if ([@"pcdd" isEqualToString:self.nextIssueModel.gameType]) {
        if (section == 0) {
               return self.preNumArray.count;
           }
           return self.subPreNumArray.count > 3 ? 3 : self.subPreNumArray.count;
    }
    else if (section == 0){
        return self.preNumArray.count;
    } else {
        return self.subPreNumArray.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UGNextIssueModel * model = self.nextIssueModel;
    
    if ([@"lhc" isEqualToString:model.gameType]) {
        
        if (indexPath.section == 0) {
            
            UGLotteryResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLotteryResultCollectionViewCell" forIndexPath:indexPath];
            cell.showBorder = NO;
            if (indexPath.row == 6) {
                cell.showAdd = YES;
            } else {
                cell.showAdd = NO;
            }
            if (indexPath.row < 6) {
                cell.title = self.preNumArray[indexPath.row];
                cell.color = [CMCommon getHKLotteryNumColorString:self.preNumArray[indexPath.row]];
            }
            if (indexPath.row == 7) {
                cell.title = self.preNumArray[indexPath.row - 1];
                cell.color = [CMCommon getHKLotteryNumColorString:self.preNumArray[indexPath.row - 1]];
            }
            return cell;
        } else {
            UGLotterySubResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLotterySubResultCollectionViewCell" forIndexPath:indexPath];
            if (indexPath.row == 6) {
                cell.showAdd = YES;
            } else {
                cell.showAdd = NO;
            }
            if (indexPath.row < 6) {
                cell.title = self.subPreNumArray[indexPath.row];
            }
            if (indexPath.row == 7) {
                cell.title = self.subPreNumArray[indexPath.row - 1];
            }
            return cell;
        }
        
    } else if ( [@"jsk3" isEqualToString:self.nextIssueModel.gameType]) {
        if (indexPath.section == 0) {
                 
                 UGFastThreeOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotteryResultCellid forIndexPath:indexPath];
                 cell.num = self.preNumArray[indexPath.row];
                 return cell;
             } else {
                     
                 UGLotterySubResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotterySubResultCellid forIndexPath:indexPath];
                 cell.title = self.subPreNumArray[indexPath.row];
                 return cell;
                
             }
    } else if ([@"pcdd" isEqualToString:self.nextIssueModel.gameType]) {
        if (indexPath.section == 0) {
                  
                  UGLotteryResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLotteryResultCollectionViewCell" forIndexPath:indexPath];
                  cell.title = self.preNumArray[indexPath.row];
                  cell.showAdd = NO;
                  cell.showBorder = NO;
                  if (indexPath.row == 3) {
                      cell.showIsequal = YES;
                      cell.showAdd = YES;
                  }
                  return cell;
              } else {
                  UGLotterySubResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLotterySubResultCollectionViewCell" forIndexPath:indexPath];
                  cell.title = self.subPreNumArray[indexPath.row];
                  return cell;
              }
    } else {
        if (indexPath.section == 0) {
            
            UGLotteryResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLotteryResultCollectionViewCell" forIndexPath:indexPath];
            cell.title = self.preNumArray[indexPath.row];
            cell.showAdd = NO;
            cell.showBorder = NO;
            return cell;
        } else {
            UGLotterySubResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGLotterySubResultCollectionViewCell" forIndexPath:indexPath];
            cell.title = self.subPreNumArray[indexPath.row];
            cell.titleColor = UGGreenColor;
            return cell;
        }
    }
}
@end
