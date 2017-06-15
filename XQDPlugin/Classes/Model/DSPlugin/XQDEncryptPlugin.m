//
//  XQDEncryptPlugin.m
//  GFDSDK
//
//  Created by EriceWang on 16/6/1.
//  Copyright © 2016年 Hangzhou Tree Finance Ltd. All rights reserved.
//

#import "XQDEncryptPlugin.h"
#import "XQDJSONUtil.h"

@implementation XQDEncryptPlugin

- (void)encrypt:(NSDictionary *)command {
    NSDictionary *orignalDic = [command objectForKey:@"params"];
    if ([orignalDic isKindOfClass:[NSString class]]) {
        orignalDic = [(NSString *)orignalDic getSetFromJson];
    }
    
    NSDictionary *encryptedDic = orignalDic.getParas;
    
    if (encryptedDic) {
        [self sendResult:command code:DSOperationStateSuccess result:encryptedDic];
    } else {
        [self sendResult:command code:DSOperationStateUnknownError result:nil];
    }
    
}
@end
