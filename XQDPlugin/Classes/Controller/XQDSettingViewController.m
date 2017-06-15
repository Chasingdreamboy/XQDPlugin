//
//  XQDSettingViewController.m
//  gongfudai
//
//  Created by David Lan on 15/8/25.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#import "XQDSettingViewController.h"
//#import "DSActionSheetView.h"
#import "XQDWebViewController.h"
#import "UIAlertView+Expand.h"
#import "XQDJSONUtil.h"
#import "XQDUtil.h"
#import "TDBadgedCell.h"
#import "MBProgressHUD+Expand.h"
#import "Header.h"
#import "UIViewController+Expand.h"

//test
#import "XQDGetPhotoManager.h"
#import "XQDAddressBookManager.h"
#import "XQDAddressBookManager+IOS10.h"
#import "XQDOSSUtil.h"




@interface XQDSettingViewController ()
{
    UILabel *sizeLabel;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lblMobile;
@end

@implementation XQDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomerLeftItem];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    
    switch (section) {
        case 0:
            break;
        case 1:
            [self securityAndSavety];
            break;
        case 2:
            [self aboutUs];
            break;
        case 3: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清理缓存" message:@"确定清理缓存吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex, UIAlertView *alertView) {
                if (buttonIndex) {
                    [MBProgressHUD showSuccess:@"缓存清理完成！" withDuration:1.2];
                    sizeLabel.text = [self getCachesizeWithClearCaches:YES];
                } else {
                    
                }
            }];
        }
            
            break;
            
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TDBadgedCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[TDBadgedCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSInteger section = indexPath.section;
    switch (section) {
        case 0: {
            cell.textLabel.text=@"手机号";
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.detailTextLabel.text=CUSTOMER_GET(mobileKey);
        }
            
            break;
        case 1: {
            cell.textLabel.text=@"隐私条款";
        }
            break;
        case 2: {
            
            cell.textLabel.text=@"关于小期贷";
            
        }
            break;
        case 3: {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"清理缓存";
            cell.detailTextLabel.text = [self getCachesizeWithClearCaches:NO];
            cell.detailTextLabel.textColor = [UIColor redColor];
            sizeLabel = cell.detailTextLabel;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

//常见问题
-(void)QA{
    XQDWebViewController* webView=[[XQDWebViewController alloc]init];
    webView.startPage=[XQDUtil getUrlWithParams:GET_H5_URL(@"/faq")];
    webView.title=@"常见问题";
    [self.navigationController pushViewController:webView animated:YES];
}

//隐私与安全
-(void) securityAndSavety{
    XQDWebViewController* webView=[[XQDWebViewController alloc]init];
    webView.startPage=[XQDUtil getUrlWithParams:GET_H5_URL(@"/tos_privacy_policy")];
    webView.title=@"隐私条款";
    [self.navigationController pushViewController:webView animated:YES];
}

//关于gongfudai
-(void) aboutUs{
    [self performSegueWithIdentifier:@"about" sender:self];
}


//获取缓存大小
- (NSString *)getCachesizeWithClearCaches:(BOOL)isClear{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    NSString *filePath;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    long long size = 0;
    NSString *result = nil;
    NSString *path = nil;
    //clear the subfiles of caches foloder
    if (isClear) {
        for (path in files) {
            filePath = [cachPath stringByAppendingPathComponent:path];
            [fileManager removeItemAtPath:filePath error:nil];
        }
        //clear the cookies of webview
        NSHTTPCookie *cookie = nil;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
        //clear the cache of webview
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        result = @"0.00 M";
    } else {
        //get size of coches folder
        for (path in files) {
            filePath = [cachPath stringByAppendingPathComponent:path];
            size += [fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
        }
        result = [NSString stringWithFormat:@"%.2f M", size * 1.0 / 1024.0 / 1024.0];
    }
    return result;
}


@end
