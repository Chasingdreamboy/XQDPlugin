//
//  UIImageView+Expand.m
//  gongfudai
//
//  Created by _tauCross on 14-7-17.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import "UIImageView+Expand.h"
#import "UIView+Expand.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (Expand)

- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholderImage
{
    [self sd_setImageWithURL:[NSURL URLWithString:URLString]
            placeholderImage:placeholderImage
                     options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)rotateAnticlockwiseSpeed:(CGFloat)speed
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 2.0 ];
    rotationAnimation.duration = speed;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT32_MAX;
    [self.layer addAnimation:rotationAnimation forKey:@"rotateAnticlockwise"];
    [self setNeedsDisplay];
}

- (void)rotateClockwiseSpeed:(CGFloat)speed
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = speed;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT32_MAX;
    [self.layer addAnimation:rotationAnimation forKey:@"rotateClockwise"];
    [self setNeedsDisplay];
}

- (void)stopAnimation
{
    [self.layer removeAllAnimations];
}

- (void)magRoundAnimationCenter:(NSValue *)centerValue
{
    CGPoint center = centerValue.CGPointValue;
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INT32_MAX;
    pathAnimation.duration = 3.0;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGFloat r = fabsf(sqrtf(powf(self.centerX - center.x, 2) + powf(self.centerY - center.y, 2)));
    CGFloat a = r;
    CGFloat b = r;
    CGFloat c = sqrtf(powf(r - (self.centerX - center.x), 2) + powf(self.centerY - center.y, 2));
    CGFloat startA = acosf((powf(a, 2) + powf(b, 2) - powf(c, 2)) / (2 * a * b));
    CGPathAddArc(curvedPath, NULL, center.x, center.y, r, startA, startA - M_PI * 2, YES);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
    [self setNeedsDisplay];
}

@end
