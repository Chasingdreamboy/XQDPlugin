//
//  Util.m
//  gongfudai
//
//  Created by David Lan on 15/7/22.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import "XQDUtil.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTSubscriberInfo.h>
#import <AFNetworking/AFNetworking.h>
#import <FCCurrentLocationGeocoder/FCCurrentLocationGeocoder.h>
#import "XQDJSONUtil.h"
#include <sys/types.h>
#include <sys/sysctl.h>

//#import "GFD_FMDeviceManager.h"
#import <UICKeyChainStore/UICKeyChainStore.h>
#import "RSA.h"
#import "Header.h"
#import "XQDPlugin.h"
#import "UIDevice+RunningProcess.h"
#import "config.h"
#import "NSDate+Expand.h"
//#import "GFD_FMDeviceManager.h"
#import "NSURL+Expand.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation XQDUtil

+(instancetype)sharedInstance{
    static XQDUtil *instance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance=[XQDUtil new];
//        FMDeviceManager_t *manager = [FMDeviceManager sharedManager]; // 获取设备管理器实例
//        NSMutableDictionary *options = [NSMutableDictionary dictionary];
//        #ifdef DEBUG //Debug模式,如果是Release模式将不会执⾏行以下代码
//            [options setValue:@"allowd" forKey:@"allowd"]; //允许调试,缺省不允许调试
//            [options setValue:@"sandbox" forKey:@"env"]; //对接测试环境,缺省为对接⽣生产环境
//        #endif        
//        [options setValue:@"gfd" forKey:@"partner"]; //替换为您的partnerCode
//        // [options setValue:@5000 forKey:@"timeout"]; //超时设置,缺省值为10000毫秒,即10 秒
//        manager->initWithOptions(options); //初始化
    });
    return instance;
}

+(NSString*)RSAEncript:(NSString*)string{
    NSString *appKey = [XQDPlugin sharedInstance].appKey;
    
//    return [RSA encryptString:string publicKey:kAppKey];
    return [RSA encryptString:string publicKey:appKey];
}
+(NSString*)RSAEncript:(NSString*)string withPublickKey:(NSString*)publicKey{
    @try{
        NSString* result=[RSA encryptString:string publicKey:publicKey];
        return result;
    }
    @catch(NSException* ex){
        NSLog(@"ex:%@",ex);
        return @"";
    }
}

+(NSString*)networktype{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    NSString* netwrokType;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            NSLog(@"No wifi or cellular");
            netwrokType=@"无服务";
            break;
            
        case 1:
            NSLog(@"2G");
            netwrokType=@"2G";
            break;
            
        case 2:
            NSLog(@"3G");
            netwrokType=@"3G";
            break;
            
        case 3:
            NSLog(@"4G");
            netwrokType=@"4G";
            break;
            
        case 4:
            NSLog(@"LTE");
            netwrokType=@"LTE";
            break;
            
        case 5:
            NSLog(@"Wifi");
            netwrokType=@"Wifi";
            break;
            
        default:
            break;
    }
    return netwrokType;
}
//是否越狱
+(BOOL)isj {
    
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    
    NSString *aptPath = @"/private/var/lib/apt/";
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    NSLog(@"%s", env);
    if (env!=NULL) {
        jailbroken=YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    } if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    
    return jailbroken;
}
//获取运营商名称
+(NSString*)getcarrierName{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    //    NSLog(@"[carrier isoCountryCode]==%@,[carrier allowsVOIP]=%d,[carrier mobileCountryCode=%@,[carrier mobileCountryCode]=%@",[carrier isoCountryCode],[carrier allowsVOIP],[carrier mobileCountryCode],[carrier mobileNetworkCode]);
    return currentCountry;
}


//获取运营商编号
+(NSString*)getOperatorCode{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    return [NSString stringWithFormat:@"%@%@",[carrier mobileCountryCode],[carrier mobileNetworkCode]];
}

