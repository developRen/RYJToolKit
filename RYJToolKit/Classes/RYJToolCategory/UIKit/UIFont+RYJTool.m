//
//  UIFont+RYJTool.m
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import "UIFont+RYJTool.h"
#import "NSString+RYJTool.h"

@implementation UIFont (RYJTool)

/** 根据指定最大宽度，和文本，缩小字体 */
+ (UIFont *)ryj_fontWithMaxWidth:(CGFloat)mWidth
                   contentString:(NSString *)string
                     defaultFont:(UIFont *)dfont {
    NSString *dfontName = dfont.familyName;
    CGFloat dfontSize = dfont.pointSize;
    for (int i = 1; i > 0; i ++) {
        CGSize sz = [string ryj_sizeWithFont:[UIFont fontWithName:dfontName size:dfontSize]];
        if (sz.width > mWidth) {
            dfontSize -= 0.2;
        }else {
            break;
        }
    }
    return [UIFont fontWithName:dfontName size:dfontSize];
}

@end
