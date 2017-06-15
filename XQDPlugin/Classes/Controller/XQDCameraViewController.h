//
//  CameraViewController.h
//  gongfudai
//
//  Created by David Lan on 15/7/8.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQDCameraHolderViewController.h"
typedef NS_ENUM(NSInteger, CameraViewPlaceholderType){
    CameraViewPlaceholderTypeFront,
    CameraViewPlaceholderTypeBack,
    CameraViewPlaceholderTypeWithCard
};

@interface XQDCameraViewController : UIViewController
@property(nonatomic,strong) id<DSCameraHolderViewDelegate> delegate;
@property(nonatomic)CameraViewPlaceholderType placeHolderType;

//点击取消的回调事件
@property (copy, nonatomic) void(^cancel)();
@end
