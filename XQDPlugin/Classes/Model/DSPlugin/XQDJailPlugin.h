//
//  XQDJailPlugin.h
//  gongfudaiNew
//
//  Created by EriceWang on 16/8/1.
//  Copyright © 2016年 dashu. All rights reserved.
//
#import "XQDBasePlugin.h"

@interface XQDJailPlugin : XQDBasePlugin
//获取手机是否越狱信息
- (void)check:(NSDictionary *)command;
//获取埋点中的所有paras，备用接口
- (void)params:(NSDictionary *)command;

@end
