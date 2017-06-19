//
//  XQDTabBarItem.m
//  gongfudai
//
//  Created by David Lan on 15/10/19.
//  Copyright (c) 2015 Hangzhou Tree Finance Ltd. All rights reserved.
//

#import "XQDTabBarItem.h"
#import "UIView+Expand.h"
#import "UIImage+Resizing.h"
#import <objc/runtime.h>

@implementation XQDTabBarItem

- (void)setBadgeValue:(NSString *)badgeValue{
    [super setBadgeValue:badgeValue];
    
    if (!badgeValue||!([badgeValue isEqualToString:@""])) {
        return;
    }
    // 获取tabbarcontroller
    UITabBarController *tabBarController = [self valueForKeyPath:@"_target"];
    
    // 寻找目标
    for (UIView *tabBarChild in tabBarController.tabBar.subviews) {
        if ([tabBarChild isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            for (UIView *tabBarButtonChild in tabBarChild.subviews) {
                
                if ([tabBarButtonChild isKindOfClass:NSClassFromString(@"_UIBadgeView")]) {
                    
                    [tabBarButtonChild setSize:CGSizeMake(15,15)];
                    
                    for (UIView *badgeViewChild in tabBarButtonChild.subviews) {
                        
                        if ([badgeViewChild isKindOfClass:NSClassFromString(@"_UIBadgeBackground")]) {

                            unsigned int count;
                            
                            Ivar *ivars = class_copyIvarList([badgeViewChild class], &count);

                            for (int i = 0 ; i < count; i++) {
                                Ivar ivar = ivars[i];
                                NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar)
                                                                        encoding:NSUTF8StringEncoding];

                                if ([ivarName isEqualToString:@"_image"]) {
                                    
                                    UIImage *image = [UIImage imageNamed:@"red-point"];
                                    
                                    [badgeViewChild setValue:[image scaleToSize:CGSizeMake(15 , 15)] forKey:ivarName];
                                }
                                
                            }
                            // 释放内存
                            free(ivars);
                            
                            
                        }
                        
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
}


@end
