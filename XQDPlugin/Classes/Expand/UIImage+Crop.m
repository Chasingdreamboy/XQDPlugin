//
//  UIImage+Crop.m
//  LLSimpleCamera
//
//  Created by Ömer Faruk Gül on 27/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage(CropCategory)
- (UIImage *)normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}
- (UIImage *)crop:(CGRect)rect {

    rect = CGRectMake(rect.origin.x * self.scale,
                      rect.origin.y * self.scale,
                      rect.size.width * self.scale,
                      rect.size.height * self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}
@end
