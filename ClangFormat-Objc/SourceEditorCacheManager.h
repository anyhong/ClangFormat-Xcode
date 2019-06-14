//
//  SourceEditorCacheManager.h
//  ClangFormat-Objc
//
//  Created by anyhong on 2019/6/13.
//  Copyright © 2019 anyhong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SourceEditorCacheManager : NSObject

+ (instancetype)manager;

@property (strong, nonatomic, readonly) NSString *cacheDirectoryPath;

@end

NS_ASSUME_NONNULL_END
