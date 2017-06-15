//
//  XQDBasePlugin.m
//  kaixindai
//
//  Created by EriceWang on 2017/3/3.
//  Copyright © 2017年 Ericdong. All rights reserved.
//

#import "XQDBasePlugin.h"
#import "Authorization.h"

@implementation XQDBasePlugin
- (XQDBasePlugin *)initWithController:(XQDWebViewController *)controller {
    self = [super init];
    if (self) {
        self.viewController = controller;
        self.webview = controller.webview;
    }
    return self;
}
- (void)sendResult:(NSDictionary *)params code:(DSOperationState)code result:(id)result {
    dispatch_async(dispatch_get_main_queue(), ^{
         [XQDBridge callCallbackForWebView:self.webview params:params response:result code:code];
    });
   
}
@end
