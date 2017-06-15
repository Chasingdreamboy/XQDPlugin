//
//  UIImage+Expand.m
//  gongfudai
//
//  Created by _tauCross on 14-6-9.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import "UIImage+Expand.h"
#import "macro.h"
#import "UIImage+Expand.h"

@implementation UIImage (Expand)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)scaleToSize:(CGSize)size
{
    CGSize selfSize = self.size;
    CGSize reSize = size;
    CGFloat rw = reSize.width / selfSize.width;
    CGFloat rh = reSize.height / selfSize.height;
    CGFloat rate = MAX(rw, rh);
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * rate, self.size.height * rate));
    [self drawInRect:CGRectMake(0, 0, self.size.width * rate, self.size.height * rate)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGRect cutRect = CGRectMake((scaledImage.size.width - reSize.width) / 2, (scaledImage.size.height - reSize.height) / 2, reSize.width, reSize.height);
    CGImageRef imageRef = scaledImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, cutRect);
    
    UIGraphicsBeginImageContext(reSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, cutRect, subImageRef);
    UIImage *cutImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return cutImage;
}

+ (UIImage *)gradientImageFromColors:(NSArray *)colors ByGradientType:(GradientType)gradientType size:(CGSize)size
{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case 3:
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)screenShot
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT), YES, 0);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

+ (UIImage *)screenShotSimple
{
    UIImage *viewImage = [UIImage screenShot];
    return [viewImage scaleToSize:CGSizeMake(viewImage.size.width / 2, viewImage.size.height / 2)];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

- (UIImage *)gaussianWithRadius:(CGFloat)radius
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:kCIInputRadiusKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect rect = inputImage.extent;
    rect.origin.x += radius / 2;
    rect.origin.y += radius / 2;
    rect.size.width -= radius;
    rect.size.height -= radius;
    CGImageRef cgImage = [context createCGImage:result fromRect:rect];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}

-(UIImage*)getImageCornerRadius:(const CGFloat)radius {
    UIImage *image = self;
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    const CGRect RECT = CGRectMake(0, 0, image.size.width, image.size.height);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:RECT cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:RECT];
    
    // Get the image, here setting the UIImageView image
    //imageView.image
    UIImage* imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return imageNew;
}

+(UIImage*)imageFromBase64String:(NSString *)base64String{
    
        unsigned long ixtext, lentext;
        unsigned char ch, inbuf[4], outbuf[3];
        short i, ixinbuf;
        Boolean flignore, flendtext = false;
        const unsigned char *tempcstring;
        NSMutableData *theData;
        
        if (base64String == nil)
        {
            return [UIImage imageWithData:[NSData data]];
        }
        
        ixtext = 0;
        
        tempcstring = (const unsigned char *)[base64String UTF8String];
        
        lentext = [base64String length];
        
        theData = [NSMutableData dataWithCapacity: lentext];
        
        ixinbuf = 0;
        
        while (true)
        {
            if (ixtext >= lentext)
            {
                break;
            }
            
            ch = tempcstring [ixtext++];
            
            flignore = false;
            
            if ((ch >= 'A') && (ch <= 'Z'))
            {
                ch = ch - 'A';
            }
            else if ((ch >= 'a') && (ch <= 'z'))
            {
                ch = ch - 'a' + 26;
            }
            else if ((ch >= '0') && (ch <= '9'))
            {
                ch = ch - '0' + 52;
            }
            else if (ch == '+')
            {
                ch = 62;
            }
            else if (ch == '=')
            {
                flendtext = true;
            }
            else if (ch == '/')
            {
                ch = 63;
            }
            else
            {
                flignore = true;
            }
            
            if (!flignore)
            {
                short ctcharsinbuf = 3;
                Boolean flbreak = false;
                
                if (flendtext)
                {
                    if (ixinbuf == 0)
                    {
                        break;
                    }
                    
                    if ((ixinbuf == 1) || (ixinbuf == 2))
                    {
                        ctcharsinbuf = 1;
                    }
                    else
                    {
                        ctcharsinbuf = 2;
                    }
                    
                    ixinbuf = 3;
                    
                    flbreak = true;
                }
                
                inbuf [ixinbuf++] = ch;
                
                if (ixinbuf == 4)
                {
                    ixinbuf = 0;
                    
                    outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                    outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                    outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                    
                    for (i = 0; i < ctcharsinbuf; i++)
                    {
                        [theData appendBytes: &outbuf[i] length: 1];
                    }
                }
                
                if (flbreak)
                {
                    break;
                }
            }
        }
        
    return [UIImage imageWithData:theData];
}

@end
