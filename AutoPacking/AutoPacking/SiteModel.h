//
//  SiteModel.h
//  iOS App Signer
//
//  Created by fish on 2019/11/24.
//  Copyright © 2019 Daniel Radtke. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface SiteModel : NSObject

@property (nonatomic, strong) NSString *siteId; /**<   站点id */
@property (nonatomic, strong) NSString *type;   /**<   打包类型 */
@property (nonatomic, strong) NSString *appName;/**<   app名 */
@property (nonatomic, strong) NSString *appId;  /**<   bundleId */
@property (nonatomic, strong) NSString *host;   /**<   接口域名 */

@property (nonatomic, assign) NSInteger retryCnt;

+ (NSArray *)allSites;
+ (NSArray *)sites:(NSString *)siteIds;
+ (void)checkSiteInfo:(NSString *)siteIds :(NSString *)projectDir; /**<   检查站点配置 */
+ (instancetype)nextSite;
@end

NS_ASSUME_NONNULL_END
