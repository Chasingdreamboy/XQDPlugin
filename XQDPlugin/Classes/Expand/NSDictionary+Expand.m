//
//  NSDictionary+Expand.m
//  gongfudai
//
//  Created by David Lan on 15/8/14.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import "NSDictionary+Expand.h"
#import "NSString+Expand.h"
#import <AFNetworking/AFNetworking.h>
#import "XQDJSONUtil.h"
#import "XQDUtil.h"
#import "Header.h"
#import "XQDPlugin.h"
@implementation NSDictionary(Expand)
-(NSString *)json{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        NSLog(@"json转换失败: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return result;
    }
}
- (NSString *)tripleDESEncrypt {
    return self.json.tripleDESEncrypt;
}
/**
 *  拼接网络请求的参数并加密
 *
 *  @return 将参数进行单独的封装加密序列化之后进行返回的结果
 */
- (NSDictionary *)getParas {
    
    NSMutableDictionary* dict=[NSMutableDictionary dictionary];
    
    NSString *appId = [XQDPlugin sharedInstance].appID;
    
    [dict setObject:appId forKey:@"appId"];
    [dict setObject:@"IOS" forKey:@"platform"];
     NSString* jsonParams=[[self getApppendedParams:self] json];
    NSString *encriptString = [XQDUtil RSAEncript:jsonParams];
    if (encriptString) {
        [dict setObject:encriptString forKey:@"params"];
        return dict;
    } else {
        NSString *where = [NSString stringWithFormat:@"class:%@, function:%s, line:%d",NSStringFromClass(self.class), __FUNCTION__, __LINE__];
        NSString *message = [NSString stringWithFormat:@"ErrorMsg:(Encript error)%@", self.json];
        NSString *errorInfo = [where stringByAppendingString:message];
        [[XQDJSONUtil sharedInstance] sendError:@{@"Error" : errorInfo} callback:^(BOOL success, id extra) {
            if (success) {
                NSLog(@"异常发送成功！");
            } else {
                NSLog(@"异常发送失败！");
            }
        }];
        return ({
            NSMutableDictionary *dic = [self getApppendedParams:self].mutableCopy;
            NSString *userId = CUSTOMER_GET(userIdKey);
            if (userId) {
                [dic setObject:userId forKey:@"userId"];
            }
            dic;
        });
    }
}
- (NSDictionary *)getParasWithoutEncript {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self getApppendedParams:self]];
    NSString *userId = CUSTOMER_GET(userIdKey);
    if (userId) {
        [dic setObject:userId forKey:@"userId"];
    }
    return (NSDictionary *)dic;
}

//自动加上常带的请求参数
-(NSDictionary*)getApppendedParams:(NSDictionary*)params{
    NSMutableDictionary* dict=[NSMutableDictionary dictionary];
    NSString *token = CUSTOMER_GET(tokenKey);
    
    if (token) {
        
        [dict setObject:token forKey:@"token"];
    }
    
    NSString *userId = CUSTOMER_GET(userIdKey);
    if (userId) {
        [dict setObject:userId forKey:@"userId"];
    }
    //V1.0.3新加参数----
    NSString *appVersion = [XQDUtil appVersion];
    if (appVersion) {
        [dict setObject:appVersion forKey:@"appVersion"];
    }
    NSString *detailModel = [XQDUtil detailModel];
    if (detailModel) {
        [dict setObject:detailModel forKey:@"model"];
    }
    NSString *carrieName = [XQDUtil getcarrierName];
    if (carrieName) {
        [dict setObject:carrieName forKey:@"operatorName"];
    }
    NSString *systemVersion = [XQDUtil systemVersion];
    if (systemVersion) {
        [dict setObject:systemVersion forKey:@"systemVersion"];
    }
    NSString *networkType = [XQDUtil networktype];
    if (networkType) {
        [dict setObject:networkType forKey:@"networkType"];
    }
    NSString *bundleId = [XQDUtil bundleId];
    if(bundleId){
        [dict setObject:bundleId forKey:@"bundleId"];
    }
    //开薪贷新增参数
    [dict setObject:@"xqdiOS" forKey:@"channel"];
    //-----------------
    //V1.0.5 新加参数;
    [dict setObject:@"ios" forKey:@"platform"];
    //--------------
    if (params) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSArray class]]||[obj isKindOfClass:[NSMutableArray class]]) {
                [dict setObject:[(NSArray*)obj json] forKey:key];
            }
            else if ([obj isKindOfClass:[NSDictionary class]]||[obj isKindOfClass:[NSMutableDictionary class]]) {
                [dict setObject:[(NSDictionary*)obj json] forKey:key];
            }
            else{
                [dict setObject:obj forKey:key];
            }
        }];
    }
    return dict;
}
- (NSDictionary *)getPushFeedBack {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self];
    [dic setObject:@"iOS" forKey:@"platform"];
    NSString *appVersion = [XQDUtil appVersion];
    if (appVersion) {
        [dic setObject:appVersion forKey:@"AppVersion"];
    }
    NSString *phoneBranch = [XQDUtil model];
    if (phoneBranch) {
        [dic setObject:phoneBranch forKey:@"PhoneBrand"];
    }
    NSString *phoneModel = [NSString stringWithFormat:@"%@", [XQDUtil detailModel]];
    if (phoneModel) {
        [dic setObject:phoneModel forKey:@"PhoneModel"];
    }
    NSString *operatorName = [XQDUtil getcarrierName];
    if (operatorName) {
        [dic setObject:operatorName forKey:@"OperatorName"];
    }
    NSString *phoneVersion = [XQDUtil systemVersion];
    if (phoneVersion) {
        [dic setObject:phoneVersion forKey:@"PhoneVersion"];
    }
    NSString *userId = CUSTOMER_GET(userIdKey);
    if (userId) {
        [dic setObject:userId forKey:@"userId"];
    }
    return (NSDictionary *)dic;
}
@end
