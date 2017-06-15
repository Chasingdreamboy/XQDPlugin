//
//  XQDViewController.m
//  XQDPlugin
//
//  Created by acct<blob>=<NULL> on 06/09/2017.
//  Copyright (c) 2017 acct<blob>=<NULL>. All rights reserved.
//

#import "XQDViewController.h"
#import <XQDPlugin/XQDPlugin.h>


@interface XQDViewController ()

@end

@implementation XQDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)beginTest:(id)sender {
    XQDPlugin *plugin = [XQDPlugin sharedInstance];
    NSString *mobile = _fieldText.text;
    [plugin showWithMobile:mobile];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
