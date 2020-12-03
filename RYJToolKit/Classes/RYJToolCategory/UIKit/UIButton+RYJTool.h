//
//  UIButton+RYJTool.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (RYJTool)

// 是否忽略连续点击，默认为NO 不开启
// 开启时忽略连点时间可通过minimumIgnoreDuration设置
@property (nonatomic,assign) BOOL ryj_ignoreBtnEvent;
// 最低忽略点击事件间隔,默认0.25
// ryj_ignoreBtnEvent = YES 时有效
@property (nonatomic,assign) NSTimeInterval ryj_minimumIgnoreDuration;


@end

NS_ASSUME_NONNULL_END
