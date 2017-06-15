//
//  XQDCameraHolderViewController
//
//  Created by david lan on 15/11/14.
//  Copyright (c) 2015 Hangzhou Tree Finance Ltd. All rights reserved.
//

#import "XQDCameraHolderViewController.h"
#import "XQDCameraViewController.h"
#import "ViewUtils.h"
#import "UIImage+Crop.h"
#import "macro.h"
#import "XQDHelper.h"
#import <NYXImageskit/UIImage+Resizing.h>
@interface XQDCameraHolderViewController (){
    
}
@property (weak, nonatomic) IBOutlet UIImageView *img_placeholder;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@end

@implementation XQDCameraHolderViewController
- (instancetype)init {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[XQDHelper bundle]];
    if(self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.backgroundColor = [UIColor blackColor];
    // ----- initialize placeholder -------- //
    if (_placeHolderType==ImageViewPlaceholderTypeFront) {
        _img_placeholder.image=[UIImage imageNamed:@"1080-1920-正面"];
    }
    else if(_placeHolderType==ImageViewPlaceholderTypeBack){
        _img_placeholder.image=[UIImage imageNamed:@"1080-1920-背面"];
    }
    else{
        _img_placeholder.image=[UIImage imageNamed:@"1080-1920-空"];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (IS_Iphone4) {
        _img_placeholder.width=213;
        _img_placeholder.height=330;
        _img_placeholder.center=self.view.center;
        _img_placeholder.top=_img_placeholder.top-10;
    }
    
    if (_img_placeholder.width>270&&_placeHolderType!=ImageViewPlaceholderTypeWithCard) {
        _img_placeholder.width=270;
        _img_placeholder.height=419;
        _img_placeholder.center=self.view.center;
        _img_placeholder.top=_img_placeholder.top-10;
    }
    
    if(IS_Iphone6p_Or_Later&&_placeHolderType==ImageViewPlaceholderTypeWithCard){
        _img_placeholder.width=270*1.2;
        _img_placeholder.height=419*1.2;
        _img_placeholder.center=self.view.center;
        _img_placeholder.top=_img_placeholder.top-10;
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self.imageView setImage:self.image];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(IBAction)eventConfirm:(id)sender{
    CGRect frame=CGRectMake(_img_placeholder.x-_imageView.x, _img_placeholder.y-_imageView.y, _img_placeholder.width, _img_placeholder.height);
    UIImage* img=nil;
    if (_placeHolderType==ImageViewPlaceholderTypeWithCard) {
        img=[_image  normalizedImage];
    }
    else{
        img=[[[_image  normalizedImage] scaleToSize:self.imageView.size]crop:frame];
    }
    [self dismissViewControllerAnimated:NO completion:^{
        __strong UIImage* image=img;
        if(self.delegate&&[self.delegate respondsToSelector:@selector(photoTaken:)]){
            [self.delegate photoTaken:image];
        }
    }];
}

-(IBAction) eventCancel:(id)sender{
    if (self.resetPhoto) {
        self.resetPhoto(self);
    } else {
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
