//
//  XQDBaseViewController.m
//  kaixindai
//
//  Created by EriceWang on 2017/3/8.
//  Copyright © 2017年 Ericdong. All rights reserved.
//

#import "XQDBaseViewController.h"
#import "UIViewController+Expand.h"

@interface XQDBaseViewController ()

@end

@implementation XQDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.showNavigationBar = YES;
    if (!_unneedResetItem) {
       [self addCustomerLeftItem];
    }
}
-(void)setShowNavigationBar:(BOOL)showNavigationBar {
    _showNavigationBar = showNavigationBar;
    [self.navigationController setNavigationBarHidden:!showNavigationBar animated:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
