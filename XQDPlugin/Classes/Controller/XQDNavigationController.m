//
//  XQDNavigationController.m
//  Pods
//
//  Created by EriceWang on 2017/5/27.
//
//

#import "XQDNavigationController.h"
#import "Header.h"

@interface XQDNavigationController ()

@end

@implementation XQDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (UIViewController *)childViewControllerForStatusBarStyle
{
    NSString *className = NSStringFromClass(self.topViewController.class);
    DSLog(@"className = %@", className);
    if ([className hasPrefix:@"XQD"]) {
        return self.topViewController;
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
