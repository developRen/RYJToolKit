//
//  NSFileManager+RYJTool.h
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.
//
//  1、除Document目录下，其他文件会随着版本的更新被替换掉
//  2、library会ituns备份，library/cache不会
//  3、tmp程序关机，低容量会删除
//  4、路径文件不存在则默认创建
//  5、可单独创建文件夹（filename为nil，folder可选为nil)
//  6、同时创建文件夹和文件（filename不能为nil，folder可选为nil）
//
//  ⚠️沙盒目录⚠️
//         1.Documents
// Home -> 2.Library -> 1.Caches
//                      2.Preferences
//         3.tmp


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (RYJTool)

// app路径
+ (NSString *)ryj_getAppDirectoryPath;

// 程序包内资源路径
+ (NSString *)ryj_getMainBundleResource:(NSString *)resource;

// 路径下为.plist文件，直接读写操作
+ (BOOL)ryj_setDicPath:(NSString *)path object:(id)object forKey:(NSString *)key;
// 路径下为.plist文件，直接读写操作
+ (id)ryj_getDicPath:(NSString *)path key:(NSString *)key;

// 文件夹大小
+ (CGFloat)ryj_directorySizeAtPath:(NSString *)path;
// 文件大小
+ (CGFloat)ryj_fileSizeAtPath:(NSString *)path;

// 删除文件\文件夹
+ (BOOL)ryj_delFiles:(NSString *)path;

// 获取BUNDLE资源文件
+ (NSString *)ryj_getFileFromBundle:(NSString *)bundlePath file:(NSString *)file;
// home
+ (NSString *)ryj_getHomeFolder:(NSString *)folder file:(NSString *)fileName;
// home/document
+ (NSString *)ryj_getDocumentFolder:(NSString *)folder file:(NSString *)fileName;
// home/library
+ (NSString *)ryj_getLibraryFolder:(NSString *)folder file:(NSString *)fileName;
// home/library/preferences
+ (NSString *)ryj_getPreferencesPanesFolder:(NSString *)folder file:(NSString *)fileName;
// home/library/caches
+ (NSString *)ryj_getCachesFolder:(NSString *)folder file:(NSString *)fileName;
// home/tmp
+ (NSString *)ryj_getTempFolder:(NSString *)folder file:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
