//
//  UIView+Expand.h
//  gongfudai
//
//  Created by _tauCross on 14-7-16.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Expand)

@property(nonatomic, assign)CGFloat x;
@property(nonatomic, assign)CGFloat y;
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, assign)CGFloat top;
@property(nonatomic, assign)CGFloat bottom;
@property(nonatomic, assign)CGFloat left;
@property(nonatomic, assign)CGFloat right;
@property(nonatomic, assign)CGFloat centerX;
@property(nonatomic, assign)CGFloat centerY;
@property(nonatomic, assign)CGPoint origin;


@property (nonatomic) CGSize size;
- (void)removeAllSubView;
//- (UIGestureRecognizer *)gestureRecognizerWithTag:(NSInteger)tag;
//for shotScreen
-(UIImage*)imageByRenderingView;
@end
