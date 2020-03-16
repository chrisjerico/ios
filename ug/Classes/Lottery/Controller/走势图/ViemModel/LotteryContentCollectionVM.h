//
//  LotteryContentCollectionVM.h
//  ug
//
//  Created by tim swift on 2020/1/19.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryContentCollectionVM : NSObject
- (void)bindCollection: (UICollectionView *)collectionView;
- (void)reloadDataWith: (NSString *) gameMark
            isOfficial: (BOOL) official
      completionHandel: (void(^)(void)) handel;
@end

NS_ASSUME_NONNULL_END
