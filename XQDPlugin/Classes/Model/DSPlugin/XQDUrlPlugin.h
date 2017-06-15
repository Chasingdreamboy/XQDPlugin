//
//  XQDUrlPlugin.h
//  gongfudaiNew
//
//  Created by EriceWang on 16/8/30.
//  Copyright © 2016年 dashu. All rights reserved.
//

#import "XQDBasePlugin.h"

@interface XQDUrlPlugin : XQDBasePlugin
//打开url
- (void)openUrl:(NSDictionary *)command;
//打电话
- (void)dialTel:(NSDictionary *)command;
//发消息
- (void)sendMsg:(NSDictionary *)command;
//发邮件
- (void)sendMail:(NSDictionary *)command;
- (void)clipboard:(NSDictionary *)command;
- (void)download:(NSDictionary *)command;

@end
