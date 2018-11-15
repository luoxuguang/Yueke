//
//  ContentViewCell.h
//  SheetViewDemo
//
//  Created by Mengmin Duan on 2017/7/20.
//  Copyright © 2017年 Mengmin Duan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCalendarDayItem.h"
#import "EventModel.h"
#import "LTSCalendarContentView.h"
typedef NSString *(^cellForItemAtIndexPathBlock)(NSIndexPath *indexPath);
typedef NSInteger(^numberOfItemsInSectionBlock)(NSInteger section);
typedef CGSize(^sizeForItemAtIndexPathBlock)(UICollectionViewLayout * collectionViewLayout, NSIndexPath *indexPath);
typedef void(^ContentViewCellDidScrollBlock)(UIScrollView *scroll);
typedef void(^ContentViewCellDidEndDeceleratingBlock)(UIScrollView *scroll);
typedef BOOL(^cellWithColorAtIndexPathBlock)(NSIndexPath *indexPath);
typedef void(^didSelectItemBlock)(EventModel *model);

@interface ContentViewCell : UITableViewCell

@property (nonatomic, strong) cellForItemAtIndexPathBlock cellForItemBlock;
@property (nonatomic, strong) numberOfItemsInSectionBlock numberOfItemsBlock;
@property (nonatomic, strong) sizeForItemAtIndexPathBlock sizeForItemBlock;
@property (nonatomic, strong) ContentViewCellDidScrollBlock contentViewCellDidScrollBlock;
@property (nonatomic, strong) ContentViewCellDidEndDeceleratingBlock contentViewCellDidEndDeceleratingBlock;
@property (nonatomic, strong) cellWithColorAtIndexPathBlock cellWithColorBlock;
@property (nonatomic, strong) didSelectItemBlock cellDidSelectBlock;

@property (nonatomic, strong) UICollectionView *cellCollectionView;
@property (nonatomic,strong)LTSCalendarContentView *calendarView;

@property (nonatomic,assign)NSInteger currentMonthIndex;
@property (nonatomic,strong)NSArray *daysInMonth;
@property (nonatomic,strong)NSArray *daysInWeeks;
@property (nonatomic,strong)NSIndexPath *currentSelectedIndexPath;
@property (nonatomic,strong) NSArray *Events;

@property (nonatomic,assign) NSInteger CellNum;

@end
