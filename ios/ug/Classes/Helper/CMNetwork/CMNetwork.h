//
//  CMNetWork.h

#import "JSONModel.h"

@class CMNetworkStorage;
///
/// 限制器
///
typedef struct CMSpliteLimiter {
    NSInteger page;
    NSInteger size;
} CMSpliteLimiter;

///
/// @brief 网络模型类型
///
typedef id CMResultClass;


///
/// 结果容器
///
@interface CMResult<Target> : JSONModel

/// 状态
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *msg;

/// 目标数据
@property (nonatomic, strong) Target data;

///
/// @brief 检查
///
NSString* CMResultCheck(CMResult* result, NSError* error);
///
/// @brief 生成JSON信息
///
/// @param JSON         json数据
/// @param dataClass    data的类型
/// @param error        错误信息
///
+ (instancetype)resultWithJSON:(id)JSON dataClass:(Class)dataClass error:(NSError**)error;

///
/// @bief 处理错误, 失败将弹出错误
///
/// @param result 结果
/// @param success 成功回调
///
+ (void)processWithResult:(id)result success:(void(^)(void))success;
///
/// @bief 处理错误
///
/// @param result 结果
/// @param failure 失败回调
/// @param success 成功回调
///
+ (void)processWithResult:(id)result success:(void(^)(void))success failure:(void(^)(id msg))failure;

@end

///
/// @brief 用一个闭包来处理数据和错误, 当前操作完成后你将获得一个模型或者一个错误
///
/// @param model 该请求对应的模型
/// @param err 该请求失败时的所有数据
///

//typedef void (^CMNetworkBlock)(NSDictionary * model, NSError* err);

typedef void (^CMNetworkBlock)(CMResult<id>* model, NSError* err);


///
/// 分页结果容器
///
@interface CMSpliteResult<Target> : CMResult<Target>
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger lastPage;
@property (nonatomic, strong) NSString* tag;

@property (nonatomic, assign) NSInteger count; // 总页数
@end

///
/// @brief 网络管理
///
@interface CMNetwork : NSObject


///
/// 网络实例
///
+(instancetype)manager;
// 存储单元
+(CMNetworkStorage*)storage;

//下载文件
+ (void)dowdloadFileWithUrl:(NSURL *)loadUrl completionBlock:(void(^)(NSURL *filePath))completionBlock;

///
/// @brief 请求数据
///
/// @param method       方法
/// @param params       附加参数
/// @param model       响应结果类型
/// @param completion   结果回调
///
- (void)requestWithMethod:(NSString*)method
params:(NSDictionary*)params
model:(CMResultClass)model
post:(BOOL)isPost
completion:(CMNetworkBlock)completion;

///
/// @brief 请求数据(结果在主线程)
///
/// @param method       方法
/// @param params       附加参数
/// @param model       响应结果类型
/// @param completion   结果回调
///
- (void)requestInMainThreadWithMethod:(NSString*)method
params:(NSDictionary*)params
model:(CMResultClass)model
post:(BOOL)isPost
completion:(CMNetworkBlock)completion;

#pragma mark -

///
/// @brief 获取重定向地址
///
- (NSURL*)redirectURLWithURL:(NSString*)url;

/******************************************************************************
 函数名称 : encryptionCheckSignForURL;
 函数描述 : url参数加密
 输入参数 : url
 输出参数 : NSString 加密后url
 返回参数 : NSString 加密后url
 备注信息 :
 ******************************************************************************/

+(NSString*)encryptionCheckSignForURL:(NSString*)url;

/******************************************************************************
 函数名称 : encryptionCheckSignC;
 函数描述 : 网络请求的，游戏获得的url参数加密
 输入参数 : NSDictionary 参数
 输出参数 : NSMutableDictionary 加密后参数
 返回参数 : NSMutableDictionary 加密后参数
 备注信息 :
 ******************************************************************************/
+(NSMutableDictionary*)encryptionCheckSign:(NSDictionary*)params;

@end

FOUNDATION_EXPORT CMResultClass CMResultClassMake(Class cls);
FOUNDATION_EXPORT CMResultClass CMResultArrayClassMake(Class elementClass);
FOUNDATION_EXPORT CMResultClass CMResultSpliteClassMake(Class elementClass);


/// 最大值
FOUNDATION_EXTERN CMSpliteLimiter CMSpliteLimiterMax;
/// 生成限制器
FOUNDATION_STATIC_INLINE CMSpliteLimiter CMSpliteLimiterMake(NSInteger page, NSInteger size) {
    CMSpliteLimiter lt; lt.page = page; lt.size = size; return lt;
}

