//
//  XQDLoginHookViewController.m
//  gongfudai
//
//  Created by David Lan on 15/8/27.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import "XQDLoginHookViewController.h"
#import <RegexKitLite/RegexKitLite.h>
#import "Header.h"
#import "UIImage+Expand.h"
@interface XQDLoginHookViewController ()<NSURLConnectionDataDelegate>
{
    NSMutableArray* _headers;
    NSMutableDictionary* _cookieDict;
    NSMutableArray* _cookieArray;
    NSInteger _count;
    BOOL _done;
    
    NSInteger numbersRequest;
    
    
    UIButton* btnRight;
}
@end

@implementation XQDLoginHookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _headers=[NSMutableArray array];
    _cookieDict=[NSMutableDictionary dictionary];
    _cookieArray=[NSMutableArray array];
    _count=0;
    _done=NO;
    [self addDefaultBackAndRefreshItem:NO action:@selector(eventLeftItemClick:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshWebview:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        __block UIImageView* img = btnRight.imageView;
        [UIView animateKeyframesWithDuration:.8 delay:.1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            for (int i=0; i<4; ++i) {
                [UIView addKeyframeWithRelativeStartTime:0.25*i relativeDuration:1.0/4.0 animations:^{
                    img.transform=CGAffineTransformRotate(img.transform,M_PI/2);
                }];
            }
            
        } completion:^(BOOL finished) {
            
        }];
    });
    [super refreshWebview:sender];


}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    numbersRequest++;
    DSLog(@"start AAA:%@", @(numbersRequest));
    
    [super webViewDidStartLoad:webView];
    //不要问我为什么写这个，问前端
    if (!self.unneedResetItem) {
        UIBarButtonItem *item = [self addDefaultBackAndRefreshItem:YES action:@selector(eventLeftItemClick:)];
        item = [self addDefaultBackAndRefreshItem:NO action:@selector(eventLeftItemClick:)];
    }
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [super webView:webView didFailLoadWithError:error];
    numbersRequest--;
    DSLog(@"fail AAA:%@", @(numbersRequest));
    if (!numbersRequest) {
        NSString *url = [NSString stringWithFormat:@"%@", webView.request.URL];
        [self injectJS:webView url:url];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    numbersRequest--;
    [super webViewDidFinishLoad:webView];
    NSString* url=DS_STR_FORMAT(@"%@", webView.request.URL);
    //DSLog(@"finished AAA:%@, url = %@", @(numbersRequest), url);
    //css 注入
    if (_css!=nil) {
        [_css enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            NSString* reg=[item objectForKey:@"key"];
            NSString* css=[item objectForKey:@"value"];
            if(reg!=nil&&css!=nil&&[url isMatchedByRegex:reg]){
                [self injectCss:css intoWebView:webView];
            }
        }];
    }
    if (!numbersRequest) {
        [self injectJS:webView url:url];
    }
}
- (void)injectJS:(UIWebView *)webView  url:(NSString *)url {
    //js 注入
    if (_js==nil) {
        [webView stringByEvaluatingJavaScriptFromString :@"document.querySelector('input[type=text]').focus()"];
    }
    else{
        [_js enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            NSString* reg=[item objectForKey:@"key"];
            NSString* js=[item objectForKey:@"value"];
            if(reg!=nil&&js!=nil&&[url isMatchedByRegex:reg]){
                DSLog(@"key = %@",reg);
                [webView stringByEvaluatingJavaScriptFromString:js];
            }
        }];
    }


}
- (UIBarButtonItem *)addDefaultBackAndRefreshItem:(BOOL)isLeft action:(SEL)sel{
    NSString *imageName = nil;
    imageName = isLeft ? @"返回" : @"btn-refresh";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 46, 23)];
    UIImage *image = [[UIImage imageNamed:imageName] imageWithTintColor:[UIColor whiteColor]];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = nil;
    if (isLeft) {
        item = [[UIBarButtonItem alloc] initWithCustomView:button];
        [button setImageEdgeInsets:UIEdgeInsetsMake(-0.5, 0, -0.5, 23)];
        button.tag = 100;
        self.navigationItem.leftBarButtonItem = item;
    } else {
        if (btnRight) {
            item = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        } else {
            btnRight = button;
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 10)];
            button.tag = 101;
        }
        self.navigationItem.rightBarButtonItem = item;
    }
    return item;
}
- (void)eventLeftItemClick:(UIButton *)sender {
    if (sender.tag == 100) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if(sender.tag == 101) {
        [self refreshWebview:nil];
    }
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    BOOL result=[super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    if(!result){
        return NO;
    }
    if (request.URL==nil) {
        return NO;
    }
    NSLog(@"\n\n正在请求>>>>>>>>>>>%@",request.URL);
    NSArray* cookies=[[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:request.URL];
    [_cookieArray addObjectsFromArray:cookies];
    for (NSHTTPCookie* cookie in cookies) {
        [_cookieDict setObject:cookie.value forKey:cookie.name];
    }
    BOOL matched=NO;
    NSString* _finishedUrl=[_endUrls objectAtIndex:_count];
    NSLog(@"%@",request.URL);
    if ([_finishedUrl isEqualToString:@""]||_finishedUrl==nil) {
        matched=NO;
    }
    else{
        matched=[DS_STR_FORMAT(@"%@", request.URL) isMatchedByRegex:_finishedUrl];
        
        NSLog(@"matched:%d, count = %@",matched, @(_count));
        DSLog(@"url = %@, _finishedUrl = %@", request.URL, _finishedUrl);
    }
    if (matched) {
        
        [[[NSURLConnection alloc]initWithRequest:request delegate:self]start];
        return NO;
    }
    return YES;
}

-(void)stopTracking:(NSURL*)url headers:(NSDictionary*)headers{
    NSMutableString * cookiesStr=[NSMutableString stringWithString:@""];
    for (NSString* key in [_cookieDict allKeys]) {
        NSString* cookieVal=[_cookieDict objectForKey:key];
        [cookiesStr appendFormat:@"%@=%@;",key,cookieVal];
    }
    if (!_done) {
        if (self.loginSucces) {
            self.loginSucces(@{@"key":_identifier,@"cookie":cookiesStr,@"url":DS_STR_FORMAT(@"%@", url),@"header":[headers json],@"userId":CUSTOMER_GET(userIdKey)});
        }
        _done=YES;
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSDictionary* headers=[(NSHTTPURLResponse*)response allHeaderFields];
    NSArray* cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:response.URL];
    DSLog(@"cookie = %@",cookies );
    
    [_cookieArray addObjectsFromArray:cookies];
    for (NSHTTPCookie* cookie in cookies) {
        [_cookieDict setObject:cookie.value forKey:cookie.name];
    }
    ++_count;
    
    NSString* nextUrl=_count<_startUrls.count?[_startUrls objectAtIndex:_count]:nil;
    DSLog(@"_startUrls = %@", _startUrls);
    
    if (nextUrl!=nil&&![nextUrl isEqualToString:@""]) {
        
        [self.webview loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:nextUrl]]];
    }
    else{
        [self stopTracking:response.URL headers:headers];
    }
}

@end
