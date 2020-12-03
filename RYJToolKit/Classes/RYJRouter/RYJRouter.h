//
//  RYJRouter.h
//  组件化路由
//
//  Created by 任一杰 on 2020/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RYJRouterRequest;
@class RYJRouterResponse;

typedef void(^RYJRouterCallBack)(RYJRouterResponse* _Nullable response);
typedef void(^RYJRouterBlock)(RYJRouterRequest* _Nonnull request);


// 路由错误号
typedef NS_ENUM(NSInteger, RYJRouterError) {
    // 成功
    RYJRouterError_Success = 0,
    // 未找到传入的URL方法
    RYJRouterError_UnFind = -1,
    // url或者方法 非法数据
    RYJRouterError_BadURL = -2,
    // 注册功能block为nil
    RYJRouterError_BlockInvalid = -3,
    // 注册路由功能，已经存在
    RYJRouterError_Duplicate = -4,
    // 功能路由已经关闭（功能下架或关闭，当前不允许使用）
    RYJRouterError_FuctionClose = -5,
    // 功能路由出错（功能出错，当前不允许使用）
    RYJRouterError_FuctionError = -6,
};

// MARK: - 路由请求对象
@interface RYJRouterRequest : NSObject
// 路由ID
@property (nonatomic, strong) NSString   * _Nonnull url;
// 参数字典
@property (nonatomic, strong) NSDictionary   * _Nullable params;
// 路由回调
@property (nonatomic, copy)   RYJRouterCallBack _Nonnull   callBack;
@end

// MARK: - 路由应答对象
@interface RYJRouterResponse : NSObject
// 路由状态
@property (nonatomic, assign) RYJRouterError error;
// 路由ID
@property (nonatomic, strong) NSString   * _Nullable url;
// 应答数据字典
@property (nonatomic, strong) NSDictionary   * _Nullable params;

/**
 创建路由应答

 @param error 状态码
 @param params 应答数据字典
 @return 路由应答对象
 */
+ (instancetype _Nonnull )response:(RYJRouterError)error
                            params:(NSDictionary*_Nullable)params;
@end


// MARK: - 路由信息对象
@interface RYJRouterItem : NSObject<NSCopying>
// 路由功能名称
@property (nonatomic, strong) NSString   * _Nonnull routeName;
// 路由对应ID，未设置情况下，同上面routeName
@property (nonatomic, strong) NSString   * _Nonnull routeID;
// 路由功能状态 0-正常 1-已关闭 2-功能出错
@property (nonatomic, assign) int status;
// 路由状态在非正常状态下的重定向路由功能
@property (nonatomic, strong) RYJRouterItem   * _Nullable rescueItem;
// 是否可以覆盖已注册的组件，默认NO
@property (nonatomic, assign) BOOL canReplace;

/**
 新建路由对象

 @param routerName 路由名称，必填
 @param routerID 路由ID,若传入为null，则同routerName
 @param status 路由状态
 @param replace 是否能覆盖已有功能
 @param rescueItem 重定向(暂无，保留)
 @return 新建的路由对象
 */
+ (nullable RYJRouterItem*)createRouter:(nonnull NSString*)routerName
                               routerID:(nullable NSString*)routerID
                                 status:(int)status
                           forceReplace:(BOOL)replace
                             rescueItem:(nullable RYJRouterItem*)rescueItem;
@end

// MARK: - 路由对象，单例模式使用
@interface RYJRouter : NSObject

/**
 注册功能路由

 @param url 功能url，不区分大小写
 @param block 功能url对应的处理block块
 @return 注册结果，具体见tztRouterError定义
 */
+ (RYJRouterError)registRouter:(NSString* _Nonnull)url
                      forBlock:(RYJRouterBlock _Nonnull )block;

/**
 注册数据路由

 @param url 设置数据=getData 获取数据=setData，固定，其他值无效
 @param key 注册的数据的key，不区分大小写
 @param block 处理的block块
 @return 注册结果，具体见tztRouterError定义
 */
+ (RYJRouterError)registDataRouter:(NSString * _Nonnull)url
                           withKey:(NSString* _Nonnull)key
                          forBlock:(RYJRouterBlock _Nonnull)block;

/**
 注册路由功能

 @param item 路由功能对象
 @param block 回调处理block块
 @return 注册结果
 */
+ (RYJRouterError)registRouterObj:(RYJRouterItem* _Nonnull)item
                         forBlock:(RYJRouterBlock _Nonnull)block;

/**
 路由功能调用

 @param url 功能url，若要获取注册的数据路由，那url固定为getData
 @param params 数据字典
 @param callBack 处理结果回调
 */
+ (void)callRouter:(NSString* _Nonnull)url
        withParams:(NSDictionary* _Nullable)params
          callBack:(RYJRouterCallBack _Nullable)callBack;

@end

NS_ASSUME_NONNULL_END
