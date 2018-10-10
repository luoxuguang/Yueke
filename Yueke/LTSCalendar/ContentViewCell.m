//
//  ContentViewCell.m
//  SheetViewDemo
//
//  Created by Mengmin Duan on 2017/7/20.
//  Copyright © 2017年 Mengmin Duan. All rights reserved.
//

#import "ContentViewCell.h"

#import "EventModel.h"

@interface ContentViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@end
@implementation ContentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.cellCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        self.cellCollectionView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            self.cellCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
        } else {
            // Fallback on earlier versions
        }

        self.cellCollectionView.backgroundColor = [UIColor whiteColor];
        [self.cellCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"inner.cell"];
        self.cellCollectionView.dataSource = self;
        self.cellCollectionView.delegate = self;
        
        [self.contentView addSubview:self.cellCollectionView];
    }
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.contentViewCellDidScrollBlock) {
        self.contentViewCellDidScrollBlock(scrollView);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.contentViewCellDidEndDeceleratingBlock) {
        self.contentViewCellDidEndDeceleratingBlock(scrollView);
    }
}

#pragma mark -- UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return NUMBER_PAGES_LOADED;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (CGSize)collectionView:(UICollectionView *)uiCollectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width/7, 30);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *innerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"inner.cell" forIndexPath:indexPath];
    if (innerCell) {
        for (UIView *view in innerCell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    CGFloat width = self.frame.size.width/7;
    CGFloat height = 28;
    CGRect rect = CGRectMake(0, 0, width, height);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:11.0];
    label.textAlignment = NSTextAlignmentCenter;
    [innerCell.contentView addSubview:label];
    LTSCalendarDayItem *item = self.daysInWeeks[indexPath.section][indexPath.row];
    
    innerCell.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
    innerCell.layer.borderColor = [UIColor whiteColor].CGColor;
    innerCell.layer.borderWidth = 1;
    
    if ([[YKTool getTimeWithStr:@"YYYY-MMM-DD" Date:item.date] isEqualToString:[YKTool getTimeWithStr:@"YYYY-MMM-DD" Date:[NSDate date]]]) {
        innerCell.backgroundColor = [UIColor colorWithHex:0xccdff1];
    }
    [self.Events enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EventModel *model = (EventModel *)obj;
        
        if ([[YKTool getYMDWithdate:model.startDate] isEqualToString: [YKTool getYMDWithdate:item.date]]) {
            NSInteger min = 0;
            NSInteger max = 0;
            if ([YKTool getMinWithdate:model.startDate] >=30) {
                min = ([YKTool getHourWithdate:model.startDate]-9)*2+1;
            }else{
                min = ([YKTool getHourWithdate:model.startDate]-9)*2;
            }
            if ([YKTool getMinWithdate:model.endDate] >=30) {
                max = ([YKTool getHourWithdate:model.endDate]-9)*2;
            }else{
                max = ([YKTool getHourWithdate:model.endDate]-9)*2-1;
            }
            if (self.CellNum>=min&&self.CellNum<=max) {
                innerCell.backgroundColor = [UIColor redColor];
                label.text = model.username;
            }
        }
        
    }];
    
    
    
    return innerCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LTSCalendarDayItem *item = self.daysInWeeks[indexPath.section][indexPath.row];
    if (self.cellDidSelectBlock) {
        self.cellDidSelectBlock(item);
    }
}



@end
