//
//  UIViewController+vcTabName.m
//  UGBWApp
//
//  Created by ug on 2020/3/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UIViewController+vcTabName.h"

@implementation UIViewController (vcTabName)

static const char vcTabName_key = '\0';

- (void)setVcTabName:(NSString*)vcTabName{

objc_setAssociatedObject(self, &vcTabName_key, vcTabName, OBJC_ASSOCIATION_COPY_NONATOMIC);

}

- (NSString*)vcTabName {

  return objc_getAssociatedObject(self, &vcTabName_key);

}


@end
