//
//  RYJPermission.m
//  RYJToolKit
//
//  Created by 任一杰 on 2020/11/30.
//

#import "RYJPermission.h"
//相册
#import <AssetsLibrary/AssetsLibrary.h>
//通讯录
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
//定位
#import <CoreLocation/CoreLocation.h>
//语音
#import <AVFoundation/AVFoundation.h>

@interface RYJPermission() <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *reqAuth;
@property (nonatomic, strong) void(^callBack)(RYJAuthorizationStatus);
@end

@implementation RYJPermission

+ (instancetype)getShareInstance {
    static dispatch_once_t once;
    static RYJPermission *obj;
    dispatch_once(&once, ^{
        obj = [[RYJPermission alloc] init];
    });
    return obj;
}

#pragma mark 请求相册权限
+ (void)requestImagePickerAuthorization:(void(^)(RYJAuthorizationStatus status))callback
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusNotDetermined)
        {   // 未授权
            if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
            {
                [self executeCallback:callback status:RYJAuthorizationStatusAuthorized];
            }
            else
            {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
                {
                    if (status == PHAuthorizationStatusAuthorized)
                    {
                        [self executeCallback:callback status:RYJAuthorizationStatusAuthorized];
                    } else if (status == PHAuthorizationStatusDenied)
                    {
                        [self executeCallback:callback status:RYJAuthorizationStatusDenied];
                    } else if (status == PHAuthorizationStatusRestricted)
                    {
                        [self executeCallback:callback status:RYJAuthorizationStatusRestricted];
                    }
                }];
            }
            
        }
        else if (authStatus == ALAuthorizationStatusAuthorized)
        {
            [self executeCallback:callback status:RYJAuthorizationStatusAuthorized];
        }
        else if (authStatus == ALAuthorizationStatusDenied)
        {
            [self executeCallback:callback status:RYJAuthorizationStatusDenied];
        }
        else if (authStatus == ALAuthorizationStatusRestricted)
        {
            [self executeCallback:callback status:RYJAuthorizationStatusRestricted];
        }
    }
    else
    {
        [self executeCallback:callback status:RYJAuthorizationStatusNotSupport];
    }
}

#pragma mark - 相机
+ (void)requestCameraAuthorization:(void (^)(RYJAuthorizationStatus))callback
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusNotDetermined)
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted)
                {
                    [self executeCallback:callback status:RYJAuthorizationStatusAuthorized];
                } else
                {
                    [self executeCallback:callback status:RYJAuthorizationStatusDenied];
                }
            }];
        }
        else if (authStatus == AVAuthorizationStatusAuthorized)
        {
            [self executeCallback:callback status:RYJAuthorizationStatusAuthorized];
        }
        else if (authStatus == AVAuthorizationStatusDenied)
        {
            [self executeCallback:callback status:RYJAuthorizationStatusDenied];
        }
        else if (authStatus == AVAuthorizationStatusRestricted)
        {
            [self executeCallback:callback status:RYJAuthorizationStatusRestricted];
        }
    }
    else
    {
        [self executeCallback:callback status:RYJAuthorizationStatusNotSupport];
    }
}

#pragma mark - 通讯录
+ (void)requestAddressBookAuthorization:(void (^)(RYJAuthorizationStatus))callback
{
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus == kABAuthorizationStatusNotDetermined)
    {
        __block ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        if (addressBook == NULL)
        {
            [self executeCallback:callback status:RYJAuthorizationStatusNotSupport];
            return;
        }
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                [self executeCallback:callback status:RYJAuthorizationStatusAuthorized];
            } else {
                [self executeCallback:callback status:RYJAuthorizationStatusDenied];
            }
            if (addressBook) {
                CFRelease(addressBook);
                addressBook = NULL;
            }
        });
        return;
    } else if (authStatus == kABAuthorizationStatusAuthorized) {
        [self executeCallback:callback status:RYJAuthorizationStatusAuthorized];
    } else if (authStatus == kABAuthorizationStatusDenied) {
        [self executeCallback:callback status:RYJAuthorizationStatusDenied];
    } else if (authStatus == kABAuthorizationStatusRestricted) {
        [self executeCallback:callback status:RYJAuthorizationStatusRestricted];
    }
}
#pragma mark - callback
+ (void)executeCallback:(void (^)(RYJAuthorizationStatus))callback status:(RYJAuthorizationStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (callback)
        {
            callback(status);
        }
    });
}

