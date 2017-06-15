//
//  NSDate+Expand.m
//  gongfudai
//
//  Created by EricWang on 17/06/12.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import "NSDate+Expand.h"

@implementation NSDateComponents (Expand)

+(instancetype)dateComponentsWithYear:(NSInteger)year
                                month:(NSInteger)month
                                  day:(NSInteger)day
{
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    return dateComponents;
}

+(instancetype)dateComponentsWithHour:(NSInteger)hour
                               minute:(NSInteger)minute
                               second:(NSInteger)second
{
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setHour:hour];
    [dateComponents setMinute:minute];
    [dateComponents setSecond:second];
    return dateComponents;
}

+(instancetype)dateComponentsWithYear:(NSInteger)year
                                month:(NSInteger)month
                                  day:(NSInteger)day
                                 hour:(NSInteger)hour
                               minute:(NSInteger)minute
                               second:(NSInteger)second
{
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    [dateComponents setHour:hour];
    [dateComponents setMinute:minute];
    [dateComponents setSecond:second];
    return dateComponents;
}

@end

@implementation NSDate (Expand)

-(NSString *)stringWithDateFormat:(NSString *)format
{    
    if(self != (id)[NSNull null] && self != nil)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:format];
        return [dateFormatter stringFromDate:self];
    }
    return nil;
}

