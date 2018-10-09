//
//  AddEventViewController.h
//  Yueke
//
//  Created by luo on 2018/9/28.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCalendarDayItem.h"
@interface AddEventViewController : UIViewController

@property (nonatomic,strong) LTSCalendarDayItem *item;
@property (nonatomic,copy) void (^ADDSUCCESSBLOCK)(void);
@end
