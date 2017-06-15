//
//  Util.h
//  gongfudai
//
//  Created by David Lan on 15/7/22.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>
#import <OpenUDID/OpenUDID.h>
#import <CoreLocation/CLLocation.h>


@interface TODOItem : NSObject
@property(nonatomic) NSInteger day;
@property(nonatomic) NSInteger month;
@property(nonatomic) NSInteger year;
@property(nonatomic) NSInteger hour;
@property(nonatomic) NSInteger minute;
@property(nonatomic,copy) NSString* eventNameString;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* destinationClass;
@property(nonatomic,copy) NSString* url;
@property(nonatomic,copy) NSDictionary* params;
@end

@interface XQDUtil : NSObject
{
    @private
    NSString* fingerprint;
}
@property(nonatomic,copy) void (^(getFingerPrintBlock))(NSError*,NSString*);
+(NSString*)networktype;//网络类型
+(NSString*)getcarrierName;//供应商名称
+(NSString*)idfa;//
+(NSString*)openUDID;
+(NSString*)model;
+(NSString*)detailModel;
+(NSString*)bundleId;
+(NSString*)deviceName;
+(NSString*)systemVersion;
+(NSString*)systemName;
+(NSString*)appVersion;
//+(NSString *)bundleVersion;
+(NSString*)RSAEncript:(NSString*)string;
+(NSString*)RSAEncript:(NSString*)string withPublickKey:(NSString*)publicKey;
+(NSString*)getUrlWithParams:(NSString*)urlString;
+(NSString*)getUrlWithParamsWithoutUserId:(NSString*)urlString;
+(void)uploadAppInfoWithStep:(NSString*)step;
+(BOOL)isj;
+(void)fakeUA;//使用PC Useragent
+(void)resetUA;//重置useragent
+ (void)applyCustomerUA;
+ (NSDictionary *)getAllParams;//在插件中用于获取埋点中的参数信息
+ (NSString *)getCachesizeWithClearCaches:(BOOL)isClear;
+(void)logWithStep:(NSString*)step;//埋点
+(void)blackboxWithStep:(NSString*)step;//同盾埋点
+(void)getLocationWithGPS:(void (^)(BOOL success))block;//获取地理位置
+(void)precheck:(CLLocation*)location block:(void (^)(NSError *error,BOOL success, id responseData))block;//检查地理位置


+ (NSArray*)chkApps;

@end
