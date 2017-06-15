//
//  XQDNoticeView.m
//  gongfudai
//
//  Created by David Lan on 15/11/2.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import "XQDNoticeView.h"
#import "XQDWebViewController.h"
#import "UIButton+Expand.h"
#import <pop/POP.h>
#import "Header.h"
#import "XQDHelper.h"

@implementation XQDNoticeView

- (instancetype)initWithNotifications:(NSArray*)notices
{
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.frame =frame;
        self.notifications=notices;
        [self initContentView];
    }
    return self;
}

-(void)initContentView{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float width = screenWidth-30;
    float height = width/3*4;
    contentFrame = CGRectMake(15, 75, width, height);
    _backdrop = [[UIView alloc] initWithFrame:self.frame];
    _backdrop.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _closeButton=[[UIButton alloc]initWithFrame:CGRectMake(screenWidth-15-22, 30, 22, 22)];
    [_closeButton setBackgroundImage:[XQDHelper getImageWithNamed:@"close-notice"] forState:UIControlStateNormal];
    _content=[[UIScrollView alloc]init];
    _content.layer.cornerRadius=8;
    _pageControl=[[UIPageControl alloc]init];
    _pageControl.hidesForSinglePage=YES;
    _pageControl.numberOfPages=_notifications.count;
    [_notifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton* btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTag:idx];
        [btn addTarget:self action:@selector(eventImageSelected:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(idx*contentFrame.size.width, 0, contentFrame.size.width, contentFrame.size.height)];
        [btn setImageForState:UIControlStateNormal withURLString:[obj objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"notice-placeholder"]];
        [_content addSubview:btn];
    }];
    [_content setBackgroundColor:HEXCOLOR(@"ffffff")];
    [_content setContentSize:CGSizeMake(_notifications.count*contentFrame.size.width, 0)];
    [_content setShowsHorizontalScrollIndicator:NO];
    [_content setPagingEnabled:YES];
//    [_content setDelaysContentTouches:NO]
    [_content setDelegate:self];
    
    
    [self addSubview:_backdrop];
    [self addSubview:_content];
    [self addSubview:_pageControl];
    [self addSubview:_closeButton];
    [self bringSubviewToFront:_pageControl];
    
    [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - public

-(void)eventImageSelected:(UIButton*)button{
    
    NSInteger index=button.tag;
    NSDictionary* notice=[_notifications objectAtIndex:index];
    if ([notice objectForKey:@"destinationClass"]&&![[notice objectForKey:@"destinationClass"] isEqualToString:@""]) {
        Class clas=NSClassFromString([notice objectForKey:@"destinationClass"]);
        UIViewController* vc=[[clas alloc] init];
        if ([vc isKindOfClass:NSClassFromString(@"CDVViewController")]) {
            NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:[notice objectForKey:@"params"]];
            [params setObject:CUSTOMER_GET(userIdKey) forKey:@"userId"];
            [params setObject:CUSTOMER_GET(tokenKey) forKey:@"token"];
            NSString* u=[notice objectForKey:@"url"];
            NSString* url=[NSString stringWithFormat:([u containsString:@"?"]?@"%@&%@":@"%@?%@"),[notice objectForKey:@"url"],[params queryStringValue]];
            if (![url isEqual:[NSNull null]]&&![url isEqualToString:@""]) {
                [(XQDWebViewController*)vc setStartPage:url];
            }
        }
        else{
            NSLog(@"%@",NSStringFromClass([[self.window visibleViewController] class]));
            if ([NSStringFromClass([[self.window visibleViewController] class]) isEqualToString:[notice objectForKey:@"destinationClass"]]) {
                return;
            }
        }
        [vc.view setBackgroundColor:BG_COLOR];
        vc.title=[notice objectForKey:@"title"];
        vc.hidesBottomBarWhenPushed=YES;
        [self hide];
        [self.window.visibleViewController.navigationController pushViewController:vc animated:YES];
    }
}
- (void)show
{
    if(_isShow)
    {
        return;
    }
    _isShow = YES;
    _backdrop.alpha = 1.0;
    
    POPSpringAnimation *popAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    popAni.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.1f, 0.1f)];
    popAni.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    popAni.springBounciness = 10.0f;
    popAni.springSpeed = 15.0f;
    [popAni setCompletionBlock:^(POPAnimation *animate,BOOL success) {
        [self addTimer];
    }];
    _content.frame=contentFrame;
    _pageControl.width=_content.width;
    _pageControl.center=_content.center;
    _pageControl.bottom=_content.bottom-20;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [_content.layer pop_addAnimation:popAni forKey:@"scale"];
    
//    [MobClick beginLogPageView:@"noticeView"];
}

- (void)hide
{
    _isShow = NO;
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float width = screenWidth-30;
    [UIView animateWithDuration:0.2
                     animations:^{
                         _backdrop.alpha = 0.0;
                         _content.frame = CGRectMake(15, 75, width, 0);
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    [self removeTimer];
//    [MobClick endLogPageView:@"noticeView"];
}


- (void)nextImage
{
    int page = (int)_pageControl.currentPage;
    if (page == _pageControl.numberOfPages-1) {
        page = 0;
    }
    else{
        page++;
    }
    
    //  滚动scrollview
    CGFloat x = page * contentFrame.size.width;
    [UIView animateWithDuration:.5 animations:^{
        _content.contentOffset=CGPointMake(x, 0);
    }];
}

// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    _pageControl.currentPage = page;
}

// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
    //    [self.timer invalidate];
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    开启定时器
    [self addTimer];
}

/**
 *  开启定时器
 */
- (void)addTimer{
    if(_notifications&&_notifications.count>1){
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    }
}
/**
 *  关闭定时器
 */
- (void)removeTimer
{
    [timer invalidate];
}

@end
