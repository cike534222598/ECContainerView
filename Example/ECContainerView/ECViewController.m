//
//  ECViewController.m
//  ECContainerView
//
//  Created by Jame on 09/19/2016.
//  Copyright (c) 2016 Jame. All rights reserved.
//

#import "ECViewController.h"
#import "ECContainerView.h"

@interface ECViewController () <ECContainerViewDelegate>

@end

@implementation ECViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self creatContainerView];
}


#pragma mark ------CREATVIEW------
- (void)creatContainerView
{
    CGRect  containerViewRC = {0.0,20.0,self.view.width,self.view.height - 20.0};
    
    NSArray *titles = @[@"全部通知",@"系统通知",@"社交通知",@"招聘通知",@"培训通知",@"群通知",@"社区通知",@"公告通知"];
    NSMutableArray  *titlesArr = [titles mutableCopy];
    NSArray *laterTitlesArr =  @[];
    
    ECContainerBarParam * param =  [ECContainerBarParam getECContainerViewParamWithBaseView:self.view titles:titlesArr laterTitlesArr:[laterTitlesArr mutableCopy] DefaultsKey:@"notice_default"];
    param.visableCursor = YES;
    param.isHeaderLine = NO;
    param.isFootLine = YES;
    param.isSegmentLine = NO;
    param.fontSize = 13.f;
    param.focusFontSize = 15.f;
    param.itemBarNBackgroudColor = ECCOLOR(255, 255, 255, 1);
    param.itemBarSBackgroudColor = ECCOLOR(255, 255, 255, 1);
    param.cursorColor = ECCOLOR(14,91,171,1.0);
    param.focusFontColor = ECCOLOR(14,91,171,1.0);
    param.footLineColor = [UIColor lightGrayColor];
    ECContainerView  * containerView = [[ECContainerView alloc]initWithFrame:containerViewRC param:param];
    containerView.delegate = self;
    [self.view addSubview:containerView];
}


- (void)ECContainerView:(ECContainerView *)containerView loadContentForCurrentIndexTitle:(NSString *)title currentIndex:(NSInteger)index
{
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
