//
//  NSArray+RYJTool.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (RYJTool)

/**
 在数组中寻找字符串索引
 
 @param strString 搜索的字符串
 @return 返回字符串在数组中的索引
 */
- (NSInteger)ryj_findStringIndexByArray:(NSString *)strString;

/**
 在数组中根据index获取数据
 
 @param index 索引
 @return 返回值
 */
- (id)ryj_getSafeDataByIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
