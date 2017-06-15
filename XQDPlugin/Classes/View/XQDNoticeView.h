//
//  XQDNoticeView.h
//  gongfudai
//
//  Created by David Lan on 15/11/2.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQDNoticeView : UIView<UIScrollViewDelegate>
{
    @private
    UIView          *_backdrop;
    UIScrollView    *_content;
    UIButton        *_closeButton;
    UIPageControl   *_pageControl;
    BOOL            _isShow;
    CGRect          contentFrame;
    NSTimer*        timer;
}
@property(strong,nonatomic) NSArray* notifications;
//@property(nonatomic,copy) void(^(onNoticeOpen))(NSDictionary* notification);
- (instancetype)initWithNotifications:(NSArray*)notifications;
- (void)show;
- (void)hide;
@end
