//
//  TimeCell.h
//  Yueke
//
//  Created by Lance on 2018/9/9.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic,copy) NSString *title;

@end
