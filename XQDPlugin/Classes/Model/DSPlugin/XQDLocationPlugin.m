//
//  XQDLocationPlugin.m
//  kaixindai
//
//  Created by EriceWang on 2017/2/23.
//  Copyright © 2017年 Ericdong. All rights reserved.
//

#import "XQDLocationPlugin.h"
#import "Authorization.h"
#import <FCCurrentLocationGeocoder/FCCurrentLocationGeocoder.h>
@implementation XQDLocationPlugin
- (void)get:(NSDictionary*)command {
    
    //or create a new geocoder and set options
    FCCurrentLocationGeocoder *geocoder = [FCCurrentLocationGeocoder new];
    geocoder.canPromptForAuthorization = YES; //(optional, default value is YES)
    geocoder.canUseIPAddressAsFallback = NO; //(optional, default value is NO. very useful if you need just the approximate user location, such as current country, without asking for permission)
    geocoder.timeFilter = 15; //(cache duration, optional, default value is 5 seconds)
    geocoder.timeoutErrorDelay = 10; //(optional, default value is 15
    if ([geocoder canGeocode]) {
        [geocoder geocode:^(BOOL success) {
            if (success) {
                NSDictionary *result = @{@"latitude" : @(geocoder.location.coordinate.latitude), @"longitude" : @(geocoder.location.coordinate.longitude)};
                [self sendResult:command code:DSOperationStateSuccess result:result];
            } else {
                [self sendResult:command code:DSOperationStateUnknownError result:nil];
            }
        }];
    } else {
        [self sendResult:command code:DSOperationStateAuthorizationDenied result:@"[]请前往 设置-隐私-定位服务 中允许“开薪贷”获取您的地理位置后再来申请"];
    }
}
@end
