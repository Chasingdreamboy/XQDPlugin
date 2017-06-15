//
//  XQDNavBarPlugin.m
//  gongfubao
//
//  Created by David Lan on 15/12/31.
//  Copyright (c) 2015年 Hangzhou Tree Finance Ltd. All rights reserved.
//

#import "XQDNavBarPlugin.h"
#import "UIImage+Resize.h"
#import "UIImage+Expand.h"
#import <SDWebImage/SDWebImageManager.h>
@interface XQDNavBarPlugin()
{
    NSDictionary* currentLeftCommand;
    NSDictionary* currentRightCommand;
}
@end
@implementation XQDNavBarPlugin

-(void)setBarShow:(NSDictionary *)command{
    BOOL showNavigationBar = [[command objectForKey:@"showNavigationBar"] boolValue];
    BOOL animated= [[command objectForKey:@"animated"] boolValue];
    [self.viewController.navigationController setNavigationBarHidden:!showNavigationBar animated:animated];
    [self sendResult:command code:DSOperationStateSuccess result:nil];
}

-(void)setTitle:(NSDictionary *)command{
    NSString* title=[command objectForKey:@"title"];
    if (!title) {
        title = [command objectForKey:@"key"];
    }
    self.viewController.navigationItem.title=title;
    [self sendResult:command code:DSOperationStateSuccess result:nil];
}

-(void)setRightItem:(NSDictionary*)command{

    UIViewController* vc=self.viewController;
    NSString* imageUrl=[command objectForKey:@"url"];
    if (!imageUrl || !imageUrl.length) {
        vc.navigationItem.rightBarButtonItem = nil;
        return;
    }
    currentRightCommand=command;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        image = [image imageWithTintColor:[UIColor whiteColor]];
        
        image = [image resizedImageToSize:(CGSize){24,24}];
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:image
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(eventRightItemClick:)];
        rightBtn.tintColor = [UIColor whiteColor];
        vc.navigationItem.rightBarButtonItem = rightBtn;
        
    }];
}

-(void)setLeftItem:(NSDictionary*)command{
    
    UIViewController* vc=self.viewController;
    NSString* imageUrl=[command objectForKey:@"url"];
    if (!imageUrl || !imageUrl.length) {
        vc.navigationItem.leftBarButtonItem = nil;
        [self sendResult:command code:DSOperationStateParamsError result:nil];
        return;
    }
    currentLeftCommand=command;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        image = [image imageWithTintColor:[UIColor whiteColor]];
        image = [image resizedImageToSize:(CGSize){24,24}];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:image
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(eventLeftItemClick:)];
            leftBtn.tintColor = [UIColor whiteColor];
            vc.navigationItem.leftBarButtonItem = leftBtn;
        });
    }];
}

-(void)eventRightItemClick:(id)sender{
    [self sendResult:currentRightCommand code:DSOperationStateSuccess result:nil];
    [self.webview stringByEvaluatingJavaScriptFromString:@"window.onNativeRightButtonClick()"];
}

-(void)eventLeftItemClick:(id)sender{
    [self sendResult:currentLeftCommand code:DSOperationStateSuccess result:nil];
    BOOL isExist = [[self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"typeof (%@) == 'function'",@"window.onNativeLeftButtonClick"]] isEqualToString:@"true"];
    if (isExist) {
        [self.webview stringByEvaluatingJavaScriptFromString:@"window.onNativeLeftButtonClick()"];
    } else {
        [self.viewController.navigationController popViewControllerAnimated:YES];
    }
}
@end
