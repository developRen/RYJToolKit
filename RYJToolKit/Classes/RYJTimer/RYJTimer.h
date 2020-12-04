//
//  RYJTimer.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/11/30.
//
//  封装GCD定时器

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RYJTimer : NSObject

/**
 创建定时器

 @param timer 时间， 若timer<=0, 返回nil
 @param block 回掉block
 @param repeat 是否重复
 @return 返回定时器
 */

+ (RYJTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timer
                                       block:(void(^)(void))block
                                     repeats:(BOOL)repeat;

// 暂停计时(注意调用完pauseTimer后不能直接调用releaseTimer 否则会崩溃 如果要释放直接调用releaseTimer)
- (void)pauseTimer;


// 继续计时
- (void)resumeTimer;

// 终止计时
- (void)releaseTimer;

@end

NS_ASSUME_NONNULL_END
