//
//  NSString+RYJTool.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 电话号码正则表达式
FOUNDATION_EXPORT NSString * const RYJMatchPhoneRegular;
// 手机号码正则表达式
FOUNDATION_EXPORT NSString * const RYJMatchMobilePhoneRegular;
// 身份证号正则表达式
FOUNDATION_EXPORT NSString * const RYJMatchIDNumberRegular;
// Email正则表达式
FOUNDATION_EXPORT NSString * const RYJMatchEmailRegular;
// URL地址正则表达式
FOUNDATION_EXPORT NSString * const RYJMatchURLAddressRegular;
// 中国邮政编码正则表达式
FOUNDATION_EXPORT NSString * const RYJMatchChinaPostcodeRegular;
// IP地址正则表达式
FOUNDATION_EXPORT NSString * const RYJMatchIPAddressRegular;

@interface NSString (RYJTool)

/**
 判断字符串是否为空

 @return BOOL
 */
- (BOOL)ryj_isEmpty;

/**
 清空字符串中的空白字符

 @return 新字符串
 */
- (NSString *)ryj_trim;

/**
 根据正则表达式校验字符串是否符合

 @param regular 正则表达式
 @return BOOL
 */
- (BOOL)ryj_match:(NSString *)regular;

/**
 根据分割符分割字符串
 
 @param seperator 分割符
 @return 返回数组
 */
- (nullable NSMutableArray<NSString *> *)ryj_seperateToArray:(NSString *)seperator;

/**
 字符串MD5加密

 @return MD5后的值
 */
- (nullable NSString *)ryj_toMD5;

/**
 字符串四舍五入
 向上取整 ego:1.2456 2位小数 1.25
 
 @param nNumber 保留位数
 @return 返回值
 */
- (NSString *)ryj_decimalRounding:(NSInteger)nNumber;

/*
 通过字体计算文字所占大小
 
 @param font 字体
 @return 所占大小
 */
- (CGSize)ryj_sizeWithFont:(UIFont *)font;

/**
 根据区域缩放字体进行绘制到界面

 @param rect 绘制区域
 @param pFont 字体，显示区域不够，会自动缩小
 @param lineBreakMode linebreakMode
 @param alignment 对齐
 @param pColor 绘制颜色
 @return 实际绘制的字体
 */
- (UIFont *)ryj_drawStringInRect:(CGRect)rect
                            font:(UIFont *)pFont
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                       alignment:(NSTextAlignment)alignment
                       textColor:(UIColor *)pColor;

/*
 格式化数字
 1000000 -> 1,000,000

 @return 新字符串
 */
- (NSString *)ryj_formatNum;

@end

NS_ASSUME_NONNULL_END
