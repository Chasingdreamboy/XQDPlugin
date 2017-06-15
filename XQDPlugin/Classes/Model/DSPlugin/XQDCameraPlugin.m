//
//  XQDCameraPlugin.m
//  gongfudaiNew
//
//  Created by EriceWang on 16/5/5.
//  Copyright © 2016年 dashu. All rights reserved.
//

#import "XQDCameraPlugin.h"
#import "XQDGetPhotoManager.h"
#import "Header.h"
#import <AVFoundation/AVFoundation.h>

@implementation XQDCameraPlugin
- (void)open:(NSDictionary *)command {
    //para预期中应该有两个参数，第一个是是时间戳，第二个参数是拍照的类型（正，反和faceDetection）
    NSString *timestamp = [NSString stringWithFormat:@"%@", [command objectForKey:@"timestamp"]];
    NSString *typeStr = [NSString stringWithFormat:@"%@", [command objectForKey:@"type"]];
    NSInteger type = [typeStr integerValue];
    if (type > 2 || type < 0 || !timestamp || !timestamp.length) {
        [self sendResult:command code:DSOperationStateParamsError result:nil];
        return;
    }
    //隔离掉userId为空的状态，理论上应该不存在
    NSString *userId = CUSTOMER_GET(userIdKey);
    userId = [NSString stringWithFormat:@"%@", userId];
    if (!userId || !userId.length) {
        [self sendResult:command code:DSOperationStateUnlogin result:nil];
        return;
    }
    void(^executeBlock)(void);
    //use camera to get what you want.
    executeBlock = ^() {
        [XQDGetPhotoManager showCameraWithType:type timestamp:timestamp controller:self.viewController finished:^(BOOL success, id result) {
            DSOperationState stateCode = -1;
            NSNumber *code = [(NSDictionary *)result objectForKey:@"ErrorCode"];
            if (success) {
                stateCode = DSOperationStateSuccess;
            } else {
                stateCode = [code integerValue];
            }
            [self sendResult:command code:stateCode result:result];
        }];
    };
    //隔离掉相机权限被拒绝的用户
    @try {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(AVAuthorizationStatusDenied == authStatus) {
            [self sendResult:command code:DSOperationStateAuthorizationDenied result:@"访问相机"];
            return;
        } else if(AVAuthorizationStatusNotDetermined == authStatus) {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        executeBlock();
                    });
                    
                } else {
                    [self sendResult:command code:DSOperationStateAuthorizationDenied result:@"[]您拒绝了对应用授权使用相机"];
                    return ;
                }
            }];
            
        } else if(AVAuthorizationStatusAuthorized == authStatus) {
            executeBlock();
        }
    } @catch (NSException *exception) {
        DSLog(@"exception = %@", exception);
        
    } @finally {
        
    }
}


@end
