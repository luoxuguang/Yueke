//
//  HeadView.m
//  Yueke
//
//  Created by luo on 2018/11/23.
//  Copyright © 2018 luoxuguang. All rights reserved.
//

#import "HeadView.h"
#import "headCell.h"

static NSString *cellId = @"headCell";

@interface HeadView() <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UILabel *monthLabel;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation HeadView

#pragma mark  sys

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

-(void)layoutSubviews{
    self.monthLabel.frame = CGRectMake(0, 0, 60, self.frame.size.height);
    self.collectionView.frame  = CGRectMake(60, 0, self.frame.size.width, self.frame.size.height);
}

-(void)reloadData{
    [self.collectionView reloadData];
}

#pragma mark -- func

-(void)addSubviews{
    [self addSubview:self.monthLabel];
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([headCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId];
}

#pragma mark --- datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    headCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)uiCollectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

#pragma mark --  lazy

-(UILabel *)monthLabel{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc]init];
        _monthLabel.text  = @"11";
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.font = [UIFont systemFontOfSize:15.0];
        _monthLabel.textColor = [UIColor redColor];
    }
    return _monthLabel;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = layout.minimumInteritemSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        
    }
    return _collectionView;
}




@end
