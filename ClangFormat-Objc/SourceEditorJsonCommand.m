//
//  SourceEditorJsonCommand.m
//  ClangFormat-Objc
//
//  Created by anyhong on 2019/6/13.
//  Copyright © 2019 anyhong. All rights reserved.
//

#import "SourceEditorJsonCommand.h"

@implementation SourceEditorJsonCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError *_Nullable nilOrError))completionHandler {
    
    if (invocation.buffer.selections.count) {
        
        XCSourceTextRange *firstObj = invocation.buffer.selections.firstObject;
        NSUInteger startLine = firstObj.start.line;
        NSUInteger endLine = firstObj.end.line;
        NSUInteger lenLine = endLine - startLine;
        
        NSUInteger startColumn = firstObj.start.column;
        NSUInteger endColumn = firstObj.end.column;
        NSUInteger lenColumn = endColumn - startColumn;
        
        if (lenLine || lenColumn) {
            NSMutableString *selectionsString = [NSMutableString new];
            
            for (NSInteger index = startLine; index <= endLine; index++) {
                NSString *lineString = invocation.buffer.lines[index];
                [selectionsString appendString:lineString];
            }
            
            NSError *serializationError;
            NSData *jsonData = [selectionsString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&serializationError];
            
            NSMutableArray<NSString *> *lineArray = [NSMutableArray array];
            [lineArray addObject:@"\n"];
            [lineArray addObject:@"//****解析json****//"];
            if (serializationError) {
                [lineArray addObject:[NSString stringWithFormat:@"//json解析失败: %@", serializationError.localizedDescription]];
            } else {
                [lineArray addObjectsFromArray:[self dictionaryToProperty:jsonDictionary]];
            }
            [lineArray addObject:@"//****解析json****//"];
            [lineArray addObject:@"\n"];
            
            __block NSInteger insertIndex = NSNotFound;
            [invocation.buffer.lines enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj hasPrefix:@"@interface"]) {
                    insertIndex = idx;
                    *stop = YES;
                }
            }];
            
            if (insertIndex == NSNotFound) {
                insertIndex = startLine;
            }
            
            NSRange range = NSMakeRange(insertIndex + 1,  lineArray.count);
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
            [invocation.buffer.lines insertObjects:lineArray atIndexes:indexSet];
        }
    }
    
    completionHandler(nil);
}

- (NSMutableArray<NSString *> *)dictionaryToProperty:(NSDictionary *)dictionary {
    NSMutableArray *propertyArray = [NSMutableArray array];
    if (![dictionary isKindOfClass:[NSDictionary class]]) return propertyArray;
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            if (strcmp([obj objCType], @encode(int)) == 0 ||
                strcmp([obj objCType], @encode(char)) == 0 ||
                strcmp([obj objCType], @encode(long)) == 0 ||
                strcmp([obj objCType], @encode(short)) == 0 ||
                strcmp([obj objCType], @encode(long long)) == 0 ||
                strcmp([obj objCType], @encode(unsigned int)) == 0 ||
                strcmp([obj objCType], @encode(unsigned char)) == 0 ||
                strcmp([obj objCType], @encode(unsigned long)) == 0 ||
                strcmp([obj objCType], @encode(unsigned short)) == 0 ||
                strcmp([obj objCType], @encode(unsigned long long)) == 0 ) {
                [propertyArray addObject:[NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;", key]];
                
            } else if (strcmp([obj objCType], @encode(float)) == 0 ||
                       strcmp([obj objCType], @encode(double)) == 0) {
                [propertyArray addObject:[NSString stringWithFormat:@"@property (nonatomic, assign) CGFloat %@;", key]];
                
            } else if (strcmp([obj objCType], @encode(BOOL)) == 0) {
                [propertyArray addObject:[NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;", key]];
                
            }  else {
                // undefine
            }
            
        } else if ([obj isKindOfClass:[NSString class]]) {
            [propertyArray addObject:[NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;", key]];
            
        } else if ([obj isKindOfClass:[NSNull class]]) {
            [propertyArray addObject:[NSString stringWithFormat:@"@property (nonatomic, strong) id %@;", key]];
            
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [propertyArray addObjectsFromArray:[self dictionaryToProperty:obj]];
        }
    }];
    
    return propertyArray;
}
@end
