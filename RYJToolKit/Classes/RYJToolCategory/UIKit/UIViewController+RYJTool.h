//
//  UIViewController+RYJTool.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (RYJTool)

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)ryj_currentVC;

/**
 获取最上层控制器

 @return 最上层控制器
 */
+ (UIViewController *)ryj_rootViewController;

@end

NS_ASSUME_NONNULL_END
