//
//  SourceEditorCacheManager.m
//  ClangFormat-Objc
//
//  Created by anyhong on 2019/6/13.
//  Copyright © 2019 anyhong. All rights reserved.
//

#import "SourceEditorCacheManager.h"

@interface SourceEditorCacheManager ()
@property (strong, nonatomic, readwrite) NSString *cacheDirectoryPath;
@end


@implementation SourceEditorCacheManager

+ (instancetype)manager {
    static SourceEditorCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SourceEditorCacheManager alloc] init];
        [manager generateCachePath];
    });
    
    return manager;
}

- (void)generateCachePath {
    NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    self.cacheDirectoryPath = [documentDirectory stringByAppendingPathComponent:@"ClangFormatCache"];
}

@end
