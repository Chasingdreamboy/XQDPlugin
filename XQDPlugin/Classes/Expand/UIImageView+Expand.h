//
//  UIImageView+Expand.h
//  gongfudai
//
//  Created by _tauCross on 14-7-17.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Expand)

- (void)setImageWithURLString:(NSString *)URLString
             placeholderImage:(UIImage *)placeholderImage;

- (void)rotateClockwiseSpeed:(CGFloat)speed;
- (void)rotateAnticlockwiseSpeed:(CGFloat)speed;
- (void)stopAnimation;
- (void)magRoundAnimationCenter:(NSValue *)centerValue;

@end
