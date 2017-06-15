//
//  config.h
//  gongfudai
//
//  Created by David Lan on 15/7/12.
//  Copyright (c) 2015年 dashu. All rights reserved.
//
#ifndef gongfudai_config_h
#define gongfudai_config_h
#define ISDEV YES

//网关配置
#define SERVICE_BASE_URL    ISDEV ? @"http://test.91gfd.com.cn/gongfudaiv2/dqd":@"https://www.91gfd.com.cn/gongfudaiv2/dqd"
#define GET_SERVICE(s)  [NSString stringWithFormat:@"%@%@",SERVICE_BASE_URL,s]

//HTML5服务器地址
#define GFD_H5_BASE_URL ISDEV ? @"http://test.91gfd.com.cn/xqd" : @"https://www.91gfd.com.cn/xqd"
#define GET_H5_URL(path) [NSString stringWithFormat:@"%@%@",GFD_H5_BASE_URL,path]

//用户中心配置
#define GFD_BASE_URL ISDEV ? @"http://test.91gfd.com.cn/usercenterv2/" : @"https://www.91gfd.com.cn/usercenterv2/"

//友盟配置
#define MOBILE_CLICK_KEY    @"58ec4c99734be46ef400250c"


//个推--企业Inhouse证书
#define GETUI_APPID             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GETUI_APPID"]
#define GETUI_APPKEY            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GETUI_APPKEY"]
#define GETUI_APPSECRET         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GETUI_APPSECRET"]

//阿里OSS
#define OSS_BUCKET ISDEV ? @"gfd-test":@"gongfu2"
#define OSS_HOST @"oss-cn-hangzhou.aliyuncs.com"
//微信登录
#define WXAPPID @"wxbf97334aa2208333"

//系统配置
#define SERVICE_TEL         @"0571-81592788"
#define SERVICE_QQ          @"800007405" //3202017377
#define PC_UA               @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36"

//超时设置（单位：秒）
#define ENTER_BACKGROUND_TIMEOUT 300

//MBProgressHud显示时间（单位：秒）
#define DEFAULT_DISMISS_TIMEUOT 2.0

#endif
