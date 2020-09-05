//
//  UGredEnvelopeView.m
//  ug
//
//  Created by ug on 2019/9/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGredEnvelopeView.h"
#import "UGRedEnvelopeModel.h"

@interface UGredEnvelopeView ()

@property(nonatomic, strong) dispatch_source_t timer;

@end


@implementation UGredEnvelopeView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self = [[NSBundle mainBundle] loadNibNamed:@"UGredEnvelopeView" owner:self options:0].firstObject;
		self.frame = frame;
		[self setBackgroundColor:[UIColor clearColor]];
		
	}
	return self;
}

- (IBAction)cancelButtonClick:(id)sender {
	if (self.cancelClickBlock)
		self.cancelClickBlock();
}

- (IBAction)redButtonClick:(id)sender {
	if (self.redClickBlock)
		self.redClickBlock();
}

- (void)setItem:(UGRedEnvelopeModel *)item {
	_item = item;
	[self setHidden:true];
	if (item) {
		[self.imgView sd_setImageWithURL:[NSURL URLWithString:item.redBagLogo]];
		self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
		dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
		dispatch_source_set_event_handler(_timer, ^{
			WeakSelf
			if (item.show_time.intValue < [NSDate date].timeIntervalSince1970) {
				[weakSelf setHidden:false];
				dispatch_source_cancel(weakSelf.timer);
				weakSelf.timer = nil;
			}
		});
		dispatch_resume(self.timer);
	}
}

-(void)setScratchDataModel:(ScratchDataModel *)scratchDataModel {
	_scratchDataModel = scratchDataModel;
	[self setHidden:true];
	double time = [NSNumber numberWithString:[NSString stringWithFormat:@"%@", scratchDataModel.scratchList[0].param[@"scratchDataModel"]]].doubleValue;
	self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
	dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
	dispatch_source_set_event_handler(_timer, ^{
		WeakSelf
		if (time < [NSDate date].timeIntervalSince1970) {
			[weakSelf setHidden:false];
			dispatch_source_cancel(weakSelf.timer);
			weakSelf.timer = nil;
		}
	});
	dispatch_resume(self.timer);
	
}

- (void)setItemSuspension:(UGhomeAdsModel *)item {
	_itemSuspension = item;
	[self.imgView sd_setImageWithURL:[NSURL URLWithString:item.image]];
}
@end
