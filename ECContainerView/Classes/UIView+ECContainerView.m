//
//  UIView+ECContainerView.m
//  weizhiMobile
//
//  Created by Jame on 16/3/25.
//  Copyright © 2016年 中良 赵. All rights reserved.
//

#import "UIView+ECContainerView.h"

@implementation UIView (ECContainerView)

- (CGFloat)y{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)maxY{
    return self.y + self.height;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint  center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint  center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)x{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)maxX{
    return self.x + self.width;
}

- (CGPoint)xy{
    return CGPointMake(self.x, self.y);
}

- (CGFloat)width{
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height{
    return CGRectGetHeight(self.frame);
}

- (CGSize)size{
    return CGSizeMake(self.width, self.height);
}

- (void)setY:(CGFloat)Y{
    CGRect   rc = self.frame;
    rc.origin.y = Y;
    self.frame = rc;
}

- (void)setX:(CGFloat)X{
    CGRect   rc = self.frame;
    rc.origin.x = X;
    self.frame = rc;
}

- (void)setXy:(CGPoint)point{
    CGRect   rc = self.frame;
    rc.origin = point;
    self.frame = rc;
}

- (void)setSize:(CGSize)size{
    CGRect   rc = self.frame;
    rc.size = size;
    self.frame = rc;
}

- (void)setWidth:(CGFloat)width{
    CGRect   rc = self.frame;
    rc.size.width = width;
    self.frame = rc;
}

- (void)setHeight:(CGFloat)height{
    CGRect   rc = self.frame;
    rc.size.height = height;
    self.frame = rc;
}

@end
