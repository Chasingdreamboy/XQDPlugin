//
//  UIImage+Expand.h
//  gongfudai
//
//  Created by _tauCross on 14-6-9.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    topToBottom = 0,//从上到下
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;

@interface UIImage (Expand)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

+ (UIImage *)gradientImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType size:(CGSize)size;

+ (UIImage *)screenShot;
+ (UIImage *)screenShotSimple;

- (UIImage *)gaussianWithRadius:(CGFloat)radius;

-(UIImage*)getImageCornerRadius:(const CGFloat)radius;

+(UIImage*)imageFromBase64String:(NSString*)base64String;

@end
