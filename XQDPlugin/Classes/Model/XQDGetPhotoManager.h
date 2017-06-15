//
//  XQDGetPhotoManager.h
//  gongfudai
//
//  Created by EriceWang on 16/4/29.
//  Copyright © 2016年 dashu. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  参数说明
 *
 *  @param success 获取图片是否成功
 *  @param result  如果success为YES， 该参数result为图片资源的（NSString *）url，包含userId／timestamp／图片名（front.jpg  或者 back.jpg  或者 withCard.jpg 其中之一）
 如果success为NO， 则参数result为(NSError*)error对象,说明失败的原因
 */
typedef void(^Finished) (BOOL success, id result);
typedef NS_ENUM(NSInteger, DSPhotoType) {
    DSPhotoTypeFront = 0,//身份证正面照
    DSPhotoTypeBack,//身份证反面照
    DSPhotoTypeIdInHand//手持身份证照
};

@interface XQDGetPhotoManager : NSObject
/**
 *  调用相机进行拍照时调用
 *
 *  @param type           拍照的类型
 0:身份证正面
 1:身份证翻面
 2:手持身份证
 *  @param viewController 调用相机的当前控制器
 *  @param success        调用结束时返回的结果，参数意义详见block参数说明
 */
+ (void)showCameraWithType:(DSPhotoType)type timestamp:(NSString *)timestamp controller:(UIViewController *)viewController finished:(Finished)finished;
+ (void)resetCamera;//切换用户或者退出该次上传时调用(想要改变时间戳时调用)
@end
