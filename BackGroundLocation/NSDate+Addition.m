//
//  NSDate+Addition.m
//  MyFrameWork
//
//  Created by 徐银 on 16/7/1.
//  Copyright © 2016年 徐银. All rights reserved.
//

#import "NSDate+Addition.h"
#import "XYDateFormatterManager.h"

#define DateFormat			@"yyyy-MM-dd"
#define TimeFormat			@"MM-dd HH:mm:ss"
#define FullFormat          @"yyyy-MM-dd HH:mm:ss"
#define LocalFormat          @"MM月dd日"

@implementation NSDate (Addition)

- (NSDate *)dateDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    return [calendar dateFromComponents:comps];
}

+ (NSDate*)dateFromString:(NSString *)string
{
    return [XYDateFormatterManager dateFromString:string format:FullFormat];
}

+ (NSDate *)dateFromString:(NSString *)string withFormate:(NSString *)formate
{
    return [XYDateFormatterManager dateFromString:string format:formate];
}

+ (NSString*)nowDateToString
{
    return [XYDateFormatterManager stringFromDate:[[self class] transformUTCDate:[NSDate date]]
                                    format:FullFormat];
}

- (NSString *)timeDescription
{
    return [XYDateFormatterManager stringFromDate:self
                                    format:DateFormat];
}

- (NSString *)localDescription
{
    return [XYDateFormatterManager stringFromDate:self
                                    format:LocalFormat];
}

- (NSString *)hoursDescription
{
    return [XYDateFormatterManager stringFromDate:self
                                    format:TimeFormat];
}

- (NSString *)timeDescriptionFull
{
    return [XYDateFormatterManager stringFromDate:self
                                    format:FullFormat];
}

- (NSString*)toStringWithFormat:(NSString*)format
{
    return [XYDateFormatterManager stringFromDate:self format:format];
}

- (NSUInteger)getWeekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitWeekday) fromDate:self];
    return [weekdayComponents weekday];
}

- (NSUInteger)getYears
{
    NSCalendar* chineseClendar = [NSCalendar currentCalendar];
    NSDateComponents *targetCom = [ chineseClendar components:NSCalendarUnitYear fromDate:self];
    
    return [targetCom year];
}

- (NSUInteger)getMonth
{
    NSCalendar* chineseClendar = [NSCalendar currentCalendar];
    NSDateComponents *targetCom = [ chineseClendar components:NSCalendarUnitMonth fromDate:self];
    
    return [targetCom month];
}

- (NSUInteger)getDay
{
    NSCalendar* chineseClendar = [NSCalendar currentCalendar];
    //    [chineseClendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [chineseClendar setTimeZone:[NSTimeZone  localTimeZone]];
    NSDateComponents *targetCom = [ chineseClendar components:NSCalendarUnitDay fromDate:self];
    
    return  [targetCom day];
}

- (NSUInteger)getweekOfMonth
{
    NSCalendar* chineseClendar = [NSCalendar currentCalendar];
    NSDateComponents *targetCom = [ chineseClendar components:NSCalendarUnitWeekOfMonth fromDate:self];
    return  [targetCom day];
}

- (NSUInteger)getIntervalOtherDate:(NSDate *)other
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags
                                           fromDate:self
                                             toDate:other
                                            options:0];
    return [comps day];
}

- (NSUInteger)getDaysOfMonth:(NSDate *)date
{
    NSDate *currTime = [[self class]transformUTCDate:self];
    NSCalendar *currentC = [NSCalendar currentCalendar];
    //根据最小单位获取到当前的范围比如月单位 获取月份的范围1-31
    NSRange days = [currentC rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currTime];
    return days.length == NSNotFound?0:days.length;
}

- (NSString *)formatDateToAvatar
{
    return [XYDateFormatterManager stringFromDate:self
                                    format:@"MM-dd HH:mm"];
}

- (NSArray *)timeFullSection
{
    NSString *time = [XYDateFormatterManager stringFromDate:self
                                              format:@"yyyy:MM:dd:HH:mm:ss"];
    if ([time length] > 0)
    {
        return [time componentsSeparatedByString:@":"];
    }
    
    return nil;
}


