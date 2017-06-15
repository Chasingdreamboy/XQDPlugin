//
//  ConstString.h
//  jidongsudai
//
//  Created by EriceWang on 16/8/26.
//  Copyright © 2016年 dashu. All rights reserved.
//

#ifndef ConstString_h
#define ConstString_h
//本地化数据存储字符串(加密)
static NSString *userIdKey     = @"userId";//用户id
static NSString *tokenKey      = @"token";//用户token信息
static NSString *mobileKey     = @"gfd_un";//电话号存储
static NSString *positionKey   = @"positionData";//用户地理位置信息

//本地化数据存储字符串(未加密)
static NSString *onlineAppVersionKey  = @"onlineAppVersion";
static NSString *isLoanedKey        = @"isLoaned";//是否是贷后用户
static NSString *originalUAKey      = @"originalUA";
static NSString *schemeUrlKey       = @"schemeUrl";//回调需要打开的detinationClass
static NSString *hasNewVersionKey   = @"hasNewVersion";//线上是否有版本需要更新
static NSString *releaseNoteKey     = @"releaseNoteKey";
static NSString *lastEnteranceTimeKey   = @"lastEnteranceTime";//最后一次进入后台运行时的时间戳
static NSString *sequenceNumKey        = @"sequenceNum";//个推别名参数
static NSString *isInReviewKey      = @"isInReview";
static NSString *notDisplayIndicatorKey = @"notDisplayIndicator";

static NSString *lastGetLocationTimestampKey = @"lastGetLocationTimestamp";





static NSString  *illegalPasswordMsg= @"请输入6-18位数字或字母组合密码";
static NSString  *illegalMobileMsg     = @"请输入正确的11位手机号码";
#endif /* ConstString_h */
