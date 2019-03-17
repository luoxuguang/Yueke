//
//  YKTool.m
//  Yueke
//
//  Created by luo on 2018/9/29.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "YKTool.h"

@implementation YKTool

+(NSString *)getTimeWithStr:(NSString *)str Date:(NSDate *)date{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:str];
    return [outputFormatter stringFromDate:date];
}
+(NSString *)timeStampConversionNSString:(NSString *)timeStamp
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df dateFromString:timeStamp];
    NSTimeInterval inter = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld", (long)inter];
}

+(NSString *)dateConversionTimeStamp:(NSDate *)date
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000];
    return timeSp;
}

+(NSString *)nsstringConversionNSDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datestr timeIntervalSince1970]*1000];
    return timeSp;
}
+(NSString *)getYMDWithdate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%ld-%ld-%ld",[dateComponent year],[dateComponent month],[dateComponent day]];
}
+(NSInteger)getHourWithdate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMonth |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return [dateComponent hour];
}
+(NSInteger)getMinWithdate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return [dateComponent minute];
}
+(void)saveToDisk:(id)object{
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 这个文件后缀可以是任意的，只要不与常用文件的后缀重复即可，我喜欢用data
    NSString *filePath = [path stringByAppendingPathComponent:@"home.events.data"];
    // 归档
    [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}
+(id)fectchHomeData{
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"home.events.data"];
    // 解档
    id responseObject = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return responseObject;
}
@end
