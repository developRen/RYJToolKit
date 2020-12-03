//
//  RYJRouter.m
//  组件化路由
//
//  Created by 任一杰 on 2020/10/13.
//

#import "RYJRouter.h"

// MARK: - 路由请求
@implementation RYJRouterRequest
@end

// MARK: - 路由记录对象
@interface RYJRouterRecordItem : NSObject
@property (nonatomic, strong) RYJRouterItem   *routeItem;
@property (nonatomic, copy)   RYJRouterBlock  callBack;
@end

@implementation RYJRouterRecordItem
@end

// MARK: - 路由应答
@implementation RYJRouterResponse
+ (instancetype)response:(RYJRouterError)error
                  params:(NSDictionary*)params {
    RYJRouterResponse *res = [[RYJRouterResponse alloc] init];
    res.error = error;
    res.params = params;
    return res;
}
@end

//MARK: - 路由对象
@implementation RYJRouterItem
- (id)copyWithZone:(nullable NSZone *)zone {
    RYJRouterItem* item = [[RYJRouterItem alloc] init];
    item.routeName = self.routeName;
    item.routeID  = self.routeID;
    item.status = self.status;
    return item;
}

+ (RYJRouterItem*)createRouter:(NSString *)routerName
                      routerID:(NSString *)routerID
                        status:(int)status
                  forceReplace:(BOOL)replace
                    rescueItem:(RYJRouterItem *)rescueItem {
    if (routerName.length < 1)
        return nil;
    RYJRouterItem* item = [[RYJRouterItem alloc] init];
    item.routeName = routerName;
    if (routerID.length < 1)
        routerID = routerName;
    item.routeID = routerID;
    item.status = status;
    item.canReplace = replace;
    item.rescueItem = rescueItem;
    return item;
}

@end

// MARK: - 路由处理
@interface RYJRouter ()
@property (nonatomic, strong) NSMutableDictionary *dictRouters;
@property (nonatomic, strong) NSMutableDictionary *dictDataRouters;
@end

@implementation RYJRouter

