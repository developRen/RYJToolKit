//
//  RYJReachability.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//
//  网络状态监听工具

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 网络状态

 - RYJNetStatus_NotReachable: 无网络
 - RYJNetStatus_ReachableViaWiFi: WIFI
 - RYJNetStatus_ReachableViaWWAN: WWAN
 - RYJNetStatus_ReachableVia2G: 2G
 - RYJNetStatus_ReachableVia3G: 3G
 - RYJNetStatus_ReachableVia4G: 4G
 - RYJNetStatus_ReachableViable: 可用
 - RYJNetStatus_ReachableUnKnown: 未知
 */
typedef NS_ENUM(NSInteger, RYJNetworkStatus) {
    /**无网络*/
    RYJNetStatus_NotReachable = 0,
    /**WIFI*/
    RYJNetStatus_ReachableViaWiFi,
    /**WWAN*/
    RYJNetStatus_ReachableViaWWAN,
    /**2G*/
    RYJNetStatus_ReachableVia2G,
    /**3G*/
    RYJNetStatus_ReachableVia3G,
    /**4G*/
    RYJNetStatus_ReachableVia4G,
    /**可用*/
    RYJNetStatus_ReachableViable,
    /**未知*/
    RYJNetStatus_ReachableUnKnown,
};

// 网络切换的通知
FOUNDATION_EXPORT NSString * const RYJReachabilityChangedNotification;

@interface RYJReachability : NSObject

// 当前网络状态
@property (nonatomic, assign) RYJNetworkStatus currentStatus;

// 单例
+ (RYJReachability *)getShareInstance;
// 开始监听
- (void)startListening;

@end

NS_ASSUME_NONNULL_END
