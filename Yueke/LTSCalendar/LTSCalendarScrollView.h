//
//  LTSCalendarScrollView.h
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/13.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCalendarContentView.h"
#import "LTSCalendarWeekDayView.h"
#import "EventModel.h"

@interface LTSCalendarScrollView : UIScrollView
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITableView *leftTableView;
@property (nonatomic,strong)LTSCalendarContentView *calendarView;

@property (nonatomic,strong)UIColor *bgColor;

@property (nonatomic,strong) NSArray *Events;

@property (nonatomic,copy) void (^addCurseBlock)(EventModel *model);


- (void)scrollToSingleWeek;

- (void)scrollToAllWeek;
@end
