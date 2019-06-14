//
//  SourceEditorExtension.m
//  ClangFormat-Objc
//
//  Created by anyhong on 2019/6/12.
//  Copyright © 2019 anyhong. All rights reserved.
//

#import "SourceEditorExtension.h"
#import "SourceEditorCacheManager.h"
#import "SourceEditorUtil.h"

@implementation SourceEditorExtension

- (void)extensionDidFinishLaunching {
    SourceEditorCacheManager *manager = [SourceEditorCacheManager manager];
    NSString *targetPath = [manager.cacheDirectoryPath stringByAppendingPathComponent:@"_clang-format"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:manager.cacheDirectoryPath]) {
        [fileManager createDirectoryAtPath:manager.cacheDirectoryPath
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
    }

    if (![fileManager fileExistsAtPath:targetPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"_clang-format" ofType:nil];
        [fileManager copyItemAtURL:[NSURL fileURLWithPath:sourcePath]
                             toURL:[NSURL fileURLWithPath:targetPath]
                             error:nil];
    }
}


/*
- (NSArray <NSDictionary <XCSourceEditorCommandDefinitionKey, id> *> *)commandDefinitions
{
    // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
    return @[];
}
*/

@end
