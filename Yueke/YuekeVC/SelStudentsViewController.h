//
//  SelStudentsViewController.h
//  Yueke
//
//  Created by luo on 2018/9/28.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelStudentsViewController : UIViewController

@property (nonatomic,strong)NSArray *students;
@property (nonatomic,copy) void(^SelectBlock)(NSString *name);

@end
