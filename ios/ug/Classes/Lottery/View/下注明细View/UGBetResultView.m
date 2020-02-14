//
//  UGBetResultView.m
//  ug
//
//  Created by xionghx on 2019/9/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBetResultView.h"
#import "BetImgView.h"

@interface UGBetResultView()

@property(nonatomic, strong) NSMutableArray<BetImgView *> * numberImgVs;//用于加载球图图片

@property(nonatomic, strong) NSMutableArray<UILabel *> * numberlabels;
@property(nonatomic, strong) NSMutableArray<UILabel *> * resultlabels;
@property(nonatomic, strong) UIImageView * resultImage;
@property(nonatomic, strong) UILabel * bonusLabel;
@property(nonatomic, strong) UILabel * timerLabel;

@property(nonatomic, strong) UIButton* closeButton;
@property(nonatomic, strong) UIButton* timerButton;

@property(nonatomic, strong) dispatch_source_t timer;

@property(nonatomic, strong) void(^timerAction)(dispatch_source_t timer);

@end
@implementation UGBetResultView

static UGBetResultView *_singleInstance = nil;

+ (instancetype)shareInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (_singleInstance == nil) {
			_singleInstance = [[self alloc]init];
		}
	});
	return _singleInstance;
}


- (instancetype)init
{
	self = [super init];
	if (self) {
		self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
		
		UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mmcbackpi"]];
		[self addSubview:image];
		[image mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(self);
			make.centerY.equalTo(self).offset(-60);
		}];
		
		[self addSubview:self.resultImage];
		[self.resultImage mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(image);
			make.top.equalTo(image).offset(160);
			make.width.equalTo(image).multipliedBy(0.4);
			make.height.equalTo(image.mas_width).multipliedBy(0.4*23/56);
		}];
		
		[self addSubview: self.timerButton];
		[self.timerButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(image).offset(-10);
			make.bottom.equalTo(image).offset(-20);
			make.width.height.equalTo(@80);
		}];
		
		[self addSubview: self.closeButton];
		[self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(image).offset(-10);
			make.top.equalTo(image).offset(20);
			make.width.height.equalTo(@80);
		}];
		
        
        {
            UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[({
                // 号码
                UIView *v = [UIView new];
                v.backgroundColor = [UIColor clearColor];
                UIStackView *sv = [UIStackView new];
                [v addSubview:({
                    
                    if (APP.isBall) {
                        sv.spacing = 0;
                        sv.axis = UILayoutConstraintAxisHorizontal;
                        for (int i = 0; i < 10 ; i ++) {
                            BetImgView * bet =  [[BetImgView alloc] initView];
                            [self.numberImgVs addObject:bet];
                            [sv addArrangedSubview:bet];
                            [bet mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.width.height.equalTo(@34);
                            }];
                        }
                    } else {
                        sv.spacing = 3;
                        sv.axis = UILayoutConstraintAxisHorizontal;
                        for (int i = 0; i < 10 ; i ++) {
                            UILabel * label = [UILabel new];
                            label.textColor = UIColor.whiteColor;
                            label.backgroundColor = [UIColor colorWithHex:0x2f9cf3];
                            label.font = [UIFont systemFontOfSize: 12];
                            label.layer.cornerRadius = 2;
                            label.layer.masksToBounds = true;
                            label.textAlignment = NSTextAlignmentCenter;
                            [self.numberlabels addObject:label];
                            [sv addArrangedSubview:label];
                            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.width.height.equalTo(@25);
                            }];
                        }
                    }
                    sv;
                })];
                [sv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.centerX.equalTo(v);
                    make.left.greaterThanOrEqualTo(v);
                }];
                v;
            }), ({
                // 结果
                UIView *v = [UIView new];
                v.tagString = @"第二行结果View";
                v.backgroundColor = [UIColor clearColor];
                UIStackView *sv = [UIStackView new];
                [v addSubview:({
                    sv.spacing = 3;
                    sv.axis = UILayoutConstraintAxisHorizontal;
                    for (int i = 0; i < 10 ; i ++) {
                        UILabel * label = [UILabel new];
                        label.textColor = [UIColor colorWithHex:0x2c962c];
                        label.backgroundColor = [UIColor whiteColor];
                        label.font = [UIFont systemFontOfSize: 10];
                        label.layer.borderWidth = 0.5;
                        label.layer.cornerRadius = 2;
                        label.layer.borderColor = UIColor.grayColor.CGColor;
                        label.textAlignment = NSTextAlignmentCenter;
                        [self.resultlabels addObject:label];
                        [sv addArrangedSubview:label];
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.width.height.equalTo(@25);
                        }];
                    }
                    sv;
                })];
                [sv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.centerX.equalTo(v);
                    make.left.greaterThanOrEqualTo(v);
                }];
                v;
            })]];
            stackView.spacing = 3;
            stackView.axis = UILayoutConstraintAxisVertical;
            [self addSubview:stackView];
            [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(image).offset(4);
                make.centerY.equalTo(image).offset(71);
            }];
        }
		
		[self addSubview: self.bonusLabel];
		[self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(image);
			make.top.equalTo(image.mas_centerY).offset(115);
		}];
		[self addSubview: self.timerLabel];
		
		[self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(image);
			make.top.equalTo(image).offset(20);
		}];
		
	}
	return self;
}


