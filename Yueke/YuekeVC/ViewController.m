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
#import <UIViewController+CWLateralSlide.h>
#import "LeftViewController.h"

@interface ViewController ()<LTSCalendarEventSource>


@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;
@property (nonatomic) BOOL isWeek;
@property (nonatomic,strong)LTSCalendarManager *manager;
@property (nonatomic,strong)UILabel *monthLabel;
@property (nonatomic,strong) LeftViewController *leftVC; // 强引用，可以避免每次显示抽屉都去创建

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    self.view.backgroundColor = [UIColor  whiteColor];
    
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    [self cw_registerShowIntractiveWithEdgeGesture:NO transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        if (direction == CWDrawerTransitionFromLeft) { // 左侧滑出
             [weakSelf defaultAnimationFromLeft];
        }
    }];
    
    [self.manager.calenderScrollView.tableView.mj_header beginRefreshing];
}
// 仿QQ从左侧划出
- (void)defaultAnimationFromLeft {
    
    // 强引用leftVC，不用每次创建新的,也可以每次在这里创建leftVC，抽屉收起的时候会释放掉
    [self cw_showDefaultDrawerViewController:self.leftVC];
}
-(void)requestData{
    [MBProgressHUD showMessage:@"正在加载数据..." toView:self.view];
    NSDictionary *param = @{@"token":user_token,@"state":@"0"};
    [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_allCourse] parameters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.manager.calenderScrollView.tableView.mj_header endRefreshing];
        NSMutableArray *mulArr = [[NSMutableArray alloc]init];
        [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EventModel *model = [[EventModel alloc]init];
            model.startDate = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",[obj objectForKey:@"startDate"]] longLongValue]/1000];
            model.endDate = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",[obj objectForKey:@"endDate"]] longLongValue]/1000];
            model.storeName = [NSString stringWithFormat:@"%@",[[[obj objectForKey:@"dateCollege"] objectForKey:@"collegename"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            model.courseName = [NSString stringWithFormat:@"%@",[[obj objectForKey:@"name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            model.storeId = [NSString stringWithFormat:@"%@",[[obj objectForKey:@"dateCollege"] objectForKey:@"fid"]];
            model.userId = [NSString stringWithFormat:@"%@",[[obj objectForKey:@"dateUser"] objectForKey:@"fid"]];
            model.relid = [NSString stringWithFormat:@"%@",[obj objectForKey:@"relid"]];
            model.username = [NSString stringWithFormat:@"%@",[[[obj objectForKey:@"dateUser"] objectForKey:@"name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [mulArr addObject:model];
        }];
        
        self.manager.calenderScrollView.Events =mulArr;
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
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
    self.manager.calenderScrollView.addCurseBlock = ^(id model) {
        @strongify(self)
        AddEventViewController *addVc =[[AddEventViewController alloc]init];
        addVc.model = model;
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
- (LeftViewController *)leftVC {
    if (_leftVC == nil) {
        _leftVC = [LeftViewController new];
    }
    return _leftVC;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
