//
//  CalendarDaysClass.h
//  Yueke
//
//  Created by luo on 2018/9/27.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarDaysClass : NSObject


@property (nonatomic,strong)NSArray *daysInMonth;
@property (nonatomic,strong)NSArray *daysInWeeks;

+(instancetype)shareClass;

@end
