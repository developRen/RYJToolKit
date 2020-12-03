//
//  NSObject+RYJTool.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (RYJTool)

/**
 处理对象方法交换

 @param originalSel 原函数
 @param swizzledSel 交换后的函数
 */
+ (void)ryj_swizzledInstanceMethod:(SEL)originalSel siwzzledSelector:(SEL)swizzledSel;

/**
 处理类方法交换

 @param originalSel 原函数
 @param swizzledSel 交换后的函数
 */
+ (void)ryj_swizzledClassMethod:(SEL)originalSel swizzledSelector:(SEL)swizzledSel;

@end

NS_ASSUME_NONNULL_END
