//
//  UIImage+RYJTool.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (RYJTool)

/**
 根据颜色创建单色图片

 @param color 颜色
 @param size 尺寸
 @return 对应的图片
 */
+ (UIImage *)ryj_createImage:(UIColor *)color size:(CGSize)size;

/**
 根据指定的大小，对图片进行压缩处理，并返回对应符合大小后的图片数据

 @param image 原始图片数据
 @param fSize 压缩的最大图片大小
 @return 返回的图片数据
 */
+ (NSData *)ryj_compressOriginalImage:(UIImage *)image toMaxSize:(CGFloat)fSize;


/**
 view 转换成 image

 @param view 目标视图
 @return 对应的图片
 */
+ (UIImage *)ryj_convertViewToImage:(UIView *)view;

/**
 竖向拼接图片
 
 @param images array of UIImage
 @return return value description
 */
+ (UIImage *)ryj_jointImageVerticlely:(NSArray *)images;

@end

NS_ASSUME_NONNULL_END
