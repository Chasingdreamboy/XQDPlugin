//
//  XQDImagePlugin.m
//  kaixindai
//
//  Created by EriceWang on 2017/2/23.
//  Copyright © 2017年 Ericdong. All rights reserved.
//

#import "XQDImagePlugin.h"
#import "UIView+Expand.h"
#import <RKDropdownAlert/RKDropdownAlert.h>

@interface XQDImagePlugin () {
    NSDictionary *currentCommand;
}
@end

@implementation XQDImagePlugin
- (void)save:(NSDictionary *)command {
    NSString *base64String = [command objectForKey:@"base64String"];
    if (base64String) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
         UIImage *image = image = [UIImage imageWithData:data];
        if (image) {
            currentCommand = command;
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:error:contextInfo:), nil);
        }
    } else {
        [self sendResult:command code:DSOperationStateParamsError result:nil];
    }
}
- (void)screen:(NSDictionary *)command {
    //保存屏幕截图（含二维码）
    UIImage *screenShot = [self.viewController.view imageByRenderingView];
    if (screenShot) {
        currentCommand =  command;
        
        UIImageWriteToSavedPhotosAlbum(screenShot, self, @selector(image:error:contextInfo:), nil);
        
    }
}
- (void)image:(UIImage *)image error:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [self sendResult:currentCommand code:DSOperationStateUnknownError result:nil];
        [RKDropdownAlert title:@"保存提示" message:@"截图保存失败,请重新尝试"];
    } else {
        [self sendResult:currentCommand code:DSOperationStateSuccess result:nil];
        [RKDropdownAlert title:@"保存提示" message:@"截图保存成功" backgroundColor:COLOR_SUCCESS textColor:COLOR_DEFAULT];
    }
}
@end
