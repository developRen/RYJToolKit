//
//  NSArray+RYJTool.m
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import "NSArray+RYJTool.h"

@implementation NSArray (RYJTool)

// 在数组中寻找字符串索引
- (NSInteger)ryj_findStringIndexByArray:(NSString *)strString {
    if (self == NULL || [self count] < 1 || strString == NULL)
        return -1;
    for (int i = 0; i < [self count]; i++)
    {
        NSString *string = [self objectAtIndex:i];
        if (string && [string isKindOfClass:[NSString class]] && [string compare:strString] == NSOrderedSame)
        {
            return i;
        }
    }
    return -1;
}

// 在数组中根据index获取数据
- (id)ryj_getSafeDataByIndex:(NSInteger)index {
    if ([self count] == 0 || index < 0 || index >= [self count])
        return NULL;
    
    return [self objectAtIndex:index];
}

@end
