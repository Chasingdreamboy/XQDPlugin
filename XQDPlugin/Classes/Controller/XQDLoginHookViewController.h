//
//  XQDLoginHookViewController.h
//  gongfudai
//
//  Created by David Lan on 15/8/27.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import "XQDWebViewController.h"

@interface XQDLoginHookViewController : XQDWebViewController
@property(nonatomic,strong) NSArray* startUrls;
@property(nonatomic,strong) NSArray* endUrls;
@property(nonatomic,strong) NSString* identifier;
@property(nonatomic,strong) NSArray* css;
@property(nonatomic,strong) NSArray* js;
@property(nonatomic) BOOL saveCookie;
@property(nonatomic,copy,readwrite) void (^(loginSucces))(id params);
@end
