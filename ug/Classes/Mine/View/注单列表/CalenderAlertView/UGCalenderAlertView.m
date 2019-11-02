//
//  UGCalenderAlertView.m
//  ug
//
//  Created by fish on 2019/10/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGCalenderAlertView.h"
#import "FSCalendar.h"  // 日历控件

@interface UGCalenderAlertView ()<FSCalendarDelegate>
@property (nonatomic) FSCalendar *calendar;

@end


@implementation UGCalenderAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(30, 200, APP.Width-60, 300)];
        _calendar.layer.cornerRadius = 10;
        _calendar.layer.masksToBounds = true;
        _calendar.backgroundColor = [UIColor whiteColor];
        _calendar.delegate = self;
        _calendar.allowsMultipleSelection = false;
        _calendar.scrollEnabled = true;
        _calendar.appearance.headerDateFormat = @"yyyy年M月";
        _calendar.appearance.selectionColor = Skin1.navBarBgColor;
        _calendar.appearance.headerTitleColor = [UIColor blackColor];
        _calendar.appearance.headerMinimumDissolvedAlpha = 0;
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
        // 设置周字体颜色
        _calendar.appearance.weekdayTextColor = [UIColor lightGrayColor];
        _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        _calendar.appearance.todayColor = [UIColor clearColor];
//        [_calendar selectDate:[NSDate date] scrollToDate:true];
        [self addSubview:_calendar];
    }
    
    __weakSelf_(__self);
    // 左箭头
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 40, 45);
        [btn setImage:[UIImage imageNamed:@"jiantouzuo"] forState:UIControlStateNormal];
        [btn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
            [__self.calendar setCurrentPage:[__self.calendar.currentPage dateBySubtractingMonths:1] animated:YES];
        }];
        [_calendar addSubview:btn];
    }
    // 右箭头
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(_calendar.width-40, 0, 40, 45);
        [btn setImage:[UIImage imageNamed:@"jiantouyou"] forState:UIControlStateNormal];
        [btn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
            [__self.calendar setCurrentPage:[__self.calendar.currentPage dateByAddingMonths:1] animated:YES];
        }];
        [_calendar addSubview:btn];
    }
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;
    [_calendar selectDate:selectedDate scrollToDate:true];
}

- (void)show {
    self.frame = APP.Bounds;
    self.alpha = 0;
    [APP.Window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (IBAction)onHideBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}


#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    if (_didSelectedDate)
        _didSelectedDate(date);
    [self removeFromSuperview];
}

@end
