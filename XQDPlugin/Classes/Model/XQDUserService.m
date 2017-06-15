//
//  UserService.m
//  gongfudai
//
//  Created by EricWang on 17/06/12.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import "XQDUserService.h"

#import <AFNetworking/AFNetworking.h>
#import "Header.h"
typedef void (^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject);
typedef void (^failBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);
@implementation XQDUserService

+(instancetype)sharedService {
    static XQDUserService *userSvc = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        userSvc = [[self alloc] init];
    });
    return userSvc;
}
#pragma mark - DSGesture related operation

-(XQDUser *)doRegister:(XQDUser *)user block:(void (^)(id, NSError *))block {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GFD_BASE_URL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager POST:@"api/customers/register" parameters:[user toRegisterParams].getParas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

        if (block) {
            block(responseObject, nil);
        };
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //服务器返回的业务逻辑报文信息
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *responseObject  = (NSDictionary *)errResponse.getSetFromJson;
        if (block) { block(responseObject, error);}
    }];
    return user;
}

-(XQDUser *)doReset:(XQDUser *)user block:(void (^)(id, NSError *))block {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GFD_BASE_URL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager POST:@"api/customers/pwdreset" parameters:[user toRegisterParams].getParas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (block) {
            block(responseObject, nil);
        };
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //服务器返回的业务逻辑报文信息
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *responseObject  = (NSDictionary *)errResponse.getSetFromJson;
        if (block) { block(responseObject, error);}
    }];
    return user;
}

-(XQDUser *)login:(XQDUser *)user block:(void (^)(id, NSError *))block {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GFD_BASE_URL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager POST:@"api/customers/login" parameters:[user toLoginParams].getParas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString* userid=[NSString stringWithFormat:@"%@",responseObject[@"data"][@"userid"]];
        NSString* token=[NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
        
        if (block) {
            NSInteger userType = [responseObject[@"data"][@"userType"] integerValue];
            if (!userType) {
                //如果没有该参数，默认为贷前
                userType = 1;
            }
            BOOL isLoaned = (userType == 1) ? 0 : 1;
            CUSTOMER_SET(userIdKey, userid);
            CUSTOMER_SET(tokenKey, token);
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //用户是贷前，或者贷中贷后
            CUSTOMER_SET(isLoanedKey, @(isLoaned));
            if (block) {
                block(responseObject, nil);
            };
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //服务器返回的业务逻辑报文信息
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSDictionary *responseObject  = (NSDictionary *)errResponse.getSetFromJson;
        if (block) { block(responseObject, error);}
    }];
    return user;
}
-(void)sendSMSCode:(NSString *)mobile block:(void (^)(id data, NSError *error))block{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GFD_BASE_URL]];
    [manager POST:@"api/sms/sendSmsCode" parameters:@{@"mobile":mobile}.getParas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (block) {
            block(responseObject, nil);
            NSLog(@"短信发送成功!");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            //服务器返回的业务逻辑报文信息
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSDictionary *responseObject  = (NSDictionary *)errResponse.getSetFromJson;
            block(responseObject, error);
            NSLog(@"短信发送失败!");
        }
    }];
}
-(void)validateMobile:(NSString *)mobile block:(void (^)(id data, NSError *error))block{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GFD_BASE_URL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager POST:@"api/customers/mobile/validate" parameters:@{@"mobile":mobile}.getParas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        if (block) {
            block(responseObject, nil);
            NSLog(@"短信发送成功!");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            //服务器返回的业务逻辑报文信息
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSDictionary *responseObject  = (NSDictionary *)errResponse.getSetFromJson;
            block(responseObject, error);
            NSLog(@"短信发送失败!");
        }
    }];
}


//微信登录
- (void)checkWebchatRegister:(NSDictionary *)params block:(void (^)(id data, NSError *error))block {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GFD_BASE_URL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager POST:@"api/weixin/login" parameters:params.getParas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            //服务器返回的业务逻辑报文信息
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSDictionary *responseObject  = (NSDictionary *)errResponse.getSetFromJson;
            block(responseObject, error);
        }
    }];
}
- (void)checkBindStateForMobile:(NSString *)mobile block:(void (^)(id data, NSError *error))block {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GFD_BASE_URL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager POST:@"api/weixin/mobile/validate" parameters:@{@"mobile":mobile}.getParas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            //服务器返回的业务逻辑报文信息
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSDictionary *responseObject  = (NSDictionary *)errResponse.getSetFromJson;
            block(responseObject, error);
        }
    }];
}
- (void)registerWebchatAndMobile:(NSDictionary *)params block:(void (^)(id data, NSError *error))block {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GFD_BASE_URL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager POST:@"api/weixin/register" parameters:params.getParas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *userid = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"userid"]];
        NSString *token = responseObject[@"data"][@"token"];
        NSInteger userType = [responseObject[@"data"][@"userType"] integerValue];
        if (!userType) {
            //如果没有该参数，默认为贷前
            userType = 1;
        }
        BOOL isLoaned = (userType == 1) ? 0 : 1;
        //用户是贷前，或者贷中贷后
        CUSTOMER_SET(isLoanedKey, @(isLoaned));
        CUSTOMER_SET(userIdKey, userid);
        CUSTOMER_SET(tokenKey, token);
        if (block) {
            block(responseObject,nil);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            //服务器返回的业务逻辑报文信息
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSDictionary *responseObject  = (NSDictionary *)errResponse.getSetFromJson;
            block(responseObject, error);
        }
    }];

}
- (void)bindWebchatAndMobile:(NSDictionary *)param block:(void (^)(id data, NSError *error))block {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GFD_BASE_URL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager POST:@"api/weixin/bind" parameters:param.getParas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *userid = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"userid"]];
        NSString *token = responseObject[@"data"][@"token"];
        NSInteger userType = [responseObject[@"data"][@"userType"] integerValue];
        if (!userType) {
            //如果没有该参数，默认为贷前
            userType = 1;
        }
        BOOL isLoaned = (userType == 1) ? 0 : 1;
        //用户是贷前，或者贷中贷后
        CUSTOMER_SET(isLoanedKey, @(isLoaned));
        CUSTOMER_SET(userIdKey, userid);
        CUSTOMER_SET(tokenKey, token);
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            //服务器返回的业务逻辑报文信息
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSDictionary *responseObject  = (NSDictionary *)errResponse.getSetFromJson;
            block(responseObject, error);
        }
    }];
}
- (void)loginWithMessageCode:(NSDictionary *)mandc block:(void (^)(id data, NSError *error))block{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GFD_BASE_URL]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager POST:@"api/customers/captchaLogin" parameters:mandc.getParas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            //服务器返回的业务逻辑报文信息
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSDictionary *responseObject  = (NSDictionary *)errResponse.getSetFromJson;
            block(responseObject, error);
        }
    }];
}

@end
