//
//  XQDLoginViewController.m
//  Pods
//
//  Created by EriceWang on 2017/6/13.
//
//

#import "XQDLoginViewController.h"
#import "XQDHelper.h"
#import "XQDUserService.h"
#import "Header.h"
#import "XQDPlugin.h"
#import <objc/message.h>
#import "UIButton+LSSmsVerification.h"

@interface XQDLoginViewController ()

@end

@implementation XQDLoginViewController

- (IBAction)sendSMSCode:(UIButton *)sender {
    
    [[XQDUserService sharedService] sendSMSCode:_tf_Mobile.text block:^(id data, NSError *error) {
        if (!error) {
            [sender startTimeWithDuration:60];
        } else {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *errorMsg = data[@"errorMsg"];
                if (!errorMsg || !errorMsg.length) {
                    errorMsg = @"服务器请求失败，请检查网络连接";
                }
            }
        }
    }];
    
}
- (IBAction)login:(id)sender {
    
    NSString *mobile = _tf_Mobile.text;
    NSString *code = _tf_SMSCode.text;
    NSDictionary *params = @{@"mobile" : mobile, @"code" : code};
    [[XQDUserService sharedService] loginWithMessageCode:params block:^(id data, NSError *error) {
        if (error) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *errorMsg = data[@"errorMsg"];
                if (errorMsg) {
                }
            }
        } else {
            NSDictionary *resp = [data objectForKey:@"data"];
            NSString *userId = [NSString stringWithFormat:@"%@", [resp objectForKey:@"userid"]];
            NSString *token = [resp objectForKey:@"token"];
            CUSTOMER_SET(userIdKey, userId);
            CUSTOMER_SET(tokenKey, token);

            if (self.loginBlock) {
                self.loginBlock();
            }
        }
    }];
}
- (IBAction)backToApp:(id)sender {
    XQDPlugin *plugin = [XQDPlugin sharedInstance];
    SEL sel = NSSelectorFromString(@"backToApp");
    NSMethodSignature *sig = [plugin methodSignatureForSelector:sel];
    if (sig) {
        
        ((void(*)(id, SEL))objc_msgSend)(plugin, sel);
    } else {
        
        DSLog(@"backToApp方法出错啦！");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
