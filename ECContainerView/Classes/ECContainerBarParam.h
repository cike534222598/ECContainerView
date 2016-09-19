//
//  ECContainerBarParam.h
//  ECContainerView
//
//  Created by Jame on 16/3/25.
//  Copyright © 2016年 Jame. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EC_ContainerTitlesArrKey      (@"ContainerTitlesArr")
#define EC_ContainerLaterTitlesArrKey (@"ContainerLaterTitlesArr")

#define ECCOLOR(r, g, b, a)             [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define PRINTFLOG(_NAME_,_CONTENT_) _CONTENT_ ? NSLog(@"*****%@*****\n{%@}",_NAME_,_CONTENT_): NSLog(@"*****%@*****",_NAME_)


@interface ECContainerBarParam : NSObject

@property (nonatomic , assign) BOOL             visableCursor;     //游标是否可见

@property (nonatomic , assign) BOOL             isHeaderLine;     //头部是否有横线

@property (nonatomic , assign) BOOL             isFootLine;       //底部是否有横线

@property (nonatomic , assign) BOOL             isSegmentLine;    //是否有分隔线

@property (nonatomic , assign) NSInteger        defaultFocusItem;  //默认选中项

@property (nonatomic , assign) NSInteger        mustSaveItemCount;  //必须保留的项数

@property (nonatomic , assign) CGFloat          focusFontSize;     //聚焦标题字体大小

@property (nonatomic , assign) CGFloat          fontSize;          //标题字体大小

@property (nonatomic , assign) CGFloat          cursorHeight;      //游标高度

@property (nonatomic , assign) CGFloat          segmentLineMargin; //分隔线与头部或者底部间距

@property (nonatomic , assign) CGFloat          lineWidth;         //线宽

@property (nonatomic , assign) CGFloat          cursorMargin;      //游标边距

@property (nonatomic , strong) UIColor        * itemBarNBackgroudColor;//选项正常背景颜色

@property (nonatomic , strong) UIColor        * itemBarSBackgroudColor;//选项选中背景颜色

@property (nonatomic , strong) UIColor        * cursorColor;       //游标颜色

@property (nonatomic , strong) UIColor        * headerLineColor;   //头部线颜色

@property (nonatomic , strong) UIColor        * segmentLineColor;  //分隔线颜色

@property (nonatomic , strong) UIColor        * footLineColor;     //底部线颜色

@property (nonatomic , strong) UIColor        * fontColor;         //字体颜色

@property (nonatomic , strong) UIColor        * focusFontColor;    //聚焦字体颜色

@property (nonatomic , strong) NSMutableArray * titlesArr;         //标题数组

@property (nonatomic , strong) NSMutableArray * laterTitlesArr;    //将添加的标题数组

@property (nonatomic, copy) NSString          * defaults;
                       //本地存储名称

@property (nonatomic, strong) UIView          *baseView;            //根视图

+ (ECContainerBarParam *)getECContainerViewParamWithBaseView:(UIView *)baseView titles:(NSMutableArray*)titlesArr laterTitlesArr:(NSMutableArray *)laterTitlesArr DefaultsKey:(NSString *)key;

@end
