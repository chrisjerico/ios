//
//  PathDefine.h
//  AutoPacking
//
//  Created by fish on 2019/12/12.
//  Copyright © 2019 fish. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN
//#import "SiteModel.h"

#define Path [PathDefine shared]
#define APPVersion @"1.1.1" // 千万别改，改了code-push可能更新不了

@interface PathDefine : NSObject

@property (nonatomic, readonly) NSString *username;         /**<   当前电脑的用户名 */
@property (nonatomic, readonly) NSString *pwd;              /**<   后台管理账号密码 */
@property (nonatomic, readonly) NSString *privateKey;       /**<   私钥 */
@property (nonatomic, copy) NSString *gitVersion;           /**<   根据git提交次数生成的版本号 */
@property (nonatomic, copy) NSString *commitId;             /**<   此次打包的 git 提交ID */
@property (nonatomic, copy) NSString *gitLog;               /**<   此次打包的 git 提交记录 */

@property (nonatomic, readonly) NSString *jspatchDir;       /**<   jspatch文件目录 */
@property (nonatomic, readonly) NSString *projectDir;       /**<   打包项目目录 */
@property (nonatomic, readonly) NSString *ipaExportDir;     /**<   ipa导出目录 */
@property (nonatomic, readonly) NSString *jsExportDir;      /**<   js导出目录 */
@property (nonatomic, readonly) NSString *shellDir;         /**<   脚本目录 */
@property (nonatomic, readonly) NSString *ipaLogPath;       /**<   ipa发包记录 */
@property (nonatomic, readonly) NSString *jsLogPath;        /**<   热更新发包记录 */

@property (nonatomic, readonly) NSString *tempPlist;        /**<   （临时）plist */
@property (nonatomic, readonly) NSString *tempIpa;          /**<   （临时）ipa */
@property (nonatomic, readonly) NSString *tempXcarchive;    /**<   （临时）Xcode归档包 */
@property (nonatomic, readonly) NSString *tempCiphertext;   /**<   （临时）rsa加密文本 */
@property (nonatomic, readonly) NSString *tempCommitId;     /**<   （临时）git最后一次提交的ID */
@property (nonatomic, readonly) NSString *tempLog;          /**<   （临时）git最后一次提交的记录 */
@property (nonatomic, readonly) NSString *tempVersion;      /**<   （临时）git提交次数 */

+ (instancetype)shared;
@end




@interface SiteModel (Helper)

@property (nonatomic, readonly) NSString *ipaPath;
@property (nonatomic, readonly) NSString *plistPath;
@property (nonatomic, readonly) NSString *xcarchivePath;
@property (nonatomic, readonly) NSString *logPath;

@property (nonatomic, copy) NSString *siteUrl;

@end



NS_ASSUME_NONNULL_END