#pragma mark 请求定位权限
+(void)requestLocationAuthoriztion:(void(^)(RYJAuthorizationStatus status))callback
{
//    BOOL isLocation = [CLLocationManager locationServicesEnabled];  //是否开启定位服务
//    if (!isLocation)
//    {
//        NSLog(@"用户未开启定位");
//        [tztPermission showRequestLocationAlert];
//        return;
//    }
    if (![RYJPermission getShareInstance].reqAuth)
    {
        [RYJPermission getShareInstance].reqAuth = [CLLocationManager new];
    }
    [RYJPermission getShareInstance].callBack = callback;
    
    CLAuthorizationStatus locationStatus = [CLLocationManager authorizationStatus];
    [[RYJPermission getShareInstance] dealLocationStatus:locationStatus];
   
  
}
+(void)showRequestLocationAlert
{
    [RYJPermission getShareInstance].reqAuth.delegate = [RYJPermission getShareInstance];
    [[RYJPermission getShareInstance].reqAuth requestWhenInUseAuthorization];
    [[RYJPermission getShareInstance].reqAuth requestAlwaysAuthorization];
}
-(void)dealLocationStatus:(CLAuthorizationStatus)locationStatus
{
    void (^callback)(RYJAuthorizationStatus) = [RYJPermission getShareInstance].callBack;
    switch (locationStatus)
    {
        case kCLAuthorizationStatusNotDetermined://未询问用户是否授权
        {
            [RYJPermission showRequestLocationAlert];//启用弹框
        }
            break;
        case kCLAuthorizationStatusRestricted://加长控制
        {
            [RYJPermission executeCallback:callback status:RYJAuthorizationStatusRestricted];
        }
            break;
        case kCLAuthorizationStatusDenied://用户拒绝
        {
            [RYJPermission executeCallback:callback status:RYJAuthorizationStatusDenied];
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [RYJPermission executeCallback:callback status:RYJAuthorizationStatusAuthorized];
            break;
        default:
            break;
    }
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
     [self dealLocationStatus:status];
}

#pragma mark 请求语音权限
+(void)requestVideoAuthoriztion:(void (^)(RYJAuthorizationStatus))callback
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            
            if (granted) {
                [self executeCallback:callback status:RYJAuthorizationStatusAuthorized];
            } else {
                [self executeCallback:callback status:RYJAuthorizationStatusDenied];
            }
            
        }];
        
        return;
    } else if (videoAuthStatus == AVAuthorizationStatusAuthorized) {
        [self executeCallback:callback status:RYJAuthorizationStatusAuthorized];
    } else if (videoAuthStatus == AVAuthorizationStatusRestricted) {
        [self executeCallback:callback status:RYJAuthorizationStatusDenied];
    } else if (videoAuthStatus == AVAuthorizationStatusDenied) {
        [self executeCallback:callback status:RYJAuthorizationStatusRestricted];
    }
    
}

+(void)applicationOpenSettings
{
    // iOS7.0及以前
    // NSURL * url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"]; 被废弃了
    // 苹果废弃上面的方式 认为是私有API
    if (@available(iOS 10.0, *))
    {   // iOS10.0及以后
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            }];
        }
    }
    else
    {
        CGFloat systemVersion =  [[[UIDevice currentDevice] systemVersion] floatValue];
        if (systemVersion >= 8.0 && systemVersion < 10.0) {  // iOS8.0 和 iOS9.0
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

@end
