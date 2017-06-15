//
//  JSBridge.m
//
//  Created by Ken.Liu on 16/10/14.
//  Copyright © 2016年 Hangzhou Ai Cai Network Technology Co., Ltd. All rights reserved.
//


#import <objc/runtime.h>
#import "XQDBridge.h"
//#import "KenJSBridgeBase.h"
#import "XQDBasePlugin.h"
#import "XQDHelper.h"
#import <objc/message.h>

@interface XQDBridge()

@property (nonatomic, assign) UIWebView               *jsWebView;
@property (nonatomic, assign) id<UIWebViewDelegate>   jsWebViewDelegate;
@property (nonatomic, assign) NSBundle                *resourceBundle;
@property (nonatomic, assign) JSBHandler              bridgeHandler;
@property (nonatomic, assign) long                    uniqueId;
@property (nonatomic, assign) NSUInteger              numberOfUrlRequests;

@property (nonatomic, strong) NSMutableArray          *startupMessageQueue;
@property (nonatomic, strong) NSMutableDictionary     *responseCallbacks;
@property (nonatomic, strong) NSMutableDictionary     *messageHandlers;
@property (nonatomic, strong) NSMutableDictionary     *nativeModules;

@end

@implementation XQDBridge

#pragma mark - Alloc-Dealloc
- (instancetype)initWithParentVC:(XQDWebViewController *)parentVC {
    
    self = [super init];
    if (self) {
        [self initialize];
        _jsWebView           = parentVC.webview;
        _parentVC = parentVC;
        //已经初始化的Plugin
        _nativeModules       = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)initialize {
    _jsWebViewDelegate   = nil;
    _resourceBundle      = nil;
    _bridgeHandler       = nil;
    _uniqueId            = 0;
    _numberOfUrlRequests = 0;
    
//    if(_jsWebView) _jsWebView.delegate = nil;
    RELEASE_MEM(_jsWebView);
    RELEASE_MEM(_startupMessageQueue);
    RELEASE_MEM(_responseCallbacks);
    RELEASE_MEM(_messageHandlers);
    RELEASE_MEM(_nativeModules);
}

- (void)dealloc {
    [self initialize];
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
}
#pragma mark - WebView Delegates
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if(webView != _jsWebView) return;
    _numberOfUrlRequests++;
//    DSLog(@"start AAA== %ld", _numberOfUrlRequests);
    [_jsWebView stringByEvaluatingJavaScriptFromString:@"window.isHybridMode = true"];
    
//    if (_jsWebViewDelegate && [_jsWebViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
//        [_jsWebViewDelegate webViewDidStartLoad:webView];
//    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if(webView != _jsWebView) return;
    _numberOfUrlRequests--;
    DSLog(@"fail AAA== %ld", _numberOfUrlRequests);
    if(!(_numberOfUrlRequests > 0)) {
        if(![[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"typeof (%@) == 'object'",JS_BRIDGE]] isEqualToString:@"true"]) {
            NSBundle *bundle = _resourceBundle ? _resourceBundle : [XQDHelper bundle];
            NSString *filePath = [bundle pathForResource:JS_BRIDGE_FILE_NAME ofType:@"js"];
            
            NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [webView stringByEvaluatingJavaScriptFromString:js];
            });
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if(webView != _jsWebView) return;
    _numberOfUrlRequests--;
    DSLog(@"finish AAA== %ld", _numberOfUrlRequests);
    
//    if(!(_numberOfUrlRequests > 0)) {
        if(![[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"typeof %@ == 'object'",JS_BRIDGE]] isEqualToString:@"true"]) {
            NSBundle *bundle = _resourceBundle ? _resourceBundle : [XQDHelper bundle];
            NSString *filePath = [bundle pathForResource:JS_BRIDGE_FILE_NAME ofType:@"js"];
            NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [webView stringByEvaluatingJavaScriptFromString:js];
            });
//        }
    }
    
    if (_startupMessageQueue) {
        for (id queuedMessage in _startupMessageQueue) {
            [self dispatchMessage:queuedMessage];
        }
        _startupMessageQueue = nil;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {

    if(webView != _jsWebView) return YES;
    
    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:JSBRIDGE_URL_SCHEME]) {
        if ([[url host] isEqualToString:JSBRIDGE_URL_MESSAGE]) {
            NSString *relativePath = [url relativePath];
            if([relativePath isEqualToString:JSBRIDGE_URL_EVENT_REL_PATH]) {
                [self processJSEventQueue:webView];
            } else if([relativePath isEqualToString:JSBRIDGE_URL_API_REL_PATH]) {
                [self processJSAPIRequest:webView];
            }
        } else {
            DSLog(@"shouldStartLoadWithRequest: WARNING: Received unknown command %@",url);
        }
        return NO;
    }
    return YES;
}

