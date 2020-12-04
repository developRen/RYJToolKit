//
//  RYJTimer.m
//  RYJToolKit
//
//  Created by 任一杰 on 2020/11/30.
//

#import "RYJTimer.h"

@interface RYJTimer()

// GCD定时器对象
#if TARGET_OS_IPHONE
@property (nonatomic, strong) dispatch_source_t timer;
#else
@property (nonatomic) dispatch_source_t timer;
#endif

@end

@implementation RYJTimer
#pragma mark 开启定时器
+ (RYJTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timer
                                       block:(void(^)(void))block
                                     repeats:(BOOL)repeat
{
    if (timer <= 0)
        return nil;
    @synchronized (self)
    {
        RYJTimer *Timer = [[RYJTimer alloc] init];
        [Timer createGCDTimer:timer Block:^{
            if (block)
            {
                block();
            };
            if (!repeat)
            {
                [Timer releaseTimer];
            }
        }];
        return Timer;
    }
}
#pragma mark 创建GCD定时器
- (void)createGCDTimer:(NSTimeInterval)timer Block:(dispatch_block_t)block
{
    //并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, timer * NSEC_PER_SEC, 0);
    
    //设置事件
    dispatch_source_set_event_handler(_timer, ^{
        @autoreleasepool
        {
            block();
        }
    });
    dispatch_resume(_timer);
}

#pragma mark 暂停定时器
- (void)pauseTimer
{
    NSLog(@"定时器停止——%@",_timer);
    if(_timer)
        dispatch_suspend(_timer);
}

#pragma mark 重启定时器
- (void)resumeTimer
{
    NSLog(@"定时器重启——%@",_timer);
    if (_timer)
        dispatch_resume(_timer);
}

#pragma mark 销毁定时器
- (void)releaseTimer{
    NSLog(@"定时器销毁——%@",_timer);
    if(_timer)
        dispatch_source_cancel(_timer);
        _timer = nil;
}

#pragma mark dealloc
- (void)dealloc
{
    [self releaseTimer];
}

@end
