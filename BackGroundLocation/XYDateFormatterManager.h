//
//  XYDateFormatterManager.h
//  MyFrameWork
//
//  Created by 徐银 on 16/6/30.
//  Copyright © 2016年 徐银. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYDateFormatterManager : NSObject

/**
 *  类方法返回一个时间格式化对象
 *
 *  @return NSDateFormatter 对象
 */
+ (NSDateFormatter *)dateformatter;

/**
 *  将时间按照指定格式转换为字符串对象
 *
 *  @param date   将要转换的日期
 *  @param format 需要输出的日期格式
 *
 *  @return 指定格式的字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

/**
 *  将时间字符串按照指定格式转换为日期对象
 *
 *  @param date   将要转换的时间字符串
 *  @param format 需要输出的日期格式
 *
 *  @return 指定格式的日期对象
 */
+ (NSDate *)dateFromString:(NSString *)date format:(NSString *)format;

/**
 *  将目标时间对象与当前时间对象进行比对返回描述说明
 *
 *  @param date   目标时间字符串时间对象
 *  @param format 需要输出的日期格式
 *
 *  @return 比对后时间描述
 */
+ (NSString *)getSimilarDesrip:(NSString *)date format:(NSString *)format;

/**
 *  返回具体的日期天数描述
 *
 *  @param weekday 星期描述
 *
 *  @return 当前语言特色下的星期描述
 */
+ (NSString *)weekChinese:(int)weekday;

/**
 *  获取时间戳精确到微妙
 *
 *  @return 返回时间戳数字对象
 */
+ (NSNumber *)timeSStringSince1970;

/**
 *  比较两个时间对象大小
 *
 *  @param original 源时间对象
 *  @param destTime 目的时间对象
 *
 *  @return 返回比较后的结果
 */
+ (BOOL)laterThan:(NSDate  *)original  desTime:(NSDate *)destTime;
@end
