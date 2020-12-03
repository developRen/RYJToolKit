//
//  RYJDate.m
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import "RYJDate.h"

// 默认时间格式 YYYY-MM-dd HH:mm:ss
NSString * const RYJDateFormatDefault = @"YYYY-MM-dd HH:mm:ss";
// 中文时间格式 YYYY年MM月dd日
NSString * const RYJDateFormatCN = @"YYYY年MM月dd日";

@implementation RYJDate

// 获取当前时间
+ (NSString *)currentDate:(NSString *)format {
    // 获取当前时间，日期
    NSDate *currentDate = [NSDate date];
    // 创建一个时间格式化对象
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    // 设定时间格式
    [dateFormatter setDateFormat:format];
    // 将时间转化成字符串
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    return dateString;
}

// 获取当前时间戳
+ (NSString *)currentTimestamp:(RYJDatePrecision)precision {
    // 获取当前时间0秒后的时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    // *1000 是精确到毫秒，不乘就是精确到秒
    NSTimeInterval time;
    switch (precision) {
        case RYJDatePrecision_Second:
        {
            time = [date timeIntervalSince1970];
        }
            break;
        case RYJDatePrecision_Millisecond:
        {
            time = [date timeIntervalSince1970] * 1000;
        }
            break;
    }
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

// 时间戳转时间
+ (NSString *)dateForTimestamp:(NSString *)timestamp
                        format:(NSString *)format {
    // 传入的时间戳str如果是精确到毫秒的要 / 1000
    NSTimeInterval time;
    if (timestamp.length == 13) {
        time = [timestamp doubleValue] / 1000;
    } else {
        time = [timestamp doubleValue];
    }
    
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    // 实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    // 将时间转化成字符串
    NSString *currentDateStr = [dateFormatter stringFromDate:detailDate];
    
    return currentDateStr;
}

// 时间转时间戳
+ (NSString *)timestampForDate:(NSString *)date
                        format:(NSString *)format
                     precision:(RYJDatePrecision)precision {
    // 创建一个时间格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 设定时间的格式
    [dateFormatter setDateFormat:format];
    // 将字符串转换为时间对象
    NSDate *tempDate = [dateFormatter dateFromString:date];
    // 字符串转成时间戳,精确到毫秒 * 1000
    NSString *timeStr;
    switch (precision) {
        case RYJDatePrecision_Second:
        {
            timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];
        }
            break;
        case RYJDatePrecision_Millisecond:
        {
            timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970] * 1000];
        }
            break;
    }    
    
    return timeStr;
}

// 日期转换成字符串
+ (NSString *)formatDate:(NSDate *)date format:(NSString *)format {
    if (date == nil) {
        return nil;
    }
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    [dateformatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
    NSString *strDate = [dateformatter stringFromDate:date];
    return strDate;
}

// 字符串转换成日期
+ (NSDate *)formatStr:(NSString *)dateStr format:(NSString *)format {
    if (dateStr.length < 1) {
        return nil;
    }
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    [dateformatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
    NSDate *date = [dateformatter dateFromString:dateStr];
    return date;
}

// 当前星期几
+ (NSString *)currentWeekday {
    NSDate *currentDate = [NSDate date];
    return [self weekdayForDate:currentDate];
}

// 根据日期计算星期几
+ (NSString *)weekdayForDate:(NSDate *)date {
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    return [weekday objectAtIndex:theComponents.weekday];
}

// 当前月份
+ (NSString *)currentMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitHour fromDate:[[NSDate alloc] init]];
    [components setMonth:[components month]];
    NSDate *monthDate = [cal dateFromComponents:components];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zn_CN"]];
    return [formatter stringFromDate:monthDate];
}

@end
