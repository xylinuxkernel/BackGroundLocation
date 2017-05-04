//
//  XYDateFormatterManager.m
//  MyFrameWork
//
//  Created by 徐银 on 16/6/30.
//  Copyright © 2016年 徐银. All rights reserved.
//

#import "XYDateFormatterManager.h"

static NSDateFormatter *dateFormate;
@implementation XYDateFormatterManager

//初始化时间转化对象
+ (NSDateFormatter *)dateformatter
{
    if(!dateFormate)
    {
        dateFormate =  [[NSDateFormatter alloc]init];
    }
    [dateFormate setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return dateFormate;
}

//按照指定的格式转化时间对象为对应的字符串描述
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formate = [[self class] dateformatter];
    if (date && format) {
        [formate setDateFormat:format];
        return [formate stringFromDate:date];

    }
    return  nil;
}


//按照指定的格式把date对象转换成对应的string对象
+ (NSDate *)dateFromString:(NSString *)date format:(NSString *)format
{
    if (date) {
        NSDateFormatter *formate = [[self class] dateformatter];
        [formate setDateFormat:format];
        return [formate dateFromString:date];
    }
    return  nil;
}

//按照指定的格式把日期字符串对象转换成与当前时间的对应描述
+ (NSString *)getSimilarDesrip:(NSString *)date format:(NSString *)format
{
    return nil;
}

//礼拜描述
+ (NSString *)weekChinese:(int)weekday
{
    //系统NSDateComponents的weekday是1-7 1是星期日
    switch (weekday) {
        case 1:
            return NSLocalizedString(@"周日", nil);
            break;
        case 2:
            return NSLocalizedString(@"周一", nil);
            break;
        case 3:
            return NSLocalizedString(@"周二", nil);
            break;
        case 4:
            return NSLocalizedString(@"周三", nil);
            break;
        case 5:
            return NSLocalizedString(@"周四", nil);
            break;
        case 6:
            return NSLocalizedString(@"周五", nil);
            break;
        case 7:
            return NSLocalizedString(@"周六", nil);
            break;
        default:
            break;
    }
    return NSLocalizedString(@"未知", nil);
}

//返回当前时间时间戳
+ (NSNumber *)timeSStringSince1970
{
    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSNumber *llTime = [NSNumber numberWithLongLong:time];
    return llTime;
}

//时间比对
+ (BOOL)laterThan:(NSDate *)original desTime:(NSDate *)destTime
{
    long long origInterval = [original timeIntervalSince1970]*1000;
    long long destInterval = [destTime timeIntervalSince1970]*1000;
    
    if(origInterval - destInterval > 0)
    {
        return NO;
    }
    return YES;
}

@end
