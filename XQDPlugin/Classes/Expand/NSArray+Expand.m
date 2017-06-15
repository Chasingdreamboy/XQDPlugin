//
//  NSArray+Expand.m
//  gongfudai
//
//  Created by David Lan on 15/7/29.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import "NSArray+Expand.h"
#import "NSString+Expand.h"

@implementation NSArray(Expand)
- (NSString*)json
{
    NSString* json = nil;
    NSError* error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    json = [json deleteMoreWhitespaceAndNewlineCharacter];
    return (error ? nil : json);
}
- (NSString *)tripleDESEncrypt {
    return self.json.tripleDESEncrypt;
}
@end
