//
//  NSObject+Expand.h
//  gongfudai
//
//  Created by _tauCross on 14-9-4.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Expand)

@property(nonatomic, setter = setCMTag:)NSInteger CMTag;

@property(nonatomic, setter = setTCUserInfo:)NSDictionary *TCUserInfo;
- (NSString *)tripleDESEncrypt;

@end
