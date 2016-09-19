//
//  ECContainerView.h
//  ECContainerView
//
//  Created by Jame on 16/3/25.
//  Copyright © 2016年 Jame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECContainerBar.h"

@class ECContainerView;

@protocol  ECContainerViewDelegate <NSObject>

@required

- (void)ECContainerView:(ECContainerView *)containerView loadContentForCurrentIndexTitle:(NSString *)title currentIndex:(NSInteger)index;

@end


@interface ECContainerView : UIView

@property (nonatomic , assign) id<ECContainerViewDelegate> delegate;
@property (nonatomic , copy) NSArray *selectTitleArray;

- (instancetype)initWithFrame:(CGRect)frame param:(ECContainerBarParam *)param;

+ (void)saveContainerBarTitlesArr:(NSArray *)titlesArr laterTitlesArr:(NSArray *)laterTitlesArr DefaultsKey:(NSString *)key;

//读取缓存中要显示的标题组
+ (NSArray *)readContainerBarTitlesArrWithDefaultsKey:(NSString *)key;
//读取缓存中待显示的标题组
+ (NSArray *)readContainerBarLaterTitlesArrWithDefaultsKey:(NSString *)key;


@end
