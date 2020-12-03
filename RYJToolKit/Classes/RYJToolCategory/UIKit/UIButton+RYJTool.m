//
//  UIButton+RYJTool.m
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import "UIButton+RYJTool.h"

@interface UIButton (RYJTool)
// 上一次实际响应事件时间戳
@property (nonatomic,assign) NSTimeInterval ryj_latestBtnEventTimestamp;
@end

@implementation UIButton (RYJTool)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            //点击事件交换
            [self ryj_swizzledInstanceMethod:@selector(sendAction:to:forEvent:) siwzzledSelector:@selector(ryj_sendAction:to:forEvent:)];
        }
    });
}

// 双击时间控制
- (void)ryj_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.ryj_ignoreBtnEvent && self.ryj_minimumIgnoreDuration > 0.0) {
        // 可点击条件=当前时间戳-上一次时间记录时间戳 >= 最小间隔时间
        BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.ryj_latestBtnEventTimestamp >= self.ryj_minimumIgnoreDuration);
        if (!needSendAction) {
            return;
        }
        // 更新上次响应点击事件时间戳
        self.ryj_latestBtnEventTimestamp = NSDate.date.timeIntervalSince1970;
    }
    // 执行系统点击事件
    [self ryj_sendAction:action to:target forEvent:event];
}

- (void)setRyj_ignoreBtnEvent:(BOOL)ryj_ignoreBtnEvent {
    objc_setAssociatedObject(self, @selector(ryj_ignoreBtnEvent), @(ryj_ignoreBtnEvent), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)ryj_ignoreBtnEvent {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return [number boolValue];
}

- (void)setRyj_minimumIgnoreDuration:(NSTimeInterval)ryj_minimumIgnoreDuration {
    objc_setAssociatedObject(self, @selector(ryj_minimumIgnoreDuration),@(ryj_minimumIgnoreDuration), OBJC_ASSOCIATION_RETAIN);
}

- (NSTimeInterval)ryj_minimumIgnoreDuration {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return [number doubleValue];
}

- (void)setRyj_latestBtnEventTimestamp:(NSTimeInterval)ryj_latestBtnEventTimestamp {
    objc_setAssociatedObject(self, @selector(ryj_latestBtnEventTimestamp),@(ryj_latestBtnEventTimestamp), OBJC_ASSOCIATION_RETAIN);
}

- (NSTimeInterval)ryj_latestBtnEventTimestamp {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return [number doubleValue];
}

@end
