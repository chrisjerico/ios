//
//  HelpDocModel.m
//  UGBWApp
//
//  Created by fish on 2020/10/6.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HelpDocModel.h"

@implementation HelpDocModel

-(instancetype)initWithBtnTitle:(NSString *)title WebName:(NSString *)webName{
    if (self = [super init]) {
        self.btnTitle = title;
        self.webName = webName;
    }
    return self;
}
@end
