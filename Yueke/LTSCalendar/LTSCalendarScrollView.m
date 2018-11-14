//
//  LTSCalendarScrollView.m
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/13.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import "LTSCalendarScrollView.h"
#import "ContentViewCell.h"

static NSString *contentViewCellId = @"content.tableview.cell";

@interface LTSCalendarScrollView()<UITableViewDelegate,UITableViewDataSource,LTSCalendarEventSource>

@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end
@implementation LTSCalendarScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
    self.tableView.backgroundColor = bgColor;
    self.leftTableView.backgroundColor = bgColor;
    self.line.backgroundColor = bgColor;
}

- (void)initUI{
    self.delegate = self;
    self.bounces = false;
    self.showsVerticalScrollIndicator = false;
    self.backgroundColor = [LTSCalendarAppearance share].scrollBgcolor;
    LTSCalendarContentView *calendarView = [[LTSCalendarContentView alloc]initWithFrame:CGRectMake(LeftWidth, 0, self.frame.size.width-LeftWidth, [LTSCalendarAppearance share].weekDayHeight*[LTSCalendarAppearance share].weeksToDisplay)];
    calendarView.CollectionViewScrollBlock = ^(UIScrollView *scrollView) {
        if ([scrollView isKindOfClass:[UICollectionView class]]) {
//            [self.tableView reloadData];
            for (ContentViewCell *cell in self.tableView.visibleCells) {
                cell.cellCollectionView.contentOffset = scrollView.contentOffset;
            }
        }
    };
    calendarView.CollectionViewEndScrollBlock = ^(UIScrollView *scrollView) {
        [self.tableView reloadData];
    };
    calendarView.eventSource = self;
    calendarView.currentDate = [NSDate date];
    [self addSubview:calendarView];
    self.calendarView = calendarView;
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame),0.5)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(LeftWidth, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame)-LeftWidth, CGRectGetHeight(self.frame)-CGRectGetMaxY(calendarView.frame)-200)];
    self.tableView.backgroundColor = self.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.scrollEnabled = [LTSCalendarAppearance share].isShowSingleWeek;
    
    [self addSubview:self.tableView];
    
    
    self.leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), LeftWidth, CGRectGetHeight(self.frame)-CGRectGetMaxY(calendarView.frame)-200)];
    self.leftTableView.backgroundColor = self.backgroundColor;
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftTableView.estimatedRowHeight = 0;
    self.leftTableView.estimatedSectionHeaderHeight = 0;
    self.leftTableView.estimatedSectionFooterHeight = 0;
    self.leftTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.leftTableView.scrollEnabled = [LTSCalendarAppearance share].isShowSingleWeek;
    
    [self addSubview:self.leftTableView];
    
    self.line.backgroundColor = self.backgroundColor;
    [self addSubview:self.line];
    [LTSCalendarAppearance share].isShowSingleWeek ? [self scrollToSingleWeek]:[self scrollToAllWeek];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[UITableViewCell new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView == self.tableView) {
        ContentViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:contentViewCellId];
        if (contentCell == nil)
        {
            contentCell = [[ContentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentViewCellId];
            contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        contentCell.daysInMonth = self.calendarView.daysInMonth;
        contentCell.daysInWeeks = self.calendarView.daysInWeeks;
        contentCell.currentSelectedIndexPath  = self.calendarView.currentSelectedIndexPath;
        contentCell.currentMonthIndex = self.calendarView.currentMonthIndex;
        contentCell.Events = self.Events;
        contentCell.CellNum = indexPath.row;
        
        
        contentCell.contentViewCellDidScrollBlock = ^(UIScrollView *scroll) {
            for (ContentViewCell *cell in self.tableView.visibleCells) {
                cell.cellCollectionView.contentOffset = scroll.contentOffset;
            }
            self.calendarView.collectionView.contentOffset = scroll.contentOffset;
        };
        contentCell.cellDidSelectBlock = ^(EventModel *model) {
            if (self.addCurseBlock) {
                self.addCurseBlock(model);
            }
        };
        contentCell.contentViewCellDidEndDeceleratingBlock = ^(UIScrollView *scroll) {
            [self.calendarView updatePageWithNewDate:YES];
        };
        
        contentCell.backgroundColor = [UIColor whiteColor];
        contentCell.cellCollectionView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 30);
        [contentCell.cellCollectionView reloadData];
        
        return contentCell;
        
    }else{
        if (indexPath.row%2==0) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LeftWidth, 13)];
            label.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font =[UIFont systemFontOfSize:13.0];
            [cell.contentView addSubview:label];
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==1) {
        return 32;
    }
    return 30;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.leftTableView) {
        return;
    }
    ContentViewCell *willDisplayCell = (ContentViewCell *)cell;
    ContentViewCell *didDisplayCell = (ContentViewCell *)[tableView.visibleCells firstObject];
    if (willDisplayCell.cellCollectionView && didDisplayCell.cellCollectionView && willDisplayCell.cellCollectionView.contentOffset.x != didDisplayCell.cellCollectionView.contentOffset.x) {
        willDisplayCell.cellCollectionView.contentOffset = didDisplayCell.cellCollectionView.contentOffset;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    if (scrollView != self) {
        if (scrollView == self.tableView) {
            self.leftTableView.contentOffset = self.tableView.contentOffset;
        }
        if (scrollView == self.leftTableView) {
            self.tableView.contentOffset = self.leftTableView.contentOffset;
        }
        return;
    }
  
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    ///日历需要滑动的距离
    CGFloat calendarCountDistance = self.calendarView.singleWeekOffsetY;
    
    CGFloat scale = calendarCountDistance/tableCountDistance;
    
    CGRect calendarFrame = self.calendarView.frame;
    self.calendarView.maskView.alpha = offsetY/tableCountDistance;
    self.calendarView.maskView.hidden = false;
    calendarFrame.origin.y = offsetY-offsetY*scale;
    if(ABS(offsetY) >= tableCountDistance) {
        self.leftTableView.scrollEnabled = YES;
         self.tableView.scrollEnabled = true;
        self.calendarView.maskView.hidden = true;
        //为了使滑动更加顺滑，这部操作根据 手指的操作去设置
//         [self.calendarView setSingleWeek:true];
        
    }else{
        self.leftTableView.scrollEnabled = NO;
        self.tableView.scrollEnabled = false;
        if ([LTSCalendarAppearance share].isShowSingleWeek) {
           
            [self.calendarView setSingleWeek:false];
        }
    }
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame)+offsetY;
    self.tableView.frame = tableFrame;
    
    CGRect leftTableFrame = self.leftTableView.frame;
    leftTableFrame.size.height = tableFrame.size.height;
    self.leftTableView.frame = leftTableFrame;
    
    self.bounces = false;
    if (offsetY<=0) {
        self.bounces = true;
        calendarFrame.origin.y = offsetY;
        tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame);
        leftTableFrame.size.height = tableFrame.size.height;
        self.leftTableView.frame = leftTableFrame;
        self.tableView.frame = tableFrame;
    }
    self.calendarView.frame = calendarFrame;
    
    
    
    
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    if ( appearce.isShowSingleWeek) {
        if (self.contentOffset.y != tableCountDistance) {
            return  nil;
        }
    }
    if ( !appearce.isShowSingleWeek) {
        if (self.contentOffset.y != 0 ) {
            return  nil;
        }
    }

    return  [super hitTest:point withEvent:event];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);

    if (scrollView.contentOffset.y>=tableCountDistance) {
        [self.calendarView setSingleWeek:true];
    }
    
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
   
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    if (point.y<=0) {
       
        [self scrollToSingleWeek];
    }
    
    if (scrollView.contentOffset.y<tableCountDistance-20&&point.y>0) {
        [self scrollToAllWeek];
    }
}
//手指触摸完
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self != scrollView) {
        return;
    }
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    
    if (point.y<=0) {
        if (scrollView.contentOffset.y>=20) {
            if (scrollView.contentOffset.y>=tableCountDistance) {
                [self.calendarView setSingleWeek:true];
            }
            [self scrollToSingleWeek];
        }else{
            [self scrollToAllWeek];
        }
    }else{
        if (scrollView.contentOffset.y<tableCountDistance-20) {
            [self scrollToAllWeek];
        }else{
            [self scrollToSingleWeek];
        }
    }
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
     [self.calendarView setUpVisualRegion];
}


- (void)scrollToSingleWeek{
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    [self setContentOffset:CGPointMake(0, tableCountDistance) animated:true];
}

- (void)scrollToAllWeek{
    [self setContentOffset:CGPointMake(0, 0) animated:true];

}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentSize = CGSizeMake(0, CGRectGetHeight(self.frame)+[LTSCalendarAppearance share].weekDayHeight*([LTSCalendarAppearance share].weeksToDisplay-1));
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithObjects:@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00", nil];
    }
    return _dataArr;
}

-(void)setEvents:(NSArray *)Events{
    _Events = Events;
    [self.tableView reloadData];
}
@end
