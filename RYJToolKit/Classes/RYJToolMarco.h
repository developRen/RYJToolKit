//
//  RYJToolKit.h
//  Pods
//
//  Created by 任一杰 on 2020/11/30.
//
//  常用宏定义

#ifndef RYJToolMarco_h
#define RYJToolMarco_h

#pragma mark - 日志打印

#if DEBUG
#define RYJLog(fmt, ...) NSLog((@"%s line:%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define RYJLog(fmt, ...)
#endif

// 打印方法名称
#define RYJ_LOG_FUNC RYJLog(@"方法名:\n %s", __func__);
// 打印沙盒目录
#define RYJ_LOG_NSHomeDirectory RYJLog(@"沙盒目录:\n %@",NSHomeDirectory());

#pragma mark - 对象为空处理
// 字符串是否为空
#define RYJ_STRING_IS_EMPTY(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO)
// 字符串若为空，设置成@""
#define RYJ_SET_STRING_IF_NULL(str) {if(!RYJ_NSSTRING_IS_EMPTY(str)) str = @"";}
// 字符串若为空，替换成对应字符串
#define RYJ_REPLACE_STRING_IF_NULL(str,replace) {if(!RYJ_NSSTRING_IS_EMPTY(str)) str = replace;}
// 数组是否为空
#define RYJ_ARRAY_IS_EMPTY(array) ((array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0) ? YES : NO)
// 字典是否为空
#define RYJ_DICT_IS_EMPTY(dic) ((dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0) ? YES : NO)
// 是否是空对象
#define RYJ_OBJECT_IS_EMPTY(_object) ((_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0)) ? YES : NO)

#pragma mark - APP版本号
#define RYJ_APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#pragma mark - 系统版本判断
#define RYJ_SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]
#define RYJ_IS_IOS(x) ([[UIDevice currentDevice].systemVersion intValue] >= x)
#define RYJ_IS_IOS_AVALIABLE(x) @available(iOS x, *)

#pragma mark - APP BUILD 版本号
#define RYJ_APP_BUILD_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#pragma mark - APP名字
#define RYJ_APP_DISPLAY_NAME  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

#pragma mark - APP语言
// 当前语言
#define RYJ_LOCAL_LANGUAGE [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]
// 当前国家
#define RYJ_LOCAL_COUNTRY [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]

#pragma mark - iPhone型号判断
// 判断是否是ipad
#define RYJ_IS_PAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 判断iPhone4系列
#define RYJ_IS_IPHONE_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !RYJ_IS_PAD : NO)
// 判断iPhone5系列
#define RYJ_IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !RYJ_IS_PAD : NO)
// 判断iPhone6系列
#define RYJ_IS_IPHONE_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !RYJ_IS_PAD : NO)
//判断iphone6+系列
#define RYJ_IS_IPHONE_6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !RYJ_IS_PAD : NO)
// 判断iPhoneX
#define RYJ_IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !RYJ_IS_PAD : NO)
// 判断iPHoneXr | 11
#define RYJ_IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !RYJ_IS_PAD : NO)
// 判断iPhoneXs | 11Pro
#define RYJ_IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !RYJ_IS_PAD : NO)
// 判断iPhoneXs Max | 11ProMax
#define RYJ_IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !RYJ_IS_PAD : NO)
// 判断iPhone12_Mini
#define RYJ_IS_IPHONE_12_Mini ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 2340), [[UIScreen mainScreen] currentMode].size) && !RYJ_IS_PAD : NO)
// 判断iPhone12 | 12Pro
#define RYJ_IS_IPHONE_12 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) && !RYJ_IS_PAD : NO)
// 判断iPhone12 Pro Max
#define RYJ_IS_IPHONE_12_ProMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) && !RYJ_IS_PAD : NO)
// 判断X系列
#define RYJ_IS_IPHONE_XSeries (RYJ_IS_IPHONE_X || RYJ_IS_IPHONE_Xr || RYJ_IS_IPHONE_Xs || RYJ_IS_IPHONE_Xs_Max || RYJ_IS_IPHONE_12_Mini || RYJ_IS_IPHONE_12 || RYJ_IS_IPHONE_12_ProMax)

#pragma mark - 高度宽度
// 设备屏幕宽度
#define RYJ_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
// 设备屏幕高度
#define RYJ_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
// 状态栏高度
#define RYJ_HEIGHT_STATUSBAR (RYJ_IS_IPHONE_XSeries == YES ? 44.0 : 20.0)
// 顶部导航栏高度
#define RYJ_HEIGHT_NAVBAR (RYJ_IS_IPHONE_XSeries == YES ? 91 : 64.0)
// 底部导航栏高度
#define RYJ_HEIGHT_TABBAR ((RYJ_IS_IPHONE_XSeries == YES) ? 83.0 : 49.0)
// safeArea
#define RYJ_HEIGHT_SAFEAREA (RYJ_IS_IPHONE_XSeries == YES ? 34.0 : 0.0)

#pragma mark - 颜色相关
#define RYJ_RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]
#define RYJ_RGB(r,g,b) RYJ_RGBA(r,g,b,1.f)
#define RYJ_RGBA_HEX(hex,a) RYJ_RGBA((float)((hex & 0xFF0000) >> 16),(float)((hex & 0xFF00) >> 8),(float)(hex & 0xFF),a)
#define RYJ_RGB_HEX(hex) RYJ_RGBA_HEX(hex,1.f)
// 随机颜色
#define RYJ_RANDOM_COLOR PCBRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#pragma mark - 弱引用 / 强引用
#define RYJ_WEAK_SELF(type)    __weak typeof(type) weak##type = type;
#define RYJ_STRONG_SELF(type)  __strong typeof(type) type = weak##type;

#pragma mark - 获取路径
// 获取沙盒Document路径
#define RYJ_DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// 获取沙盒temp路径
#define RYJ_TEMP_PATH NSTemporaryDirectory()
// 获取沙盒Cache路径
#define RYJ_CACHE_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
// Library/Caches 文件路径
#define RYJ_FILE_PATH ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])

#pragma mark - 代码执行时间
#define RYJ_CODE_START(x) { CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent(); NSString *RYJCodeName = x; RYJLog(@"%@, 代码执行开始", x);
#define RYJ_CODE_END CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime); RYJLog(@"%@, 代码执行结束，耗时: %f ms", RYJCodeName, linkTime * 1000.0); }

#endif /* RYJToolKit_h */
