//
//  XQDHelper.m
//  Pods
//
//  Created by EriceWang on 2017/6/13.
//
//

#import "XQDHelper.h"
#import "XQDCameraViewController.h"
#import "UIImage+Expand.h"
#import "Header.h"

@implementation XQDHelper
+ (NSBundle *)bundle {
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [currentBundle URLForResource:@"XQDPlugin" withExtension:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:url];
    return resourceBundle;
}
+ (UIImage *)getImageWithNamed:(NSString *)imageName {
    NSBundle *resourceBundle = [self bundle];
   UIImage *image = [UIImage imageNamed:imageName inBundle:resourceBundle compatibleWithTraitCollection:nil];
    image = [image imageWithTintColor:[UIColor whiteColor]];
    return image;
}
@end
