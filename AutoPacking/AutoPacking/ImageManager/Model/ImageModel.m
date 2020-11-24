//
//  ImageModel.m
//  AppImageManager
//
//  Created by fish on 2020/11/24.
//

#import "ImageModel.h"
#import "NSMutableArray+KVO.h"

#define AllImagesKey @"allImagesA5"

@interface ImageModel ()<NSMutableArrayDidChangeDelegate>

@end

@implementation ImageModel

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[];
}

MJCodingImplementation

+ (instancetype)shared {
    static ImageModel *im = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        im = [ImageModel new];
    });
    return im;
}

+ (NSMutableArray<ImageModel *> *)allImages {
    static NSMutableArray<ImageModel *> *ims = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ims = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:AllImagesKey]]];
        [ims addObserver:[ImageModel shared]];
    });
    return ims;
}

+ (NSArray *)getAllTags {
    NSMutableDictionary *dict = @{}.mutableCopy;
    for (ImageModel *im in ImageModel.allImages) {
        [dict addEntriesFromDictionary:im.tags];
    }
    return [dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
}

+ (void)save {
    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:ImageModel.allImages] forKey:AllImagesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -

- (NSString *)mediumURL {
    return _mediumURL ? : _originalURL;
}

- (NSString *)thumbURL {
    return _thumbURL ? : _originalURL;
}


#pragma mark - NSMutableArrayDidChangeDelegate

- (void)array:(NSMutableArray *)array didChange:(NSDictionary<NSString *,id> *)change {
    [ImageModel save];
}

@end
