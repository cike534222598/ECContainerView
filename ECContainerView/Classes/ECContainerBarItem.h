//
//  ECContainerBarItem.h
//  ECContainerView
//
//  Created by Jame on 16/3/25.
//  Copyright © 2016年 Jame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ECContainerView.h"

#define EC_DropBtn_Width (50.0)     //下拉按钮的宽度

typedef enum _ECBarItemStyle{
    TITLE_SHOW,               //首页展示类型
    EDIT_SHOW,                //编辑展示类型
    ADD_SHOW                  //编辑添加展示类型
}ECBarItemStyle;

@class ECContainerBarItem;

@protocol ECContainerBarItemDelegate <NSObject>

@optional
- (void)ECContainerBarItem:(ECContainerBarItem*)barItem clickIndex:(NSInteger)index animated:(BOOL)animated;

- (void)ECContainerBarItem:(ECContainerBarItem *)barItem clickDeleteBtn:(UIButton*)sender index:(NSInteger)index;

@end


@interface ECContainerBarItem : UIView

@property (nonatomic , assign)   id <ECContainerBarItemDelegate>delegate;

@property (nonatomic , strong)   NSString  * title;                 //标题
@property (nonatomic , assign)   NSInteger   index;                 //下标
@property (nonatomic , assign)   CGFloat     normalFontSize;        //正常字体大小
@property (nonatomic , assign)   CGFloat     selectedFontSize;      //选择时字体大小
@property (nonatomic , strong)   UIColor   * normalTitleColor;      //正常标题颜色
@property (nonatomic , strong)   UIColor   * selectedTitleColor;    //选择标题颜色
@property (nonatomic , strong)   UIColor   * normalBackgroundColor; //正常背景颜色
@property (nonatomic , strong)   UIColor   * selectedBackgroundColor;//选择背景颜色

@property (nonatomic , assign)   BOOL        selected;

- (instancetype)initWithFrame:(CGRect)frame Style:(ECBarItemStyle)style;

- (void)dynamicChangeBackgroudColor:(UIColor *)color;

- (void)dynamicChangeTextColor:(UIColor *)color;

- (void)dynamicChangeTextSize:(UIFont *)font;

- (void)setItemStyle:(ECBarItemStyle)style;

- (void)startEdit;

- (void)stopEdit;

@end
