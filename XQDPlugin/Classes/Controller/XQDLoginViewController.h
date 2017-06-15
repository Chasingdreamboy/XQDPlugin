//
//  XQDLoginViewController.h
//  Pods
//
//  Created by EriceWang on 2017/6/13.
//
//

#import <UIKit/UIKit.h>
typedef void(^LoginSuccessBlock) (void);
@interface XQDLoginViewController : UIViewController
@property (copy, nonatomic) LoginSuccessBlock loginBlock;
@property (weak, nonatomic) IBOutlet UITextField *tf_Mobile;
@property (weak, nonatomic) IBOutlet UITextField *tf_SMSCode;


@end
