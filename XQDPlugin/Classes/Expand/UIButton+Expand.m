//
//  UIButton+Expand.m
//  gongfudai
//
//  Created by _tauCross on 14-8-11.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import "UIButton+Expand.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation UIButton (Expand)

- (void)setImageForState:(UIControlState)state
           withURLString:(NSString *)URLString
        placeholderImage:(UIImage *)placeholderImage
{
    [self sd_setImageWithURL:[NSURL URLWithString:URLString] forState:state placeholderImage:placeholderImage options:SDWebImageAllowInvalidSSLCertificates];
}

@end
