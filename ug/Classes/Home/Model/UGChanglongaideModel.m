//
//  UGChanglongaideModel.m
//  ug
//
//  Created by ug on 2019/5/20.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGChanglongaideModel.h"

@implementation UGChanglongaideModel

- (NSString *)displayNumber {
    return _displayNumber.length ? _displayNumber : _issue;
}

@end
