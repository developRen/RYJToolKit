//
//  RYJLocation.m
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/9.
//

#import "RYJLocation.h"

@interface RYJLocation ()
@property (nonatomic, copy) RYJLocationResultsBlock resultsBlock;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFinished;
@end

@implementation RYJLocation

+ (RYJLocation *)shareInstance {
    static dispatch_once_t once;
    static RYJLocation *shared;
    dispatch_once(&once, ^{
        shared = [[RYJLocation alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isFinished = NO;
        _longitude = @"";
        _latitude = @"";
        _isSuccess = NO;
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)getLocation:(RYJLocationResultsBlock)completion {
    self.resultsBlock = completion;
    
    // 系统的位置服务开关未开启
    if (![CLLocationManager locationServicesEnabled]) {
        self.longitude = @"";
        self.latitude = @"";
        // 系统的位置服务开关未开启，也回调completion
        if (self.resultsBlock)
        {
            self.resultsBlock(_longitude,_latitude);
        }
    }
    
    // 开始定位
    [self startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (_isFinished)
        return;
    
    CLLocation *currLocation = [locations lastObject];
    
    self.longitude = [NSString stringWithFormat:@"%f",currLocation.coordinate.longitude];
    self.latitude = [NSString stringWithFormat:@"%f",currLocation.coordinate.latitude];
    
    if (self.resultsBlock) {
        self.resultsBlock(_longitude, _latitude);
    }
    _isSuccess = YES;
    // 定位成功 立即停止位置信息更新
    [self stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    if (_isFinished)
        return;
    NSString *errorString = @"";
    [manager stopUpdatingLocation];
    _isSuccess = NO;
    switch([error code]) {
        case kCLErrorDenied:
            errorString = @"用户选择不允许定位";
            break;
        case kCLErrorLocationUnknown:
            errorString = @"未知位置信息";
            break;
        case kCLErrorNetwork:
            errorString = @"网络连接错误";
            break;
        default:
            errorString = @"定位发生未知错误";
            break;
    }
    self.longitude = @"";
    self.latitude = @"";
    // 定位失败 也回调completion
    if (self.resultsBlock) {
        self.resultsBlock(_longitude,_latitude);
    }
    [self stopUpdatingLocation];
}

- (void)startUpdatingLocation {
    [_locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    _isFinished = YES;
    [_locationManager stopUpdatingLocation];
}

#pragma mark - lazy
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        
    }
    return _locationManager;
}

@end
