//
//  NSObject+Expand.m
//  gongfudai
//
//  Created by _tauCross on 14-9-4.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import "NSObject+Expand.h"
#import <objc/runtime.h>

static char nsobject_cmtag_key;
static char nsobject_tcuserinfo_key;

@implementation NSObject (Expand)

- (void)setCMTag:(NSInteger)CMTag
{
    objc_setAssociatedObject(self, &nsobject_cmtag_key, [NSNumber numberWithInteger:CMTag], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)CMTag
{
    return [objc_getAssociatedObject(self, &nsobject_cmtag_key) integerValue];
}

- (void)setTCUserInfo:(NSDictionary *)userInfo
{
    objc_setAssociatedObject(self, &nsobject_tcuserinfo_key, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)TCUserInfo
{
    return objc_getAssociatedObject(self, &nsobject_tcuserinfo_key);
}

@end
