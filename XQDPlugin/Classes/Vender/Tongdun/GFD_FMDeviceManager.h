//
//  GFD_FMDeviceManager.h
//  GFD_FMDeviceManager
//
//  Copyright (c) 2016年 Tongdun.inc. All rights reserved.
//

#define FM_SDK_VERSION @"3.0.2"

#import <Foundation/Foundation.h>

typedef struct GFD_void {
    void (*initWithOptions)(NSDictionary *);
    NSString *(*getDeviceInfo)();
} GFD_FMDeviceManager_t;

@interface GFD_FMDeviceManager : NSObject

+ (GFD_FMDeviceManager_t *) sharedManager;
+ (void) destroy;

@end

