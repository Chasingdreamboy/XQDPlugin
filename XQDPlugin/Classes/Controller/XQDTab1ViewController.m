//
//  XQDTab1ViewController.m
//  gongfudaiNew
//
//  Created by EriceWang on 16/5/9.
//  Copyright © 2016年 dashu. All rights reserved.
//

#import "XQDTab1ViewController.h"
#import "XQDJSONUtil.h"
#import "XQDTabBarItem.h"
#import "XQDNoticeView.h"
#import "XQDUtil.h"
//#import "macro.h"
//#import "config.h"
#import "Header.h"
#import "UIView+WZLBadge.h"
#import "UIImage+Expand.h"
#import "UITabBar+RedPoint.h"
#import "XQDHelper.h"
#import "UIImage+Expand.h"
#import "XQDPlugin.h"
#import <objc/message.h>
@interface XQDTab1ViewController ()
{
    NSArray* notifications;
}

typedef NS_ENUM(NSInteger, DSRightItemType) {
    DSRightItemTypeBell = 7001,
    DSRightItemTypeQA
};

@property (weak,nonatomic) IBOutlet UIButton *btnLeft;
@property (strong,nonatomic)  UIButton *btnRight;
@property (assign,nonatomic) DSRightItemType itemType;
@property (strong, nonatomic) UIBarButtonItem *notificationItem;
@property (strong, nonatomic) UIBarButtonItem *QAItem;

@end

@implementation XQDTab1ViewController

- (void)viewDidLoad {
    //startPage必须在调用父类方法之前被赋值
    NSString *url = [XQDUtil getUrlWithParams:GET_H5_URL(@"/")];
    self.startPage = url;
    self.unneedResetItem = YES;
    [super viewDidLoad];
    [self showQA];
}
- (void)setItemType:(DSRightItemType)itemType {
    if (_itemType == itemType) {
        return;
    }
    _itemType = itemType;
    NSString *imageName = nil;
    NSString *currentSelString = nil;
    NSString *lastSelString = nil;
    if (DSRightItemTypeBell == itemType) {
        lastSelString = @"pushQA:";
        currentSelString = @"showNotifications:";
        imageName = @"消息通知";
    } else if(DSRightItemTypeQA == itemType) {
        lastSelString = @"showNotifications:";
        currentSelString = @"pushQA:";
        imageName = @"常见问题";
    }
    SEL lastSel = NSSelectorFromString(lastSelString);
    [_btnRight removeTarget:self action:lastSel forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [XQDHelper getImageWithNamed:imageName];
    image = [image imageWithTintColor:[UIColor whiteColor]];
    SEL sel = NSSelectorFromString(currentSelString);
    
    [_btnRight setImage:image forState:UIControlStateNormal];
    [_btnRight addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
}
-(void)showQA{
    self.navigationItem.rightBarButtonItem = self.QAItem;
}
- (UIBarButtonItem *)QAItem {
    if (!_QAItem) {
        _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRight setFrame:CGRectMake(0, 0, 24, 24)];
        UIImage *image = [XQDHelper getImageWithNamed:@"常见问题"];
        [_btnRight setImage:[image imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(pushQA:) forControlEvents:UIControlEventTouchUpInside];
        _QAItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    }
    return _QAItem;
}
- (void)pushQA:(UIButton *)sender {
    [XQDUtil getLocationWithGPS:^(BOOL success) {
        [XQDUtil logWithStep:@"10004"];
    }];
    XQDWebViewController *web = [[XQDWebViewController alloc] init];
    web.title = @"常见问题";
    web.startPage = [XQDUtil getUrlWithParams:GET_H5_URL(@"/faq")];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

-(void)hideNotificationIcon{
    self.navigationItem.rightBarButtonItem = self.QAItem;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}
- (IBAction)backToApp:(UIButton *)sender {
    XQDPlugin *plugin = [XQDPlugin sharedInstance];
    SEL sel = NSSelectorFromString(@"backToApp");
    NSMethodSignature *sig = [plugin methodSignatureForSelector:sel];
    if (sig) {
        
        ((void(*)(id, SEL))objc_msgSend)(plugin, sel);
    } else {
        
        DSLog(@"backToApp方法出错啦！");
    }
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadRedPointConfig];
}
//获取消息系统是否有红点
- (void)loadRedPointConfig {
    
    NSString *userId = CUSTOMER_GET(userIdKey);
    if (!userId || !userId.length) {
        return;
    }
    NSDictionary *params = @{@"userId" : userId};
    __weak typeof (self) weakSelf = self;
    [[XQDJSONUtil sharedInstance] getJSONAsync:GET_SERVICE(@"/msg/check") withData:params.getParas method:@"POST" success:^(NSDictionary *data) {
        NSDictionary *dic = data[@"data"];
        if (dic[@"hasMsg"] && [dic[@"hasMsg"] boolValue]) {
            [weakSelf showBadge];
        } else  {
            [weakSelf hideBadge];
        }
    } error:^(NSError *error, id responseData) {
        [weakSelf hideBadge];
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self loadNotice];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)showBadgeOnTab3{
    [self.tabBarController.tabBar showBadgeOnItemIndex:2];
}

-(void)hideBadgeOnTab3{
    [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
}
-(void) showBadge{
    [_btnLeft showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeScale];
}

-(void) hideBadge{
    [_btnLeft clearBadge];
}

-(void)showNotifications:(UIButton *)sender {
    XQDNoticeView* noticeView=[[XQDNoticeView alloc]initWithNotifications:notifications];
    [noticeView show];
}

//加载通知
-(void) loadNotice{
    
    NSString *userId = CUSTOMER_GET(userIdKey);
    if (!userId || !userId.length) {
        return;
    }
    __weak typeof (self) weakSelf = self;
    NSDictionary *params = @{@"userId":CUSTOMER_GET(userIdKey),@"view":@"tab1"};
    [[XQDJSONUtil sharedInstance]getJSONAsync:GET_SERVICE(@"/notifications") withData:params.getParas method:@"get" success:^(NSDictionary *data) {
        NSArray* array=[data objectForKey:@"data"];
        if ([array count]>0) {
            self.itemType = DSRightItemTypeBell;
            if (notifications==nil) {
                notifications=array;
                [weakSelf showNotifications:nil];
            }
            notifications=array;
        }
        else{
            [weakSelf showQA];
        }
    } error:^(NSError *error, id responseData) {
        [weakSelf showQA];
    }];
}

#pragma mark - Events
-(IBAction)eventShowTab2:(id)sender{
    [self.tabBarController setSelectedIndex:1];
    [self.navigationController popToViewController:self animated:YES];
}
//加载消息系统通知
- (IBAction)pushSystemNotification:(UIButton *)sender {
    
    XQDWebViewController* vc=[[XQDWebViewController alloc]init];
    vc.startPage=[XQDUtil getUrlWithParams:GET_H5_URL(@"/notification")];
    vc.hidesBottomBarWhenPushed = YES;
    [XQDUtil getLocationWithGPS:^(BOOL success) {
         [XQDUtil logWithStep:@"10005"];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)openQA:(UIButton *)sender {
}

@end
