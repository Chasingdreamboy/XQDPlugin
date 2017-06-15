//
//  RKDropdownAlert+Expand.h
//  gongfubao
//
//  Created by EriceWang on 15/12/10.
//  Copyright © 2015年 Hangzhou Tree Finance Ltd. All rights reserved.
//

#import <RKDropdownAlert/RKDropdownAlert.h>
typedef void(^TapClick)(RKDropdownAlert *alert);
@interface RKDropdownAlert (Expand)
+ (void)successWithTitle:(NSString *)title message:(NSString *)message withTapClick:(TapClick)callBack;
+ (void)warningWithTitle:(NSString *)title message:(NSString *)message withTapClick:(TapClick)callBack;
+ (void)errorWithTitle:(NSString *)title message:(NSString *)message withTapClick:(TapClick)callBack;
+ (void)notificationWithTitle:(NSString *)title message:(NSString *)message withTapClick:(TapClick)callBack;
@end
