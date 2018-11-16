//
//  LeftViewCell.h
//  Yueke
//
//  Created by luo on 2018/11/16.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

-(void)showWithDic:(NSDictionary *)dic;

@end

