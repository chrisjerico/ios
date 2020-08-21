//
//  UGLHOldYearViewController.m
//  ug
//
//  Created by ug on 2019/11/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHOldYearViewController.h"
#import "UGLHLhlModel.h"
#import "STBarButtonItem.h"
#import "STPickerDate.h"
#import "CMNetwork.h"
#import "CMTimeCommon.h"
@interface UGLHOldYearViewController ()<STPickerDateDelegate>{
    NSString *currentSelDataStr;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *reghtBtn;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgV;

@end

@implementation UGLHOldYearViewController

- (BOOL)允许游客访问 { return true; }
- (BOOL)允许未登录访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 按屏幕比例缩放（因为等比例约束太复杂，所以直接缩放得了）
    CGFloat scale = APP.Width/414;
    _contentView.transform = CGAffineTransformMakeScale(scale, scale);
//    _contentView.cc_constraints.bottom.constant = APP.BottomSafeHeight;
    
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"riqi" target:self action:@selector(rightBarButtonItemClick)];
    
    [self imgVButtonInteractionEnabled];
    NSString *dataStr = [CMTimeCommon currentDateString];
    //    NSLog(@"dataStr= %@",dataStr);
    [self getlhlDetail:dataStr];
    
}
#pragma mark ---------------- 网络请求
// 老黄历
- (void)getlhlDetail:(NSString *)dataStr{
    
    currentSelDataStr = dataStr;
    [SVProgressHUD showWithStatus:nil];
    [self imgVButtonInteractionNoEnabled];
    //    NSLog(@"currentSelDataStr= %@",currentSelDataStr);
    NSDictionary *params = @{@"date":dataStr};
    WeakSelf;
    [CMNetwork lhlDetailWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGLHLhlModel *obj =   ((UGLHLhlModel*)model.data);
            //               NSLog(@"obj = %@",obj);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [weakSelf imgVButtonInteractionEnabled];
                if (obj) {
                    [weakSelf setLHLDate:obj];
                }
                else{
                   [weakSelf setLHLNillDate];
                }
            });
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            [weakSelf imgVButtonInteractionEnabled];
            
        }];
    }];
}

-(void)setLHLNillDate {
    FastSubViewCode(self.view)
    subLabel(@"月份中文label").text = @"";
    subLabel(@"月份英文label").text = @"";
    subLabel(@"年份label").text = @"";
    subLabel(@"数字label").text = @"";
    subLabel(@"中label").text = @"";
    subLabel(@"星期label").text = @"";
    subLabel(@"日期label").text = @"";
    subLabel(@"宜详细label").text = @"";
    subLabel(@"吉神宜趋详细label").text = @"";
    subLabel(@"六合吉数详细label").text = @"";
    subLabel(@"凶煞宜忌详细label").text = @"";
    subLabel(@"忌详细label").text = @"";
    subLabel(@"时辰吉凶详细label").text = @"";
    subLabel(@"冲煞详细label").text = @"";
    subLabel(@"天干地支详细label").text = @"";
    subLabel(@"喜神详细label").text = @"";
    subLabel(@"福神详细label").text = @"";
    subLabel(@"财神详细label").text = @"";
    subLabel(@"白忌详细label").text = @"";
    subLabel(@"日五行详细label").text = @"";
   
}


