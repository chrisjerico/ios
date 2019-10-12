//
//  UGLaunchPageVC.m
//  ug
//
//  Created by xionghx on 2019/10/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLaunchPageVC.h"

@interface LaunchPageModel : UGModel
@property (nonatomic) NSString *pic;
@end
@implementation LaunchPageModel
@end


@interface UGLaunchPageVC ()

@end

@implementation UGLaunchPageVC

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = UIColor.whiteColor;
	UIImageView * imageView = [UIImageView new];
	
	[CMNetwork.manager requestWithMethod:[[NSString stringWithFormat:@"%@/wjapp/api.php?c=system&a=launchImages", baseServerUrl] stringToRestfulUrlWithFlag:RESTFUL]
								  params:nil
								   model:CMResultArrayClassMake(LaunchPageModel.class)
									post:NO
							  completion:^(CMResult<id> *model, NSError *err) {
		NSArray<LaunchPageModel *> * launchPics = model.data;
		[[NSUserDefaults standardUserDefaults] setObject: launchPics.firstObject.pic forKey:@"launchImage"];
	}];
	
	[self.view addSubview:imageView];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	NSString * picURL = [[NSUserDefaults standardUserDefaults]  valueForKey:@"launchImage"];
	[imageView sd_setImageWithURL: [NSURL URLWithString:picURL]];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        APP.Window.rootViewController = [[UGTabbarController alloc] init];
	});
}

@end