-(BOOL)isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([self compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([self compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
- (NSUInteger)daysAgo {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
    // get a midnight version of ourself:
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
    
    return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
    return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
    NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
    NSString *text = nil;
    switch (daysAgo) {
        case 0:
            text = @"Today";
            break;
        case 1:
            text = @"Yesterday";
            break;
        default:
            text = [NSString stringWithFormat:@"%lu days ago", (unsigned long)daysAgo];
    }
    return text;
}

- (NSUInteger)weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
    return [weekdayComponents weekday];
}
//周一到周日为1-7
- (NSInteger)weekdayMondayFirst{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
    NSInteger weekDay = [weekdayComponents weekday];
    NSInteger newWeekDay = 1+(weekDay+5)%7;
    return newWeekDay;
}

- (NSArray *)dayNameFromMonday//@“周一”到@“周日”，今日用@“今日”代替
{
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:7];
    for (int i = 1; i<=7; i++) {
        NSString *weekdayStr = nil;
        switch (i) {
            case 1:
                weekdayStr = @"周一";
                break;
            case 2:
                weekdayStr = @"周二";
                break;
            case 3:
                weekdayStr = @"周三";
                break;
            case 4:
                weekdayStr = @"周四";
                break;
            case 5:
                weekdayStr = @"周五";
                break;
            case 6:
                weekdayStr = @"周六";
                break;
            case 7:
                weekdayStr = @"周日";
                break;
        }
        if (i == [self weekdayMondayFirst]) {
            weekdayStr = @"今日";
        }
        [mArr addObject:weekdayStr];
    }
    return [NSArray arrayWithArray:mArr];
}

-(NSString *)weekdayStringCN
{
    NSString *weekdayStr = nil;
    switch ([self weekday]) {
        case 1:
            weekdayStr = @"星期日";
            break;
        case 2:
            weekdayStr = @"星期一";
            break;
        case 3:
            weekdayStr = @"星期二";
            break;
        case 4:
            weekdayStr = @"星期三";
            break;
        case 5:
            weekdayStr = @"星期四";
            break;
        case 6:
            weekdayStr = @"星期五";
            break;
        case 7:
            weekdayStr = @"星期六";
            break;
    }
    return weekdayStr;
}

-(NSString *)weekdayStringCNShort
{
    NSString *weekdayStr = nil;
    switch ([self weekday]) {
        case 1:
            weekdayStr = @"日";
            break;
        case 2:
            weekdayStr = @"一";
            break;
        case 3:
            weekdayStr = @"二";
            break;
        case 4:
            weekdayStr = @"三";
            break;
        case 5:
            weekdayStr = @"四";
            break;
        case 6:
            weekdayStr = @"五";
            break;
        case 7:
            weekdayStr = @"六";
            break;
    }
    return weekdayStr;
}

-(NSString *)weekdayStringEN
{
    NSString *weekdayStr = nil;
    switch ([self weekday]) {
        case 1:
            weekdayStr = @"Sunday";
            break;
        case 2:
            weekdayStr = @"Monday";
            break;
        case 3:
            weekdayStr = @"Tuesday";
            break;
        case 4:
            weekdayStr = @"Wednesday";
            break;
        case 5:
            weekdayStr = @"Thursday";
            break;
        case 6:
            weekdayStr = @"Friday";
            break;
        case 7:
            weekdayStr = @"Saturday";
            break;
    }
    return weekdayStr;
}

-(NSString *)weekdayStringENShort
{
    NSString *weekdayStr = nil;
    switch ([self weekday]) {
        case 1:
            weekdayStr = @"Sun";
            break;
        case 2:
            weekdayStr = @"Mon";
            break;
        case 3:
            weekdayStr = @"Tue";
            break;
        case 4:
            weekdayStr = @"Wed";
            break;
        case 5:
            weekdayStr = @"Thu";
            break;
        case 6:
            weekdayStr = @"Fri";
            break;
        case 7:
            weekdayStr = @"Sat";
            break;
    }
    return weekdayStr;
}

+ (NSDate *)dateFromString:(NSString *)string {
    return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

+ (NSDate *)dateFromChinaDateString:(NSString *)string
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:[NSDate dbFormatString]];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    return [inputFormatter dateFromString:string];
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime {
    /*
     * if the date is in today, display 12-hour time with meridian,
     * if it is within the last 7 days, display weekday name (Friday)
     * if within the calendar year, display as Jan 23
     * else display as Nov 11, 2008
     */
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
    
    NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                     fromDate:today];
    
    NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    NSString *displayString = nil;
    
    // comparing against midnight
    NSComparisonResult midnight_result = [date compare:midnight];
    if (midnight_result == NSOrderedDescending) {
        if (prefixed) {
            [displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
        } else {
            [displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
        }
    } else {
        // check if date is within last 7 days
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        [componentsToSubtract setDay:-7];
        NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
        NSComparisonResult lastweek_result = [date compare:lastweek];
        if (lastweek_result == NSOrderedDescending) {
            if (displayTime) {
                [displayFormatter setDateFormat:@"EEEE h:mm a"];
            } else {
                [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
            }
        } else {
            // check if same calendar year
            NSInteger thisYear = [offsetComponents year];
            
            NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                           fromDate:date];
            NSInteger thatYear = [dateComponents year];
            if (thatYear >= thisYear) {
                if (displayTime) {
                    [displayFormatter setDateFormat:@"MMM d h:mm a"];
                }
                else {
                    [displayFormatter setDateFormat:@"MMM d"];
                }
            } else {
                if (displayTime) {
                    [displayFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
                }
                else {
                    [displayFormatter setDateFormat:@"MMM d, yyyy"];
                }
            }
        }
        if (prefixed) {
            NSString *dateFormat = [displayFormatter dateFormat];
            NSString *prefix = @"'on' ";
            [displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
        }
    }
    
    // use display formatter to return formatted date string
    displayString = [displayFormatter stringFromDate:date];
    
    return displayString;
}

+ (NSString *)stringForSince1970
{
    return [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
}

- (NSString *)stringForSince1970
{
    return [NSString stringWithFormat:@"%lf", [self timeIntervalSince1970]];
}

+ (NSTimeInterval)timeIntervalForSince1970
{
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    return [[self class] stringForDisplayFromDate:date prefixed:prefixed alwaysDisplayTime:NO];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
    return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

- (NSString *)string {
    return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:dateStyle];
    [outputFormatter setTimeStyle:timeStyle];
    NSString *outputString = [outputFormatter stringFromDate:self];
    return outputString;
}

- (NSDate *)beginningOfWeek {
    // largely borrowed from "Date and Time Programming Guide for Cocoa"
    // we'll use the default calendar and hope for the best
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *beginningOfWeek = nil;
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
                           interval:NULL forDate:self];
    if (ok) {
        return beginningOfWeek;
    }
    
    // couldn't calc via range, so try to grab Sunday, assuming gregorian style
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    beginningOfWeek = nil;
    beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
    //normalize to midnight, extract the year, month, and day components and create a new date from those components.
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:beginningOfWeek];
    return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:self];
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    
    return endOfWeek;
}

+ (NSString *)dateFormatString {
    return @"yyyy-MM-dd";
}

+ (NSString *)dateFormatString2 {
    return @"yyyy/MM/dd";
}

+ (NSString *)timeFormatString {
    return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
    return @"yyyy-MM-dd HH:mm:ss";
}

+ (NSString *)timestampFormatLongString {
    return @"yyyy-MM-dd HH:mm:ss.SSS";
}

// preserving for compatibility
+ (NSString *)dbFormatString {
    return [NSDate timestampFormatString];
}

+ (NSDate*)dateFromJSON:(NSString *)dateString
{
    // Expect date in this format "/Date(1268123281843)/"
    if([dateString rangeOfString:@"Date"].location == NSNotFound)
        return nil;
    
    NSInteger startPos = [dateString rangeOfString:@"("].location+1;
    NSInteger endPos = [dateString rangeOfString:@")"].location;
    NSRange range = NSMakeRange(startPos,endPos-startPos);
    unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
    NSLog(@"%llu",milliseconds);
    NSTimeInterval interval = milliseconds/1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}
- (NSDate *)dateByAddingMonthComponents:(NSInteger)months weekComponents:(NSInteger)weeks
{
    
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setMonth:months];
    [dateComponents setWeek:weeks];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* nextDate = [calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return nextDate;
}

+(NSString *)nowDateString{
    return [[NSDate date] stringWithFormat:[NSDate dateFormatString]];
}

+(NSString *)nowTimeString
{
    return [[NSDate date] stringWithFormat:[NSDate timeFormatString]];
}

+(NSString *)nowTimeStampString
{
    return [[NSDate date] stringWithFormat:[NSDate timestampFormatString]];
}

//2014-01-01 00:00:00 String
+(NSString *)todayZeroDateString
{
    return [NSString stringWithFormat:@"%@ 00:00:00",[NSDate nowDateString]];
}

//2014-01-01 00:00:00 Date
+(NSDate *)todayZeroDate
{
    return [NSDate dateFromString:[NSDate todayZeroDateString] withFormat:[NSDate timestampFormatString]];
}

//今天零点 TimeInterval
+(NSTimeInterval)todayZeroDateTimeIntervalSince1970
{
    return [[NSDate todayZeroDate] timeIntervalSince1970];
}

//指定日期零点 TimeInterval
-(NSTimeInterval)zeroDateTimeIntervalSince1970
{
    NSString *zeroDateString = [NSString stringWithFormat:@"%@ %@",[self stringWithFormat:[NSDate dateFormatString]],@"00:00:00"];
    return [[NSDate dateFromString:zeroDateString withFormat:zeroDateString] timeIntervalSince1970];
}

-(NSDate *)startOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * currentDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: self];
    NSDate * startOfMonth = [calendar dateFromComponents: currentDateComponents];
    return startOfMonth;
}

- (NSDate *)endOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate * plusOneMonthDate = [self dateByAddingMonths: 1];
    NSDateComponents * plusOneMonthDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: plusOneMonthDate];
    NSDate * endOfMonth = [[calendar dateFromComponents: plusOneMonthDateComponents] dateByAddingTimeInterval: -1];
    return endOfMonth;
}