- (NSString *)formatDateToViewShow;
{
    NSDate *currTime = [[self class]transformUTCDate:[NSDate date]];
    NSCalendar* chineseClendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    //NSDateComponents *cps = [ chineseClendar components:unitFlags fromDate:date toDate:startDate options:0];
    NSDateComponents *targetCom = [ chineseClendar components:unitFlags fromDate:self];
    NSDateComponents *NowCom = [ chineseClendar components:unitFlags fromDate:currTime];
    
    NSInteger diffDay  = [NowCom day]-[targetCom day];
    NSInteger diffmonth  = [NowCom month]-[targetCom month];
    NSInteger diffYear = [NowCom year]-[targetCom year];
    NSInteger diffMinute = [NowCom minute]-[targetCom minute];
    NSInteger diffHour = [NowCom hour] - [targetCom hour];
    NSString *returnText = nil;
    if (diffYear >= 1)
    {
        returnText = [XYDateFormatterManager stringFromDate:self
                                              format:DateFormat];
    }
    else
    {
        if (!(diffmonth+diffDay))//一天之内
        {
            if (diffHour <= 0 && diffMinute < 5)
            {
                returnText = @"刚刚";
            }
            else if (diffHour <= 0 && diffMinute <= 30)
            {
                returnText = [NSString stringWithFormat:@"%ld分钟前", (long)diffMinute];
            }
            else
            {
                returnText = [XYDateFormatterManager stringFromDate:self
                                                      format:@"今天 HH:mm"];
            }
        }
        else if (!diffmonth && 1 == diffDay)
        {
            returnText = [XYDateFormatterManager stringFromDate:self
                                                  format:@"昨天 HH:mm"];
        }
        else
        {
            returnText = [XYDateFormatterManager stringFromDate:self
                                                  format:@"MM-dd HH:mm"];
        }
    }
    
    return returnText;
}

//人人返回的时间格式为yyyy-MM-dd HH:mm:ss或者yyyy-mm-dd hh:mm
+ (NSDate *)formateDateWithString:(NSString *)str
{
    NSUInteger cnt = [[[[str componentsSeparatedByString:@" "] objectAtIndex:1] componentsSeparatedByString:@":"] count];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    
    //yyyy-MM-dd HH:mm:ss
    if(3 == cnt)
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    yyyy-mm-dd hh:mm
    else
        [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formater dateFromString:str];
}

- (BOOL)isSameDay:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

-(BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear;
    NSDateComponents *curr = [calendar components:unitFlags fromDate:[[self class] transformUTCDate:[NSDate date]]];
    NSDateComponents *user = [calendar components:unitFlags fromDate:self];
    
    return curr.year == user.year;
    
}

- (BOOL)isThisMonth;
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *curr = [calendar components:unitFlags fromDate:[[self class] transformUTCDate:[NSDate date]]];
    NSDateComponents *user = [calendar components:unitFlags fromDate:self];
    
    return (curr.year == user.year) && (curr.month == user.month);
}

+ (NSDate *)transformUTCDate:(NSDate *)currentUTCDate{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:currentUTCDate];
    NSDate *localeDate = [currentUTCDate  dateByAddingTimeInterval: interval];
    return localeDate;
}

- (NSString *)getCountDownTimeDescrip
{
    NSDate *currTime = [NSDate date];
    NSDate *localTime = [[self class] transformUTCDate:currTime];
    NSCalendar* chineseClendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    BOOL compareFlag = [XYDateFormatterManager laterThan:localTime desTime:self];
    if(compareFlag == NO)
    {
        return nil;
    }
    NSDateComponents *d = [ chineseClendar components:unitFlags fromDate:localTime toDate:self options:0];
    if([d month] == 0)
    {
        
    }
    if ([d month]>0) {
        return [NSString stringWithFormat:@"%ld天%ld小时%ld分钟%ld秒",(long)([localTime getIntervalOtherDate:self]),(long)[d hour],(long)[d minute],(long)[d second]];
    }
    return [NSString stringWithFormat:@"%ld天%ld小时%ld分钟%ld秒",(long)[d day],(long)[d hour],(long)[d minute],(long)[d second]];
}

- (NSDate *)getFirstDateOfMonth
{
    NSDate * startDate = nil;
    //根据小单位 获取当前时间对象的开始时间
    BOOL isOk = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
    if(isOk)
        return  startDate;
    return nil;
}

- (NSUInteger)getCurrentMonthFirstWeek
{
    //ordinal在大单位里面获取范围内的数据
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
}

- (NSDate *)getRelativeDateByDiff:(NSUInteger)diff timeType:(timeType)type
{
    NSDateComponents *component = [[NSDateComponents alloc] init];
    switch (type) {
        case TimeYear:
            component.year = diff;
            break;
        case TimeMonth:
            component.month = diff;
            break;
        case TimeDay:
            component.day  = diff;
            break;
        default:
            break;
    }
    return [[NSCalendar currentCalendar] dateByAddingComponents:component toDate:self options:NSCalendarMatchNextTime];
}

- (NSString *)getChineseCalendar
{
    NSInteger wCurYear = [self getYears];
    NSInteger wCurMonth = [self getMonth];
    NSInteger wCurDay = [self getDay];
    //农历日期名
    NSArray *cDayName =  [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                          @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                          @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    //农历月份名
    NSArray *cMonName =  [NSArray arrayWithObjects:@"*",@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"腊月",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (int)((wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38);
    
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    //生成农历月
    NSString *szNongliMonth;
    if (wCurMonth < 1){
        szNongliMonth = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }else{
        szNongliMonth = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
    //生成农历日
    NSString *szNongliDay = [cDayName objectAtIndex:wCurDay];
    //合并
    NSString *lunarDate = [NSString stringWithFormat:@"%@-%@",szNongliMonth,szNongliDay];
    
    return lunarDate;
}

@end
