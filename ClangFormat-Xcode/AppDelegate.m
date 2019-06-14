//
//  AppDelegate.m
//  ClangFormat-Xcode
//
//  Created by anyhong on 2019/6/12.
//  Copyright © 2019 anyhong. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSString *json = @"\{\"orderId\": 104,\"totalPrice\": 13.45,\"product\": {\"id\": 123,\"name\": \"Product name\",\"price\": 12.95,\"soldout\": true}}";
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
    NSLog(@"");
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