-(void)setLHLDate :(UGLHLhlModel *)obj{
    FastSubViewCode(self.view)
    subLabel(@"月份中文label").text = [NSString stringWithFormat:@"%d月",obj.info.monthEN];
    subLabel(@"月份英文label").text = obj.info.weekEN;
    subLabel(@"年份label").text = [NSString stringWithFormat:@"%@",obj.info.yearEN];
    subLabel(@"数字label").text = [NSString stringWithFormat:@"%d",obj.info.dayEN];
    subLabel(@"中label").text = [NSString stringWithFormat:@"%@  %@  %@",obj.info.yearCN,obj.info.monthCN,obj.info.dayCN];
    subLabel(@"星期label").text = [NSString stringWithFormat:@"%@",obj.info.weekCN];;
    subLabel(@"日期label").text = [NSString stringWithFormat:@"%@",obj.info.dayCN];
    subLabel(@"宜详细label").text = [NSString stringWithFormat:@"%@",obj.info.yi];
    subLabel(@"吉神宜趋详细label").text = [NSString stringWithFormat:@"%@",obj.info.jiShenYiQu];
    subLabel(@"六合吉数详细label").text = [NSString stringWithFormat:@"%@",obj.info.luckyNumber];
    subLabel(@"凶煞宜忌详细label").text = [NSString stringWithFormat:@"%@",obj.info.xiongShaYiJi];
    subLabel(@"忌详细label").text = [NSString stringWithFormat:@"%@",obj.info.ji];
    subLabel(@"时辰吉凶详细label").text = [NSString stringWithFormat:@"%@",obj.info.jiShi];
    subLabel(@"冲煞详细label").text = [NSString stringWithFormat:@"%@",obj.info.chongSha];
    subLabel(@"天干地支详细label").text = [NSString stringWithFormat:@"%@",obj.info.ganZhi];
    subLabel(@"喜神详细label").text = [NSString stringWithFormat:@"%@",obj.info.xiShen];
    subLabel(@"福神详细label").text = [NSString stringWithFormat:@"%@",obj.info.fuShen];
    subLabel(@"财神详细label").text = [NSString stringWithFormat:@"%@",obj.info.caiShen];
    subLabel(@"白忌详细label").text = [NSString stringWithFormat:@"%@",obj.info.baiJi];
    subLabel(@"日五行详细label").text = [NSString stringWithFormat:@"%@",obj.info.riWuXing];
   
}
#pragma mark ---------------- 其他方法

-(void)imgVButtonInteractionEnabled{
    self.leftBtn.userInteractionEnabled = YES;
    self.reghtBtn.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageNamed:@"LH_icon_left"];
    UIImage *afterImage = [image qmui_imageWithBlendColor: RGBA(173, 88, 0, 1)];
    self.leftImgV.image = afterImage;
    {
        UIImage *image = [UIImage imageNamed:@"LH_icon_right"];
        UIImage *afterImage = [image qmui_imageWithBlendColor: RGBA(173, 88, 0, 1)];
        self.rightImgV.image = afterImage;
    }

}

-(void)imgVButtonInteractionNoEnabled{
    self.leftBtn.userInteractionEnabled = NO;
    self.reghtBtn.userInteractionEnabled = NO;
    UIImage *image = [UIImage imageNamed:@"LH_icon_left"];
    self.leftImgV.image = image;
    {
        UIImage *image = [UIImage imageNamed:@"LH_icon_right"];
         self.rightImgV.image = image;
    }
}
- (void)rightBarButtonItemClick {
    STPickerDate *pickerDate = [[STPickerDate alloc]init];
    [pickerDate setYearLeast:2000];
    [pickerDate setYearSum:50];
    [pickerDate setDelegate:self];
    [pickerDate show];
    
}
- (IBAction)leftClicked:(id)sender {
//    NSLog(@"leftClicked");
    [self getlhlDetail:[CMTimeCommon lastDayStr:currentSelDataStr format:@"YYYYMMdd"]];
}
- (IBAction)rightClicked:(id)sender {
//    NSLog(@"rightClicked");
    [self getlhlDetail:[CMTimeCommon nextDayStr:currentSelDataStr format:@"YYYYMMdd"]];
}

- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *monthStr  = @"";
    if (month < 10) {
        monthStr = [NSString stringWithFormat:@"0%zd",month];
    } else {
        monthStr = [NSString stringWithFormat:@"%zd",month];
    }
//    NSLog(@"monthStr = %@",monthStr);
    
    NSString *dayStr  = @"";
    if (day < 10) {
        dayStr = [NSString stringWithFormat:@"0%zd",day];
    } else {
        dayStr = [NSString stringWithFormat:@"%zd",day];
    }
//    NSLog(@"dayStr = %@",dayStr);
    
    NSString *dataStr = [NSString stringWithFormat:@"%zd%@%@", year, monthStr, dayStr];
//    NSLog(@"dataStr = %@",dataStr);
    [self getlhlDetail:dataStr];
}

@end
