//
//  YKTool.h
//  Yueke
//
//  Created by luo on 2018/9/29.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKTool : NSObject

+(NSString *)getTimeWithStr:(NSString *)str Date:(NSDate *)date; //获取时间所在的时分秒

+(NSString *)timeStampConversionNSString:(NSString *)timeStamp; //时间戳转时间
+(NSString *)dateConversionTimeStamp:(NSDate *)date;
+(NSString *)nsstringConversionNSDate:(NSString *)dateStr;
+(NSInteger)getHourWithdate:(NSDate *)date;
+(NSInteger)getMinWithdate:(NSDate *)date;
+(NSString *)getYMDWithdate:(NSDate *)date;

+(void)saveToDisk:(id)object;
+(id)fectchHomeData;

@end
