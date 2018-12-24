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
#import "UIViewController+CWLateralSlide.h"
#import "LeftViewController.h"
#import "UIButton+Gradient.h"
#import "UIView+Gradient.h"

@interface ViewController ()<LTSCalendarEventSource>


@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;
@property (nonatomic) BOOL isWeek;
@property (nonatomic,strong)LTSCalendarManager *manager;
@property (nonatomic,strong)UILabel *monthLabel;
@property (nonatomic,strong) LeftViewController *leftVC; // 强引用，可以避免每次显示抽屉都去创建
@property (nonatomic) BOOL isShowLeft;
@property (nonatomic,strong) UIView *bottomView;


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
    self.isShowLeft = !self.isShowLeft;
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

    UIBarButtonItem *todayItem = [[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(todayItemClicked:)];
    todayItem.tintColor = [UIColor blackColor];
    [todayItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0x333333], NSForegroundColorAttributeName,[UIFont systemFontOfSize:14.0],NSFontAttributeName,nil] forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = todayItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.manager = [LTSCalendarManager new];
    self.manager.eventSource = self;
    [LTSCalendarAppearance share].isShowLunarCalender = NO;
    [LTSCalendarAppearance share].firstWeekday = 2;
    self.manager.weekDayView = [[LTSCalendarWeekDayView alloc]initWithFrame:CGRectMake(LeftWidth, SafeAreaTopHeight, self.view.frame.size.width-LeftWidth, 20)];
    [self.view addSubview:self.manager.weekDayView];
    
    self.manager.calenderScrollView = [[LTSCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame), ScreenHeight-CGRectGetMaxY(self.manager.weekDayView.frame))];
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
    self.manager.calenderScrollView.showAddBtn = ^{
        [UIView animateWithDuration:1 animations:^{
            weak_self.bottomView.hidden = YES;
        }];
    };
    self.manager.calenderScrollView.hiddenAddBtn = ^{
        [UIView animateWithDuration:1 animations:^{
            weak_self.bottomView.hidden = NO;
        }];
    };
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.manager.calenderScrollView.tableView.mj_header = header;
    
    [self.view addSubview:self.manager.calenderScrollView];
    
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.view addSubview:self.monthLabel];
    
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor clearColor];
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.manager.calenderScrollView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(144);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
//    UIImage *image = [[UIImage alloc]init];
//    [image createImageWithSize:CGSizeMake(bottomView.frame.size.width,bottomView.frame.size.height ) gradientColors:@[(id)RGB(165, 255, 214,1),(id)RGB(55, 223, 189, 1),(id)RGB(31, 199, 211, 1),(id)RGB(8, 174, 234,1)]  percentage:@[@(0.0),@(1)] gradientType:GradientFromTopToBottom];
//    bottomView.image = image;
//
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake((ScreenWidth-64)/2, 20, 64, 64);
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 64/2;
    addBtn.layer.shouldRasterize = YES;
    addBtn.layer.shadowColor = RGB(3, 99, 166, 1).CGColor;
    addBtn.layer.shadowOffset = CGSizeMake(2, 2);
    [addBtn addTarget:self action:@selector(addCourse) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTintColor:[UIColor whiteColor]];
    [addBtn gradientButtonWithSize:CGSizeMake(64, 64) colorArray:@[(id)RGB(165, 255, 214,1),(id)RGB(55, 223, 189, 1),(id)RGB(31, 199, 211, 1),(id)RGB(8, 174, 234,1)] percentageArray:@[@(0.0),@(1)] gradientType:GradientFromLeftBottomToRightTop];
    [addBtn setImage:[UIImage imageNamed:@"iconfont_添加"] forState:UIControlStateNormal];
    [bottomView addSubview:addBtn];
    
//    UIImage *image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e627", 30, [UIColor whiteColor])];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(30, 30, 40, 40);
    menuBtn.layer.masksToBounds = YES;
    menuBtn.layer.cornerRadius = 40/2;
    [menuBtn setBackgroundColor:[UIColor colorWithHex:0xC9D1D1]];
    [menuBtn setTintColor:[UIColor whiteColor]];
    [menuBtn setImage:[UIImage imageNamed:@"iconfont_菜单"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(defaultAnimationFromLeft) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:menuBtn];
    
}

-(void)addCourse{
    AddEventViewController *addVc =[[AddEventViewController alloc]init];
    EventModel *model = [[EventModel alloc]init];
    model.startDate = [NSDate date];
    addVc.model = model;
    addVc.hidesBottomBarWhenPushed = YES;
    addVc.ADDSUCCESSBLOCK = ^{
        [self.manager.calenderScrollView.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:addVc animated:YES];
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
        _monthLabel.textColor = [UIColor colorWithHex:0x333333];
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
