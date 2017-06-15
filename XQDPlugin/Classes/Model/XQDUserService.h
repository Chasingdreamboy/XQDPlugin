//
//  UserService.h
//  gongfudai
//
//  Created by EricWang on 17/06/12.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQDUser.h"
//#import "DSGesture.h"

@interface XQDUserService : NSObject
@property (nonatomic,copy) void (^(sendSMSSuccss))();
+ (instancetype) sharedService;
//+ (NSString *) readGesture;
//+ (NSString *) saveGesture:(NSString *)gesture;

- (XQDUser *) doRegister:(XQDUser *)user block:(void(^)(id data, NSError *error)) block;
-(XQDUser *)doReset:(XQDUser *)user block:(void (^)(id, NSError *))block;
- (XQDUser *) login:(XQDUser *)user block:(void(^)(id data, NSError *error)) block;

- (void) sendSMSCode:(NSString *)mobile block:(void (^)(id data, NSError *error))block;
- (void) validateMobile:(NSString*)mobile block:(void(^)(id data, NSError *error)) block;
- (void)loginWithMessageCode:(NSDictionary *)mandc block:(void (^)(id data, NSError *error))block;

//微信登录
//检测该微信号是否绑定过手机
- (void)checkWebchatRegister:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
- (void)checkBindStateForMobile:(NSString *)mobile block:(void (^)(id data, NSError *error))block;
- (void)registerWebchatAndMobile:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
- (void)bindWebchatAndMobile:(NSDictionary *)param block:(void (^)(id data, NSError *error))block;



@end
