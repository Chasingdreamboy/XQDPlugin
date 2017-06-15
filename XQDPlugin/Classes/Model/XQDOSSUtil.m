//
//  UpLoadALiCloud.m
//  Wedding
//
//  Created by wangzhen on 16/1/26.
//  Copyright © 2016年 Bao. All rights reserved.
//

#import "XQDOSSUtil.h"
#import "XQDJSONUtil.h"
#import <AliyunOSSiOS/OSSClient.h>
#import <AliyunOSSiOS/OSSCompat.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "Header.h"
#import "NSDate+Expand.h"

@interface XQDOSSUtil () {
    id<OSSCredentialProvider> credentialProvider;
    NSTimeInterval timeStamp;//时间戳
    OSSPutObjectRequest *upload;//上传请求
    OSSGetObjectRequest *download;//下载
    OSSDeleteObjectRequest *delete;//删除请求
    OSSClient *client;//客户端
}

@end

@implementation XQDOSSUtil
+(instancetype)sharedInstance{
    static XQDOSSUtil *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
    });
    return instance;
}
//上传资源
-(void)getUpLoadHandler:(NSData *)data filePath:(NSString *)filePath contentType:(NSString *)type progress:(ProgressBlock)progressBlock finished:(FinishedBlock)finishedBlock {
    
    upload = [OSSPutObjectRequest new];
    upload.bucketName = OSS_BUCKET;
    NSString* oss_path=CUSTOMER_GET(userIdKey);
    NSString* key=[NSString stringWithFormat:@"%@/%@",oss_path,filePath];
    NSLog(@"keyPath = %@", key);
    upload.objectKey = key;
    upload.uploadingData = data;
    upload.contentType = type;
        upload.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressBlock) {
                    progressBlock(totalByteSent / (totalBytesExpectedToSend / 1.0));
                }
            });

        };
    OSSTask * putTask1 = [client putObject:upload];
    [putTask1 continueWithBlock:^id(OSSTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!task.error) {
                if (finishedBlock) {
                    
                    finishedBlock(YES, key);
                } else {
                    NSLog(@"finished 为空");
                }
            } else {
                NSString *error = [NSString stringWithFormat:@"%@", task.error];
                finishedBlock(NO, error);
            }
        });
        return nil;
    }];
    
}
//下载资源
- (void)getDownlLoadHanderWithFilePath:(NSString *)filePath contentType:(NSString *)type progress:(ProgressBlock)progressBlock finished:(FinishedBlock)finishedBlock {
    [self initOSSService];
    //首先监测删除资源是否在OSS上
    NSString* oss_path=CUSTOMER_GET(userIdKey);
    NSString* key=[NSString stringWithFormat:@"%@/%@",oss_path,filePath];
//    NSLog(@"another key =%@", key);
    NSError *error = nil;
    BOOL isExist = [client doesObjectExistInBucket:OSS_BUCKET objectKey:key error:&error];
    if (!error) {
        if (isExist) {
            //文件存在
            NSLog(@"The file you want to delete does exist!");
        } else {
            //文件不存在
            NSLog(@"The file you want to delete doesnot exist!");
            return;
        }
    } else {
        //发生错误
        NSLog(@"Error happens:%@", error);
        return;
    }
    download = [OSSGetObjectRequest new];
    download.bucketName = OSS_BUCKET;
    download.objectKey = key;
    
    download.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(totalBytesWritten / (totalBytesExpectedToWrite / 1.0));
            }
        });
        
    };
    OSSTask *task = [client getObject:download];
    [task continueWithBlock:^id(OSSTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (task.error) {
                //发生错误
                NSLog(@"Error happens:%@", error);
                if (finishedBlock) {
                    NSString *error = [NSString stringWithFormat:@"%@", task.error];
                    
                    finishedBlock(NO, error);
                }
            } else {
                OSSGetObjectResult * getResult = task.result;
                if (finishedBlock) {
                    finishedBlock(YES, getResult.downloadedData);
                }
                
            }
        });
        return nil;
    }];
}
//删除资源
-(void)getDeleteHandlerWithFilePath:(NSString *)filePath contentType:(NSString *)type finished:(FinishedBlock)finishedBlock {
    [self initOSSService];
    //首先监测删除资源是否在OSS上
    NSString* oss_path=CUSTOMER_GET(userIdKey);
    NSString* key=[NSString stringWithFormat:@"%@/%@",oss_path,filePath];
    NSError *error = nil;
    BOOL isExist = [client doesObjectExistInBucket:OSS_BUCKET objectKey:key error:&error];
    
    if (!error) {
        if (isExist) {
            //文件存在
            NSLog(@"The file you want to delete does exist!");
        } else {
            //文件不存在
            NSLog(@"The file you want to delete doesnot exist!");
            return;
        }
    } else {
        //发生错误
        NSLog(@"Error happens:%@", error);
        return;
    }
    delete = [OSSDeleteObjectRequest new];
    delete.bucketName = OSS_BUCKET;
    delete.objectKey = key;
    OSSTask *task = [client deleteObject:delete];
    [task continueWithBlock:^id(OSSTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!task.error) {
                finishedBlock(YES, nil);
            } else {
                NSString *error = [NSString stringWithFormat:@"%@", task.error];
                finishedBlock(NO, error);
            }
        });
        return nil;
    }];
}
//初始化参数
-(BOOL)initOSSService {
    if (credentialProvider&&[NSDate timeIntervalForSince1970] - timeStamp<3500) {
        return YES;
    }
    timeStamp = [NSDate timeIntervalForSince1970];
    credentialProvider = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        //通过同步请求获取accessKey accessToken, tempToken和expiration
        NSError* error=nil;
        NSDictionary *params = @{@"userId":CUSTOMER_GET(userIdKey)};
        NSDictionary* response=[[XQDJSONUtil sharedInstance]getJSON:GET_SERVICE(@"/oss/authorise")  withData:params.getParas method:@"get" error:&error];
        NSDictionary* data=[response objectForKey:@"data"];
        if (!error&&data!=nil) {
            NSString* ak=[[XQDJSONUtil sharedInstance]getParam:@"ak" fromDict:data];
            NSString* sk=[[XQDJSONUtil sharedInstance]getParam:@"sk" fromDict:data];
            NSString* tempToken=[[XQDJSONUtil sharedInstance]getParam:@"tempToken" fromDict:data];
            NSNumber* temExpiration=[[XQDJSONUtil sharedInstance]getParam:@"expiration" fromDict:data];
            NSString *expiration = [NSString stringWithFormat:@"%@", temExpiration];
            OSSFederationToken * token = [OSSFederationToken new];
            token.tAccessKey = ak;
            token.tSecretKey = sk;
            token.tToken = tempToken;
            token.expirationTimeInGMTFormat = expiration;
            return token;
        }
        return nil;
    }];
    if (!credentialProvider) {
        return NO;
    }
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    client = [[OSSClient alloc] initWithEndpoint:OSS_HOST credentialProvider:credentialProvider clientConfiguration:conf];
    return YES;
}

-(void)clearService{
    credentialProvider=nil;
}


@end