+(NSString*)idfa{
    UICKeyChainStore *kc = [UICKeyChainStore keyChainStoreWithService:nil];
    NSLog(@"idfa:%@",[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString]);
        DSLog(@"idfa:%@",[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString]);
    if (kc[@"idfa"]==nil) {
        kc[@"idfa"]=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
    }
    return kc[@"idfa"];
}
+(NSString*)openUDID{
    return [OpenUDID value];
}
//phonebranch
+(NSString*)model{
    return [UIDevice currentDevice].model;
}
//phoneModel
+(NSString*)detailModel{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);

    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    //6s和6sPlus位置颠倒（历史遗留）
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s";
    //new add
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
+(NSString*)deviceName{
    return [UIDevice currentDevice].name;
}
+(NSString*)systemVersion{
    return [UIDevice currentDevice].systemVersion;
}
+(NSString*)systemName{
    return [UIDevice currentDevice].systemName;
}
+(NSString *)appVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(NSString*)bundleId{
    return [[NSBundle mainBundle] bundleIdentifier];
}
+(void)getLocationWithGPS:(void (^)(BOOL success))block{
    static BOOL hasAvailableLocation = NO;
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval lastLocationTimestamp = [CUSTOMER_GET(lastGetLocationTimestampKey) doubleValue];
    //the time from last validate location is beyond one hour,get a new one
    if (timeInterval - lastLocationTimestamp > 60 * 60) {
        hasAvailableLocation = NO;
    }
    if (!hasAvailableLocation) {
        //or create a new geocoder and set options
        FCCurrentLocationGeocoder *geocoder = [FCCurrentLocationGeocoder new];
        geocoder.canPromptForAuthorization = YES; //(optional, default value is YES)
        geocoder.canUseIPAddressAsFallback = NO; //(optional, default value is NO. very useful if you need just the approximate user location, such as current country, without asking for permission)
        geocoder.timeFilter = 15; //(cache duration, optional, default value is 5 seconds)
        geocoder.timeoutErrorDelay = 10; //(optional, default value is 15 seconds)
        if ([geocoder canGeocode]) {
            [geocoder geocode:^(BOOL success) {
                if (success) {
                    NSTimeInterval lastGetLocationTimestamp = [[NSDate date] timeIntervalSince1970];
                    NSString *timestamp = [NSString stringWithFormat:@"%@", @(lastGetLocationTimestamp)];
                    CUSTOMER_SET(lastGetLocationTimestampKey, timestamp);
                    NSString* positionData= [NSString stringWithFormat:@"%lf,%lf",geocoder.location.coordinate.latitude,geocoder.location.coordinate.longitude];
                    CUSTOMER_SET(positionKey,positionData);
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    if (block) {
                        hasAvailableLocation = YES;
                        block(success);
                    }
                } else {
                    hasAvailableLocation = NO;
                    CUSTOMER_SET(positionKey,@"");
                    block(NO);
                }

            }];
        }else{
            if (block) {
                hasAvailableLocation = NO;
                CUSTOMER_SET(positionKey,@"");
                [[NSUserDefaults standardUserDefaults] synchronize];
                block(NO);
            }
        }
    } else {
        NSString *positionData = CUSTOMER_GET(positionKey);
        if (!positionData || !positionData.length) {
            hasAvailableLocation = NO;
            if (block) {
                block(NO);
            }
        } else {
            if (block) {
                block(YES);
            }
        }
    }
}

+(BOOL)isOlderThanVersion:(NSString*)version{
    NSString* currentVersion=[XQDUtil appVersion];
    NSArray* currentVersionNumbers=[currentVersion componentsSeparatedByString:@"."];
    NSArray* versionNumbers=[version componentsSeparatedByString:@"."];
    
    if ([currentVersion isEqualToString:version]) {
        return NO;
    }
    NSInteger minCount = MIN(currentVersionNumbers.count, versionNumbers.count);
    NSInteger CV = 0;
    NSInteger VV = 0;
    NSInteger current = 0;
    NSInteger online = 0;
    for (int i = 0; i < minCount; i++) {
        VV = [versionNumbers[i] integerValue];
        CV = [currentVersionNumbers[i] integerValue];
        current += CV * pow(10, minCount - 1 - i);
        online += VV * pow(10, minCount - 1 - i);

    }
    return online > current ? YES : NO;
}



