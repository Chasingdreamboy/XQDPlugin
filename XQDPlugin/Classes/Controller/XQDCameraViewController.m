//
//  CameraViewController.m
//  gongfudai
//
//  Created by David Lan on 15/7/8.
//  Copyright (c) 2015 Hangzhou Tree Finance Ltd. All rights reserved.
//

#import "XQDCameraViewController.h"
#import "UIView+Expand.h"
#import "macro.h"
#import "XQDHelper.h"
#import <LLSimpleCamera/LLSimpleCamera.h>

@interface XQDCameraViewController ()
{
    UIImage* _image;
}
@property (weak, nonatomic) IBOutlet UIView *errorLayer;
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (weak, nonatomic) IBOutlet UIButton *snapButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UIImageView *img_placeholder;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIImageView *tip;
@end

@implementation XQDCameraViewController
- (instancetype)init {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[XQDHelper bundle]];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (IS_Iphone4) {
        _img_placeholder.width=213;
        _img_placeholder.height=330;
        _img_placeholder.center=self.view.center;
        _img_placeholder.top=_img_placeholder.top-10;
        _tip.height=268;
        _tip.width=10;
    }
    
    if (_img_placeholder.width>270&&_placeHolderType!=CameraViewPlaceholderTypeWithCard) {
        _img_placeholder.width=270;
        _img_placeholder.height=419;
        _img_placeholder.center=self.view.center;
        _img_placeholder.top=_img_placeholder.top-10;
    }
    
    if(IS_Iphone6p_Or_Later&&_placeHolderType==CameraViewPlaceholderTypeWithCard){
        _img_placeholder.width=270*1.2;
        _img_placeholder.height=419*1.2;
        _img_placeholder.center=self.view.center;
        _img_placeholder.top=_img_placeholder.top-10;
    }
    
    _tip.centerY=_img_placeholder.centerY;
    _tip.left=_img_placeholder.left+8;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [_errorLayer.layer setCornerRadius:10.0f];
    
    // ----- initialize placeholder -------- //
    if (_placeHolderType==CameraViewPlaceholderTypeFront) {
        _img_placeholder.image=[UIImage imageNamed:@"1080-1920-正面"];
        _tip.hidden=NO;
    }
    else if(_placeHolderType==CameraViewPlaceholderTypeBack){
        _img_placeholder.image=[UIImage imageNamed:@"1080-1920-背面"];
        _tip.hidden=NO;
    }
    else{
        _img_placeholder.image=[UIImage imageNamed:@"1080-1920-手持"];
        _tip.hidden=YES;
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请按拍摄框提示位置拍照，确保照片中本人五官及身份证内容清晰可见。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    // ----- initialize camera -------- //
    
    // create camera vc
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:_placeHolderType==CameraViewPlaceholderTypeWithCard? CameraPositionFront:CameraPositionBack
                                             videoEnabled:NO];
    
    // attach to a view controller
    [self.camera updateFlashMode:CameraFlashOff];
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-135)];
    [self.view sendSubviewToBack:self.camera.view];
    self.camera.view.frame=CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-135);
    NSLog(@"%@",NSStringFromCGRect(self.camera.view.frame));
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        NSLog(@"Device changed.");
        
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            
            if(camera.flash == CameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        __strong typeof(self) strongSelf=weakSelf;
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                [strongSelf.errorLayer setHidden:NO];
                [strongSelf.img_placeholder setHidden:YES];
                [strongSelf.tip setHidden:YES];
            }
        }
    }];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(photoTakenSuccess:) name:@"photoTakenSuccess" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // start the camera
    [self.camera start];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)photoTakenSuccess:(NSNotification*)notification{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

/* camera button methods */

- (IBAction)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
}

- (IBAction)cancelButtonPressed:(UIButton *)button {
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.cancel) {
            self.cancel();
        }
    }];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (IBAction)flashButtonPressed:(UIButton *)button {
    
    if(self.camera.flash == CameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:CameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
            self.flashButton.tintColor = [UIColor yellowColor];
            [self.flashButton setNeedsLayout];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:CameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
            self.flashButton.tintColor = [UIColor whiteColor];
        }
    }
    
}

- (IBAction)snapButtonPressed:(UIButton *)button {
        // capture
    __weak typeof(self) weakSelf=self;
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            __strong typeof(self) strongSelf=weakSelf;
            // we should stop the camera, since we don't need it anymore. We will open a new vc.
            // this very important, otherwise you may experience memory crashes
            [camera stop];
            _image=image;
            XQDCameraHolderViewController* imageViewController= [[XQDCameraHolderViewController alloc]initWithNibName:NSStringFromClass(XQDCameraHolderViewController.class) bundle:[NSBundle mainBundle]];
            imageViewController.delegate=self.delegate;
            imageViewController.placeHolderType=(DSCameraHolderViewPlaceholderType)self.placeHolderType;
            imageViewController.image=_image;
            [strongSelf presentViewController:imageViewController animated:NO completion:nil];
        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];
    
}
- (IBAction)eventGoToSetting:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Photos"]];
}

- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
