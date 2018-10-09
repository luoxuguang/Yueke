//
//  AddStudentVC.h
//  Yueke
//
//  Created by luo on 2018/9/19.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddStudentVC : UIViewController

@property (nonatomic,copy) void (^AddSuccessBlock)(void);

@property (nonatomic) NSInteger addType;


@end
