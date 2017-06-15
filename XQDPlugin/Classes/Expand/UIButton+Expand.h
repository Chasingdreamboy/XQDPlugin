//
//  UIButton+Expand.h
//  gongfudai
//
//  Created by _tauCross on 14-8-11.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Expand)

- (void)setImageForState:(UIControlState)state
           withURLString:(NSString *)URLString
        placeholderImage:(UIImage *)placeholderImage;

@end
