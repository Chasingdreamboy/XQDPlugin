//
//  DSFirstViewController.m
//  Demo
//
//  Created by EriceWang on 2017/5/27.
//  Copyright © 2017年 Ericdong. All rights reserved.
//

#import "DSFirstViewController.h"

@interface DSFirstViewController ()
@property (strong, nonatomic) UIView *topView;


@end

@implementation DSFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView = [[UIView alloc] initWithFrame:self.view.bounds];
    _topView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_topView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