- (NSDate *)dateByAddingMonths: (NSInteger)monthsToAdd
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * months = [[NSDateComponents alloc] init];
    [months setMonth: monthsToAdd];
    return [calendar dateByAddingComponents: months toDate: self options: 0];
}

- (NSDate *)dateByAddingMonths: (NSInteger)monthsToAdd hour:(NSInteger) hour minute:(NSInteger) minute second:(NSInteger) second{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * comp = [[NSDateComponents alloc] init];
    [comp setMonth: monthsToAdd];
    [comp setHour:hour];
    [comp setMinute:minute];
    [comp setSecond:second];
    return [calendar dateByAddingComponents: comp toDate: self options: 0];
}

- (NSDate *)dateByAddingDays: (NSInteger)daysToAdd
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * days = [[NSDateComponents alloc] init];
    [days setDay:daysToAdd];
    return [calendar dateByAddingComponents: days toDate: self options: 0];
}

+(NSInteger)daysOfMonthWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:date];
    return days.length;
}

-(NSInteger)daysToDate:(NSDate *)aTargetDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:self
                                                          toDate:aTargetDate
                                                         options:0];
    return components.day;
}

-(NSString *)friendlyDisplayStringSinceNow
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self];
    if(timeInterval<10.0)
    {
        return @"刚刚";
    }
    else if(timeInterval>=10 && timeInterval<60)
    {
        int seconds = timeInterval;
        return [NSString stringWithFormat:@"%i秒前", seconds];
    }
    else if(timeInterval>=60 && timeInterval<3600)
    {
        int minutes = timeInterval/60;
        return [NSString stringWithFormat:@"%i分钟前", minutes];
    }
    else if(timeInterval>=3600 && timeInterval<86400)
    {
        int hours = timeInterval/3600;
        return [NSString stringWithFormat:@"%i小时前", hours];
    }
    else
    {
        int days = timeInterval/86400;
        return [NSString stringWithFormat:@"%i天前",days];
    }
    return nil;
}

