//
//  User.m
//  gongfudai
//
//  Created by EricWang on 17/06/12.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import "XQDUser.h"

@implementation XQDUser

-(NSDictionary *)toRegisterParams {
    return @{
             @"mobile": _mobile,
             @"userpwd": _password,
             @"code": _captcha
             };
}

-(NSDictionary *)toLoginParams {
    return @{
             @"mobile": _mobile,
             @"userpwd": _password
             };
}

@end
