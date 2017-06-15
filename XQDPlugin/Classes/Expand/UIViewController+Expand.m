//
//  ViewController-Expand.m
//  gongfudai
//
//  Created by David Lan on 15/7/4.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import "UIViewController+Expand.h"
#import "XQDHelper.h"
#import "NSObject+Swizzle.h"
#import "XQDWebViewController.h"
#import "UIImage+Expand.h"
#import "Header.h"
@implementation UIViewController(Expand)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzingInstanceSel:@selector(viewDidLoad) withSel:@selector(ds_viewDidLoad)];
        [self swizzingInstanceSel:@selector(viewDidAppear:) withSel:@selector(ds_viewDidAppear:)];
        [self swizzingInstanceSel:@selector(viewDidDisappear:) withSel:@selector(ds_viewDidDisappear:)];
    });
}
-(void)ds_viewDidLoad{
    NSString *className = NSStringFromClass(self.class);
    if ([className hasPrefix:@"XQD"]) {
        UIImage *image = [UIImage gradientImageFromColors:@[HEXCOLOR(@"#4b80ff"),HEXCOLOR(@"#a855fe")] ByGradientType:leftToRight size:(CGSize){SCREEN_WIDTH, 64}];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        UIFont* defaultFont=({
            NSLog(@"%@",[UIFont systemFontOfSize:18.0].fontName);
            UIFont* font=[UIFont fontWithName:@".HelveticaNeueInterface-Bold" size:18.0];
            font;
        });
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                        NSForegroundColorAttributeName :
                                                                            [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                                        NSFontAttributeName :defaultFont};
    }
    [self ds_viewDidLoad];
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)ds_viewDidAppear:(BOOL)animated{
    //设置当前页面的返回按钮样式，避免前一个页面title太长导致当前页面title不居中
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self ds_viewDidAppear:animated];
}
-(void)ds_viewDidDisappear:(BOOL)animated{
    [self ds_viewDidDisappear:animated];
}
- (void)addCustomerLeftItem {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 24, 24);
        UIImage *image = [XQDHelper getImageWithNamed:@"返回"];
        [button addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        button;
    })] ;
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)pop:(UIButton *)sender {
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
