//
//  NSObject+Swizzle.h
//  GFDSDK
//
//  Created by EriceWang on 16/5/18.
//  Copyright © 2016年 Hangzhou Tree Finance Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)
+ (void)swizzingInstanceSel:(SEL)aSel withSel:(SEL)bSel;
+ (void)swizzingClassSel:(SEL)aSel withSel:(SEL)bSel;


@end
