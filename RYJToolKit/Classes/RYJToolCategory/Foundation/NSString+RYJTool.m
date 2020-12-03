//
//  NSString+RYJTool.m
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/2.
//

#import "NSString+RYJTool.h"
#import <CommonCrypto/CommonDigest.h>

// 电话号码正则表达式
NSString * const RYJMatchPhoneRegular = @"^(\\d{3,4}-)\\d{7,8}$";
// 手机号码正则表达式
NSString * const RYJMatchMobilePhoneRegular = @"^1[3|4|5|7|8][0-9]\\d{8}$";
// 身份证号正则表达式
NSString * const RYJMatchIDNumberRegular = @"\\d{14}[[0-9],0-9xX]";
// Email正则表达式
NSString * const RYJMatchEmailRegular = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
// URL地址正则表达式
NSString * const RYJMatchURLAddressRegular = @"^http://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$";
// 中国邮政编码正则表达式
NSString * const RYJMatchChinaPostcodeRegular = @"[1-9]\\d{5}(?!\\d)";
// IP地址正则表达式
NSString * const RYJMatchIPAddressRegular = @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";


@implementation NSString (RYJTool)

// 判断字符串是否为空
- (BOOL)ryj_isEmpty {
    return ([self isKindOfClass:[NSNull class]] || self == nil || [self length] < 1 ? YES : NO);
}

// 清空字符串中的空白字符
- (NSString *)ryj_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// 校验正则表达式
- (BOOL)ryj_match:(NSString *)regular {
    if (regular.length < 1) {
        return YES;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self MATCHES %@",regular];
    
    return [predicate evaluateWithObject:self];
}

// 根据分割符分割字符串
- (nullable NSMutableArray<NSString *> *)ryj_seperateToArray:(NSString *)seperator {
    if (seperator.length < 1)
        return nil;

    NSMutableArray *ay =  [[NSMutableArray alloc] initWithArray:[self componentsSeparatedByString:seperator]];
    [ay removeObject:@""];
    return ay;
}

// MD5加密
- (nullable NSString *)ryj_toMD5 {
    if (self == nil)
        return nil;
    
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr,(CC_LONG)strlen(cStr), result);
    NSString *strValue = @"";
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        NSString *strformat = [NSString stringWithFormat:@"%02X",result[i]];
        strValue = [strValue stringByAppendingString:strformat];
    }
    
    return [NSString stringWithFormat:@"%@",strValue];
}

// 字符串四舍五入
- (NSString *)ryj_decimalRounding:(NSInteger)nNumber {
    if (self == nil) {
        return nil;
    }
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:nNumber raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *value1;
    NSDecimalNumber *value2;
    value1 = [[NSDecimalNumber alloc] initWithString:self];
    value2 = [value1 decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",value2];
}

// 通过字体计算文字所占大小
- (CGSize)ryj_sizeWithFont:(UIFont *)font {
    return [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
}

// 根据区域缩放字体进行绘制到界面
- (UIFont *)ryj_drawStringInRect:(CGRect)rect
                            font:(UIFont *)pFont
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
                       alignment:(NSTextAlignment)alignment
                       textColor:(UIColor *)pColor {
    if (pColor == nil)
        pColor = [UIColor blackColor];
    UIFont *returnFont = pFont;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    NSDictionary *attributes = @{NSFontAttributeName:pFont,
                                 NSForegroundColorAttributeName:pColor,
                                 NSParagraphStyleAttributeName:paragraphStyle};

    CGSize sz = [self sizeWithAttributes:attributes];
    if ((sz.width > rect.size.width) || (sz.height > rect.size.height)) {
        CGFloat fScaleW = rect.size.width / sz.width;
        CGFloat fScaleH = rect.size.height / sz.height;

        CGFloat fScale = MIN(fScaleH, fScaleW);
        NSString* strName = pFont.fontName;
        UIFont *font = [UIFont fontWithName:strName size:pFont.pointSize * fScale];
        sz = [self ryj_sizeWithFont:font];
        rect.origin.y += (rect.size.height - sz.height) / 2;
        if (alignment == NSTextAlignmentCenter)
            rect.origin.x += (rect.size.width - sz.width) / 2;
        else if (alignment == NSTextAlignmentRight)
            rect.origin.x += (rect.size.width - sz.width);
 
        attributes = @{NSFontAttributeName:font,
                       NSForegroundColorAttributeName:pColor,
                       NSParagraphStyleAttributeName:paragraphStyle};

        [self drawAtPoint:rect.origin
           withAttributes:attributes];
        returnFont = font;
    } else {
        rect.origin.y += (rect.size.height - sz.height) / 2;
        if (alignment == NSTextAlignmentCenter)
            rect.origin.x += (rect.size.width - sz.width) / 2;
        else if (alignment == NSTextAlignmentRight)
            rect.origin.x += (rect.size.width - sz.width);
        else
            rect.origin.x = rect.origin.x;

        [self drawAtPoint:rect.origin withAttributes:attributes];
    }

    return returnFont;
}

- (NSString *)ryj_formatNum {
    NSString *str = [self substringWithRange:NSMakeRange(self.length % 3, self.length - self.length % 3)];
    NSString *strs = [self substringWithRange:NSMakeRange(0, self.length % 3)];
    for (int  i = 0; i < str.length; i =i + 3) {
        NSString *sss = [str substringWithRange:NSMakeRange(i, 3)];
        strs = [strs stringByAppendingString:[NSString stringWithFormat:@",%@",sss]];
    }
    if ([[strs substringWithRange:NSMakeRange(0, 1)] isEqualToString:@","]) {
        strs = [strs substringWithRange:NSMakeRange(1, strs.length - 1)];
    }
    return strs;
}

@end


