//
//  ViewController.m
//  Demo
//
//  Created by EriceWang on 2017/11/6.
//  Copyright © 2017年 Ericdong. All rights reserved.
//

#import "ViewController.h"
//#import <AFNetworking.h>
#import "Man.h"
#import "Fish.h"
#import <VKVideoPlayer/VKVideoPlayer.h>
@interface ViewController ()
@property (strong, nonatomic) VKVideoPlayer *player;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
NSString *const AYOULoginNotificationName = @"ayouloginnotificationName";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player = [VKVideoPlayer alloc] ;
    UICollectionView *collectionView = nil;
}
//- (IBAction)recognizeQRCode:(UILongPressGestureRecognizer *)longPress {
//    UIImageView *imageView = (UIImageView *)longPress.view;
//    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
//    NSArray *fetures = [detector featuresInImage:[CIImage imageWithCGImage:imageView.image.CGImage]];
//    if (fetures) {
//        CIQRCodeFeature *feature = [fetures firstObject];
//        NSString *result = feature.messageString;
//
//        if (result && result.length) {
//            if ([result hasPrefix:@"http"]) {
//                if (@available(iOS 10.0, *)) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result] options:@{} completionHandler:^(BOOL success) {
//                        NSLog(@"success open！");
//                    }];
//                } else {
//                    // Fallback on earlier versions
//                }
//            } else {
//                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alertView show];
//            }
//        }
//
//
//    } else {
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:@"您还没有生成二维码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//    }
//
//}
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