-(NSString *)cnBigMonthString
{
    NSString *str = @"";
    int month = [[self stringWithFormat:@"MM"] intValue];
    switch (month) {
        case 1:
            str = @"一月";
            break;
        case 2:
            str = @"二月";
            break;
        case 3:
            str = @"三月";
            break;
        case 4:
            str = @"四月";
            break;
        case 5:
            str = @"五月";
            break;
        case 6:
            str = @"六月";
            break;
        case 7:
            str = @"七月";
            break;
        case 8:
            str = @"八月";
            break;
        case 9:
            str = @"九月";
            break;
        case 10:
            str = @"十月";
            break;
        case 11:
            str = @"十一月";
            break;
        case 12:
            str = @"十二月";
            break;
    }
    return str;
}

-(NSString *)enBigMonthString
{
    NSString *str = @"";
    int month = [[self stringWithFormat:@"MM"] intValue];
    switch (month) {
        case 1:
            str = @"1月";
            break;
        case 2:
            str = @"2月";
            break;
        case 3:
            str = @"3月";
            break;
        case 4:
            str = @"4月";
            break;
        case 5:
            str = @"5月";
            break;
        case 6:
            str = @"6月";
            break;
        case 7:
            str = @"7月";
            break;
        case 8:
            str = @"8月";
            break;
        case 9:
            str = @"9月";
            break;
        case 10:
            str = @"10月";
            break;
        case 11:
            str = @"11月";
            break;
        case 12:
            str = @"12月";
            break;
    }
    return str;
}

+(NSString*)timeWithTimestamp:(NSString*)timestamp withFormat:(NSString*)format
{
    long long time = [timestamp longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSString *timestr = [date stringWithFormat:format];
    return  timestr;
}

+(NSDate*)timeWithTimestamp:(NSString*)timestamp
{
    long long time = [timestamp longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    return  date;
}

- (NSString *)customString
{
    NSTimeInterval timeInterval = -[self timeIntervalSinceNow];
    if(timeInterval <= 30)
    {
        return @"刚刚";
    }
    else if(timeInterval < 60)
    {
        return [NSString stringWithFormat:@"%.0f秒前", timeInterval];
    }
    else if(timeInterval < 60 * 60)
    {
        return [NSString stringWithFormat:@"%li分钟前", (long)(((NSInteger)timeInterval) / 60)];
    }
    else if(timeInterval < 60 * 60 * 12)
    {
        return [NSString stringWithFormat:@"%li小时前", (long)(((NSInteger)timeInterval) / 60 / 60)];
    }
    else
    {
        return [self stringWithFormat:[NSDate dateFormatString]];
    }
}

@end
