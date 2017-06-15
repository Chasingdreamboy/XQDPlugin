//
//  DSAboutViewController.m
//  gongfudai
//
//  Created by David Lan on 15/9/1.
//  Copyright (c) 2015年 dashu. All rights reserved.
//
#import <TDBadgedCell.h>
#import "DSAboutViewController.h"
#import "XQDUtil.h"
#import "XQDJSONUtil.h"
#import "XQDWebViewController.h"
#import "Header.h"
#import "UIViewController+Expand.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface DSAboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

@end

@implementation DSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomerLeftItem];
    self.lblVersion.text=DS_STR_FORMAT(@"v%@", [XQDUtil appVersion]);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TDBadgedCell* cell=[tableView dequeueReusableCellWithIdentifier:@"reuseCell"];
    if (cell==nil) {
        cell=[[TDBadgedCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseCell"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.detailTextLabel.text=@"";
        cell.textLabel.text=@"";
        cell.textLabel.textColor=HEXCOLOR(@"333333");
        cell.detailTextLabel.textColor=HEXCOLOR(@"999999");
    }
    if(indexPath.row==0){
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text=@"关于我们";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0){
        [self showAboutView];
    }
}

-(void)showAboutView{
    XQDWebViewController* webView=[[XQDWebViewController alloc]init];
    webView.title=@"关于我们";
    webView.startPage=@"https://www.treefinance.com.cn?platform=ios";
    [self.navigationController pushViewController:webView animated:YES];
}

@end
