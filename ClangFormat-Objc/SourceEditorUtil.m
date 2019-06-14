//
//  SourceEditorUtil.m
//  ClangFormat-Objc
//
//  Created by anyhong on 2019/6/13.
//  Copyright © 2019 anyhong. All rights reserved.
//

#import "SourceEditorUtil.h"

@implementation SourceEditorUtil

+ (NSString *)timestampString {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd-HH-mm-ss-SSS"];
    
    NSDate *date = [NSDate new];
    NSString *time = [format stringFromDate:date];
    
    return time;
}

@end
