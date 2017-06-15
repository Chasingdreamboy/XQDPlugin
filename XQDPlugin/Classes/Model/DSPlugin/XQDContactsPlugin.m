//
//  XQDContactsPlugin.m
//  gongfudaiNew
//
//  Created by EriceWang on 16/5/6.
//  Copyright © 2016年 dashu. All rights reserved.

#import "XQDContactsPlugin.h"
#import "XQDAddressBookManager.h"
@implementation XQDContactsPlugin
- (void)open:(NSDictionary *)command {
    
    [XQDAddressBookManager showAddressBookWithController:self.viewController result:^(BOOL success, ContactCode code, NSDictionary * _Nullable info) {
        //        DSLog(@"info = %@", info);
        
        DSOperationState operationType = -1;
        NSDictionary *result = nil;
        NSString *message = nil;
        if (code == ContactCodeNomal) {
            result = [NSDictionary dictionaryWithDictionary:info];
            operationType = DSOperationStateSuccess;
            [self sendResult:command code:operationType result:result];
            return ;
        } else if(code == ContactCodeNoPermit) {
            operationType = DSOperationStateAuthorizationDenied;
            message = @"访问通讯录";
        } else if((code == ContactCodeNoMobile) || (code == ContactCodeNoName)) {
            operationType = DSOperationStateResultUnavaiable;
            message = @"[]所选择的联系人信息无效，请重新选择";
        } else if (code == ContactCodeNoSelect) {
            operationType = DSOperationStateOperationCancel;
            result = nil;
        } else if(code == ContactCodeNetworkFail) {
            operationType = DSOperationStateNetFail;
            result = nil;
        } else if (code == ContactCodeUnknownError){
            operationType = DSOperationStateUnknownError;
            result = nil;
        }
        [self sendResult:command code:operationType result:message];
    }];
}
//上传联系人
- (void)upload:(NSDictionary *)command {
    [XQDAddressBookManager uploadAllContactsWithResult:^(BOOL success,  NSInteger code, NSDictionary *allContactsInfo) {
        //此处的code 只有两中情况  －1： 执行成功，正常返回 0:无权限
        //paraDic中含有除UserId之外的所有上传参数
        NSDictionary *result = nil;
        DSOperationState operationType = -1;
        if (success) {
            operationType = DSOperationStateSuccess;
        } else if((DSOperationState) code == DSOperationStateAuthorizationDenied){
            [self sendResult:command code:DSOperationStateAuthorizationDenied result:nil];
            return ;
        } else {
            operationType = DSOperationStateUnknownError;
        }
        [self sendResult:command code:operationType result:result];
    }];
    
}
//获取原始通讯录
- (void)orignal:(NSDictionary *)command {
    [XQDAddressBookManager getOrignalContactsWithFilter:NO result:^(BOOL success, NSInteger code, NSDictionary *allContactsInfo) {
        NSDictionary *result = nil;
        DSOperationState operationType = -1;
        if (success && code == ContactCodeNomal) {
            result = [allContactsInfo objectForKey:@"contacts"];
            operationType = DSOperationStateSuccess;
        } else {
            result = nil;
            if (ContactCodeNoPermit == code) {
                operationType = DSOperationStateAuthorizationDenied;
            }
            operationType = DSOperationStateUnknownError;
        }
        [self sendResult:command code:operationType result:result];
        
    }];
}
//获取处理之后的通讯录(预留，防止本地上传方法出现意外或者其他地方需要通讯录)
- (void)filter:(NSDictionary *)command {
    [XQDAddressBookManager getOrignalContactsWithFilter:YES result:^(BOOL success, NSInteger code, NSDictionary *allContactsInfo) {
        NSDictionary *result = nil;
        DSOperationState operationType = -1;
        if (success && code == ContactCodeNomal) {
            result = [allContactsInfo objectForKey:@"contacts"];
            operationType = DSOperationStateSuccess;
        } else {
            if (ContactCodeNoPermit == code) {
                operationType = DSOperationStateAuthorizationDenied;
            } else {
                operationType = DSOperationStateUnknownError;
            }
            result = nil;
        }
        [self sendResult:command code:operationType result:result];
    }];
}
@end