+ (instancetype)getShareInstance {
    static dispatch_once_t once;
    static RYJRouter *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[RYJRouter alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        if (_dictRouters == nil)
            _dictRouters = [[NSMutableDictionary alloc] init];

        if (_dictDataRouters == nil)
            _dictDataRouters = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// MARK: - 判断是否已经有对应的路由记录，url忽略大小写
// url是否已经有对应的路由记录
+ (BOOL)isRouterExist:(RYJRouterItem*)item {
    if (item.routeName.length < 1)
        return NO;
    
    if ([[RYJRouter getShareInstance].dictRouters
         valueForKey:[item.routeName lowercaseString]] != nil)
        return YES;
    
    return NO;
}

// 数据是否已经有对应的路由记录
+ (BOOL)isDataRouterExist:(NSString*)url {
    if (url.length < 1)
        return NO;

    if ([[RYJRouter getShareInstance].dictDataRouters
         valueForKey:[url lowercaseString]] != nil)
        return YES;

    return NO;
}

// MARK: - 注册路由调用
+ (RYJRouterError)registRouter:(NSString *)url
                      forBlock:(RYJRouterBlock)block {
    // 1、校验注册的url
    if (url.length < 1) {
        NSLog(@"register Router Error: %s, %s", __FILE__, __FUNCTION__);
        return RYJRouterError_BadURL;
    }

    // 2、校验回调处理的block
    if (block == nil) {
        NSLog(@"register Router Error: %s, %s", __FILE__, __FUNCTION__);
        return RYJRouterError_BlockInvalid;
    }

    RYJRouterItem* item = [[RYJRouterItem alloc] init];
    item.routeName = url;
    item.routeID = url;
    return [[self class] registRouterObj:item forBlock:block];
}

+ (RYJRouterError)registRouterObj:(RYJRouterItem *)item
                         forBlock:(RYJRouterBlock)block {
    if (item.routeName.length < 1 || item.routeID.length < 1)
        return RYJRouterError_BadURL;
    
    if (block == nil)
        return RYJRouterError_BlockInvalid;
    
    if ([RYJRouter isRouterExist:item] && !item.canReplace)
        return RYJRouterError_Duplicate;

    RYJRouterRecordItem* record = [[RYJRouterRecordItem alloc] init];
    record.routeItem = item.copy;
    record.callBack = block;
    [[RYJRouter getShareInstance].dictRouters setValue:record forKey:[item.routeName lowercaseString]];
    return RYJRouterError_Success;
}

// MARK: - 注册数据路由
+ (RYJRouterError)registDataRouter:(NSString *)url
                          withKey:(NSString*)key
                         forBlock:(RYJRouterBlock)block {
    // 1、判断url
    if (url.length < 1 || key.length < 1) {
        return RYJRouterError_BadURL;
    }

    // 2、判断具体处理的回调block
    if (block == nil) {
        NSLog(@"register DataRouter Error: %s, %s", __FILE__, __FUNCTION__);
        return RYJRouterError_BlockInvalid;
    }

    // 3、判断是否已经被注册了
    if ([RYJRouter isDataRouterExist:[key lowercaseString]]) {
        return RYJRouterError_Duplicate;
    }
    
    // 4、进行注册，忽略大小写
    [[RYJRouter getShareInstance].dictDataRouters setValue:block forKey:[key lowercaseString]];
    return YES;
}

// MARK: - 路由调用
// 组件间路由调用
+ (void)callRouter:(NSString *)url
        withParams:(NSDictionary *)params
          callBack:(RYJRouterCallBack)callBack {
    // 1、判断url是否合法
    if (url.length < 1) {
        if (callBack) {
            RYJRouterResponse* response = [RYJRouterResponse response:RYJRouterError_BadURL params:params];
            callBack(response);
        }
        NSLog(@"callRouter Error: %s, %s", __FILE__, __FUNCTION__);
        return;
    }

    // 2、判断是否有对应功能，查找相应block回调，若没有对应记录，那么认为没有注册过该功能
    RYJRouterRecordItem* recordItem = nil;
    if ([url caseInsensitiveCompare:@"getData"] == NSOrderedSame) {
        [self dealWithGetData:params callBack:callBack];
        return;
    } else if ([url caseInsensitiveCompare:@"setData"] == NSOrderedSame) {
        [self dealWithSetData:params callBack:callBack];
        return;
    } else {
        recordItem = [[RYJRouter getShareInstance].dictRouters valueForKey:[url lowercaseString]];
    }

    // 3、没有对应block记录，直接返回错误
    if (recordItem == nil) {
        if (callBack) {
            RYJRouterResponse* response = [RYJRouterResponse response:RYJRouterError_UnFind params:params];
            callBack(response);
        }
        return;
    }

    // 4、对item进行判断，查看是否组件功能允许调用
    // 不为0，表示调用不允许，需要处理
    if (recordItem.routeItem.status != 0) {
        RYJRouterItem* reDirectRouter = recordItem.routeItem.rescueItem;
        if (reDirectRouter != NULL && reDirectRouter.routeName.length > 0) {
            [[self class] callRouter:reDirectRouter.routeName withParams:params callBack:^(RYJRouterResponse * _Nullable response) {
                if (callBack)
                    callBack(response);
            }];
            return;
        } else {
            RYJRouterResponse* response = [RYJRouterResponse response:RYJRouterError_UnFind params:params];
            callBack(response);
            return;
        }
    }
    
    // 执行block，处理具体组件内的逻辑业务
    // 组织请求包
    RYJRouterRequest * request = [[RYJRouterRequest alloc] init];
    request.url = url;
    request.params = params;
    request.callBack = ^(RYJRouterResponse *response){
        // 6、执行回调
        if (callBack) {
            callBack(response);
        }
        // 整个调度流程结束
    };
    // 5、执行调用函数,并得到具体的结果
    recordItem.callBack(request);
}

// 处理数据路由获取
+ (void)dealWithGetData:(NSDictionary*)params
               callBack:(RYJRouterCallBack)callBack {
    RYJRouterBlock block = nil;
    __block NSMutableDictionary* dict = nil;
    for (NSString* key in params.allKeys) {
        block = [[RYJRouter getShareInstance].dictDataRouters valueForKey:[key lowercaseString]];
        if (block) {
            RYJRouterRequest* request = [[RYJRouterRequest alloc] init];
            request.url = key;
            request.params = params;
            request.callBack = ^(RYJRouterResponse* response){
                //拿到数据
                if (dict == nil)
                    dict = [[NSMutableDictionary alloc] init];

                NSString* strValue = [response.params valueForKey:key];
                if (strValue)
                    [dict setValue:strValue forKey:key];
            };
            block(request);
        } else {
            // 需要进行下特殊处理，兼容老的处理形式
            // 老得获取数据的时候，只要交易登录过的，都可以通过后台字段进行获取数据，这个客户端没有明确定义出来
            // 这里，判断下params中是否有JYLoginInfo，存在的话，即使没有block注册，也统一到指定的地方获取
            id jyinfo = [params valueForKey:@"jylogininfo"];
            if (jyinfo != nil) {
                [RYJRouter callRouter:@"tztGetJyLoginInfoWithDefaultKey" withParams:@{@"key" : key, @"jylogininfo" : jyinfo} callBack:^(RYJRouterResponse* response){
                    NSString* strValue = [response.params valueForKey:key];
                    
                    if (dict == nil)
                        dict = [[NSMutableDictionary alloc] initWithCapacity:0];
                    
                    if (strValue)
                        [dict setValue:strValue forKey:key];
                }];
            }
        }

    }

    // 执行回调
    if (callBack) {
        RYJRouterResponse* response = [[RYJRouterResponse alloc] init];
        response.params = dict;
        callBack(response);
    }
}

// 处理数据路由设置
+ (void)dealWithSetData:(NSDictionary*)params
               callBack:(RYJRouterCallBack)callBack {
    RYJRouterBlock block = nil;
    for (NSString* key in params.allKeys) {
        block = [[RYJRouter getShareInstance].dictDataRouters valueForKey:[key lowercaseString]];
        if (block) {
            RYJRouterRequest* request = [[RYJRouterRequest alloc] init];
            request.url = key;
            request.params = @{key : [params valueForKey:key]};
            request.callBack = ^(RYJRouterResponse* response){

            };
            block(request);
        }
    }

    // 执行回调
    if (callBack) {
        RYJRouterResponse* response = [[RYJRouterResponse alloc] init];
        callBack(response);
    }
}

@end
