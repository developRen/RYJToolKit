//
//  UIFont+RYJTool.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (RYJTool)

/**
 根据指定最大宽度，和文本，缩小字体

 @param mWidth 最大宽度
 @param string 文本内容
 @param dfont 当前字体
 @return 返回缩小后的字体
 */
+ (UIFont *)ryj_fontWithMaxWidth:(CGFloat)mWidth
                   contentString:(NSString *)string
                     defaultFont:(UIFont *)dfont;

@end

NS_ASSUME_NONNULL_END
