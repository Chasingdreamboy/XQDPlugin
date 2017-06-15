/********* controller.m Cordova Plugin Implementation *******/

#import "XQDControllerPlugin.h"
#import "XQDJSONUtil.h"
//#import <Cordova/CDVViewController.h>
#import "XQDWebViewController.h"
//#import "DSBaseCDVBridgeViewController.h"

@implementation XQDControllerPlugin
- (void)push:(NSDictionary *)command {
    
    NSString* type = [command objectForKey:@"type"];
    if ([@"class" isEqualToString:type]) {
        NSString* classStr = [command objectForKey:@"className"];
        NSString* title = [command objectForKey:@"title"];
        BOOL showNavigationBar = [[command objectForKey:@"showNavigationBar"] boolValue];
        UIViewController* vc = [[NSClassFromString(classStr) alloc] init];
        if ([vc isKindOfClass:[XQDWebViewController class]]) {
            [(XQDWebViewController *)vc setShowNavigationBar:showNavigationBar];
        }
        vc.title = title;
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
        [self sendResult:command code:DSOperationStateSuccess result:nil];
        
    } else if ([@"url" isEqualToString:type]) {
        
        NSString* url = [command objectForKey:@"url"];
        NSString* title = [command objectForKey:@"title"];
        NSString* classStr = [command objectForKey:@"className"];
        BOOL showNavigationBar = [[command objectForKey:@"showNavigationBar"] boolValue];
        if (!classStr) {
            classStr = NSStringFromClass([XQDWebViewController class]);
        } else {
            [self sendResult:command code:DSOperationStateParamsError result:nil];
        }
        XQDWebViewController* vc = [[NSClassFromString(classStr) alloc] init];
        vc.showNavigationBar = showNavigationBar;
        vc.title = title ? : @"";
        vc.hidesBottomBarWhenPushed = YES;
        vc.startPage = url;
        [self.viewController.navigationController pushViewController:vc animated:YES];
        
        [self sendResult:command code:DSOperationStateSuccess result:nil];
    }
    
}

- (void)pop:(NSDictionary *)command {
    if (self.viewController.navigationController.viewControllers.count>1) {
        [self.viewController.navigationController popViewControllerAnimated:YES];
        [self sendResult:command code:DSOperationStateSuccess result:nil];
    } else {
        [self sendResult:command code:DSOperationStateParamsError result:nil];
    }
}

-(void)popTo:(NSDictionary *)command {
    NSString *popToNumber = [NSString stringWithFormat:@"%@", [command objectForKey:@"popToNumber"]];
    if (!popToNumber || !popToNumber.length) {
        [self sendResult:command code:DSOperationStateParamsError result:nil];
        return;
    }
    NSInteger popNum = [popToNumber integerValue];
    NSArray* vcStack = self.viewController.navigationController.viewControllers;
    if (vcStack.count < popNum) {
        [self.viewController.navigationController popToRootViewControllerAnimated:YES];
    } else {
        UIViewController* vc = [vcStack objectAtIndex:([vcStack count] - popNum)];
        [self.viewController.navigationController popToViewController:vc animated:YES];
    }
    [self sendResult:command code:DSOperationStateSuccess result:nil];
}

- (void)exit:(NSDictionary *)command {
    [self pop:command];
}
- (void)logout:(NSDictionary *)command {
    [[XQDJSONUtil sharedInstance] logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    [self sendResult:command code:DSOperationStateSuccess result:nil];
    
}
@end