#pragma mark - PUBLIC STATIC APIs
+ (NSString *)stringifyJSON:(id)message {
    if([NSJSONSerialization isValidJSONObject:message]) {
        return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:0 error:nil]
                                     encoding:NSUTF8StringEncoding];
    }
    return @"";
}

+ (NSDictionary*)parseJSON:(NSString *)messageJSON {
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingAllowFragments error:nil];
}

+ (NSDictionary *)putKeyValue:(NSMutableDictionary *)src key:(NSString *)key value:(id)value {
    if(src == nil) src = [[NSMutableDictionary alloc] init];
    if((key != nil) && (value != nil)) [src setObject:value forKey:key];
    return src;
}

+ (void)callCallbackForWebView:(UIWebView *)webView params:(NSDictionary *)params response:(id)response code:(DSOperationState)code {
    if(params) {
        NSString *callbackID = [params objectForKey:@"callbackID"];
        
        if(callbackID) {
            NSString *removeAfterExecute = [params objectForKey:@"removeAfterExecute"];
            if(!removeAfterExecute) removeAfterExecute = @"true";
            
            NSDictionary *retObj = [XQDBridge getReturnObjectWithCode:code data:response];
            NSString *retVal = [XQDBridge stringifyJSON:retObj];
            NSString *jsAPIToExecute = [NSString stringWithFormat:@"JSBridge._invokeJSCallback(\"%@\", %@, %@);", callbackID,removeAfterExecute,retVal];
            
            [webView stringByEvaluatingJavaScriptFromString:jsAPIToExecute];
        }
    }
}

+ (void)callEventCallback:(JSBResponseCallback)responseCallback data:(id)data {
    if(responseCallback != nil) {
        responseCallback([XQDBridge getReturnObjectWithCode:DSOperationStateSuccess data:data]);
    }
}

#pragma mark - PUBLIC APIs
- (void)callH5:(NSString *)eventName data:(id)data responseCallback:(JSBResponseCallback)responseCallback {
    NSMutableDictionary* message = [NSMutableDictionary dictionary];
    
    message[@"status"] = @"true";
    if(data) message[@"data"] = data;
    if(eventName) message[@"eventName"] = eventName;
    if (responseCallback) {
        NSString* callbackId = [NSString stringWithFormat:@"objc_cb_%ld", ++_uniqueId];
        _responseCallbacks[callbackId] = [responseCallback copy];
        message[@"callbackId"] = callbackId;
    }
    
    [self queueMessage:message];
}

- (void)registerEvent:(NSString *)eventName handler:(JSBHandler)handler {
    _messageHandlers[eventName] = [handler copy];
}

- (void)deRegisterEvent:(NSString *)eventName handler:(JSBHandler)handler {
    [_messageHandlers removeObjectForKey:eventName];
}

#pragma mark - PRIVATE STATIC APIs
+ (NSArray*)parseJSONArray:(NSString *)messageJSON {
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingAllowFragments error:nil];
}

+ (NSDictionary *)getReturnObjectWithCode:(DSOperationState)code data:(id)data {
    NSMutableDictionary *retValue = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:code], @"code", nil];
    if (code == DSOperationStateSuccess) {
        if(data) {
            [retValue setObject:data forKey:@"data"];
        }
    } else {
        
        NSString *errorMsg = [XQDBridge getErrMsgWithCode:code];
        
        if (data && ([data isKindOfClass:[NSString class]] && ((NSString *)data).length > 0)) {
            
            NSString *str = (NSString *)data;
            NSRange range = [str rangeOfString:@"[]"];
            //个性化提示,若包含[]则表示是个性化提示，不再附加
            if (range.location != NSNotFound) {
                errorMsg = [str substringFromIndex:(range.location + range.length)];
            } else {
                //普通提示
               errorMsg = [(NSString *)data stringByAppendingFormat:@"%@", errorMsg];
            }
        }
        [retValue setObject:errorMsg forKey:@"errMsg"];
    }
    return retValue;
}

