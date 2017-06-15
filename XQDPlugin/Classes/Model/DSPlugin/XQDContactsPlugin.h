//
//  XQDContactsPlugin.h
//  gongfudaiNew
//
//  Created by EriceWang on 16/5/6.
//  Copyright © 2016年 dashu. All rights reserved.
//


#import "XQDBasePlugin.h"

@interface XQDContactsPlugin : XQDBasePlugin
//选择联系人
- (void)open:(NSDictionary *)command;
////上传联系人
- (void)upload:(NSDictionary *)command;
//获取原始通讯录
- (void)orignal:(NSDictionary *)command;
////获取处理之后的通讯录(预留，防止本地上传方法出现意外或者其他地方需要通讯录)
- (void)filter:(NSDictionary *)command;


@end
