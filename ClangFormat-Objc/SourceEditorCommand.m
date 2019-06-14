//
//  SourceEditorCommand.m
//  ClangFormat-Objc
//
//  Created by anyhong on 2019/6/12.
//  Copyright © 2019 anyhong. All rights reserved.
//
 
#import "SourceEditorCommand.h"
#import "SourceEditorCacheManager.h"
#import "SourceEditorUtil.h"

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError *_Nullable nilOrError))completionHandler {
    
    if ([invocation.buffer.contentUTI isEqualToString:@"public.swift-source"]) {
        
    } else if ([invocation.buffer.contentUTI isEqualToString:@"public.objective-c-source"]) {
        NSString *timeString = [SourceEditorUtil timestampString];
        
        NSString *sourceFileName = [NSString stringWithFormat:@"%@.bak", timeString];
        NSString *targetFileName = [NSString stringWithFormat:@"%@_target", timeString];
        
        SourceEditorCacheManager *manager = [SourceEditorCacheManager manager];
        NSString *sourcePath = [manager.cacheDirectoryPath stringByAppendingPathComponent:sourceFileName];
        NSString *targetPath = [manager.cacheDirectoryPath stringByAppendingPathComponent:targetFileName];
        
        NSError *error = nil;
        [invocation.buffer.completeBuffer writeToFile:sourcePath
                                           atomically:YES
                                             encoding:NSUTF8StringEncoding
                                                error:&error];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        [invocation.buffer.completeBuffer writeToFile:targetPath
                                           atomically:YES
                                             encoding:NSUTF8StringEncoding
                                                error:&error];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        NSPipe *standardError = [NSPipe new];
        NSPipe *standardOutput = [NSPipe new];
        [standardOutput.fileHandleForReading readToEndOfFileInBackgroundAndNotify];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"clang-format" ofType:nil];
        
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = path;
        task.arguments = @[@"--style=file", @"-i", targetPath];
        task.standardError = standardError;
        task.standardOutput = standardOutput;
        
        [task launch];
        [task waitUntilExit];
        NSData *errorData = [standardError.fileHandleForReading readDataToEndOfFile];
        
        NSString *formattedDoc = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:targetPath]
                                                          encoding:NSUTF8StringEncoding
                                                             error:NULL];
        invocation.buffer.completeBuffer = formattedDoc;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:targetPath]) {
            [fileManager removeItemAtPath:targetPath error:nil];
        }
    }

    completionHandler(nil);
    
    NSLog(@"performCommandWithInvocation");
}

@end
