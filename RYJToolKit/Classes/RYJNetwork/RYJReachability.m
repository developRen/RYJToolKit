//
//  RYJReachability.m
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import "RYJReachability.h"
#import "RealReachability.h"

NSString * const RYJReachabilityChangedNotification = @"RYJReachabilityChangedNotification";

@implementation RYJReachability

+ (RYJReachability *)getShareInstance {
    static dispatch_once_t once;
    static RYJReachability *shared;
    dispatch_once(&once, ^{
        shared = [[RYJReachability alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentStatus = RYJNetStatus_ReachableUnKnown;
    }
    return self;
}

- (void)startListening {
    // 防止重复订阅
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    [self realNetworkingStatus:status];
}

- (void)networkChanged:(NSNotification *)notification {
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    [self realNetworkingStatus:status];
}

- (void)realNetworkingStatus:(ReachabilityStatus)status {
    switch (status) {
        case RealStatusUnknown: {
            _currentStatus = RYJNetStatus_ReachableUnKnown;
            break;
        }
            
        case RealStatusNotReachable: {
            _currentStatus = RYJNetStatus_NotReachable;
            break;
        }
        case RealStatusViaWWAN: {
            _currentStatus = RYJNetStatus_ReachableViaWWAN;
            WWANAccessType wwanType = [GLobalRealReachability currentWWANtype];
            if (WWANType4G == wwanType) {
                _currentStatus = RYJNetStatus_ReachableVia4G;
            } else if (WWANType3G == wwanType) {
                _currentStatus = RYJNetStatus_ReachableVia3G;
            } else if (WWANType2G == wwanType) {
                _currentStatus = RYJNetStatus_ReachableVia2G;
            }
            break;
        }
        case RealStatusViaWiFi: {
            _currentStatus = RYJNetStatus_ReachableViaWiFi;
            break;
        }
        default:
            break;
    }
    
    // 发送网络切换通知
    NSDictionary *userInfo = @{@"currentStatus" : @(_currentStatus)};
    [[NSNotificationCenter defaultCenter] postNotificationName:RYJReachabilityChangedNotification object:self userInfo:userInfo];
}

@end
