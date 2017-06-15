//
//  NSDate+Expand.h
//  gongfudai
//
//  Created by EricWang on 17/06/12.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSComponentsYMD(pYear,pMonth,pDay) [NSDateComponents dateComponentsWithYear:pYear month:pMonth day:pDay]
#define NSComponentsHMS(pHour,pMinute,pSecond) [NSDateComponents dateComponentsWithHour:pHour minute:pMinute second:pSecond]
#define NSComponentsYMDHMS(pYear,pMonth,pDay,pHour,pMinute,pSecond) [NSDateComponents dateComponentsWithYear:pYear month:pMonth day:pDay hour:pHour minute:pMinute second:pSecond]

@interface NSDateComponents (Expand)

@end

@interface NSDate (Expand)

-(NSString *)stringWithDateFormat:(NSString *)format;
-(BOOL)isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;
//周一到周日为1-7
- (NSInteger)weekdayMondayFirst;
- (NSArray *)dayNameFromMonday;//@“周一”到@“周日”，今日用@“今日”代替
- (NSString *)weekdayStringCNShort;
- (NSString *)weekdayStringCN;
- (NSString *)weekdayStringENShort;
- (NSString *)weekdayStringEN;

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

+ (NSDate *)dateFromChinaDateString:(NSString *)string;

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime;
+ (NSString *)stringForSince1970;
- (NSString *)stringForSince1970;
+ (NSTimeInterval)timeIntervalForSince1970;

- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSDate *)dateByAddingMonthComponents:(NSInteger)months weekComponents:(NSInteger)weeks;

- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;

+ (NSString *)dateFormatString;
+ (NSString *)dateFormatString2;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)timestampFormatLongString;
+ (NSString *)dbFormatString;
+ (NSDate *)dateFromJSON:(NSString *)dateString;

+(NSString *)nowDateString;
+(NSString *)nowTimeString;
+(NSString *)nowTimeStampString;

+(NSInteger)daysOfMonthWithDate:(NSDate *)date;

+(NSString *)todayZeroDateString;
+(NSDate *)todayZeroDate;
+(NSTimeInterval)todayZeroDateTimeIntervalSince1970;
-(NSTimeInterval)zeroDateTimeIntervalSince1970;

-(NSDate *)startOfMonth;
-(NSDate *)endOfMonth;

-(NSDate *)dateByAddingDays: (NSInteger)daysToAdd;
-(NSDate *)dateByAddingMonths: (NSInteger)monthsToAdd;
- (NSDate *)dateByAddingMonths: (NSInteger)monthsToAdd hour:(NSInteger) hour minute:(NSInteger) minute second:(NSInteger) second;


-(NSInteger)daysToDate:(NSDate *)aTargetDate;

-(NSString *)friendlyDisplayStringSinceNow;

-(NSString *)cnBigMonthString;
-(NSString *)enBigMonthString;

+(NSString*)timeWithTimestamp:(NSString*)timestamp withFormat:(NSString*)format;
+(NSDate*)timeWithTimestamp:(NSString*)timestamp;

- (NSString *)customString;

@end

