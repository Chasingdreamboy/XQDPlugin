//
//  XQDPayPlugin.m
//  gongfudaiNew
//
//  Created by EriceWang on 2016/11/1.
//  Copyright © 2016年 dashu. All rights reserved.
//

#import "XQDPayPlugin.h"
//#import "DSAlipayManager.h"
#import <UIKit/UIKit.h>
#import "Authorization.h"
//插件原则：处理基本的必须逻辑，将尽可能多的细节放在H5端进行处理，增强灵活性和实时性。
@implementation XQDPayPlugin
- (void)pay:(NSDictionary *)command {
//     NSString *type = [command objectForKey:@"type"];
//     id paras = [command objectForKey:@"params"];
//    NSDictionary *para = nil;
//    if ([paras isKindOfClass:NSDictionary.class]) {
//        para = (NSDictionary *)paras;
//    } else if ([paras isKindOfClass:NSString.class]) {
//        para = [(NSString *)paras dictionaryValue];
//    }
//    NSString *orderString = para[@"orderString"];
//    if ([type isEqualToString:@"alipay"]) {
//        if (orderString && orderString.length) {
//            [DSAlipayManager alipayWithOrderstring:orderString callBack:^(BOOL success,NSDictionary *dic) {
//                [self sendResult:command
//                            code:DSOperationStateSuccess result:nil];
//            }];
//        } else {
//            [self sendResult:command code:DSOperationStateParamsError result:nil];
//
//        }
//    }
    
}
@end
