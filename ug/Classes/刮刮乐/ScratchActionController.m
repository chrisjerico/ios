//
//  ScratchActionController.m
//  UGBWApp
//
//  Created by xionghx on 2020/8/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ScratchActionController.h"
#import "OttoScratchView.h"

@interface ScratchActionController ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *describLabel;
@property (nonatomic, copy) void (^resultBlock)(NSString *);

@property (nonatomic, assign)BOOL didScratch;

@end

@implementation ScratchActionController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.didScratch = false;
	
	// Do any additional setup after loading the view from its nib.
}
- (IBAction)confirmButtonAction:(UIButton *)sender {
	[self dismissViewControllerAnimated:true completion:nil];
	
	
}

// 刮
- (void)scratch: (void (^)(void)) completionHandle {
	
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
							 @"scratchId":self.item.scratchId};
	WeakSelf
	[CMNetwork activityScratchWinWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		completionHandle();
		[CMResult processWithResult:model success:^{
			NSInteger code  = model.code;
			dispatch_async(dispatch_get_main_queue(), ^{
				
				if (code == 0 && weakSelf.resultBlock) {
					weakSelf.resultBlock(weakSelf.item.amount);
				}
				else{
					[SVProgressHUD showErrorWithStatus:model.msg];
				}
			});
			
		} failure:^(id msg) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[SVProgressHUD showErrorWithStatus:msg];
			});
			
		}];
		
	}];
	//	activityGoldenEggWinWithParams
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.confirmButton setSelected:true];
	self.confirmButton.backgroundColor = [UIColor colorWithHex:0x8D65D8];
	UITouch * touch = [touches anyObject];
	CGPoint cententPoint = [touch locationInView:self.coverImage];
	CGRect rect = CGRectMake(cententPoint.x-15, cententPoint.y-15, 30, 30);
	UIGraphicsBeginImageContextWithOptions(self.coverImage.bounds.size, false, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self.coverImage.layer renderInContext:context];
	CGContextClearRect(context, rect);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	self.coverImage.image = image;
	if (self.didScratch) {
		return;
	}
	WeakSelf
	self.didScratch = true;
	[self scratch:^{
		weakSelf.didScratch = true;
	}];
	
	self.describLabel.text = [NSString stringWithFormat:@"彩金%@", self.item.amount];
	
}

- (void)bindNumber:(NSInteger)number resultBlock:(void (^)(NSString * _Nonnull))resultBlock {
	self.resultBlock = resultBlock;
	self.numberLabel.text = [NSString stringWithFormat:@"%ld", number];
}
@end
