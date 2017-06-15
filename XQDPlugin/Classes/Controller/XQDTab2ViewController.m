//
//  LoanOrderViewController.m
//  gongfudai
//
//  Created by EriceWang on 15/8/19.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import "XQDTab2ViewController.h"
//#import "YCXMenu.h"
#import "XQDUtil.h"
#import "config.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "XQDJSONUtil.h"
#import "XQDNoticeView.h"

@interface XQDTab2ViewController()
{
    NSArray* notifications;
}

@end

@implementation XQDTab2ViewController
- (void)viewDidLoad {
    self.startPage = [XQDUtil getUrlWithParams:GET_H5_URL(@"/application/records")];
    self.unneedResetItem = YES;
    [super viewDidLoad];
    self.webview.scrollView.scrollEnabled = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self loadNotice];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


@end
