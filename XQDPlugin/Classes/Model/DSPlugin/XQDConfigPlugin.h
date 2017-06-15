//
//  GFDAppConfig.h
//  gongfudai
//
//  Created by EricWang on 17/06/12.
//  Copyright © 2015年 dashu. All rights reserved.
//

#import "XQDBasePlugin.h"

@interface XQDConfigPlugin : XQDBasePlugin

- (void)load:(NSDictionary*)command;

- (void)get:(NSDictionary*)command;
//20160613  增加set方法byErice
-(void)set:(NSDictionary *)command;


@end
