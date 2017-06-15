//
//  XQDPlugin.m
//  Pods
//
//  Created by EriceWang on 2017/6/13.
//
//

#import "XQDPlugin.h"
#import "XQDHelper.h"
#import "UIWindow+Expand.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "RKDropdownAlert+Expand.h"
#import "Header.h"
#import "GFD_FMDeviceManager.h"
#import "UIWindow+Expand.h"
#import "XQDNavigationController.h"
#import "XQDLoginViewController.h"

@interface XQDPlugin ()
@property (strong, nonatomic) UIViewController *rootController;

@end
XQDPlugin *plugin = nil;
static dispatch_once_t onceToken;
@implementation XQDPlugin
+ (_Nonnull instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        plugin = [[super alloc] init];
    });
    return plugin;
}
//pop到根视图
-(void)backToApp {
    if (self.rootController) {
        
        UIWindow *win = [UIWindow xqd_getWindow];
        @synchronized (win) {
            win.rootViewController = self.rootController;
            self.rootController = nil;
            if (self.addCustomOperation && self.addCustomOperation()) {
            }
        }
    }
}

-(void)setupAPPID:(NSString* _Nonnull)appID appKey:(NSString* _Nonnull)appKey {
    BOOL invalidate = (!appID || !appID.length)||(!appKey || !appKey.length);
    if (invalidate) {
        DSLog(@"appID or appKey 不合法!请核对传入的相关参数!");
        return;
    }
    _appID = appID;
    _appKey = appKey;

}
- (void)showWithMobile:(NSString *)mobile {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        GFD_FMDeviceManager_t *manager = [GFD_FMDeviceManager sharedManager]; // 获取设备管理器实例
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        [options setValue:@"gfd" forKey:@"partner"]; //替换为您的partnerCode
//#ifdef DEBUG //Debug模式,如果是Release模式将不会执⾏行以下代码
        [options setValue:@"allowd" forKey:@"allowd"]; //允许调试,缺省不允许调试
        [options setValue:@"sandbox" forKey:@"env"]; //对接测试环境,缺省为对接⽣生产环境
//#endif
        // [options setValue:@5000 forKey:@"timeout"]; //超时设置,缺省值为10000毫秒,即10 秒
        manager->initWithOptions(options); //初始化
    });
    
    if (![self appID] || ![self appKey]) {
        DSLog(@"Error:请先调用初始化方法[GFDPlugin setupAPPID: appKey:]传入所需参数");
        return;
    }
    NSString *timeStamp = [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
    NSString *lastTime = CUSTOMER_GET(lastEnteranceTimeKey);
    if ([timeStamp doubleValue] - [lastTime doubleValue] < 1.4) {
        return;
    } else {
        CUSTOMER_SET(lastEnteranceTimeKey, timeStamp);
    }
    BOOL invalidate = [mobile isEqual:[NSNull null]] ||!mobile||!mobile.length || (mobile.length != 11);
    if (invalidate) {
        mobile = nil;
    }
    [self dealWithPhone:mobile];
}
- (void)dealWithPhone:(NSString *)mobile {
    if (!mobile) {
        [self showRegister];
//        [self showMainTab];
        return;
    }
    NSString *lastMobile = CUSTOMER_GET(mobileKey);
    if (mobile && [lastMobile isEqualToString:mobile]) {
        
        //手机号存在，且和上次的一样
        [self showMainTab];
        return;
    }
    
    UIWindow *win = [UIWindow xqd_getWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:win animated:YES];
    [[XQDJSONUtil sharedInstance] getJSONAsync:GET_SERVICE(@"/certification/checkMobileAndChannel") withData:@{@"mobile" : mobile}.getParas method:@"post" success:^(NSDictionary *data) {
        CUSTOMER_SET(mobileKey, mobile);
        
        data = [data objectForKey:@"data"];
        [hud hide:NO];
        NSInteger status = [[data objectForKey:@"status"] integerValue];
        switch (status) {
            case 1://支持免密登录
            {
                //直接进入全流程应用
                NSString *userid = [data objectForKey:@"userId"];
                NSString *token = [data objectForKey:@"token"];
                CUSTOMER_SET(userIdKey, userid);
                CUSTOMER_SET(tokenKey, token);
                
                [self showMainTab];
            }
                break;
            case 2:{//不支持免登录
                if ([CUSTOMER_GET(@"ds_hasLogined") boolValue]) {
                    [self showMainTab];
                }
                else{
                    NSString *message = data[@"msg"];
                    if (![message isEqual:[NSNull null]]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                        [alert show];
                    }
                    //是否已注册
                    BOOL isRegistered = [[data objectForKey:@"register"] integerValue];
                    if (isRegistered) {
                        [self showLogin];
                    } else {
                        [self showRegister];
                    }
                }
            }
                break;
                
            default:
                [self showRegister];
                break;
        }
        
    } error:^(NSError *error, id responseData) {
        
        [hud hide:NO];
        if (responseData) {
            [RKDropdownAlert errorWithTitle:@"错误提示" message:responseData[@"errorMsg"] withTapClick:nil];
        }
    }];
}
- (void)showRegister {
    //注册界面
    NSString *mobile = CUSTOMER_GET(mobileKey);
    if (![mobile isEqual:[NSNull null]] || !mobile || mobile.length) {
        mobile = nil;
    }
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[XQDHelper bundle]];
    XQDNavigationController *loginNa = (XQDNavigationController *)[story instantiateViewControllerWithIdentifier:@"loginViewController"];
    XQDLoginViewController *login = loginNa.viewControllers.firstObject;
    login.loginBlock = ^{
        [self showMainTab];
    };
    [self saveRootController:loginNa];
}
- (void)showLogin {
    //登录界面
    NSString *mobile = CUSTOMER_GET(mobileKey);
    if (![mobile isEqual:[NSNull null]] || !mobile || mobile.length) {
        mobile = nil;
    }
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[XQDHelper bundle]];
    XQDNavigationController *loginNa = (XQDNavigationController *)[story instantiateViewControllerWithIdentifier:@"loginViewController"];
    XQDLoginViewController *login = loginNa.viewControllers.firstObject;
    login.loginBlock = ^{
        [self showMainTab];
    };
    [self saveRootController:loginNa];
}
- (void)showMainTab {
    //显示主tab界面
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[XQDHelper bundle]];
    UITabBarController *mainController = (UITabBarController *)[sb instantiateInitialViewController];
    [self saveRootController:mainController];
}

- (void)saveRootController:(UIViewController *)rootController {
    UIWindow *win = [UIWindow xqd_getWindow];
    @synchronized (win) {
        NSString *className = NSStringFromClass(win.rootViewController.class);
        if (![className hasPrefix:@"XQD"]) {
            self.rootController = win.rootViewController;
        }
        win.rootViewController = rootController;
    }
}
@end
