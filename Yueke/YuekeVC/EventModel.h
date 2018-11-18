//
//  EventModel.h
//  Yueke
//
//  Created by luo on 2018/9/13.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventModel : NSObject

@property (nonatomic,strong) NSDate *startDate; //开始时间
@property (nonatomic,strong) NSDate *endDate; //结束时间
@property (nonatomic,copy) NSString *storeName; //门店名字
@property (nonatomic,copy) NSString *courseName; //门店名字
@property (nonatomic,copy) NSString *storeId; //门店id
@property (nonatomic,copy) NSString *userId; //学员id
@property (nonatomic,copy) NSString *fid; //约课id
@property (nonatomic,copy) NSString *relid; //修改删除课程时使用
@property (nonatomic,copy) NSString *username; //学员的名字

@property (nonatomic) NSInteger cellNum; //方便约课时使用

@property (nonatomic) BOOL isShowName;
@end