+(void)precheck:(CLLocation*)location block:(void (^)(NSError *error,BOOL success, id responseData))block{
    if (CUSTOMER_GET(userIdKey)==nil) {
        block(nil,NO,nil);
        return;
    }
    NSDictionary *params = @{@"userId":CUSTOMER_GET(userIdKey),@"lng":[NSNumber numberWithDouble:location.coordinate.longitude],@"lat":[NSNumber numberWithDouble:location.coordinate.latitude]};
    [[XQDJSONUtil sharedInstance]getJSONAsync:GET_SERVICE(@"/certification/precheck") withData:params.getParas method:@"get" success:^(NSDictionary *data) {
        
        NSDictionary* innerData=[data objectForKey:@"data"];
        if (![[innerData objectForKey:@"allow"] boolValue]) {
            block(nil,NO,data);
            return ;
        }
        else{
            if (block) {
                block(nil,YES,data);
            }
        }
    } error:^(NSError *error, id responseData) {
        block(error,NO,responseData);
    }];
    
}

-(void) getFingerPrint:(void(^)( NSError *error,NSString* finger))block{
    if (fingerprint!=nil) {
        block(nil,fingerprint);
    }
    self.getFingerPrintBlock=block;
}

-(void)generateFinerPrintOnSuccess:(NSString *)fingerPrint{
    if (self.getFingerPrintBlock) {
        fingerprint=fingerPrint;
        self.getFingerPrintBlock(nil,fingerPrint);
    }
}

-(void)generateFinerPrintOnFailed:(NSError *)error{
    if (self.getFingerPrintBlock) {
        self.getFingerPrintBlock(error,@"");
    }
}

+(void) blackboxWithStep:(NSString*)step{
//    NSString *blackBox = [GFD_FMDeviceManager sharedManager]->getDeviceInfo();
    NSMutableDictionary* p=[NSMutableDictionary dictionary];
    if (CUSTOMER_GET(tokenKey)!=nil) {
        [p setObject:CUSTOMER_GET(tokenKey) forKey:@"token"];
    }
    if (CUSTOMER_GET(userIdKey)!=nil) {
        [p setObject:CUSTOMER_GET(userIdKey) forKey:@"userId"];
    }
//    if(blackBox!=nil){
//        [p setObject:blackBox forKey:@"blackbox"];
//    }
    [p setObject:[self appVersion] forKey:@"appVersion"];
    [p setObject:@"ios" forKey:@"platform"];
    [p setObject:step forKey:@"stepId"];
    [[XQDJSONUtil sharedInstance] getJSONAsync:GET_SERVICE(@"/blackbox") withData:p.getParas method:@"POST" success:^(NSDictionary *data) {
        DSLog(@"step:%@ 埋点blackbox成功",step);
    } error:^(NSError *error, id responseData) {
        DSLog(@"step:%@ 埋点blackbox失败,错误原因：%@", step,error);
    }];
}

+(void) logWithStep:(NSString*)step{
    NSDictionary* params=[self getLogParams:step fingerPrint:@""];
    if (params==nil) {
        return;
    }
    NSMutableDictionary* p=[NSMutableDictionary dictionaryWithDictionary: @{@"jsonStr":[@[params] json]}];
    if (CUSTOMER_GET(tokenKey)!=nil) {
        [p setObject:CUSTOMER_GET(tokenKey) forKey:@"token"];
    }
    if (CUSTOMER_GET(userIdKey)!=nil) {
        [p setObject:CUSTOMER_GET(userIdKey) forKey:@"userId"];
    }
    NSString *positionData = CUSTOMER_GET(positionKey);
    if (positionData && positionData.length) {
        [p setObject:CUSTOMER_GET(positionKey) forKey:@"positionData"];
    }
    else{
        [p setObject:@"" forKey:@"positionData"];
    }
    [p setObject:step forKey:@"stepId"];
    NSString *url = GET_SERVICE(@"/channel/addPoint");
    
    [[XQDJSONUtil sharedInstance] getJSONAsync:url withData:p.getParas method:@"POST" success:^(NSDictionary *data) {
        DSLog(@"step:%@ 埋点成功",step);
    } error:^(NSError *error, id responseData) {
        DSLog(@"step:%@ 埋点失败,错误原因：%@", step,error);
    }];

}

