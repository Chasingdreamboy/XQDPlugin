//
//  User.h
//  gongfudai
//
//  Created by EricWang on 17/06/12.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQDUser : NSObject

@property (readwrite, strong, nonatomic) NSString *mobile, *password, *confirmPassword, *captcha;

@property (readwrite, nonatomic) BOOL isLogin;

-(NSDictionary *) toRegisterParams;

-(NSDictionary *) toLoginParams;

@end
