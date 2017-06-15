//
//  NSURL+Expand.h
//  gongfudai
//
//  Created by Jay Ni on 15/3/11.
//  Copyright (c) 2015年 Hangzhou dashu Tech Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Expand)

-(NSDictionary *)queryParamDict;
-(NSString *)paramValueForKey:(NSString *)paramKey;

@end
