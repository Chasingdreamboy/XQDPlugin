//
//  NSObject+Swizzle.m
//  GFDSDK
//
//  Created by EriceWang on 16/5/18.
//  Copyright © 2016年 Hangzhou Tree Finance Ltd. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzle)
+ (void)swizzingInstanceSel:(SEL)aSel withSel:(SEL)bSel {
    Method orignalMethod = class_getInstanceMethod(self, aSel);
    Method replaceMethod = class_getInstanceMethod(self, bSel);
    BOOL didAdd = class_addMethod(self, aSel, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod));
    if (didAdd) {
        class_replaceMethod(self, bSel, method_getImplementation(orignalMethod), method_getTypeEncoding(orignalMethod));
    } else {
        method_exchangeImplementations(orignalMethod, replaceMethod);
    }
}
+ (void)swizzingClassSel:(SEL)aSel withSel:(SEL)bSel {
    Method orignalMethod = class_getClassMethod(self, aSel);
    Method replaceMethod =class_getClassMethod(self, bSel);
    method_exchangeImplementations(orignalMethod, replaceMethod);
}


@end