+ (NSString *)getErrMsgWithCode:(DSOperationState)code {
    NSString *msg = nil;
    switch (code) {
        case DSOperationStateParamsError: {
            msg = @"传递的参数无效";
        }
            break;
        case DSOperationStateResultUnavaiable: {
            msg = @"操作结果不可用";
        }
            break;
        case DSOperationStateUnknownError: {
            msg =  @"发生未知错误";
        }
            break;
        case DSOperationStateUnlogin: {
            msg = @"请确定登陆之后再进行操作！";
        }
            break;
        case DSOperationStateAuthorizationDenied: {
            msg = @"权限未打开，请开启后再进行操作！";
        }
            break;
        case DSOperationStateAuthorizationCancel: {
            msg = @"您取消了授权，授权失败";
        }
            break;
        case DSOperationStateOperationCancel: {
            msg = @"您点击了取消按钮，请继续进行操作";
        }
            break;
        case DSOperationStateNetFail: {
            msg = @"网络连接失败，请确认后再进行操作";
        }
            break;
        case DSOperationStateAuthorizationAppUninstalled: {
            msg = @"用户手机未安装客户端！";
        }
            break;
        case DSOperationStateFacePlusActionBlend: {
            msg = @"请按照语音提示进行动作检测！";
        }
            break;
        case DSOperationStateFacePlusActionTimeout: {
            msg = @"请在规定时间内完成动作检测！";
        }
            break;
        case DSOperationStateFacePlusActionFailed: {
            msg = @"操作失败，请重试！";
        }
            break;
        case DSOperationStatePluginErrorModule: {
//            msg = @"没有找到对应模块";
            msg = @"内部错误，请及时联系客服人员处理！";
        }
            break;
            
        case DSOperationStatePluginErrorMethod: {
            msg = @"内部错误，请及时联系客服人员处理！";
        }
            break;
            
        default: {
            msg = @"未定义的错误";
        }
            break;
    }
    return msg;
}

#pragma mark - PRIVATE APIs
- (void)dispatchMessage:(NSDictionary *)message {
    NSString *messageJSON = [XQDBridge stringifyJSON:message];
    DSLog(@"JSB Action: SEND: %@",messageJSON);
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    NSString* javascriptCommand = [NSString stringWithFormat:@"%@.%@('%@');",JS_BRIDGE,JS_BRIDGE_SEND_NATIVE_QUEUE,messageJSON];
    if ([[NSThread currentThread] isMainThread]) {
        [_jsWebView stringByEvaluatingJavaScriptFromString:javascriptCommand];
    } else {
        __strong UIWebView* strongWebView = _jsWebView;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [strongWebView stringByEvaluatingJavaScriptFromString:javascriptCommand];
        });
    }
}

- (void)queueMessage:(NSDictionary *)message {
    if (_startupMessageQueue) {
        [_startupMessageQueue addObject:message];
    } else {
        [self dispatchMessage:message];
    }
}

- (NSObject *)getNativeModuleFromName:(NSString *)name webView:(UIWebView *)webView {
    NSObject *nativeModule	= [_nativeModules objectForKey:name];
    NSString *className = [_pluginsMap objectForKey:name.lowercaseString];
    if(nativeModule == nil) {
         Class objClass = NSClassFromString(className);
        if(objClass) {
            @try {
                nativeModule = [[objClass alloc] initWithController:self.parentVC];
                [_nativeModules setObject:nativeModule forKey:name];
            } @catch (NSException *exception) {
                DSLog(@"getNativeModuleFromName: EXCEPTION: %@", name);
                nativeModule = nil;
            } @finally {
            }
        } else {
            DSLog(@"Unsupported Module: %@", name);
        }
    }
    return nativeModule;
}

- (void)handleReturnValue:(NSInvocation *)invoker sig:(NSMethodSignature *)sig webView:(UIWebView *)webView apiName:(NSString *)apiName status:(BOOL)status {
    NSString *retValue = nil;
    if((invoker != nil) && (sig != nil)) {
        if([sig methodReturnLength] > 0) {
            [invoker getReturnValue:&retValue];
            if(retValue) {
                DSLog(@"handleReturnValue:%@", retValue);
                retValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef) retValue, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
            }
        }
    }
    
    NSString *dataStr = @"";
    if(status == false) retValue = [NSString stringWithFormat:@"UN-SUPPORTED API: %@",apiName];
    if(retValue) dataStr = [NSString stringWithFormat:@",'data':'%@'",retValue];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"JSBridge.nativeReturnValue = \"{'status':'%@'%@}\"",((status)?(@"true"):(@"false")),dataStr]];
    
    RELEASE_MEM(retValue);
}

