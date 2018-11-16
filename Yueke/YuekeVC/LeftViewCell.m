//
//  LeftViewCell.m
//  Yueke
//
//  Created by luo on 2018/11/16.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "LeftViewCell.h"

@implementation LeftViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

-(void)showWithDic:(NSDictionary *)dic{
    self.imageView.image  = [UIImage iconWithInfo:[dic objectForKey:@"icon"]];
    self.nameLabel.text = [dic objectForKey:@"name"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
