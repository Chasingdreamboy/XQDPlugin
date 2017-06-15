//
//  XQDNavBarPlugin.h
//  gongfubao
//
//  Created by David Lan on 15/12/31.
//  Copyright (c) 2015年 Hangzhou Tree Finance Ltd. All rights reserved.
//

#import "XQDBasePlugin.h"

@interface XQDNavBarPlugin : XQDBasePlugin
-(void)setBarShow:(NSDictionary *)command;
-(void)setTitle:(NSDictionary *)command;
-(void)setRightItem:(NSDictionary*)command;
-(void)setLeftItem:(NSDictionary*)command;
@end
