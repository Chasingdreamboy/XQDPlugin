//
//  DSAdressBookManager.h
//  GetPhoneBook
//
//  Created by EriceWang on 16/4/28.
//  Copyright © 2016年 Ericdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ContactsUI/ContactsUI.h>
#import <AddressBookUI/AddressBookUI.h>

typedef NS_ENUM(NSInteger, ContactCode) {
    ContactCodeNomal = -1,
    ContactCodeNoPermit,//无权限
    ContactCodeNoSelect,//未选择直接退出
    ContactCodeNoMobile,//有姓名无电话
    ContactCodeNoName,//有电话无姓名
    ContactCodeNetworkFail,
    ContactCodeUnknownError
};
typedef void(^ResultBlock) (BOOL success, ContactCode code, NSDictionary *_Nullable info);
@interface XQDAddressBookManager : NSObject<ABPeoplePickerNavigationControllerDelegate,UINavigationControllerDelegate,CNContactPickerDelegate>
@property (copy, nonatomic) _Nullable ResultBlock innerBlock, uploadAllContacts;
@property (assign, atomic) BOOL forbidAppear;
@property (strong, nonatomic) _Nullable dispatch_queue_t queue;

+ (void)showAddressBookWithController:( UIViewController * _Nonnull )viewController result:(_Nullable ResultBlock)resultBlock;
+ (void)uploadAllContactsWithResult:(_Nonnull ResultBlock)uploadAllContacts;
+ (void)getOrignalContactsWithFilter:(BOOL)isFilterd result:(_Nullable ResultBlock)uploadAllContacts;
//供外部调用接口(Category)
+ (XQDAddressBookManager * _Nonnull)sharedInstance;
+(void)uploadContactsToServer:(NSArray* _Nullable)contacts;
//+ (void)clear;
//+ (void)printMessage:(NSString * _Nullable )message;
@end
