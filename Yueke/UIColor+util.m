//
//  UIColor+util.m
//  Yueke
//
//  Created by Lance on 2018/9/8.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "UIColor+util.h"

@implementation UIColor (util)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha

{
    
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
            
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
            
                            blue:((float)(hexValue & 0xFF))/255.0
            
                           alpha:alpha];
    
}



+ (UIColor *)colorWithHex:(int)hexValue

{
    
    return [UIColor colorWithHex:hexValue alpha:1.0];
    
}

@end
