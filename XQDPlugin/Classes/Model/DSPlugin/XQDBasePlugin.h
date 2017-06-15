//
//  XQDBasePlugin.h
//  kaixindai
//
//  Created by EriceWang on 2017/3/3.
//  Copyright © 2017年 Ericdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQDBridge.h"
#import "Header.h"
#import "XQDWebViewController.h"

BOOL avaiableParameter(id original);
@interface XQDBasePlugin : NSObject

@property (strong, nonatomic) UIWebView *webview;
@property (assign, nonatomic) XQDWebViewController *viewController;
- (XQDBasePlugin *)initWithController:(XQDWebViewController *)controller;
//调用callback
- (void)sendResult:(NSDictionary *)params code:(DSOperationState)code result:(id)result;
@end
