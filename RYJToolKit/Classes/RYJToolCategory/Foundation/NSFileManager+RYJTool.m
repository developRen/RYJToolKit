//
//  NSFileManager+RYJTool.m
//  RYJToolKit
//
//  Created by 任一杰 on 2020/12/3.


#import "NSFileManager+RYJTool.h"

@implementation NSFileManager (RYJTool)

// app路径
+ (NSString *)ryj_getAppDirectoryPath {
    return [[NSBundle mainBundle] bundlePath];
}

// 程序包内资源路径
+ (NSString *)ryj_getMainBundleResource:(NSString *)resource {
    NSString *string = [NSString stringWithFormat:@"%@",resource];
    NSArray *array = [NSArray arrayWithArray:[string componentsSeparatedByString:@"."]];
    if (array.count != 2) {
        return nil;
    }
    return [[NSBundle mainBundle] pathForResource:[array objectAtIndex:0] ofType:[array objectAtIndex:1]];
}

// 路径下为.plist文件，直接读写操作
+ (BOOL)ryj_setDicPath:(NSString*)path object:(id)object forKey:(NSString *)key {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if ([self createFile:path] == NO) {
            // 创建失败
            return NO;
        }
    }
    
    if (key == NULL || key.length == 0) {
        return NO;
    }
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    if (dic == NULL) {
        dic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    if (object) {
        [dic setObject:object forKey:key];
    } else {
        [dic removeObjectForKey:key];
    }
    
    return [dic writeToFile:path atomically:YES];
}

// 路径下为.plist文件，直接读写操作
+ (id)ryj_getDicPath:(NSString *)path key:(NSString *)key {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if ([self createFile:path] == NO) {
            //创建失败
            return NULL;
        }
    }
    
    if (key == NULL || key.length == 0) {
        return NULL;
    }
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (dic == NULL) {
        return NULL;
    }
    return [dic objectForKey:key];
}

// 文件夹大小
+ (CGFloat)ryj_directorySizeAtPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:path] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
        if ([manager fileExistsAtPath:fileAbsolutePath]){
            folderSize += [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
        }
    }
    
    return folderSize / (1024.0 * 1024.0);
}

// 文件大小
+ (CGFloat)ryj_fileSizeAtPath:(NSString*)path {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        return [[manager attributesOfItemAtPath:path error:nil] fileSize] / (1024.0 * 1024.0);
    }
    
    return 0;
}

