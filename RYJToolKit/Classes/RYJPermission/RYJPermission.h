//
//  RYJPermission.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/11/30.
//
//  权限管理类,用户访问系统相关权限
//  例如相机 图库 定位 日历 语音 通讯录等

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

/**
 授权状态

 - RYJAuthorizationStatusAuthorized: 已授权
 - RYJAuthorizationStatusDenied: 已拒绝
 - RYJAuthorizationStatusRestricted: 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
 - RYJAuthorizationStatusNotSupport: 硬件不支持
 */
typedef NS_ENUM(NSUInteger, RYJAuthorizationStatus) {
    // 已授权
    RYJAuthorizationStatusAuthorized = 0,
    // 已拒绝
    RYJAuthorizationStatusDenied,
    // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    RYJAuthorizationStatusRestricted,
    // 硬件等不支持
    RYJAuthorizationStatusNotSupport
};

@interface RYJPermission : NSObject

/**
 *  请求相册访问权限 (若没有权限 弹框提示用户（8.0以后版本有效）)
 *
 *  @param callback 完成回掉
 */
+ (void)requestImagePickerAuthorization:(void(^)(RYJAuthorizationStatus status))callback;

/**
 *  请求相机权限
 *
 *  @param callback 完成回掉
 */
+ (void)requestCameraAuthorization:(void(^)(RYJAuthorizationStatus status))callback;

/**
 *  请求通讯录权限
 *
 *  @param callback 完成回掉
 */
+ (void)requestAddressBookAuthorization:(void (^)(RYJAuthorizationStatus))callback;

/**
 *  请求定位权限
 *
 *  @param callback 完成回掉
 */
+ (void)requestLocationAuthoriztion:(void(^)(RYJAuthorizationStatus status))callback;

/**
 *  请求语音权限
 *
 *  @param callback 完成回掉
 */
+ (void)requestVideoAuthoriztion:(void (^)(RYJAuthorizationStatus))callback;

// 调用打开系统设置界面 支持iOS8以后
+ (void)applicationOpenSettings;

@end

NS_ASSUME_NONNULL_END
