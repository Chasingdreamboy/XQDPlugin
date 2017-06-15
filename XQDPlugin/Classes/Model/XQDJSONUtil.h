//
//  XQDJSONUtil.h
//  gongfudai
//
//  Created by David Lan on 15/7/24.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RKDropdownAlert/RKDropdownAlert.h>
@interface XQDJSONUtil : NSObject<UIAlertViewDelegate>
{
    RKDropdownAlert* alert;
    UIAlertView* alertView;
}
+(instancetype)sharedInstance;
-(NSDictionary*)getJSON:(NSString*)url withData:(NSDictionary*)params method:(NSString*)method error:(NSError *__autoreleasing *)error;
-(void)getJSONAsync:(NSString*)url withData:(NSDictionary*)params method:(NSString*)method success:(void (^)(NSDictionary* data))success error:(void (^)(NSError* error,id responseData))fail;
-(void)getJSONAsyncQuietlyWithOutDefaultParams:(NSString*)url withData:(NSDictionary*)params method:(NSString*)method success:(void (^)(NSDictionary* data))success error:(void (^)(NSError* error,id responseData))fail;
//用于异常分析的log上传接口
- (void)sendError:(NSDictionary *)exception callback:(void(^)(BOOL success, id extra))callback;
-(id)getParam:(NSString*)name fromDict:(NSDictionary*)param;
-(void)logout;



@end
