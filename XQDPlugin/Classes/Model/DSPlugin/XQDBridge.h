//
//  XQDBridge.h
//
//  Created by Ken.Liu on 16/10/14.
//  Copyright © 2016年 Hangzhou Ai Cai Network Technology Co., Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIWebView.h>
#import "XQDWebViewController.h"
#import "Authorization.h"

typedef NS_ENUM(NSInteger, XQDBridgeCodeType)
{
    kXQDBridgeCodeUnkown = -1199,                //未知错误
    kXQDBridgeCodeInternalErr = -1200,           //内部错误
    kXQDBridgeCodeSuccess = 100,                 //调用且逻辑处理成功
    kXQDBridgeCodeUnLogin = -1100,               //用户未登录（一般发生在接口需要用户处于登录状态，而当前用户未登录）
    kXQDBridgeCodeErrModule = -1101,             //模块未找到（一般发生在H5的模块输入错误的时候，请检查相关的输入是否正确）
    kXQDBridgeCodeErrMethod = -1102,             //方法未找到（一般发生在H5的方法输入错误的时候，请检查相关的输入是否正确）
    kXQDBridgeCodeErrParams = -1103,             //参数错误（一般发生H5带入的参数与接口需要的参数不致的时候，请检查参数是否正确）
};

#ifndef RELEASE_MEM
#if __has_feature(objc_arc)
#define RELEASE_MEM(ptr) ptr = nil;
#else
#define RELEASE_MEM(ptr) if(ptr) [ptr release]; ptr = nil;
#endif
#endif

//!!! WARNING - Should be in SYNC with Native Code defines - Begin
#define JSBRIDGE_URL_SCHEME             @"kxdbridge"
#define JSBRIDGE_URL_MESSAGE            @"__KXD_URL_MESSAGE__"
#define JSBRIDGE_URL_EVENT              @"__JSB_URL_EVENT__"
#define JSBRIDGE_URL_API                @"__KXD_URL_API__"

//!!! WARNING - Should be in SYNC with Native Code defines - End
#define JS_BRIDGE_FILE_NAME             @"JSBridge"
#define JS_BRIDGE                       @"JSBridge"
#define JS_BRIDGE_GET_API_DATA          @"_getAPIData"
#define JS_BRIDGE_GET_JS_EVENT_QUEUE    @"_fetchJSEventQueue"
#define JS_BRIDGE_SEND_NATIVE_QUEUE     @"_handleMessageFromNative"

#define JSBRIDGE_URL_EVENT_REL_PATH [NSString stringWithFormat:@"/%@",JSBRIDGE_URL_EVENT]
#define JSBRIDGE_URL_API_REL_PATH   [NSString stringWithFormat:@"/%@",JSBRIDGE_URL_API]

typedef void (^JSBResponseCallback)(id responseData);
typedef void (^JSBHandler)(id data, JSBResponseCallback responseCallback);


@interface XQDBridge : NSObject<UIWebViewDelegate>

@property (nonatomic, assign) XQDWebViewController *parentVC;
@property (strong, nonatomic) NSDictionary *pluginsMap;

- (instancetype)initWithParentVC:(XQDWebViewController*)parentVC;

/**
 *  调用h5的方法
 *
 *  @param eventName            h5方法
 *  @param data                 带的参数数据
 *  @param responseCallback     h5给的回调
 */
- (void)callH5:(NSString *)eventName data:(id)data responseCallback:(JSBResponseCallback)responseCallback;

/**
 *  插入字段到字典，返回插入后的字典
 *
 *  @param src      源字典
 *  @param key      要插入的关键字
 *  @param value    要插入的值
 */
+ (NSDictionary *)putKeyValue:(NSMutableDictionary *)src key:(NSString *)key value:(id)value;

/**
 *  原生针对H5的callBack
 *
 *  @param webView          webview
 *  @param params           H5带过来的参数
 *  @param response         方法返回的结果
 *  @param code             错误码
 */
+ (void)callCallbackForWebView:(UIWebView *)webView params:(NSDictionary *)params response:(id)response code:(DSOperationState)code;

//两个对外暂时没有用到的方法，先放这里，后面再考虑
+ (NSString *)stringifyJSON:(id)message;
+ (NSDictionary *)parseJSON:(NSString *)messageJSON;

//事件相关目前先不支持，这里先不做细的整理
+ (void)callEventCallback:(JSBResponseCallback)responseCallback data:(id)data;
- (void)registerEvent:(NSString *)eventName handler:(JSBHandler)handler;
- (void)deRegisterEvent:(NSString *)eventName handler:(JSBHandler)handler;

@end
