//
//  XQDBusinessPlugin.h
//  gongfudai
//
//  Created by EricWang on 17/06/12.
//  Copyright © 2015年 dashu. All rights reserved.
//

#import "XQDBasePlugin.h"

@interface XQDBusinessPlugin : XQDBasePlugin

- (void)logWithStep:(NSDictionary*)command;
- (void)logBlackBox:(NSDictionary*)command;
- (void)logAppInfo:(NSDictionary*)command;
@end
