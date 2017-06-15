//
//  XQDTab3ViewController.m
//  gongfudai
//
//  Created by David Lan on 15/8/6.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import "XQDTab3ViewController.h"
//#import "DSGridItemModel.h"
#include <objc/objc.h>
#import "XQDJSONUtil.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "XQDWebViewController.h"
#import "XQDTabBarItem.h"
#import "XQDUtil.h"
#import "config.h"
#import "UITabBar+RedPoint.h"

@interface XQDTab3ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong,nonatomic) UIView* badgeView;
@end

@implementation XQDTab3ViewController

- (void)viewDidLoad {
    
    self.startPage = [XQDUtil getUrlWithParams:GET_H5_URL(@"/settings")];
    self.unneedResetItem = YES;
    [super viewDidLoad];
    _badgeView=[[UIView alloc]initWithFrame:CGRectMake(30,8,20,3)];
    [_rightBtn addSubview:_badgeView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if ([DS_GET(hasNewVersionKey) boolValue]) {
//        [self showBadge];
//    } else {
//        [self hideBadge];
//    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//-(void) showBadge{
//    [_badgeView showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeScale];
//}
//
//-(void) hideBadge{
//    [_badgeView clearBadge];
//}


- (IBAction)eventSetting:(id)sender {
    [self performSegueWithIdentifier:@"settingView" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
