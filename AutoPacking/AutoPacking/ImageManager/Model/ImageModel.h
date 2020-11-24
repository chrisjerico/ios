//
//  ImageModel.h
//  AppImageManager
//
//  Created by fish on 2020/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel : NSObject

@property (nonatomic, strong) NSString *originalURL;
@property (nonatomic, strong) NSString *mediumURL;
@property (nonatomic, strong) NSString *thumbURL;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, assign) NSTimeInterval updateTime;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSNumber *>*tags;

+ (NSMutableArray <ImageModel *>*)allImages;
+ (NSArray *)getAllTags;
+ (void)save;
@end

NS_ASSUME_NONNULL_END
