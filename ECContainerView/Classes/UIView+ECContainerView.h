//
//  UIView+ECContainerView.h
//  weizhiMobile
//
//  Created by Jame on 16/3/25.
//  Copyright © 2016年 中良 赵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ECContainerView)

- (CGFloat)y;

- (CGFloat)centerY;

- (CGFloat)centerX;

- (CGFloat)maxY;

- (CGFloat)x;

- (CGFloat)maxX;

- (CGPoint)xy;

- (CGFloat)width;

- (CGFloat)height;

- (CGSize)size;

- (void)setY:(CGFloat)Y;

- (void)setX:(CGFloat)X;

- (void)setCenterX:(CGFloat)centerX;

- (void)setCenterY:(CGFloat)centerY;

- (void)setXy:(CGPoint)point;

- (void)setSize:(CGSize)size;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

@end
