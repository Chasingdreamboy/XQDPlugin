//
//  XQDWebViewPlugin.m
//  gongfubao
//
//  Created by David Lan on 15/12/31.
//  Copyright (c) 2015年 Hangzhou Tree Finance Ltd. All rights reserved.
//

#import "XQDTabbarPlugin.h"
#import "XQDWebViewController.h"
//#import "DSBaseCDVBridgeViewController.h"
@implementation XQDTabbarPlugin
-(void)select:(NSDictionary *)command{
    NSInteger index = [[command objectForKey:@"tabIndex"] integerValue];
    [self.viewController.tabBarController setSelectedIndex:index];
    [self sendResult:command code:DSOperationStateSuccess result:nil];
}

-(void)pop:(NSDictionary *)command{
    //tab index
    NSInteger tabIndex=[[command objectForKey:@"tabIndex"] integerValue];
    //number of view controllers to pop
    NSInteger numberOfVC=[[command objectForKey:@"count"] integerValue];
    //tabbar root
    UINavigationController* vc=[self.viewController.tabBarController.viewControllers objectAtIndex:tabIndex];
    //vc stack
    NSArray* vcs=[vc viewControllers];
    vcs=[vcs subarrayWithRange:NSMakeRange(0, MAX((long)1, (long)[vcs count]-numberOfVC))];
    [vc setViewControllers:vcs animated:NO];
    [self sendResult:command code:DSOperationStateSuccess result:nil];
}

-(void)selectAndPush:(NSDictionary *)command{
    
    NSInteger index=[[command objectForKey:@"tabIndex"] integerValue];
    NSDictionary* params=[command objectForKey:@"params"];
    [self.viewController.tabBarController setSelectedIndex:index];
    UINavigationController* nvc=[[self.viewController.tabBarController viewControllers] objectAtIndex:index];
    NSString* type = [params objectForKey:@"type"];
    if ([@"class" isEqualToString:type]) {
        NSString* classStr = [params objectForKey:@"destinationClass"];
        NSString* title = [params objectForKey:@"title"];
        UIViewController* vc = [[NSClassFromString(classStr) alloc] init];
        vc.title = title;
        vc.hidesBottomBarWhenPushed = YES;
        [nvc pushViewController:vc animated:YES];
        [self sendResult:command code:DSOperationStateSuccess result:nil];

    } else if ([@"url" isEqualToString:type]) {
        NSString* url = [params objectForKey:@"url"];
        NSString* title = [params objectForKey:@"title"];;
        NSString* classStr = [params objectForKey:@"destinationClass"];;
        if (!classStr) {
            classStr = NSStringFromClass([XQDWebViewController class]);
        }
        
        XQDWebViewController* vc = [[NSClassFromString(classStr) alloc] init];
        vc.title = title;
        vc.hidesBottomBarWhenPushed = YES;
        vc.startPage = url;
        [nvc pushViewController:vc animated:YES];
        [self sendResult:command code:DSOperationStateSuccess result:nil];
//        
//        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

@end
