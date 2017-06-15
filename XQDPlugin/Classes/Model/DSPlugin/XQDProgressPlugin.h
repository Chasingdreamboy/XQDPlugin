//
//  GFDProgress.h
//  CordovaTester
//
//  Created by EricWang on 17/06/12.
//
//

#import "XQDBasePlugin.h"
#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger, DSCordovaProgressHUDMode) {
    DSCordovaProgressHUDModeOnWebView,
    DSCordovaProgressHUDModeOnTopWindow
};

@interface XQDProgressPlugin : XQDBasePlugin<MBProgressHUDDelegate> {}

@property(nonatomic, strong) MBProgressHUD* hud;
@property(nonatomic, assign) DSCordovaProgressHUDMode mode;
@property(nonatomic, copy) NSString* callbackId;

- (void)showLoading:(NSDictionary*)command;
- (void)showSuccess:(NSDictionary*)command;
- (void)showFail:(NSDictionary*)command;
- (void)showProgress:(NSDictionary*)command;
- (void)showDropdown:(NSDictionary*)command;
- (void)hide:(NSDictionary*)command;

@end
