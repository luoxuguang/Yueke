//
//  BaseTabbarController.m
//  Yueke
//
//  Created by Lance on 2018/9/8.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "BaseTabbarController.h"
#import "BaseNavigationController.h"
#import "ViewController.h"
#import "StudentsViewController.h"


#define TabBarVC              @"vc"                //--tabbar对应的视图控制器
#define TabBarTitle           @"title"             //--tabbar标题
#define TabBarImage           @"image"             //--未选中时tabbar的图片
#define TabBarSelectedImage   @"selectedImage"     //--选中时tabbar的图片
#define TabBarItemBadgeValue  @"badgeValue"        //--未读个数
#define TabBarCount 2                              //--tabbarItem的个数

typedef NS_ENUM(NSInteger,TMTabType) {
    // --这里的顺序，决定了 tabbar 从左到右item的显示顺序
    TMTabTypeMessage,         //消息
    TMTabTypeDiscover,        //发现
    TMTabTypeContacts,        //联系人
    TMTabTypeMine,            //我的
};

@interface BaseTabbarController ()

@property (nonatomic, strong)  NSDictionary *configs;

@end

@implementation BaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubNav];
    
}


- (NSArray*)tabbars{
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSInteger tabbar = 0; tabbar < TabBarCount; tabbar++) {
        [items addObject:@(tabbar)];
    }
    return items;
}

- (void)setUpSubNav {
    
    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
    [self.tabbars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * item =[self vcInfoForTabType:[obj integerValue]];
        NSString *vcName = item[TabBarVC];
        NSString *title  = item[TabBarTitle];
        NSString *imageName = item[TabBarImage];
        NSString *imageSelected = item[TabBarSelectedImage];
        Class clazz = NSClassFromString(vcName);
        UIViewController *vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = NO;
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[UIImage imageNamed:imageName]
                                               selectedImage:[[UIImage imageNamed:imageSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        nav.tabBarItem.tag = idx;
        NSInteger badge = [item[TabBarItemBadgeValue] integerValue];
        if (badge) {
            nav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",badge];
        }
        
        [[UITabBar appearance] setTintColor:[UIColor colorWithHex:0x6a82da]]; // 设置TabBar上 字体颜色
        
        [vcArray addObject:nav];
    }];
    self.viewControllers = [NSArray arrayWithArray:vcArray];
    
}

#pragma mark - VC
- (NSDictionary *)vcInfoForTabType:(TMTabType)type{
    
    if (_configs == nil)
    {
        _configs = @{
                     @(TMTabTypeMessage) : @{
                             TabBarVC           : @"ViewController",
                             TabBarTitle        : @"约课",
                             TabBarImage        : @"date",
                             TabBarSelectedImage: @"date_selected",
                             TabBarItemBadgeValue: @(0)
                             },
                     @(TMTabTypeDiscover)     : @{
                             TabBarVC           : @"StudentsViewController",
                             TabBarTitle        : @"学员",
                             TabBarImage        : @"xueyuan",
                             TabBarSelectedImage: @"xueyuan_selected",
                             TabBarItemBadgeValue: @(0)
                             }
                     };
        
    }
    return _configs[@(type)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
