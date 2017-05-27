//
//  ViewController.m
//  Demo
//
//  Created by EriceWang on 2017/5/27.
//  Copyright © 2017年 Ericdong. All rights reserved.
//

#import "ViewController.h"
#import "DSFirstViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"This a first");
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    DSFirstViewController *first = [[DSFirstViewController alloc] init];
    first.title = @"First";
    first.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:first animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
