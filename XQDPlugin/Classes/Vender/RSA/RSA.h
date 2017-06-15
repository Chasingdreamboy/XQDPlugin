//
//  RSA.h
//  My
//
//  Created by ideawu on 15-2-3.
//  Copyright (c) 2015年 ideawu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSA : NSObject

+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSString *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)encryptInteger:(NSInteger)integer publicKey:(NSString *)pubKey;
+ (NSString *)encryptCGFloat:(CGFloat)cgFloat publicKey:(NSString *)pubKey;
+ (NSString *)encryptDouble:(double)doubleValue publicKey:(NSString *)pubKey;

@end
