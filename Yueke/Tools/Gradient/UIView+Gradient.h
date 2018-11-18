//
//  UIView+Gradient.h
//  Yueke
//
//  Created by Lance on 2018/11/17.
//  Copyright © 2018 luoxuguang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Gradient)

- (void)setGradientLayer:(UIColor*)startColor endColor:(UIColor*)endColor;
-(void)insertTransparentGradientWithColors:(NSArray *)colors;
@end

NS_ASSUME_NONNULL_END
