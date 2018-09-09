//
//  TimeCell.m
//  Yueke
//
//  Created by Lance on 2018/9/9.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//



#import "TimeCell.h"

@interface TimeCell()

@property (nonatomic,strong) UILabel *titleLabel ;

@end

@implementation TimeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addsSubViews];
    }
    return self;
}

-(void)addsSubViews{
    
    [self addSubview:self.titleLabel];
    CGFloat itemWidth = (ScreenWidth-50)/7;
    for (NSInteger i = 0; i<7; i++) {
        UIView *subView = [[UIView alloc]init];
        subView.frame = CGRectMake(itemWidth+i*itemWidth, 0, itemWidth, 60);
        if (i%2==0) {
            subView.backgroundColor = [UIColor darkGrayColor];
        }
        [self addSubview:subView];
    }
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 60)];
        _titleLabel.textColor = [UIColor colorWithHex:0x333];
    }
    return _titleLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
