//
//  XQDGetPhotoManager.m
//  gongfudai
//
//  Created by EriceWang on 16/4/29.
//  Copyright © 2016年 dashu. All rights reserved.
//

#import "XQDGetPhotoManager.h"
#import <objc/runtime.h>
#import "XQDOSSUtil.h"
#import "UIImage+Exif.h"
#import "UIImage+Rotating.h"
#import <SimpleExif/ExifContainer.h>
#import "XQDCameraViewController.h"
#import "Header.h"
#import "MBProgressHUD+Expand.h"

@interface XQDGetPhotoManager ()<DSCameraHolderViewDelegate>
@property (strong, nonatomic) XQDCameraViewController *camera;
@property (copy, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) NSString *timestamp;
@end

@implementation XQDGetPhotoManager

static dispatch_once_t onceToken;
static XQDGetPhotoManager *manager;
+(void)resetCamera {
    onceToken = 0;
    manager = nil;
}
+ (void)showCameraWithType:(DSPhotoType)type timestamp:(NSString *)timestamp controller:(UIViewController *)viewController finished:(Finished)finished {
    //初始化单例对象
    [self resetCamera];
    [self sharedInstance].timestamp = timestamp;
    XQDCameraViewController *camera = [self sharedInstance].camera;
    camera.cancel = ^() {
        if (finished) {
            finished(NO, @{@"ErrorCode" : @(DSOperationStateOperationCancel),
                           @"data" : @""
                           });
        }
    };
    camera.placeHolderType = (CameraViewPlaceholderType)type;
    objc_setAssociatedObject([self sharedInstance], @selector(photoTaken:), finished, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self sharedInstance].imageUrl = [self getSourceUrlWithType:type];
    [viewController presentViewController:camera animated:YES completion:nil];
}
#pragma DSCameraViewControlelrDelegate
-(void)photoTaken:(UIImage*)img {
    [self uploadImage:img withName:self.imageUrl withExif:YES];
}
#pragma privateMethod
+ (XQDGetPhotoManager *)sharedInstance {
    dispatch_once(&onceToken, ^{
        manager = [[XQDGetPhotoManager alloc] init];
    });
    return manager;
}
+ (NSString *)getSourceUrlWithType:(DSPhotoType)type {
    NSArray *arr = @[@"front.jpg", @"back.jpg", @"withCard.jpg"];
    NSString *imageName = [NSString stringWithFormat:@"%@/%@", [self sharedInstance].timestamp, arr[type]];
    NSLog(@"imageName = %@", imageName);
    return imageName;
}
#pragma upload
- (void) uploadImage:(UIImage*)image withName:(NSString*)imageName withExif:(BOOL)withExif{
    BOOL hasToken=[[XQDOSSUtil sharedInstance]initOSSService];
    if (!hasToken) {
        [MBProgressHUD showFail:@"服务器请求失败，请重试" withDuration:2];
        return;
    }
    //旋转上传
    if ([imageName containsString:@"front.jpg"] || [imageName containsString:@"back.jpg"] ) {
        image = [image rotateInDegrees:90];
    }
    NSData* dataToUpload;
    if (withExif) {
        dataToUpload=[self getImageDataWithExif:UIImageJPEGRepresentation(image, 0.7)];
    }
    else{
        dataToUpload=UIImageJPEGRepresentation(image, 0.7);
        imageName=DS_STR_FORMAT(@"%@_NoExif", imageName);
    }
    MBProgressHUD* hud=[MBProgressHUD showLoading:@"开始上传"];
    [[XQDOSSUtil sharedInstance] getUpLoadHandler:dataToUpload filePath:imageName contentType:@"image/jpeg" progress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
            [hud setProgress:progress];
            
        });
    } finished:^(BOOL isSuccess, id response) {
        [[XQDGetPhotoManager sharedInstance].camera dismissViewControllerAnimated:YES completion:^{
            
            Finished finished = objc_getAssociatedObject(self, @selector(photoTaken:));
            if (isSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                  [hud showSuccess:@"上传成功" withDuration:1.0];
                });
                if (finished) {
                    finished(YES,@{
                                   @"ErrorCode" : @(DSOperationStateSuccess),
                                   @"data" : response
                                   });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                [hud showFail:@"上传失败，请重试" withDuration:1.0];
                });
                NSLog(@"error = %@", response);
                if (finished) {
                    finished(NO, @{@"ErrorCode" : @(DSOperationStateNetFail),
                                   @"data" : response
                                   });
                }
            }
        }];
}];
}
- (NSData*)getImageDataWithExif:(NSData*)imageData{
    NSInteger size=imageData.length;
    UIImage* image=[UIImage imageWithData:imageData];
    ExifContainer* container=[[ExifContainer alloc]init];
    NSString* positionData=CUSTOMER_GET(positionKey);
    if (positionData&&![positionData isEqualToString:@""]&&![positionData containsString:@"null"]) {
        NSArray *positions = [positionData componentsSeparatedByString:@","];
        double lat=[positions[0] doubleValue];
        double lng=[positions[1] doubleValue];
        [container addLocation:[[CLLocation alloc] initWithLatitude:lat longitude:lng]];
    }
    [container addCreationDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    //2017.2.3
    NSString *exinfo = [NSString stringWithFormat:@"ios|%@|%@|%@|%@|%ld",[XQDUtil detailModel],[XQDUtil systemVersion],[XQDUtil appVersion],CUSTOMER_GET(userIdKey),(long)size];
    NSString* encryptComments=[XQDUtil RSAEncript:exinfo withPublickKey:PUBLIC_KEY];
    
    
    [container addUserComment:encryptComments];
    return [image addExif:container];
}
#pragma lazyLoad
- (XQDCameraViewController *)camera {
    if (!_camera) {
        _camera = [[XQDCameraViewController alloc] init];
        _camera.delegate = self;
    }
    return _camera;
}

@end
