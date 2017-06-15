//
//  Authorization.h
//  gongfudaiNew
//
//  Created by EriceWang on 2016/11/1.
//  Copyright © 2016年 dashu. All rights reserved.
//

#ifndef Authorization_h
#define Authorization_h

#include <stdio.h>
//授权状态
typedef NS_ENUM(NSInteger, DSOperationState) {
    DSOperationStateSuccess = 0,//操作成功
    
    DSOperationStateParamsError = 10001,//参数错误
    DSOperationStateResultUnavaiable = 10002,//结果为空
    DSOperationStateUnknownError = 10003,//未知错误
    DSOperationStateUnlogin = 10004,//没有userId或者token
    DSOperationStateOperationCancel  = 10005,//取消操作
    
    //授权分享类
    DSOperationStateAuthorizationDenied = 20001,//拒绝授权
    DSOperationStateAuthorizationCancel = 20002,//取消授权
    DSOperationStateNetFail = 20003,//网络出现错误
    DSOperationStateAuthorizationAppUninstalled = 20004,//应用未安装
    
    //face++
    DSOperationStateFacePlusActionBlend = 30001,//未按照提示完成动作
    DSOperationStateFacePlusActionTimeout = 30002,//动作迟缓检测超时
    DSOperationStateFacePlusActionFailed = 30003,//检测失败
    DSOperationStateFacePlusActionCameraUnavaiable,//设备损坏
    
    //Plugin
    //kJSBridgeCodeErrModule
    DSOperationStatePluginErrorModule = 40001,//没有找到对应的module
    DSOperationStatePluginErrorMethod = 40002,//没有找到对应的Method
};


typedef void(^CallBack) (BOOL success,id resposeObject);
#endif /* Authorization_h */
