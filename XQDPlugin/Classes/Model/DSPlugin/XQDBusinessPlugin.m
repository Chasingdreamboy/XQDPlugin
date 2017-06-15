//
//  XQDBusinessPlugin.m
//  gongfudai
//
//  Created by EricWang on 17/06/12.
//  Copyright © 2015年 dashu. All rights reserved.
//

#import "XQDBusinessPlugin.h"
#import "Header.h"

@implementation XQDBusinessPlugin

-(void)logWithStep:(NSDictionary *)command {
    NSString* step = [command objectForKey:@"step"];
    if (step && step.length) {
        [XQDUtil getLocationWithGPS:^(BOOL success) {
            [XQDUtil logWithStep:step];
            [self sendResult:command code:DSOperationStateSuccess result:nil];
        }];
    } else {
        [self sendResult:command code:DSOperationStateParamsError result:nil];
    }
}

- (void)logBlackBox:(NSDictionary *)command {
    NSString* blackbox = [command objectForKey:@"step"];
    if (blackbox && blackbox.length) {
        [XQDUtil blackboxWithStep:blackbox];
        [self sendResult:command code:DSOperationStateSuccess result:nil];
    } else {
        [self sendResult:command code:DSOperationStateParamsError result:nil];
    }
}

- (void)logAppInfo:(NSDictionary*)command{
    NSString* step= [command objectForKey:@"step"];
    if (step && step.length) {
        [XQDUtil uploadAppInfoWithStep:step];
        [self sendResult:command code:DSOperationStateSuccess result:nil];
    } else {
        [self sendResult:command code:DSOperationStateParamsError result:nil];
    }
}


@end