+(NSDictionary*)getLogParams:(NSString*)step fingerPrint:(NSString*)fingerPrint {
    NSMutableDictionary* params=[NSMutableDictionary dictionary];
    [params setObject:step forKey:@"stepid"];
    if (CUSTOMER_GET(userIdKey)!=nil) {
        [params setObject:CUSTOMER_GET(userIdKey) forKey:@"userid"];
    }
    [params setObject:@"小期贷-小期贷-iOS" forKey:@"channelsource"];
    [params setObject:@"1" forKey:@"platformid"];//ios=1,android=0
    [params setObject:[self model] forKey:@"phonebrand"];//手机品牌，iPhone，iPad
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [NSDate timestampFormatString];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString* timestamp=[dateFormatter stringFromDate:[NSDate date]];
    [params setObject:timestamp forKey:@"createdate"];//创建时间
    [params setObject:[self appVersion] forKey:@"appversion"];//app版本号
    NSString *detailModel = [self detailModel];
    [[NSUserDefaults standardUserDefaults] setObject:detailModel forKey:@"detalModel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (detailModel) {
        [params setObject:detailModel forKey:@"phonemodel"];//具体型号 iPhone6s
    }
    NSString *carrierName = [self getcarrierName];
    if (carrierName) {
        [params setObject:carrierName forKey:@"operatorname"]; //运营商名
    }
    NSString *operatorCode = [self getOperatorCode];
    if(operatorCode){
        [params setObject:operatorCode forKey:@"operatorcode"]; //运营商编号
    }
    NSString *systemVersion = [self systemVersion];
    if (systemVersion) {
        [params setObject:systemVersion forKey:@"phoneversion"]; //系统版本
    }
    NSString *networkType = [self networktype];
    if (networkType) {
        [params setObject:networkType forKey:@"netmodel"]; //网络类型 WIFI 4G
    }
    [params setObject:@([self isj]) forKey:@"isjailbreak"]; //是否越狱
    NSString *idfa = [self idfa];
    if (idfa) {
        [params setObject:idfa forKey:@"idfa"]; //idfa
    }
    NSString *udid = [self openUDID];
    if (udid) {
        [params setObject:udid forKey:@"openudid"];//openudid
    }
    
    return params;
}
+ (NSDictionary *)getAllParams {
    NSMutableDictionary* params=[NSMutableDictionary dictionary];
    if (CUSTOMER_GET(userIdKey)!=nil) {
        [params setObject:CUSTOMER_GET(userIdKey) forKey:@"userid"];
    }
    [params setObject:@"小期贷-小期贷-iOS" forKey:@"channelsource"];//SDK没用
    [params setObject:@"1" forKey:@"platformid"];//ios=1,android=0
    [params setObject:[self model] forKey:@"phonebrand"];//手机品牌，iPhone，iPad
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [NSDate timestampFormatString];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString* timestamp=[dateFormatter stringFromDate:[NSDate date]];
    [params setObject:timestamp forKey:@"createdate"];//创建时间
    [params setObject:[self appVersion] forKey:@"appversion"];//app版本号
    NSString *detailModel = [self detailModel];
    if (detailModel) {
        [params setObject:detailModel forKey:@"phonemodel"];//具体型号 iPhone6s
    }
    NSString *carrieName = [self getcarrierName];
    if (carrieName) {
        [params setObject:carrieName forKey:@"operatorname"]; //运营商名
    }
    NSString *operatorCode = [self getOperatorCode];
    if(operatorCode){
        [params setObject:operatorCode forKey:@"operatorcode"]; //运营商编号
    }
    NSString *systemVersion = [self systemVersion];
    if (systemVersion) {
        [params setObject:systemVersion forKey:@"phoneversion"]; //系统版本
    }
    NSString *networkType = [self networktype];
    if (networkType) {
        [params setObject:networkType forKey:@"netmodel"]; //网络类型 WIFI 4G
    }
    [params setObject:@([self isj]) forKey:@"isjailbreak"]; //是否越狱
    NSString *idfa = [self idfa];
    if (idfa) {
        [params setObject:idfa forKey:@"idfa"]; //idfa
    }
    NSString *udid = [self openUDID];
    if (udid) {
        [params setObject:udid forKey:@"openudid"];//openudid
    }
    
    return params;
}
+(void)fakeUA{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":PC_UA}];
}

+(void)resetUA{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":DS_GET(originalUAKey)}];
}
//为UserAgent添加后缀标志
+ (void)applyCustomerUA {
    NSString *userAgent = DS_GET(originalUAKey);
    if (!userAgent) {
        userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    }
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *suffix = [NSString stringWithFormat:@"XiaoQiDai/%@ (iOS; xqdiOS)", version];
    
    userAgent = [NSString stringWithFormat:@"%@ %@", userAgent, suffix];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : userAgent}];
}

