//
//  UIAlertView+Expand.m
//  gongfudai
//
//  Created by _tauCross on 14-8-1.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import "UIAlertView+Expand.h"

#import <objc/runtime.h>

static char alert_view_complete_block_key;

@implementation UIAlertView (Expand)

- (void)showAlertViewWithCompleteBlock:(AlertViewCompleteBlock)block
{
    if(block)
    {
        objc_setAssociatedObject(self, &alert_view_complete_block_key, block, OBJC_ASSOCIATION_COPY);
        self.delegate = self;
    }
    [self showWithRecord];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AlertViewCompleteBlock block = objc_getAssociatedObject(self, &alert_view_complete_block_key);
    if(block)
    {
        block(buttonIndex, alertView);
    }
}

- (void)showWithRecord
{
//    CMSharedGlobal.recordAlertView = self;
    [self show];
}

@end