- (void)processEventHandler:(UIWebView *)webView message:(NSDictionary *)message responseCallback:(JSBResponseCallback)responseCallback {
    NSString *eventName = message[@"eventName"];
    if(eventName) {
        JSBHandler handler = _messageHandlers[eventName];
        if(!handler) {
            @try {
                // eventName is not registered and so create an instance of the API
                NSArray *api = [eventName componentsSeparatedByString:@"."];
                NSObject *jsModule = [self getNativeModuleFromName:(NSString*)[api objectAtIndex:0] webView:webView];
                
                if(jsModule) {
                    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"JSBEvent_%@:responseCallback:",
                                                         (NSString*)[api objectAtIndex:1]]);
                    NSMethodSignature *sig = [[jsModule class] instanceMethodSignatureForSelector:selector];
                    if(sig) {
                        NSInvocation *invoker = [NSInvocation invocationWithMethodSignature:sig];
                        invoker.selector = selector;
                        invoker.target = jsModule;
                        [self registerEvent:eventName handler:^(id data, JSBResponseCallback responseCallback) {
                            NSDictionary *configData = message[@"data"];
                            if(configData) [invoker setArgument:&configData atIndex:2];
                            if(responseCallback) [invoker setArgument:&responseCallback atIndex:3];
                            [invoker invoke];
                        }];
                        
                        handler = _messageHandlers[eventName];
                    } else {
                        DSLog(@
                              "processEventHandler: EXCEPTION: Unsupported Event: %@", eventName);
                    }
                } else {
                    DSLog(@"processEventHandler: EXCEPTION: No Plugin: %@", eventName);
                }
            } @catch (NSException *exception) {
                DSLog(@"processEventHandler: EXCEPTION: %@", eventName);
                handler = nil;
            } @finally {
            }
        }
        if(handler == nil) {
            handler = ^(id data, JSBResponseCallback responseCallback) {
                if(responseCallback) {
                    responseCallback(@{@"status":@false,@"data":[NSString stringWithFormat:@"UN-SUPPORTED EVENT: %@", eventName]});
                }
            };
        }
        handler(message[@"data"], responseCallback);
    } else {
        if(_bridgeHandler) {
            _bridgeHandler(message[@"data"], responseCallback);
        } else {
            DSLog(@"EXCEPTION: No handler for message from JS: %@", message);
        }
    }
}

- (void)processJSEventQueue:(UIWebView *)webView {
    NSString *messageQueueString = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@.%@();",JS_BRIDGE,JS_BRIDGE_GET_JS_EVENT_QUEUE]];
    id messages = [XQDBridge parseJSONArray:messageQueueString];
    if(![messages isKindOfClass:[NSArray class]]) {
        DSLog(@"flushMessageQueue: WARNING: Invalid %@ received: %@", [messages class], messages);
        return;
    }
    for (NSDictionary *message in messages) {
        if (![message isKindOfClass:[NSDictionary  class]]) {
            DSLog(@"flushMessageQueue: WARNING: Invalid %@ received: %@", [message class], message);
            continue;
        }
        DSLog(@"flushMessageQueue: RCVD: %@", message);
        NSString* responseId = message[@"responseId"];
        if (responseId) {
            JSBResponseCallback responseCallback = _responseCallbacks[responseId];
            responseCallback(message[@"responseData"]);
            [_responseCallbacks removeObjectForKey:responseId];
        } else {
            JSBResponseCallback responseCallback = NULL;
            NSString* callbackId = message[@"callbackId"];
            if (callbackId) {
                responseCallback = ^(id responseData) {
                    if (responseData == nil) {
                        responseData = [NSNull null];
                    }
                    
                    NSDictionary *msg = @{ @"responseId":callbackId, @"responseData":responseData };
                    [self queueMessage:msg];
                };
            } else {
                responseCallback = ^(id ignoreResponseData) {
                    // Do nothing
                };
            }
            
            [self processEventHandler:webView message:message responseCallback:responseCallback];
        }
    }
}
- (void)processJSAPIRequest:(UIWebView *)webView {
    NSDictionary *cData = [XQDBridge parseJSON:[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@.%@();",JS_BRIDGE,JS_BRIDGE_GET_API_DATA]]];
    NSString *apiName   = [cData objectForKey:@"api"];
    NSDictionary *params = [cData objectForKey:@"data"];
    
    @try {
        // execute the interfacing method
        NSArray  *api       = [apiName componentsSeparatedByString:@"."];
        //返回插件对象
        NSObject *jsModule  = [self getNativeModuleFromName:(NSString*)[api objectAtIndex:0] webView:webView];
        NSString *selectorString = (NSString*)[api objectAtIndex:1];
        if(jsModule) {
            if (![selectorString containsString:@":"]) {
                selectorString = [NSString stringWithFormat:@"%@:",selectorString];
            }
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@",selectorString]);
            NSMethodSignature *sig = [[jsModule class] instanceMethodSignatureForSelector:selector];
            if (sig) {
                NSInvocation *invoker = [NSInvocation invocationWithMethodSignature:sig];
                invoker.selector = selector;
                invoker.target = jsModule;
                if (params) {
                    [invoker setArgument:&params atIndex:2];
                }
                [invoker invoke];
                RELEASE_MEM(invoker);
            } else {
                [XQDBridge callCallbackForWebView:webView params:params response:nil code:DSOperationStatePluginErrorMethod];
            }
        } else {
            [XQDBridge callCallbackForWebView:webView params:params response:nil code:DSOperationStatePluginErrorModule];
        }
    } @catch (NSException *exception) {
        DSLog(@"processJSAPIRequest: EXCEPTION: %@",exception);
        [XQDBridge callCallbackForWebView:webView params:params response:nil code:DSOperationStateUnknownError];
    } @finally {
    }
}

@end
