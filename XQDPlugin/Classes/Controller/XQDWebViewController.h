//
//  XQDWebViewController.h
//  kaixindai
//
//  Created by EriceWang on 2017/2/20.
//  Copyright © 2017年 Ericdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "XQDBaseViewController.h"
@interface XQDWebViewController : XQDBaseViewController<UIWebViewDelegate>
@property(nonatomic) BOOL usePCUA;
@property (copy, nonatomic) NSString *startPage;
@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) NSURLRequest *previousRequest;
@property (assign, nonatomic) BOOL sendPost;
@property (strong, nonatomic) NSDictionary *postParams;



//注入css
-(void) injectCss:(NSString*)css intoWebView:(UIWebView*)webView;
//注入JS
-(void) injectJs:(NSString *)js intoWebView:(UIWebView *)webView;


-(void)refreshWebview:(id)sender;
- (void)refreshAction;
-(void) fakeUA;
- (void)applyCustomerUA;
@end
