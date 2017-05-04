//
//  NSDate+Addition.h
//  MyFrameWork
//
//  Created by 徐银 on 16/7/1.
//  Copyright © 2016年 徐银. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  NS_ENUM(NSInteger,timeType )
{
    TimeYear,
    TimeMonth,
    TimeDay
};

@interface NSDate (Addition)

/**
 *  按照全拼的格式把字符串时间对象转换成日期对象
 *
 *  @param string 日期字符串对象
 *
 *  @return 日期对象
 */
+ (NSDate *)dateFromString:(NSString *)string;

/**
 *  按照指定的格式把字符串时间对象转换成日期对象
 *
 *  @param string  字符串日期对象
 *  @param formate 指定格式
 *
 *  @return 日期对象
 */
+ (NSDate *)dateFromString:(NSString *)string withFormate:(NSString *)formate;

/**
 *  当前时间转换成字符串描述
 *
 *  @return 当前时间字符串对象
 */
+ (NSString *)nowDateToString;
+ (NSDate *)formateDateWithString:(NSString *)string;
- (NSString *)toStringWithFormat:(NSString *)format;
- (NSString *)timeDescription;
- (NSString *)localDescription;
- (NSString *)hoursDescription;
- (NSString *)timeDescriptionFull;

- (NSUInteger)getWeekday;
- (NSUInteger)getYears;
- (NSUInteger)getMonth;
- (NSUInteger)getDay;
- (NSUInteger)getweekOfMonth;
- (NSUInteger)getIntervalOtherDate:(NSDate*)other;
- (NSString *)formatDateToViewShow;
- (NSArray *)timeFullSection;
- (BOOL)isSameDay:(NSDate *)date2;
- (BOOL)isThisYear;
- (BOOL)isThisMonth;
//获取一个月的天数
- (NSUInteger)getDaysOfMonth:(NSDate *)date;
//转换本地时间
+ (NSDate *)transformUTCDate:(NSDate *)currentUTCDate;
//根据天数倒计时描述
- (NSString *)getCountDownTimeDescrip;
//获取当前月份的第一天是礼拜几
- (NSUInteger)getCurrentMonthFirstWeek;
//获取该月份的第一天时间对象
- (NSDate *)getFirstDateOfMonth;
//根据传入的差值来获取指定的日期对象
- (NSDate *)getRelativeDateByDiff:(NSUInteger)diff timeType:(timeType)type;
//根据日期获取农历
- (NSString *)getChineseCalendar;
@end
