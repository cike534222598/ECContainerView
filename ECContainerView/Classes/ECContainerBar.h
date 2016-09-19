//
//  ECContainerBar.h
//  ECContainerView
//
//  Created by Jame on 16/3/25.
//  Copyright © 2016年 Jame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECContainerBarParam.h"
#import "ECContainerBarItem.h"

@class ECContainerBar;

@protocol  ECContainerBarDelegate<NSObject>

@required

- (void)ECContainerBar:(ECContainerBar *)containerBar clickIndex:(NSInteger)index animated:(BOOL)animated;
@optional
- (void)ECContainerBar:(ECContainerBar *)containerBar clickDrop:(UIButton*)sender;

@end

@interface ECContainerBar : UIView

@property (nonatomic , assign)id <ECContainerBarDelegate>  delegate;

- (instancetype)initWithFrame:(CGRect)frame param:(ECContainerBarParam*)param;

- (void)beginDynamicChangeStateOffsetX:(CGFloat)offsetX pageIndex:(NSInteger)pageIndex oriX:(CGFloat)oriX;

- (void)dynamicChangeStateOffsetX:(CGFloat)offsetX oriX:(CGFloat)oriX;

- (void)endDynamicChangeStateOffsetX:(CGFloat)offsetX currentPageIndex:(NSInteger)currentPageIndex;

- (void)rotateDropBtnDuring:(CGFloat)during;

- (void)updateContainer;

- (void)updateContainerClickIndex:(NSInteger)index;

+ (void)saveContainerBarTitlesArr:(NSArray *)titlesArr laterTitlesArr:(NSArray *)laterTitlesArr DefaultsKey:(NSString *)key;


@end
