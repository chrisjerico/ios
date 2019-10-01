//
//  UGBetResultView.m
//  ug
//
//  Created by xionghx on 2019/9/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBetResultView.h"

@interface UGBetResultView()
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

+ (instancetype)shareInstance
{
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
			make.centerY.equalTo(self);
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
		
		UILabel *tempLabel;
		for (int i = 0; i < 10 ; i ++) {
			UILabel * label = [UILabel new];
			label.textColor = UIColor.whiteColor;
			label.backgroundColor = [UIColor colorWithHex:0x2f9cf3];
			label.font = [UIFont systemFontOfSize: 12];
			label.layer.cornerRadius = 2;
			label.layer.masksToBounds = true;
			label.textAlignment = NSTextAlignmentCenter;
			[self.numberlabels addObject:label];
			[self addSubview:label];
			[label mas_makeConstraints:^(MASConstraintMaker *make) {
				if (tempLabel) {
					make.left.equalTo(tempLabel.mas_right).offset(3);
					make.centerY.equalTo(tempLabel);
				} else {
					make.left.equalTo(image).offset(55);
					make.centerY.equalTo(image).offset(55);
				}
				make.width.height.equalTo(@25);
			}];
			tempLabel = label;
			
		}
		UILabel *tempLabel2;
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
			[self addSubview:label];
			[label mas_makeConstraints:^(MASConstraintMaker *make) {
				if (tempLabel2) {
					make.left.equalTo(tempLabel2.mas_right).offset(3);
					make.centerY.equalTo(tempLabel2);
				} else {
					make.left.equalTo(image).offset(55);
					make.centerY.equalTo(image).offset(85);
				}
				make.width.height.equalTo(@25);
			}];
			tempLabel2 = label;
			
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


+ (void)showWith: (UGBetDetailModel*)model
	 timerAction: (void(^)(dispatch_source_t timer)) timerAction
{
	
	UGBetResultView * resultView = [UGBetResultView shareInstance] ;

	[resultView removeFromSuperview];
	
	UIWindow * window = [[UIApplication sharedApplication] keyWindow] ;
	
	[window addSubview: resultView];
	
	
	[resultView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(window);
	}];
	
	NSArray<NSString *> * numbers = [model.openNum componentsSeparatedByString: @","];

	for (int i = 0; i < 10; i ++) {
		
		if (i<numbers.count) {
			resultView.numberlabels[i].text = numbers[i];

		} else {
			UILabel * label = resultView.numberlabels[i];
			label.text = @"";
			label.backgroundColor = UIColor.clearColor;

		}
		
	}
	NSArray<NSString *> * results = [model.result componentsSeparatedByString: @","];

	for (int i = 0; i < 10; i ++) {
		
		if (i<results.count) {
			resultView.resultlabels[i].text = results[i];

		} else {
			UILabel * label = resultView.resultlabels[i];
			label.text = @"";
			label.backgroundColor = UIColor.clearColor;
			label.layer.borderColor = UIColor.clearColor.CGColor;

		}
		
	}
	

	
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
		[_closeButton addTarget:self action:@selector(closeButtonTaped:) forControlEvents: UIControlEventTouchUpInside];
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


- (void) closeButtonTaped: (UIButton *) sender {
	UGBetResultView * resultView = [UGBetResultView shareInstance] ;
	[resultView removeFromSuperview];
	if (resultView.timer) {
		dispatch_source_cancel(resultView.timer);
	}
	[self.timerButton setSelected:false];
	self.timerLabel.text = nil;

	
}
- (UIImageView *)resultImage {
	
	if (!_resultImage) {
		_resultImage = [[UIImageView alloc] init];
	}
	return _resultImage;
}
- (void) timerButtonTaped: (UIButton *) sender {
	[sender setSelected: !sender.isSelected];
	if (sender.isSelected) {
		
		__block int i = 0;
		self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
		dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
		dispatch_source_set_event_handler(self.timer, ^{
			i ++ ;
			if (self.timerAction && i%4 == 0) {
				self.timerAction(self.timer);
				self.timerLabel.text = nil;
			} else {
				self.timerLabel.text = [NSString stringWithFormat:@"倒计时%i秒",(4-i%4)];
			}
		});
		dispatch_resume(self.timer);
	} else {
		self.timerLabel.text = nil;
		dispatch_source_cancel(self.timer);
	}
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

@end
