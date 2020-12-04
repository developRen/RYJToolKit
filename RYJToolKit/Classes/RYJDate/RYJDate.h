//
//  RYJDate.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//
//  处理 时间 时间戳 weak 月份

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 时间精度
// 时间戳为13位是精确到毫秒的，10位精确到秒
typedef NS_ENUM(NSUInteger, RYJDatePrecision) {
    RYJDatePrecision_Second,        // 秒
    RYJDatePrecision_Millisecond,   // 毫秒
};

// 默认时间格式 YYYY-MM-dd HH:mm:ss
FOUNDATION_EXPORT NSString * const RYJDateFormatDefault;
// 中文时间格式 YYYY年MM月dd日
FOUNDATION_EXPORT NSString * const RYJDateFormatCN;

@interface RYJDate : NSObject

/**
 获取当前时间

 @param format YYYY/MM/dd hh:mm:ss SS
 @return 当前时间字符串
 */
+ (NSString *)currentDate:(NSString *)format;

/**
 获取当前时间戳

 @param precision 时间戳精度
 @return 时间戳字符串
 */
+ (NSString *)currentTimestamp:(RYJDatePrecision)precision;

/**
 时间戳转时间

 @param timestamp 时间戳
 @param format 转换格式
 @return 转换后的字符串
 */
+ (NSString *)dateForTimestamp:(NSString *)timestamp
                        format:(NSString *)format;

/**
 时间转时间戳

 @param date 时间字符串
 @param format 转换格式
 @return 转换后的时间戳
 */
+ (NSString *)timestampForDate:(NSString *)date
                        format:(NSString *)format
                     precision:(RYJDatePrecision)precision;

/**
 日期转换成字符串

 @param date 待转换日期
 @param format 转换格式
 @return 转换后字符串
 */
+ (NSString *)formatDate:(NSDate *)date format:(NSString *)format;

/**
 字符串转换成日期

 @param dateStr 日期字符串
 @param format 日期字符串格式
 @return 转换后日期
 */
+ (NSDate *)formatStr:(NSString *)dateStr format:(NSString *)format;

/**
 当前星期
 
 @return 星期几
 */
+ (NSString *)currentWeekday;

/**
 根据日期计算星期几
 
 @param date 日期
 @return 星期几
 */
+ (NSString *)weekdayForDate:(NSDate *)date;

/**
 当前月份
 
 @return 月份
 */
+ (NSString *)currentMonth;


@end

NS_ASSUME_NONNULL_END
