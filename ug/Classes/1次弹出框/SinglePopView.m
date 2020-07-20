//
//  SinglePopView.m
//  UGBWApp
//
//  Created by andrew on 2020/7/20.
//  Copyright © 2020 ug. All rights reserved.
//

#import "SinglePopView.h"
#import "SGBrowserView.h"
@interface SinglePopView()

@property (strong, nonatomic) IBOutlet UIView *contentView;


@end

@implementation SinglePopView

static SinglePopView *singlePopView = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singlePopView = [[self alloc] init];
    });
    return singlePopView;
    
}

- (instancetype)init
{
    CGRect frame = CGRectMake(0,0, UGScreenW, UGScreenW*(200.0/375.0));
    self = [super initWithFrame:frame];
    if (self) {
       
        self.contentView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];//(owner:self ，firstObject必要)
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
    }
    return self;
}

- (IBAction)closeBtnClick:(id)sender {
    [SGBrowserView hide];
}
@end
