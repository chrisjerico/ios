//
//  UGLotteryAdPopView.m
//  ug
//
//  Created by ug on 2019/8/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryAdPopView.h"

// ViewController
#import "UGPCDDLotteryController.h"
#import "UGJSK3LotteryController.h"
#import "UGHKLHCLotteryController.h"
#import "UGBJPK10LotteryController.h"
#import "UGQXCLotteryController.h"
#import "UGSSCLotteryController.h"
#import "UGGD11X5LotteryController.h"
#import "UGBJKL8LotteryController.h"
#import "UGGDKL10LotteryController.h"
#import "UGFC3DLotteryController.h"
#import "UGPK10NNLotteryController.h"

@interface UGLotteryAdPopView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end
@implementation UGLotteryAdPopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGLotteryAdPopView" owner:self options:0].firstObject;
        self.frame = frame;
        self.closeButton.layer.cornerRadius = 6;
        self.closeButton.layer.masksToBounds = YES;
        self.goButton.layer.cornerRadius = 6;
        self.goButton.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setNm:(UGNextIssueModel *)nm {
    _nm = nm;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:nm.adPic] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (IBAction)closeClick:(id)sender {
    [self hiddenSelf];
}

- (IBAction)goClick:(id)sender {
    [self hiddenSelf];
    
    // 去任务大厅
    if ([_nm.adLink isEqualToString:@"-2"]) {
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController") animated:YES];
        return;
    }
    // 去利息宝
    if ([_nm.adLink isEqualToString:@"-1"]) {
        [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
        return;
    }
    // 去彩票下注页面
    for (UGAllNextIssueListModel *listMoel in self.lotteryGamesArray) {
        for (UGNextIssueModel *nextModel in listMoel.list) {
            if ([nextModel.gameId isEqualToString:_nm.adLink]) {
                [self showAdLottery:nextModel];
                break;
            }
        }
    }
}

- (void)show {
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [maskView addSubview:view];
    [window addSubview:maskView];
}

- (void)hiddenSelf {
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
}

- (void)showAdLottery:(UGNextIssueModel *)nextModel {
    if ([@"cqssc" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGSSCLotteryController" bundle:nil];
        UGSSCLotteryController *lotteryVC = [storyboard instantiateInitialViewController];
        lotteryVC.nextIssueModel = nextModel;
        lotteryVC.gameId = nextModel.gameId;
        lotteryVC.lotteryGamesArray = self.lotteryGamesArray;
        lotteryVC.allList = self.allList;
        [NavController1 pushViewController:lotteryVC animated:YES];
    } else if ([@"pk10" isEqualToString:nextModel.gameType] ||
              [@"xyft" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJPK10LotteryController" bundle:nil];
        UGBJPK10LotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.lotteryGamesArray;
        markSixVC.allList = self.allList;
        [NavController1 pushViewController:markSixVC animated:YES];
        
    } else if ([@"qxc" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGQXCLotteryController" bundle:nil];
        UGQXCLotteryController *sevenVC = [storyboard instantiateInitialViewController];
        sevenVC.nextIssueModel = nextModel;
        sevenVC.gameId = nextModel.gameId;
        sevenVC.lotteryGamesArray = self.lotteryGamesArray;
        sevenVC.allList = self.allList;
        [NavController1 pushViewController:sevenVC animated:YES];
        
    } else if ([@"lhc" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGHKLHCLotteryController" bundle:nil];
        UGHKLHCLotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.lotteryGamesArray;
        markSixVC.allList = self.allList;
        [NavController1 pushViewController:markSixVC animated:YES];
        
    } else if ([@"jsk3" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGJSK3LotteryController" bundle:nil];
        UGJSK3LotteryController *fastThreeVC = [storyboard instantiateInitialViewController];
        fastThreeVC.nextIssueModel = nextModel;
        fastThreeVC.gameId = nextModel.gameId;
        fastThreeVC.lotteryGamesArray = self.lotteryGamesArray;
        fastThreeVC.allList = self.allList;
        [NavController1 pushViewController:fastThreeVC animated:YES];
    } else if ([@"pcdd" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPCDDLotteryController" bundle:nil];
        UGPCDDLotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.lotteryGamesArray;
        PCVC.allList = self.allList;
        [NavController1 pushViewController:PCVC animated:YES];
        
    } else if ([@"gd11x5" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGD11X5LotteryController" bundle:nil];
        UGGD11X5LotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.lotteryGamesArray;
        PCVC.allList = self.allList;
        [NavController1 pushViewController:PCVC animated:YES];
        
    } else if ([@"bjkl8" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBJKL8LotteryController" bundle:nil];
        UGBJKL8LotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.lotteryGamesArray;
        PCVC.allList = self.allList;
        [NavController1 pushViewController:PCVC animated:YES];
        
    } else if ([@"gdkl10" isEqualToString:nextModel.gameType] ||
              [@"xync" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGGDKL10LotteryController" bundle:nil];
        UGGDKL10LotteryController *PCVC = [storyboard instantiateInitialViewController];
        PCVC.nextIssueModel = nextModel;
        PCVC.gameId = nextModel.gameId;
        PCVC.lotteryGamesArray = self.lotteryGamesArray;
        PCVC.allList = self.allList;
        [NavController1 pushViewController:PCVC animated:YES];
        
    } else if ([@"fc3d" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGFC3DLotteryController" bundle:nil];
        UGFC3DLotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.lotteryGamesArray;
        markSixVC.allList = self.allList;
        [NavController1 pushViewController:markSixVC animated:YES];
        
    } else if ([@"pk10nn" isEqualToString:nextModel.gameType]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGPK10NNLotteryController" bundle:nil];
        UGPK10NNLotteryController *markSixVC = [storyboard instantiateInitialViewController];
        markSixVC.nextIssueModel = nextModel;
        markSixVC.gameId = nextModel.gameId;
        markSixVC.lotteryGamesArray = self.lotteryGamesArray;
        markSixVC.allList = self.allList;
        [NavController1 pushViewController:markSixVC animated:YES];
        
    } else {
        
    }
}
@end
