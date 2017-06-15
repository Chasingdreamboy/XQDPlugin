//
//  XQDWebViewPlugin.h
//  gongfubao
//
//  Created by David Lan on 15/12/31.
//  Copyright (c) 2015年 Hangzhou Tree Finance Ltd. All rights reserved.
//

#import "XQDBasePlugin.h"
@interface XQDWebViewPlugin : XQDBasePlugin


//-(void)bounce:(NSDictionary *)command;
- (void)bgColor:(NSDictionary *)command;
-(void)clearCookies:(NSDictionary *)command;
-(void)clearAllCookies:(NSDictionary *)command;
- (void)getCache:(NSDictionary *)command;
- (void)clearCache:(NSDictionary *)command;
@end
