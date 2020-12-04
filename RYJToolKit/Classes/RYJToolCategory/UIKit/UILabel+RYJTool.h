//
//  UILabel+RYJTool.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (RYJTool)

/**
 给一个label 加上行间距

 @param space 间距值
 */
- (void)ryj_setLineSpacing:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
