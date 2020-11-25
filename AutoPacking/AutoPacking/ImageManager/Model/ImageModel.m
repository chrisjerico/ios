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

+ (NSArray<TagModel *> *)getAllTags {
    NSMutableArray *temp = @[].mutableCopy;
    for (ImageModel *im in ImageModel.allImages) {
        for (NSString *tag in im.tags.allKeys) {
            TagModel *tm = [temp objectWithValue:tag keyPath:@"title"];
            if (tm) {
                tm.cnt += 1;
            } else {
                tm = [TagModel new];
                tm.title = tag;
                tm.cnt = 1;
                [temp addObject:tm];
            }
        }
    }
    return [temp sortedArrayUsingComparator:^NSComparisonResult(TagModel *obj1, TagModel *obj2) {
        return [obj1.title compare:obj2.title];
    }];
}

+ (void)save {
    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:ImageModel.allImages] forKey:AllImagesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - NSMutableArrayDidChangeDelegate

- (void)array:(NSMutableArray *)array didChange:(NSDictionary<NSString *,id> *)change {
    [ImageModel save];
}

@end


@implementation TagModel
MJCodingImplementation
@end
