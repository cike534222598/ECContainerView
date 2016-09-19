//
//  ECContainerBarParam.m
//  ECContainerView
//
//  Created by Jame on 16/3/25.
//  Copyright © 2016年 Jame. All rights reserved.
//

#import "ECContainerBarParam.h"
#import "ECContainerBar.h"

@implementation ECContainerBarParam

+ (ECContainerBarParam *)getECContainerViewParamWithBaseView:(UIView *)baseView titles:(NSMutableArray*)titlesArr laterTitlesArr:(NSMutableArray *)laterTitlesArr DefaultsKey:(NSString *)key{
    ECContainerBarParam  * param = [ECContainerBarParam new];
    if(titlesArr == nil){
        titlesArr =  [NSMutableArray new];
    }
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(dict && dict.count > 0){
        NSMutableArray  * tempTitlesArr = [dict[EC_ContainerTitlesArrKey] mutableCopy];
        NSMutableArray  * tempLaterTitlesArr = [dict[EC_ContainerLaterTitlesArrKey] mutableCopy];
        
        if(tempLaterTitlesArr.count + tempTitlesArr.count < titlesArr.count + laterTitlesArr.count){
            NSMutableString * strTempTitles = [NSMutableString new];
            NSMutableString * strTempLatertTitles = [NSMutableString new];
            for (NSString * txt in tempTitlesArr) {
                [strTempTitles appendString:txt];
            }
            for (NSString * txt in tempLaterTitlesArr) {
                [strTempLatertTitles appendString:txt];
            }
            for (NSString * txt in titlesArr) {
                if(![strTempTitles containsString:txt] && ![strTempLatertTitles containsString:txt]){
                    [tempLaterTitlesArr addObject:txt];
                }
            }
            for (NSString * txt in laterTitlesArr) {
                if(![strTempTitles containsString:txt] && ![strTempLatertTitles containsString:txt]){
                    [tempLaterTitlesArr addObject:txt];
                }
            }
            [ECContainerBar saveContainerBarTitlesArr:tempTitlesArr laterTitlesArr:tempLaterTitlesArr DefaultsKey:key];
        }
        param.titlesArr = [tempTitlesArr mutableCopy];
        param.laterTitlesArr = [tempLaterTitlesArr mutableCopy];
    }else{
        param.titlesArr = [titlesArr mutableCopy];
        param.laterTitlesArr = [laterTitlesArr mutableCopy];
    }
    
    param.defaults = key;
    param.baseView = baseView;
    param.mustSaveItemCount = 4;
    param.fontSize = 14.0;
    param.focusFontSize = 20.0;
    param.fontColor = [UIColor blackColor];
    param.focusFontColor = [UIColor redColor];
    param.itemBarNBackgroudColor = [UIColor colorWithWhite:230.0 / 255.0 alpha:1.0];
    param.itemBarSBackgroudColor = [UIColor whiteColor];
    param.visableCursor = NO;
    param.cursorMargin = 3.0;
    param.cursorColor = [UIColor orangeColor];
    param.cursorHeight = 3.0;
    param.defaultFocusItem = 0;
    param.isHeaderLine = NO;
    param.isFootLine = YES;
    param.headerLineColor = [UIColor clearColor];
    param.footLineColor = [UIColor blackColor];
    param.segmentLineColor = param.footLineColor;
    param.lineWidth = 0.5;
    param.isSegmentLine = YES;
    param.segmentLineMargin = 3.0;
    return param;
}

@end