+(NSString*)getUrlWithParams:(NSString*)urlString{
    NSURL* url=[NSURL URLWithString:urlString];
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:[url queryParamDict]];
    
    if (CUSTOMER_GET(userIdKey)) {
        [params setObject:CUSTOMER_GET(userIdKey) forKey:@"userId"];
    }
    if(CUSTOMER_GET(tokenKey)){
        [params setObject:CUSTOMER_GET(tokenKey) forKey:@"token"];
    }
    [params setObject:@"ios" forKey:@"platform"];
    [params setObject:[XQDUtil appVersion] forKey:@"appVersion"];
    NSString *port = url.port ? [NSString stringWithFormat:@":%@", url.port] : @"";
    
    return  [NSString stringWithFormat:@"%@://%@%@%@?%@",url.scheme,url.host,port,url.path,[params queryStringValue]];
    return urlString;
}

+(NSString*)getUrlWithParamsWithoutUserId:(NSString*)urlString{
    NSURL* url=[NSURL URLWithString:urlString];
    NSMutableDictionary* params=[NSMutableDictionary dictionaryWithDictionary:[url queryParamDict]];
    [params setObject:@"ios" forKey:@"platform"];
    return  [NSString stringWithFormat:@"%@://%@:%@%@?%@",url.scheme,url.host,url.port==nil?@"":url.port,url.path,[params queryStringValue]];
}

