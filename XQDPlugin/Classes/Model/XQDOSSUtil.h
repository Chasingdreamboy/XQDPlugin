//
//  UpLoadALiCloud.h
//  Wedding
//
//  Created by wangzhen on 16/1/26.
//  Copyright © 2016年 Bao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 *  正常操作结束
 *
 *  @param success  是否成功完成操作
 *  @param response 
 success为YES时，response为资源的全路径Url
 success为NO时，response为NSError对象，返回错误信息
 */
typedef void(^FinishedBlock) (BOOL success, id response);
/**
 *  进度回调函数
 *
 *  @param progress 当前进度
 */
typedef void(^ProgressBlock) (CGFloat progress);

@interface XQDOSSUtil : NSObject

+(instancetype)sharedInstance;
/**
 *  图片资源上传句柄
 *
 *  @param data          二进制图片数据（有压缩， 0.7）
 *  @param filePath      timestamp+imageName(front.jpg || back.jpg || withCard.jpg)
 *  @param type          上传的资源类型（optional）
 *  @param progressBlock 进度回调函数
 *  @param finishedBlock 结果回调函数
 */
-(void)getUpLoadHandler:(NSData *)data filePath:(NSString *)filePath contentType:(NSString *)type progress:(ProgressBlock)progressBlock finished:(FinishedBlock)finishedBlock;
//下载资源
- (void)getDownlLoadHanderWithFilePath:(NSString *)filePath contentType:(NSString *)type progress:(ProgressBlock)progressBlock finished:(FinishedBlock)finishedBlock;
//删除资源
-(void)getDeleteHandlerWithFilePath:(NSString *)filePath contentType:(NSString *)type finished:(FinishedBlock)finishedBlock;
-(BOOL)initOSSService;
-(void)clearService;

@end
