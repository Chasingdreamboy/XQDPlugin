//
//  RKDropdownAlert+Expand.m
//  gongfubao
//
//  Created by EriceWang on 15/12/10.
//  Copyright © 2015年 Hangzhou Tree Finance Ltd. All rights reserved.
//

#import "RKDropdownAlert+Expand.h"
#import "UIColor+Expand.h"
#import "macro.h"


@interface PrivateDelegate : NSObject<RKDropdownAlertDelegate>
+ (instancetype)sharedInstance ;
@property (copy, nonatomic) TapClick callback;
@end
@implementation PrivateDelegate
+ (instancetype)sharedInstance {
    static PrivateDelegate *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance =  [[PrivateDelegate alloc] init];
    });
    return instance;
}

-(BOOL)dropdownAlertWasTapped:(RKDropdownAlert*)alert {
    if (self.callback) {
        self.callback(alert);
    }
    return YES;
}
-(BOOL)dropdownAlertWasDismissed {
    return YES;
}
@end

@implementation RKDropdownAlert (Expand)
+ (void)successWithTitle:(NSString *)title message:(NSString *)message withTapClick:(TapClick)callBack{
    if (callBack) {
        [PrivateDelegate sharedInstance].callback = callBack;
    }
    [self title:title message:message backgroundColor:HEXCOLOR(@"6dae18") textColor:nil delegate:[PrivateDelegate sharedInstance]];
    
}
+ (void)warningWithTitle:(NSString *)title message:(NSString *)message withTapClick:(TapClick)callBack{
    if (callBack) {
        [PrivateDelegate sharedInstance].callback = callBack;
    }
    [self title:title message:message backgroundColor:HEXCOLOR(@"ffae00") textColor:nil delegate:[PrivateDelegate sharedInstance]];
    
}
+ (void)errorWithTitle:(NSString *)title message:(NSString *)message withTapClick:(TapClick)callBack {
    if (callBack) {
        [PrivateDelegate sharedInstance].callback = callBack;
    }
    [self title:title message:message backgroundColor:HEXCOLOR(@"e44142") textColor:nil delegate:[PrivateDelegate sharedInstance]];
    
}
+ (void)notificationWithTitle:(NSString *)title message:(NSString *)message withTapClick:(TapClick)callBack{
    if (callBack) {
        [PrivateDelegate sharedInstance].callback = callBack;
    }
    [self title:title message:message backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] delegate:[PrivateDelegate sharedInstance]];
    
}

@end
