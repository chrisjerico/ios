//
//  UGBMHeaderView.m
//  ug
//
//  Created by ug on 2019/10/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBMHeaderView.h"

@implementation UGBMHeaderView

@property (weak, nonatomic) IBOutlet UUMarqueeView *leftwardMarqueeView;    /**<   滚动公告 */

-(instancetype) UGBMHeaderView{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"UGBMHeaderView" owner:nil options:nil];
    return [objs firstObject];
}

-(instancetype)initView{
    if (self = [super init]) {
        self = [self UGBMHeaderView];
    }
    return self;
}

@end
