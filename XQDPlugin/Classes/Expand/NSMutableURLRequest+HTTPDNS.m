//
//  NSURLRequest+HTTPCDN.m
//  gongfudaiNew
//
//  Created by EriceWang on 2017/2/9.
//  Copyright © 2017年 dashu. All rights reserved.
//

#import "NSMutableURLRequest+HTTPDNS.h"
#import "NSObject+Expand.h"
#import "NSObject+Swizzle.h"
//#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

@implementation NSMutableURLRequest (HTTPCDN)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzingInstanceSel:@selector(initWithURL:) withSel:@selector(initWithURL_HTTPCDN:)];
    });
}
- (instancetype)initWithURL_HTTPCDN:(NSURL *)URL {
    self = [self initWithURL_HTTPCDN:URL];
//    HttpDnsService *httpService = [HttpDnsService sharedInstance];
//    NSString *ip = nil;
////    ip = [httpService getIpByHostAsync:URL.host];
//    ip = [httpService getIpByHostInURLFormat:URL.host];
//    NSString *originalUrl = URL.absoluteString;
//    if (ip) {
//        NSLog(@"ip = %@, url = %@", ip, URL.absoluteString);
//        NSLog(@"Get IP(%@) for host(%@) from HTTPDNS Successfully!", ip, URL.host);
//        NSRange hostFirstRange = [originalUrl rangeOfString:URL.host];
//        if (NSNotFound != hostFirstRange.location) {
//            NSString *newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
//            NSLog(@"New URL: %@", newUrl);
//            self.URL = [NSURL URLWithString:newUrl];
//            [self setValue:URL.host forHTTPHeaderField:@"host"];
//        }
//    } else {
//        NSLog(@"urlstring = %@", originalUrl);
//    }
    return self;
}
@end
