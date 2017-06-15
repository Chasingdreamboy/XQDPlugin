//
//  NSString+Expand.h
//  gongfudai
//
//  Created by _tauCross on 14-7-16.
//  Copyright (c) 2014年 dashu. All rights reserved.
//





#import <Foundation/Foundation.h>


#define kChosenDigestLength		CC_SHA1_DIGEST_LENGTH
#define DESKEY @"dashu123fuck51hehe"

@interface NSString (Expand)

- (NSString *)md5;

+ (NSString *)generateUUIDString;

+ (NSDate *)mfDateFromDotNetJSONString:(NSString *)aJsonDateString;

- (NSDictionary*)dictionaryValue;

+ (NSString *)encodeURL:(NSString *)string;
- (NSString *)encodeURL;
- (NSString *)decodeURL;

- (NSString *)add:(NSString *)aString;

- (BOOL)isChineseCharactor;

- (NSString *)tripleDESEncrypt;//标准3DES+Base64加密
- (NSString *)tripleDESDecrypt;//标准3DES+Base64解密

- (NSString *)tripleDESEncryptWithKey:(NSString *)key;
- (NSString *)tripleDESDecryptWithKey:(NSString *)key;

- (NSString *)tripleDESSpecialEncrypt;//3DES加密去除空格和尖括号

- (BOOL)validateEmail;

- (NSString *)trimWhitespace; //去除空格

- (BOOL) isNormalStr; //中文、英文、数字

- (BOOL) containsString: (NSString*) substring;

-(BOOL) isMobilePhone;

-(BOOL) isValidPassword;
+ (BOOL)isValidString:(NSString *)orignalString;//非空，非nil，非NULL

//分节
+ (NSString *)fourBitStringFromAmountString:(NSString *)amountString;
//json字符串转化为字典或者数组
- (id)getSetFromJson;
- (NSString *)deleteMoreWhitespaceAndNewlineCharacter;
- (BOOL)isValidJSONFormat;


@end
