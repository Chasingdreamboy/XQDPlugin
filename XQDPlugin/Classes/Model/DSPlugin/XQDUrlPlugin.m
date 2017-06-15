//
//  XQDUrlPlugin.m
//  gongfudaiNew
//
//  Created by EriceWang on 16/8/30.
//  Copyright © 2016年 dashu. All rights reserved.
//

#import "XQDUrlPlugin.h"

@implementation XQDUrlPlugin
- (void)openUrl:(NSDictionary *)command {
    
    NSDictionary *params = @{@"callbackID" : [command objectForKey:@"callbackID"]};
    NSString *str = [command objectForKey:@"url"];
    DSOperationState operationType  = -1;
    NSString *msg= nil;
    if (str && str.length ) {
        BOOL success = NO;
        if ([str isEqualToString:@"https://91gfd.com"]) {
             success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gongfudai://"]];
        }
        if (!success) {
           success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        if (success) {
            operationType = DSOperationStateSuccess;
        } else {
            operationType = DSOperationStateUnknownError;
        }
    } else {
        msg = nil;
        operationType = DSOperationStateParamsError;
    }
    [self sendResult:params code:operationType result:msg];
}
- (void)dialTel:(NSDictionary *)command {
    NSDictionary *params = @{@"callbackID" : [command objectForKey:@"callbackID"]};
    DSOperationState operationType = -1;
    NSString *msg= nil;
    NSString *tel = [command objectForKey:@"tel"];
    if (tel && tel.length) {
        BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", tel]]];
        operationType = success ? DSOperationStateSuccess : DSOperationStateUnknownError;
        
    } else {
        msg = nil;
        operationType = DSOperationStateParamsError;
    }
    [self sendResult:params code:operationType result:msg];
}
- (void)sendMsg:(NSDictionary *)command {
    NSDictionary *params = @{@"callbackID" : [command objectForKey:@"callbackID"]};
    DSOperationState operationType = -1;
    NSString *msg= nil;
    NSString *tel = [command objectForKey:@"msg"];
    if (tel && tel.length) {
        BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", tel]]];
        operationType = success ? DSOperationStateSuccess : DSOperationStateUnknownError;
        
    } else {
        msg = nil;
        operationType = DSOperationStateParamsError;
    }
    [self sendResult:params code:operationType result:msg];
}
- (void)sendMail:(NSDictionary *)command {
    NSDictionary *params = @{@"callbackID" : [command objectForKey:@"callbackID"]};
    DSOperationState operationType = -1;
    NSString *msg = nil;
    NSString *mail = [command objectForKey:@"mail"];
    if (mail && mail.length) {
        BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", mail]]];
        operationType = success ? DSOperationStateSuccess : DSOperationStateUnknownError;
    } else {
        msg = nil;
        operationType = DSOperationStateParamsError;
    }
    [self sendResult:params code:operationType result:msg];
}

- (void)clipboard:(NSDictionary *)command {
    NSString *text = [command objectForKey:@"text"];
    if (text) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = text;
        [self sendResult:command code:DSOperationStateSuccess result:nil];
    } else {
        [self sendResult:command code:DSOperationStateParamsError result:nil];
    }
}
- (void)download:(NSDictionary *)command {
    
    NSString *applicationName = [command objectForKey:@"appName"];
    NSString *url = [command objectForKey:@"url"];
    NSString *scheme = nil;
    DSOperationState operationType  = -1;
    BOOL success = NO;
    if (applicationName && applicationName.length) {
        if ([applicationName isEqualToString:@"gongfudai"]) {
            scheme = @"gongfudai://";
            url = @"https://itunes.apple.com/cn/app/id1037599157?ls=1&mt=8";
        } else if ([applicationName isEqualToString:@"kaixindai"]) {
            scheme = @"kaixindai://";
            url = @"https://itunes.apple.com/cn/app/id1225256780?ls=1&mt=8";
        } else if ([applicationName isEqualToString:@"xiaoqidai"]) {
            scheme = @"xiaoqidai://";
            url = @"https://itunes.apple.com/cn/app/id1221396040?ls=1&mt=8";
        }
         success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
        if (!success) {
            success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        if (success) {
            operationType = DSOperationStateSuccess;
        } else {
            operationType = DSOperationStateUnknownError;
        }
    } else {
        if ([url isEqual:[NSNull null]] || !url || !url.length) {
            operationType = DSOperationStateParamsError;
        } else {
           success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        if (success) {
            operationType = DSOperationStateSuccess;
        } else {
            operationType = DSOperationStateUnknownError;
        }
    }
    [self sendResult:command code:operationType result:nil];
}
-(void)saveImg:(NSDictionary *)command {
    
}
@end
