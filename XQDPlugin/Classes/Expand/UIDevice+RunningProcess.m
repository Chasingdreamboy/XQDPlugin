//
//  UIDevice+RunningProcess.m
//  gongfudai
//
//  Created by David Lan on 16/4/14.
//  Copyright © 2016年 dashu. All rights reserved.
//

#import "UIDevice+RunningProcess.h"
#import "macro.h"
#import <sys/sysctl.h>

@implementation UIDevice(RunningProcess)
+ (NSArray *)runningProcesses {
    if (IOS_OR_LATER(9.0)) {
        //In iOS 9, sysctl() was modified to no longer allow sandboxed Apps to retrieve information about other running processes
        return nil;
    }
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    size_t size;
    int st = sysctl(mib, (u_int)miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    do {
        
        size += size / 10;
        newprocess = realloc(process, size);
        
        if (!newprocess){
            
            if (process){
                free(process);
            }
            
            return nil;
        }
        
        process = newprocess;
        st = sysctl(mib, (u_int)miblen, process, &size, NULL, 0);
        
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = (int)size / sizeof(struct kinfo_proc);
            
            if (nprocess){
                
                NSMutableArray * array = [[NSMutableArray alloc] init];
                
                for (int i = nprocess - 1; i >= 0; i--){
                    
                    char* processN=process[i].kp_proc.p_comm;
                    
//                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    NSString * processName = [NSString stringWithCString:processN encoding:NSUTF8StringEncoding];
                    
                    [array addObject:processName];
                }
                
                free(process);
                return array;
            }
        }
    }
    
    return nil;
}
@end
