//
//  XQDHookPlugin.m
//  gongfudai
//
//  Created by EriceWang on 16/5/5.
//  Copyright © 2016年 dashu. All rights reserved.
//
#import "XQDHookPlugin.h"
#import "XQDLoginHookViewController.h"
#import "XQDJSONUtil.h"
#import "MBProgressHUD+Expand.h"

@implementation XQDHookPlugin
-(void)open:(NSDictionary *)command {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *keys = @[@"startUrl", @"endUrl", @"website", @"css", @"js", @"saveCookie",@"usePCUA",@"title"];//saveCookie默认为NO，清空所有cookies
    NSString *key = nil;
    if ([command isKindOfClass:[NSString class]]) {
        command = [(NSString *)command getSetFromJson];
    }
    NSArray *allKeys = [command allKeys];
    for (key in allKeys) {
        if ([keys indexOfObject:key] != NSNotFound) {
            id value= [self getParamFrom:command forKey:key];
            [dic setObject:value forKey:key];
        }
    }
    XQDLoginHookViewController *login = [[XQDLoginHookViewController alloc] init];
    login.hidesBottomBarWhenPushed=YES;
    login.title=[dic objectForKey:@"title"];
    
    login.startPage=[[dic objectForKey:@"startUrl"] objectAtIndex:0];
    
    [login setStartUrls:[dic objectForKey:@"startUrl"]];
    [login setEndUrls:[dic objectForKey:@"endUrl"]];
    [login setIdentifier:[dic objectForKey:@"website"]];
    [login setCss:[dic objectForKey:@"css"]];
    [login setJs:[dic objectForKey:@"js"]];
    
    [login setUsePCUA:[[dic objectForKey:@"usePCUA"] boolValue]];
    if([[dic objectForKey:@"usePCUA"] boolValue]){
        [login fakeUA];
    }
    BOOL saveCookie = NO;
    if (![dic objectForKey:@"saveCookie"]) {
        saveCookie = [[dic objectForKey:@"saveCookie"] boolValue];
    }
    [login setSaveCookie:saveCookie];
    __weak typeof(self) weakSelf = self;
    [login setLoginSucces:^(id params) {
        __strong id strongSelf=weakSelf;
        [strongSelf loginSuccess:params withCommand:command];
    }];
    
    [self.viewController.navigationController pushViewController:login animated:YES];
}
/**
 *  上传cookies
 *
 *  @param cookies 参数字典
 */
-(void)loginSuccess:(NSDictionary*)cookies withCommand:(NSDictionary *)command {
    if([self.viewController.navigationController.topViewController isKindOfClass:[XQDLoginHookViewController class]]){
        [self.viewController.navigationController popViewControllerAnimated:YES];
    }
    [self uploadCollection:cookies finish:^(BOOL success, id msg) {
        if (success) {
            [self sendResult:command code:DSOperationStateSuccess result:nil];
        } else {
            [self sendResult:command code:DSOperationStateNetFail result:msg];
        }
    }];
    
    
    
    
//    MBProgressHUD* hud=[MBProgressHUD showLoading:@"正在验证"];
//    [[XQDJSONUtil sharedInstance]getJSONAsync:GET_SERVICE(@"/basics/collect") withData:cookies.getParas method:@"POST" success:^(NSDictionary *data) {
//        [hud showSuccess:@"验证请求已提交，请耐心等待" withDuration:DEFAULT_DISMISS_TIMEUOT];
//        [self sendResult:command code:DSOperationStateSuccess result:nil];
//    } error:^(NSError *error, id responseData) {
//        
//        NSString *msg = [responseData objectForKey:@"errorMsg"];
//        if (msg) {
//            msg = nil;
//        }
//        [self sendResult:command code:DSOperationStateNetFail result:msg];
//        if (responseData) {
//            [hud showFail:msg withDuration:DEFAULT_DISMISS_TIMEUOT];
//        }
//        else{
//            [hud hide:NO];
//        }
//    }];
}
- (void)uploadCollection:(NSDictionary *)cookies finish:(void(^)(BOOL success, id reponseObject))finish {
    MBProgressHUD* hud=[MBProgressHUD showLoading:@"正在验证"];
    [[XQDJSONUtil sharedInstance]getJSONAsync:GET_SERVICE(@"/basics/collect") withData:cookies.getParas method:@"POST" success:^(NSDictionary *data) {
        [hud showSuccess:@"验证请求已提交，请耐心等待" withDuration:DEFAULT_DISMISS_TIMEUOT];
        if (finish) {
            finish(YES, nil);
        }
    } error:^(NSError *error, id responseData) {
        if (finish) {
            finish(NO, nil);
        }
        NSString *msg = nil;
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            msg = [responseData objectForKey:@"errorMsg"];
            if (!msg) {
                msg = @"提交失败，请重新尝试";
            }
        }
        if (msg) {
            [hud showFail:msg withDuration:DEFAULT_DISMISS_TIMEUOT];
        }
        else{
            [hud hide:NO];
        }
    }];
}
//获取指定key对应的参数
- (id) getParamFrom:(NSDictionary*)arguments forKey:(NSString *)key {
    id param = nil;
    if (key) {
        param = [arguments objectForKey:key];
        if ([param  isEqual:[NSNull null]]) {
            param = nil;
        }
    }
    return param;
}
@end
