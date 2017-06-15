//
//  UITabBar+RedPoint.h
//  gongfudaiNew
//
//  Created by EriceWang on 16/9/28.
//  Copyright © 2016年 dashu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (RedPoint)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点
- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