+ (void)showWith:(UGBetDetailModel *)model showSecondLine:(BOOL)showSecondLine timerAction:(void(^)(dispatch_source_t timer))timerAction {
	UGBetResultView * resultView = [UGBetResultView shareInstance] ;

	[resultView removeFromSuperview];
	
	UIWindow * window = [[UIApplication sharedApplication] keyWindow] ;
	
	[window addSubview: resultView];
	
	
	[resultView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(window);
	}];
	
	NSArray<NSString *> * numbers = [model.openNum componentsSeparatedByString: @","];

	for (int i = 0; i < 10; i ++) {
        
        if (APP.isBall) {
            BetImgView * bet = resultView.numberImgVs[i];
            if (i < numbers.count) {
                bet.hidden = false;
                bet.titleLabel.text = numbers[i];
                [bet.ballImgV setImage:[CMCommon getHKLotteryNumColorImg:numbers[i]]];
            } else {
                bet.hidden = true;
            }
        } else {
            UILabel * label = resultView.numberlabels[i];
            if (i < numbers.count) {
                label.hidden = false;
                label.text = numbers[i];
                NSString *color = [CMCommon getHKLotteryNumColorString:numbers[i]];
                if ([@"blue" isEqualToString:color]) {
                     label.backgroundColor = UGRGBColor(86, 170, 236);
                } else if ([@"red" isEqualToString:color]) {
                     label.backgroundColor = UGRGBColor(197, 52, 60);
                } else {
                     label.backgroundColor = UGRGBColor(96, 174, 108);
                }
            } else {
                label.hidden = true;
            }
        }
	}
    
	NSArray<NSString *> * results = [model.result componentsSeparatedByString: @","];
	for (int i = 0; i < 10; i ++) {
		UILabel *label = resultView.resultlabels[i];
		if (i < results.count) {
            label.hidden = false;
			label.text = results[i];
		} else {
            label.hidden = true;
		}
	}
	[resultView viewWithTagString:@"第二行结果View"].hidden = !showSecondLine;
    
	if ([model.bonus floatValue] > 0) {
		resultView.bonusLabel.text = [NSString stringWithFormat:@"+%@", model.bonus];
		resultView.resultImage.image = [UIImage imageNamed:@"mmczjl"];
	} else {
		resultView.bonusLabel.text = @"再接再历";
		resultView.resultImage.image = [UIImage imageNamed:@"mmcwzj"];

	}
	
    resultView.timerAction = timerAction;
}

- (UIButton *)closeButton {
	if (!_closeButton) {
		_closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_closeButton setImage:[UIImage imageNamed:@"guanbi"] forState: UIControlStateNormal];
		[_closeButton addTarget:self action:@selector(closeButtonTaped) forControlEvents: UIControlEventTouchUpInside];
		_closeButton.contentMode = UIViewContentModeCenter;
	}
	return _closeButton;
}


- (UIButton *)timerButton {
	
	if (!_timerButton) {
		
		_timerButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_timerButton setImage:[UIImage imageNamed:@"mmczdtz"] forState: UIControlStateNormal];
		[_timerButton setImage:[UIImage imageNamed:@"mmczt"] forState: UIControlStateSelected];
		
		[_timerButton addTarget:self action:@selector(timerButtonTaped:) forControlEvents: UIControlEventTouchUpInside];
		_timerButton.imageView.contentMode = UIViewContentModeScaleToFill;
	}
	return _timerButton;
}

- (UIImageView *)resultImage {
	
	if (!_resultImage) {
		_resultImage = [[UIImageView alloc] init];
	}
	return _resultImage;
}



- (NSMutableArray<BetImgView *> *)numberImgVs {
    if (!_numberImgVs) {
        _numberImgVs = [NSMutableArray array];
    }
    return _numberImgVs;
}

- (NSMutableArray<UILabel *> *)numberlabels {
	if (!_numberlabels) {
		_numberlabels = [NSMutableArray array];
	}
	return _numberlabels;
}
- (NSMutableArray<UILabel *> *)resultlabels {
	if (!_resultlabels) {
		_resultlabels = [NSMutableArray array];
	}
	return _resultlabels;
}
- (UILabel *)bonusLabel {
	
	if (!_bonusLabel) {
		_bonusLabel = [UILabel new];
		_bonusLabel.textColor = [UIColor colorWithHex:0xdecd67];
		_bonusLabel.font = [UIFont boldSystemFontOfSize:20];
	}
	return _bonusLabel;
}

- (UILabel *)timerLabel {
	if (!_timerLabel) {
		_timerLabel = [UILabel new];
		_timerLabel.textColor = UIColor.whiteColor;
		_timerLabel.font = [UIFont systemFontOfSize:14];
	}
	return _timerLabel;
}




static BOOL preparedToClose = false;
static BOOL paused = true;


- (void)closeButtonTaped {
	if (paused) {
		UGBetResultView * resultView = [UGBetResultView shareInstance] ;
		[resultView removeFromSuperview];
		if (resultView.timer) {
			dispatch_source_cancel(resultView.timer);
			preparedToClose = false;
			paused = true;
		}
		[self.timerButton setSelected:false];
		self.timerLabel.text = nil;
		preparedToClose = false;

	} else {
		preparedToClose = true;
		if (self.timerButton.isSelected) {
			[self timerButtonTaped:self.timerButton];
		}
	}
	
}

- (void)timerButtonTaped: (UIButton *) sender {
	[sender setSelected: !sender.isSelected];
	if (sender.isSelected) {
		preparedToClose = false;
		paused = false;
		__block int i = 0;
		self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
		dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
		dispatch_source_set_event_handler(self.timer, ^{
			i ++ ;
			if (self.timerAction && i%4 == 0) {
				self.timerAction(self.timer);
				self.timerLabel.text = nil;
				if (preparedToClose) {
					dispatch_source_cancel(self.timer);
					paused = true;
				}
			} else {
				self.timerLabel.text = [NSString stringWithFormat:@"倒计时%i秒",(4-i%4)];
			}
		});
		dispatch_resume(self.timer);
	} else {
//		self.timerLabel.text = nil;
//		dispatch_source_cancel(self.timer);
//		paused = true;
		preparedToClose = true;
	}
}


@end