- (void)scheduleNotificationWithItem:(TODOItem *)item interval:(int)hoursBefore {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:item.day];
    [dateComps setMonth:item.month];
    [dateComps setYear:item.year];
    [dateComps setHour:item.hour];
    [dateComps setMinute:item.minute];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [itemDate dateByAddingTimeInterval:-(hoursBefore*60*60)];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = item.eventNameString;
    localNotif.alertAction = @"查看详情";
    localNotif.alertTitle = item.eventNameString;
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    if (item.destinationClass) {
        NSDictionary *infoDict = @{@"title":item.title,@"destinationClass":item.destinationClass,@"url":item.url,@"params":item.params};
        localNotif.userInfo = infoDict;
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

+(void) uploadAppInfoWithStep:(NSString*)step{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary* params=[NSMutableDictionary dictionary];
        [params setObject:step forKey:@"stepId"];
        if (CUSTOMER_GET(userIdKey)!=nil) {
            [params setObject:CUSTOMER_GET(userIdKey) forKey:@"userId"];
        }
        if (CUSTOMER_GET(tokenKey)!=nil) {
            [params setObject:CUSTOMER_GET(tokenKey) forKey:@"token"];
        }
        [params setObject:@"1" forKey:@"platformId"];
        [params setObject:[XQDUtil isj]?@(1):@(0) forKey:@"flag"];//是否越狱
        
        NSString *appInfoEncripted = [[XQDUtil chkApps] json] ;
        [params setObject:@"0" forKey:@"enc"];
        [params setObject:appInfoEncripted forKey:@"appInfo"];//应用信息
        //    [params setObject:[XQDUtil RSAEncript:[[XQDUtil chkApps] json]] forKey:@"appInfo"];//应用信息
        [params setObject:[XQDUtil idfa] forKey:@"deviceKey"];
        [[XQDJSONUtil sharedInstance] getJSONAsync:GET_SERVICE(@"/appInfo/upload")  withData:params.getParas method:@"POST" success:^(NSDictionary *data) {
            NSLog(@"step:%@ 上传app信息成功",step);
        } error:^(NSError *error, id responseData) {
            NSLog(@"step:%@ 上传app信息失败,错误原因：%@", step,error);
        }];

    });
}
+ (NSArray*)chkApps
{

    Class wscls =  NSClassFromString([@"6RSzKVdfJZxcHdmF0u/9Pe84H9mHIuwo" tripleDESDecrypt]);
    SEL selOne = NSSelectorFromString([@"lnnmFOZ+Bux8pE9f0MqGxGybkbbufqKi" tripleDESDecrypt]);
    NSMethodSignature *sigOne = [wscls methodSignatureForSelector:selOne];
    NSObject* ws = nil;
    if (sigOne) {
        ws = ((NSObject *(*)(Class, SEL))objc_msgSend)(wscls, selOne);
    } else {
        NSLog(@"Error !!!!");
        return nil;
        
    }
//    NSObject* ws = [wscls performSelector:NSSelectorFromString([@"lnnmFOZ+Bux8pE9f0MqGxGybkbbufqKi" tripleDESDecrypt])];
    
    SEL selTwo = NSSelectorFromString([@"HGlSu7A7rLtrypgINJyC8g==" tripleDESDecrypt]);
    NSMethodSignature *sig = [ws methodSignatureForSelector:selTwo];
    NSArray * apps = nil;
    if (sig) {
        apps = ((NSArray *(*)(id, SEL))objc_msgSend)(ws, selTwo);
    } else {
        DSLog(@"Error:LSApplicationWorkspace is forbbiden!!!");
        return nil;
    }
    
    NSLog(@"apps = %@", apps);
    
//    NSArray * apps=[ws performSelector:NSSelectorFromString([@"HGlSu7A7rLtrypgINJyC8g==" tripleDESDecrypt])];
    
    NSMutableArray* appInfos=[NSMutableArray array];
    NSArray* running=[UIDevice runningProcesses];
    
    [apps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        unsigned int count = 0;
        objc_property_t *attributes = class_copyPropertyList([obj class], &count);
        objc_property_t property;
        NSString *key, *value;
        
        for (int i = 0; i < count; i++)
        {
            property = attributes[i];
            key = [NSString stringWithUTF8String:property_getName(property)];
            value = [obj valueForKey:key];
            [dict setObject:(value ? value : @"") forKey:key];
        }
        NSMutableDictionary* result=[NSMutableDictionary dictionary];
        
        NSDate* updatedAt=[dict objectForKey:[@"CR/Aa7PHstx0/hP9T/Ms3A==" tripleDESDecrypt]];//registeredDate
        
        NSString* type=[dict objectForKey:[@"s9iEF8qdGnK7Yq8fLwq8rQ==" tripleDESDecrypt]];//applicationType
        NSString* bundleId=[dict objectForKey:[@"s9iEF8qdGnLjABzZto7vxY93gk8A0PHw" tripleDESDecrypt]];//applicationIdentifier
        NSString* appVersion=[dict objectForKey:[@"P60abWY73u4JJY8J/QwIHjQpgCD2ZN+U" tripleDESDecrypt]];//shortVersionString
        NSString* urlStr=[dict objectForKey:[@"ayzcCCTjJ2qFauxcD7W/xg==" tripleDESDecrypt]];
        
        if (urlStr&&![urlStr isEqual:[NSNull null]]) {
            NSString* prodName=[urlStr.lastPathComponent stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",urlStr.pathExtension] withString:@""];
            __block BOOL find=NO;
            [running enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:prodName]) {
                    find=YES;
                    *stop=YES;
                }
            }];
            [result setObject:@(find?1:0) forKey:@"isRunning"];
        }
        
        if (updatedAt) {
            [result setObject:@([updatedAt timeIntervalSince1970]) forKey:@"updatedAt"];
        }
        if(type){
            [result setObject:type forKey:@"appType"];
        }
        if(bundleId){
            [result setObject:bundleId forKey:@"bundleId"];
        }
        if(appVersion){
            [result setObject:appVersion forKey:@"appVersion"];
        }
        [appInfos addObject:result];
    }];
    
    return appInfos;
}
//获取缓存大小
+ (NSString *)getCachesizeWithClearCaches:(BOOL)isClear{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    NSString *filePath;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    long long size = 0;
    NSString *result = nil;
    NSString *path = nil;
    //clear the subfiles of caches folder
    if (isClear) {
        for (path in files) {
            filePath = [cachPath stringByAppendingPathComponent:path];
            [fileManager removeItemAtPath:filePath error:nil];
        }
        //clear the cookies of webview
        NSHTTPCookie *cookie = nil;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
        //clear the cache of webview
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        result = @"0.00 M";
    } else {
        //get size of coches folder
        for (path in files) {
            filePath = [cachPath stringByAppendingPathComponent:path];
            size += [fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
        }
        result = [NSString stringWithFormat:@"%.2f M", size * 1.0 / 1024.0 / 1024.0];
    }
    
    //清理webview cookie
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    return result;
}


@end
