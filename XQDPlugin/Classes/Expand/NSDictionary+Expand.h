//
//  NSDictionary+Expand.h
//  gongfudai
//
//  Created by David Lan on 15/8/14.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Expand)
-(NSString*)json;
//组合请求参数,
- (NSDictionary *)getParas;
- (NSDictionary *)getParasWithoutEncript;//不加密参数传输
- (NSDictionary *)getPushFeedBack;

@end
