//
//  ViewController.m
//  Yueke
//
//  Created by Lance on 2018/9/7.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "ViewController.h"
#import "FSCalendar.h"
#import "TimeCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource>

@property (nonatomic,strong) FSCalendar *calendar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;
@property (nonatomic) BOOL isWeek;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    
    
}

-(void)setupUI{
    self.navigationItem.title = @"约课";
    UIBarButtonItem *todayItem = [[UIBarButtonItem alloc] initWithTitle:@"TODAY" style:UIBarButtonItemStylePlain target:self action:@selector(todayItemClicked:)];
    self.navigationItem.rightBarButtonItem = todayItem;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.calendar];
    [self.view addSubview:self.tableView];
    
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).offset(30);
        make.top.mas_equalTo(self.view).offset(SafeAreaTopHeight);
        make.height.mas_equalTo(300);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.calendar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
}
- (void)todayItemClicked:(id)sender
{
    [_calendar setCurrentPage:[NSDate date] animated:NO];
}
#pragma mark calendar

-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    
}
-(NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date{
    return 0;
}
-(NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date{
    if ([self.calendar isDateInToday:date]) {
        return @"今";
    }
    return nil;
}

#pragma uitableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.title = self.dataArr[indexPath.row];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
    if(translatedPoint.y < 0){
        if (!self.isWeek) {
            self.calendar.scope = FSCalendarScopeWeek;
            [self.calendar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(120);
            }];
            self.isWeek = YES;
        }
    }else{
        if (self.isWeek) {
            self.calendar.scope = FSCalendarScopeMonth;
            [self.calendar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(300);
            }];
            self.isWeek = NO;
        }
    }
        
}

#pragma mark -- lazy

-(FSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc]init];
        _calendar.appearance.titleFont = [UIFont systemFontOfSize:15.0];
        _calendar.appearance.headerTitleColor = [UIColor redColor];
        _calendar.appearance.weekdayTextColor = [UIColor colorWithHex:0x666666];
        _calendar.appearance.weekdayFont = [UIFont systemFontOfSize:17.0];
        _calendar.appearance.titleWeekendColor = [UIColor orangeColor];
        _calendar.appearance.borderSelectionColor = [UIColor orangeColor];
        _calendar.appearance.selectionColor = [UIColor whiteColor];
        _calendar.appearance.titleSelectionColor = [UIColor colorWithHex:0x333333];
        _calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        _calendar.delegate = self;
        _calendar.dataSource = self;
    }
    return _calendar;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 60;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithObjects:@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00", nil];
    }
    return _dataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
