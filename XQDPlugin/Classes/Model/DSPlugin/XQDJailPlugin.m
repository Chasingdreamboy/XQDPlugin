//
//  XQDJailPlugin.m
//  gongfudaiNew
//
//  Created by EriceWang on 16/8/1.
//  Copyright © 2016年 dashu. All rights reserved.
//

#import "XQDJailPlugin.h"
#import "XQDUtil.h"

@implementation XQDJailPlugin
- (void)check:(NSDictionary *)command {
    BOOL isJailBreak = [XQDUtil isj];
    [self sendResult:command code:DSOperationStateSuccess result:@(isJailBreak)];
    
}
- (void)params:(NSDictionary *)command {
    NSDictionary *params = [XQDUtil getAllParams];
    if (params) {
        [self sendResult:command code:DSOperationStateSuccess result:params];
    } else {
        [self sendResult:command code:DSOperationStateUnknownError result:@""];
    }
}

@end
