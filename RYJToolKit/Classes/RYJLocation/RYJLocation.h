//
//  RYJLocation.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/9.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RYJLocationResultsBlock)(NSString *longitude, NSString *latitude);

@interface RYJLocation : NSObject<CLLocationManagerDelegate>

// 经度
@property (nonatomic, strong) NSString *longitude;
// 纬度
@property (nonatomic, strong) NSString *latitude;

// 定位是否成功
@property (nonatomic, assign) BOOL isSuccess;

/**
 获取当前位置坐标，并通过block回调返回

 @param completion 回调应答block
 */
- (void)getLocation:(RYJLocationResultsBlock)completion;

/**
 单例模式

 @return tztNSLocation对象
 */
+ (RYJLocation *)shareInstance;

@end

NS_ASSUME_NONNULL_END
