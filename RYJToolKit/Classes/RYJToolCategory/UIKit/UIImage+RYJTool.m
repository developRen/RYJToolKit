//
//  UIImage+RYJTool.m
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import "UIImage+RYJTool.h"

@implementation UIImage (RYJTool)

// 根据颜色创建单色图片
+ (UIImage *)ryj_createImage:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// 根据指定的大小，对图片进行压缩处理，并返回对应符合大小后的图片数据
+ (NSData*)ryj_compressOriginalImage:(UIImage *)image toMaxSize:(CGFloat)fSize {
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length / 1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > fSize && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        } else {
            lastData = dataKBytes;
        }
    }
    return data;
}

// view 转换成 image
+ (UIImage *)ryj_convertViewToImage:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake((int)view.frame.size.width, (int)view.frame.size.height), YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 竖向拼接图片
+ (UIImage *)ryj_jointImageVerticlely:(NSArray *)images {
    NSInteger count = images.count;
    CGSize size[count];
    CGFloat totalHeight = 0;
    CGFloat width = 0;
    for (int i = 0; i < count; i ++) {
        UIImage *image = [images objectAtIndex:i];
        CGSize imageSize = image.size;
        size[i] = imageSize;
        totalHeight = totalHeight + imageSize.height;
        width = MAX(width, imageSize.width);
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, totalHeight), YES, 0);
    totalHeight = 0;
    CGRect rect = CGRectZero;
    for (int i = 0; i < count; i ++) {
        CGSize currentSize = size[i];
        rect = CGRectMake(0, totalHeight, width, currentSize.height);
        UIImage *image = [images objectAtIndex:i];
        [image drawInRect:rect];
        totalHeight = totalHeight + currentSize.height;
    }
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
