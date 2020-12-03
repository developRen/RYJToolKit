//
//  NSObject+RYJTool.m
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import "NSObject+RYJTool.h"

@implementation NSObject (RYJTool)

+ (void)ryj_swizzledInstanceMethod:(SEL)originalSel siwzzledSelector:(SEL)swizzledSel {
    Method originalMethod = class_getInstanceMethod([self class], originalSel);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSel);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (void)ryj_swizzledClassMethod:(SEL)originalSel swizzledSelector:(SEL)swizzledSel {
    Method originalMethod = class_getClassMethod(self, originalSel);
    Method swizzledMethod = class_getClassMethod(self, swizzledSel);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@end
