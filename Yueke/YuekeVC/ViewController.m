//
//  ViewController.m
//  Yueke
//
//  Created by Lance on 2018/9/7.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "ViewController.h"
#import "LTSCalendarManager.h"
#import "EventModel.h"
#import "AddEventViewController.h"

@interface ViewController ()<LTSCalendarEventSource>


@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;
@property (nonatomic) BOOL isWeek;
@property (nonatomic,strong)LTSCalendarManager *manager;
@property (nonatomic,strong)UILabel *monthLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    
    [self.manager.calenderScrollView.tableView.mj_header beginRefreshing];
}

-(void)requestData{

    NSDictionary *param = @{@"token":user_token,@"state":@"0"};
    [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_allCourse] parameters:param success:^(id responseObject) {
        [self.manager.calenderScrollView.tableView.mj_header endRefreshing];
        NSMutableArray *mulArr = [[NSMutableArray alloc]init];
        [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EventModel *model = [[EventModel alloc]init];
            model.startDate = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",[obj objectForKey:@"startDate"]] longLongValue]/1000];
            model.endDate = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",[obj objectForKey:@"endDate"]] longLongValue]/1000];
            model.storeName = [NSString stringWithFormat:@"%@",[[obj objectForKey:@"dateCollege"] objectForKey:@"collegename"]];
            model.storeId = [NSString stringWithFormat:@"%@",[[obj objectForKey:@"dateCollege"] objectForKey:@"fid"]];
            model.userId = [NSString stringWithFormat:@"%@",[[obj objectForKey:@"dateUser"] objectForKey:@"fid"]];
            model.username = [NSString stringWithFormat:@"%@",[[obj objectForKey:@"dateUser"] objectForKey:@"name"]];
            [mulArr addObject:model];
        }];
        
        self.manager.calenderScrollView.Events =mulArr;
        
    } failure:^(NSError *error) {
        [self.manager.calenderScrollView.tableView.mj_header endRefreshing];
    }];
    
    
}

-(void)setupUI{
    self.navigationItem.title = @"约课";
    UIBarButtonItem *todayItem = [[UIBarButtonItem alloc] initWithTitle:@"TODAY" style:UIBarButtonItemStylePlain target:self action:@selector(todayItemClicked:)];
    todayItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = todayItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.manager = [LTSCalendarManager new];
    self.manager.eventSource = self;
    [LTSCalendarAppearance share].isShowLunarCalender = NO;
    [LTSCalendarAppearance share].firstWeekday = 2;
    self.manager.weekDayView = [[LTSCalendarWeekDayView alloc]initWithFrame:CGRectMake(LeftWidth, SafeAreaTopHeight, self.view.frame.size.width-LeftWidth, 20)];
    [self.view addSubview:self.manager.weekDayView];
    
    self.manager.calenderScrollView = [[LTSCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.manager.weekDayView.frame)-SafeAreaTopHeight+10)];
    @weakify(self)
    self.manager.calenderScrollView.addCurseBlock = ^(LTSCalendarDayItem *item) {
        @strongify(self)
        AddEventViewController *addVc =[[AddEventViewController alloc]init];
        addVc.item = item;
        addVc.hidesBottomBarWhenPushed = YES;
        addVc.ADDSUCCESSBLOCK = ^{
            [self.manager.calenderScrollView.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:addVc animated:YES];
    };
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.manager.calenderScrollView.tableView.mj_header = header;
    
    [self.view addSubview:self.manager.calenderScrollView];
    
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.view addSubview:self.monthLabel];
    
}


- (void)todayItemClicked:(id)sender
{
   [self.manager goBackToday];
}
-(void)calendarDidSelectedDate:(NSDate *)date{
    [self changeMonthWithDate:date];
}
- (void)calendarDidLoadPageCurrentDate:(NSDate *)date{
    [self changeMonthWithDate:date];
}

-(void)changeMonthWithDate:(NSDate *)date{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [LTSCalendarAppearance share].calendar.timeZone;
        [dateFormatter setDateFormat:@"MM"];
    }
    self.monthLabel.text = [NSString stringWithFormat:@"%@月",[dateFormatter stringFromDate:date]];
}

-(UILabel *)monthLabel{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, LeftWidth, 50)];
        _monthLabel.textColor = [UIColor redColor];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.numberOfLines = 0;
    }
    return _monthLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
