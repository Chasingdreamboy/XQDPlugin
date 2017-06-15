//
//  UIAlertView+Expand.h
//  gongfudai
//
//  Created by _tauCross on 14-8-1.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewCompleteBlock) (NSInteger buttonIndex, UIAlertView *alertView);

@interface UIAlertView (Expand)

- (void)showAlertViewWithCompleteBlock:(AlertViewCompleteBlock)block;

- (void)showWithRecord;

@end
