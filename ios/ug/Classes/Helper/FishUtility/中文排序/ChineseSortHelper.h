//
//  ChineseSortHelper.h
//  C
//
//  Created by fish on 2017/12/19.
//  Copyright © 2017年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseSortGroupModel : NSObject
@property (nonatomic) NSString *key;
@property (nonatomic) NSMutableArray *array;
@end


@interface ChineseSortHelper : NSObject

+ (NSArray <ChineseSortGroupModel *>*)sortedWithStringArray:(NSArray <NSString *>*)array;

+ (NSArray <ChineseSortGroupModel *>*)sortedWithObjectArray:(NSArray <NSObject *>*)array keyPath:(NSString *)keyPath;
@end