// 创建文件夹，及中间文件夹
+ (BOOL)createDirectory:(NSString *)path {
    if (path == NULL || path.length == 0) {
        return NO;
    }
    
    NSError *error = nil;
    if ([[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
        if (error) {
            NSLog(@"文件夹创建失败：%@", [error localizedDescription]);
        }
        return NO;
    }
    
    return YES;
}

// 创建文件
+ (BOOL)createFile:(NSString *)path {
    if (path == NULL || path.length == 0) {
        return NO;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    
    if ([[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil] == NO) {
        NSLog(@"文件创建失败：%@", path);
        return NO;
    }
    
    return YES;
}


// 获取BUNDLE资源文件
+ (NSString *)ryj_getFileFromBundle:(NSString *)bundlePath file:(NSString *)file{
    NSString *string1 = [NSString stringWithFormat:@"%@",bundlePath];
    NSArray *array1 = [NSArray arrayWithArray:[string1 componentsSeparatedByString:@"."]];
    if (array1.count != 2) {
        return nil;
    }
    
    NSString *string2 = [NSString stringWithFormat:@"%@",file];
    NSArray *array2 = [NSArray arrayWithArray:[string2 componentsSeparatedByString:@"."]];
    if (array2.count != 2) {
        return nil;
    }
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[array1 objectAtIndex:0] ofType:[array1 objectAtIndex:1]]];
    NSString * strPath = [bundle pathForResource:[array2 objectAtIndex:0] ofType:[array2 objectAtIndex:1]];
    return strPath;
}

// home
+ (NSString *)getHomeDirectory {
    return NSHomeDirectory();
}

// Documents
+ (NSString *)getDocumentDirectory {
    NSArray *pArySearch = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ([pArySearch count] < 1) {
        return NULL;
    }
    return [pArySearch objectAtIndex:0];
}

// library路径 /Library
+ (NSString *)getLibraryDirectory {
    NSArray *libraryArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if ([libraryArray count] < 1) {
        return nil;
    }
    
    return [libraryArray objectAtIndex:0];
}


// 缓存文件的路径 /Library/Caches
+ (NSString *)getCachesDirectory {
    NSArray *pArySearch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    if ([pArySearch count] < 1) {
        return NULL;
    }
    return [pArySearch objectAtIndex:0];
}

// 公共偏好设置的路径 /Library/PreferencePanes
+ (NSString *)getPreferencePanesDirectory {
    NSArray *pArySearch = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES);
    
    if ([pArySearch count] < 1) {
        return NULL;
    }
    return [pArySearch objectAtIndex:0];
}

// 临时文件的路径 /tmp
+ (NSString *)getTemporaryDirectory {
    return NSTemporaryDirectory();
}

// 获取用户信息文件夹   (foler为nil时，要设置为@""，否则系统默认设置为@"（null）")
+ (NSString *)getHomePath:(NSString *)folder {
    if (folder == nil) {
        folder = @"";
    }
    NSString *folderName = [NSString stringWithFormat:@"%@",folder];
    NSString *pathString = [self getHomeDirectory];
    NSString *folderString = [pathString stringByAppendingPathComponent:folderName];
    if ([self createDirectory:folderString]) {
        return folderString;
    }
    return nil;
}

// 获取用户信息文件夹     (foler为nil时，要设置为@""，否则系统默认设置为@"（null）")
+ (NSString *)getDocumentPath:(NSString *)folder {
    if (folder == nil) {
        folder = @"";
    }
    NSString *folderName = [NSString stringWithFormat:@"%@",folder];
    NSString *pathString = [self getDocumentDirectory];
    NSString *folderString = [pathString stringByAppendingPathComponent:folderName];
    if ([self createDirectory:folderString]) {
        return folderString;
    }
    return nil;
}

// library           (foler为nil时，要设置为@""，否则系统默认设置为@"（null）")
+ (NSString *)getLibraryPath:(NSString *)folder {
    if (folder == nil) {
        folder = @"";
    }
    NSString *folderName = [NSString stringWithFormat:@"%@",folder];
    NSString *pathString = [self getLibraryDirectory];
    NSString *folderString = [pathString stringByAppendingPathComponent:folderName];
    if ([self createDirectory:folderString]) {
        return folderString;
    }
    
    return nil;
}

// perferencespanes     (foler为nil时，要设置为@""，否则系统默认设置为@"（null）")
+ (NSString *)getPreferencesPanesPath:(NSString *)folder {
    if (folder == nil) {
        folder = @"";
    }
    NSString *folderName = [NSString stringWithFormat:@"%@",folder];
    NSString *pathString = [self getPreferencePanesDirectory];
    NSString *folderString = [pathString stringByAppendingPathComponent:folderName];// nil即为空
    if ([self createDirectory:folderString]) {
        return folderString;
    }
    
    return nil;
}

// cache         (foler为nil时，要设置为@""，否则系统默认设置为@"（null）")
+ (NSString *)getCachesPath:(NSString *)folder {
    if (folder == nil) {
        folder = @"";
    }
    NSString *folderName = [NSString stringWithFormat:@"%@",folder];
    NSString *pathString = [self getCachesDirectory];
    NSString *folderString = [pathString stringByAppendingPathComponent:folderName];// nil即为空
    if ([self createDirectory:folderString]) {
        return folderString;
    }
    
    return nil;
}

// temp          (foler为nil时，要设置为@""，否则系统默认设置为@"（null）")
+ (NSString *)getTempPath:(NSString *)folder {
    if (folder == nil) {
        folder = @"";
    }
    
    NSString *folderName = [NSString stringWithFormat:@"%@",folder];
    NSString *pathString = [self getTemporaryDirectory];
    NSString *folderString = [pathString stringByAppendingPathComponent:folderName];// nil即为空
    if ([self createDirectory:folderString]) {
        return folderString;
    }
    
    return nil;
}

// home目录   1.可单独创建文件夹（filename为nil，folder可选为nil）或  2.同时创建文件夹和文件（filename不能为nil，folder可选为nil）
+ (NSString *)ryj_getHomeFolder:(NSString *)folder file:(NSString *)fileName {
    NSString *folderPath = [NSString stringWithFormat:@"%@",[self getHomePath:folder]];
    if (fileName == NULL || fileName.length == 0) {
        return folderPath;
    }
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    return filePath;
}

// home/document  1.可单独创建文件夹（filename为nil，folder可选为nil）或  2.同时创建文件夹和文件（filename不能为nil，folder可选为nil）
+ (NSString *)ryj_getDocumentFolder:(NSString *)folder file:(NSString *)fileName {
    NSString *folderPath = [NSString stringWithFormat:@"%@",[self getDocumentPath:folder]];
    if (fileName == NULL || fileName.length == 0) {
        return folderPath;
    }
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    return filePath;
}

// home/library  1.可单独创建文件夹（filename为nil，folder可选为nil）或  2.同时创建文件夹和文件（filename不能为nil，folder可选为nil）
+ (NSString *)ryj_getLibraryFolder:(NSString *)folder file:(NSString *)fileName {
    NSString *folderPath = [NSString stringWithFormat:@"%@",[self getLibraryPath:folder]];
    if (fileName == NULL || fileName.length == 0) {
        return folderPath;
    }
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    return filePath;
}

// home/library/preferences  1.可单独创建文件夹（filename为nil，folder可选为nil）或  2.同时创建文件夹和文件（filename不能为nil，folder可选为nil）
+ (NSString *)ryj_getPreferencesPanesFolder:(NSString *)folder file:(NSString *)fileName {
    NSString *folderPath = [NSString stringWithFormat:@"%@",[self getPreferencesPanesPath:folder]];
    if (fileName == NULL || fileName.length == 0) {
        return folderPath;
    }
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    return filePath;
}

// home/library/caches 1.可单独创建文件夹（filename为nil，folder可选为nil）或  2.同时创建文件夹和文件（filename不能为nil，folder可选为nil）
+ (NSString *)ryj_getCachesFolder:(NSString *)folder file:(NSString *)fileName {
    NSString *folderPath = [NSString stringWithFormat:@"%@",[self getCachesPath:folder]];
    if (fileName == NULL || fileName.length == 0) {
        return folderPath;
    }
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    return filePath;
}

// home/tmp 1.可单独创建文件夹（filename为nil，folder可选为nil）或  2.同时创建文件夹和文件（filename不能为nil，folder可选为nil）
+ (NSString *)ryj_getTempFolder:(NSString *)folder file:(NSString *)fileName {
    NSString *folderPath = [NSString stringWithFormat:@"%@",[self getTempPath:folder]];
    if (fileName == NULL || fileName.length == 0) {
        return folderPath;
    }
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    return filePath;
}

#pragma mark - 删除文件
// 删除文件
+ (BOOL)ryj_delFiles:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return false;
    }
    return [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}


@end
