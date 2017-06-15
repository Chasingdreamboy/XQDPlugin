//
//  NSUserDefaults+Decrypt.m
//  kaixindai
//
//  Created by EriceWang on 2017/3/4.
//  Copyright © 2017年 Ericdong. All rights reserved.
//

#import "NSUserDefaults+Decrypt.h"
#import "NSString+Expand.h"
#import "NSObject+Expand.h"
#import "NSArray+Expand.h"

@implementation NSUserDefaults (Decrypt)

- (id)ds_objectForKey:(NSString *)defaultName {
    NSString *encryptName = [defaultName tripleDESEncrypt];
    NSString *result = (NSString *)[self objectForKey:encryptName];
    result = [result tripleDESDecrypt];
    id value = [(NSArray *)result.getSetFromJson firstObject];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", value];
    } else {
        return value;
    }
}
- (void)ds_setObject:(id)value forKey:(NSString *)defaultName {

    NSString *encryptName = [defaultName tripleDESEncrypt];
    if (!value) {
        [self removeObjectForKey:encryptName];
        return;
    }
    NSString *result = [self getJSONFromSet:value];
    result = [result tripleDESEncrypt];
    [self setObject:result forKey:encryptName];
    [self synchronize];
}
- (NSString *)getJSONFromSet:(id)value {
    id arguments = (value == nil ? [NSNull null] : value);
    NSArray* argumentsWrappedInArray = @[arguments];
    NSString* argumentsJSON = argumentsWrappedInArray.json;
    return argumentsJSON;
}
@end
