//
//  AppDelegate.h
//  Yueke
//
//  Created by Lance on 2018/9/7.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

