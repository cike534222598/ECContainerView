//
//  ECContainerView.m
//  ECContainerView
//
//  Created by Jame on 16/3/25.
//  Copyright © 2016年 Jame. All rights reserved.
//

#import "ECContainerView.h"

#define  EC_ContainerBarHeight     (40.0)                  //容器条高度
#define  EC_ButtonColumns          (4)                     //按钮列数
#define  EC_ButtonMargin            (20.0)                 //按钮边距
#define  EC_LableMargin            (20.0)                  //标签边距
#define  EC_LableFontSize          (15.0)                  //标签字体大小
#define  EC_EditButtonWidth        (50.0)                  //编辑按钮宽度
#define  EC_EditButtonHeight       (30.0)                  //编辑按钮高度
#define  EC_EditButtonTag          (100)                   //编辑按钮id
#define  EC_DropButtonTag          (101)                   //下拉按钮id
#define  EC_ShowAnimationDuring    (0.25)                  //编辑视图显示动画周期
#define  EC_ShowAlertMsg           (@"至少保留4项")          //保留项的限制提示



@interface ECContainerView () <UIScrollViewDelegate , ECContainerBarDelegate , ECContainerBarItemDelegate>
{
    UIScrollView * _addScrollView;            //待添加滚动背部视图
    ECContainerBar * _containerBar;           //顶部容器条
    ECContainerBarParam * _containerBarParam; //容器创建参数
    UIView * _editView;                       //编辑菜单视图
    UIView * _addItemView;                    //增加栏目视图
    UIView * _labView;                        //标签
    UIButton * _dropBtn;                      //下拉按钮
    UIButton * _editButton;                   //编辑按钮
    UIImageView * _dropImageView;             //下拉图片
    NSInteger _currentPageIndex;              //当前页下标
    BOOL _isClickSwitch;                      //是否单击切换页
    BOOL _isBigSwitch;                        //是否进行大切换
    BOOL _isAnimationMoving;                  //正在动画移动中
    BOOL _canMoveBarItem;                     //可移动项
    BOOL _isTouchEnd;                         //是否触摸结束
    BOOL _isSelectedEditBtn;                  //是否選擇編輯按鈕
    BOOL _isAddAnimation;                     //正在执行添加动画
    BOOL _isDeleteAnimation;                  //正在执行删除动画
    BOOL _isClickDrop;                        //是否点击下拉按钮
    CGPoint _startPoint;                      //长按开始点
    NSInteger _moveBarItemIndex;              //可移动项的下标
    NSInteger _editRowCount;                  //可编辑的行数
    NSInteger _clickItemBarIndex;             //单击item下标
    ECContainerBarItem * _moveBarItem;        //可移动项
    
    NSMutableArray * _pointArr;               //编辑视图上Item坐标数组
    NSMutableArray * _addPointArr;            //增加视图上Item坐标数组
    NSMutableArray * _barItemArr;             //编辑视图上Item数组
    NSMutableArray * _addBarItemArr;          //增加视图上Item数组
}

@end

@implementation ECContainerView

- (instancetype)initWithFrame:(CGRect)frame param:(ECContainerBarParam*)param{
    NSParameterAssert(param);
    self = [super initWithFrame:frame];
    if(self){
        _containerBarParam = param;
        [self initUILayout];
    }
    return self;
}

- (void)setDelegate:(id<ECContainerViewDelegate>)delegate
{
    _delegate = delegate;
}

- (void)initUILayout{
    _isClickDrop = YES;
    _pointArr = [NSMutableArray new];
    _barItemArr = [NSMutableArray new];
    _addBarItemArr = [NSMutableArray new];
    _addPointArr = [NSMutableArray new];
    CGRect    containerBarRC = self.bounds;
    containerBarRC.size.height = EC_ContainerBarHeight;
    _containerBar = [[ECContainerBar alloc]initWithFrame:containerBarRC param:_containerBarParam];
    _containerBar.delegate = self;
    [self addSubview:_containerBar];
    
    _editView = [self createEditView];
    
    [_containerBarParam.baseView sendSubviewToBack:self];
}


#pragma mark ------CREATBASEVIEW------
- (UILabel *)createLable:(CGRect)frame txt:(NSString *)txt{
    UILabel  * lab = [[UILabel alloc]initWithFrame:CGRectMake(EC_LableMargin, 0.0, self.width / 2.0, EC_ContainerBarHeight)];
    lab.text = txt;
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont boldSystemFontOfSize:EC_LableFontSize];
    return lab;
}

- (UIButton *)createButton:(CGRect)frame txt:(NSString *)txt tag:(NSInteger)tag{
    UIButton  * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.tag = tag;
    [btn setBackgroundImage:[UIImage imageNamed:@"edit_button"] forState:UIControlStateNormal];
    [btn setTitle:txt forState:UIControlStateNormal];
    [btn setTitleColor:ECCOLOR(221, 50, 55, 1) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [btn addTarget:self action:@selector(clickEditViewButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


- (UIView *)createEditView{
    UIView  * editView = [[UIView alloc]initWithFrame:self.bounds];
    editView.backgroundColor = [UIColor whiteColor];
    
    UIView *topLabView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, EC_ContainerBarHeight)];
    topLabView.backgroundColor = [UIColor colorWithWhite:240.0 / 255.0 alpha:1.0];
    [editView addSubview:topLabView];

    UILongPressGestureRecognizer     * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
    [editView addGestureRecognizer:longPressGesture];
    
    CGRect    rc = {EC_LableMargin, 0.0, self.width / 2.0, EC_ContainerBarHeight};
    [editView addSubview:[self createLable:rc txt:@"现有选项"]];
    
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, self.width - 85 - EC_DropBtn_Width - EC_EditButtonWidth - 5, EC_ContainerBarHeight)];
    noticeLabel.text = @"(长按并拖动标签可调整位置)";
    noticeLabel.font = [UIFont systemFontOfSize:11.f];
    noticeLabel.textColor = [UIColor lightGrayColor];
    noticeLabel.numberOfLines = 2;
    [editView addSubview:noticeLabel];
    
    
    rc = CGRectMake(self.width - EC_EditButtonWidth - EC_DropBtn_Width, (EC_ContainerBarHeight - 40) / 2.0, EC_EditButtonWidth, 40);
    _editButton = [self createButton:rc txt:@"编辑" tag:EC_EditButtonTag];
    [editView addSubview:_editButton];
    
    _dropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dropBtn.selected = YES;
    _dropBtn.frame = CGRectMake(self.width - EC_DropBtn_Width, 0.0, EC_DropBtn_Width, EC_ContainerBarHeight);
    _dropBtn.tag = EC_DropButtonTag;
    _dropBtn.backgroundColor = [UIColor clearColor];
    [_dropBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_dropBtn addTarget:self action:@selector(clickEditViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:_dropBtn];
    
    _dropImageView = [[UIImageView alloc]initWithFrame:_dropBtn.bounds];
    _dropImageView.backgroundColor = [UIColor clearColor];
    _dropImageView.contentMode = UIViewContentModeCenter;
    _dropImageView.image = [UIImage imageNamed:@"icon_down_arrow"];
    [_dropBtn addSubview:_dropImageView];
    
    _editRowCount = [self calcRowCount];
    CGFloat        addItemViewY = (_editRowCount + 1) * EC_ContainerBarHeight + (EC_ContainerBarHeight - EC_EditButtonHeight) / 2.0;
    CGRect         addItemViewRC = {0.0, addItemViewY, self.width, self.height - addItemViewY};
    _addItemView = [[UIView alloc]initWithFrame:addItemViewRC];
    _addItemView.backgroundColor = editView.backgroundColor;
    [editView addSubview:_addItemView];
    
    CGRect labViewRC = {EC_LableMargin, 0.0, self.width, EC_ContainerBarHeight};
    _labView = [[UIView alloc]initWithFrame:labViewRC];
    _labView.backgroundColor = [UIColor colorWithWhite:240.0 / 255.0 alpha:1.0];
    _labView.x = 0.0;
    [_addItemView addSubview:_labView];
    UILabel  * lab = [self createLable:rc txt:@"可选选项"];
    [_labView addSubview:lab];
    
    CGRect    addScrollViewRC = {0.0, EC_ContainerBarHeight, self.width, _addItemView.height - EC_ContainerBarHeight};
    _addScrollView = [[UIScrollView alloc]initWithFrame:addScrollViewRC];
    _addScrollView.showsHorizontalScrollIndicator = NO;
    _addScrollView.showsVerticalScrollIndicator = YES;
    _addScrollView.contentSize = _addScrollView.size;
    [_addItemView addSubview:_addScrollView];
    return editView;
}



#pragma mark ------COUNT------
- (NSInteger)calcRowCount{
    NSInteger  count = _containerBarParam.titlesArr.count;
    NSInteger  rowCount = count / EC_ButtonColumns + ((count % EC_ButtonColumns) != 0 ? 1 : 0);
    return rowCount;
}



- (void)clearMemoryArr:(NSArray *)array{
    if(array){
        for (NSInteger i = 0; i < array.count; i++) {
            NSObject * object = array[i];
            if([object isKindOfClass:[UIView class]]){
                [((UIView *)object) removeFromSuperview];
            }
            object = nil;
        }
    }
}


#pragma mark ------LAYOUTBAR------
- (CGFloat)layoutBarItemToView:(UIView *)view titleArr:(NSArray *)titleArr barItemArr:(NSMutableArray *)barItemArr pointArr:(NSMutableArray *)pointArr yConst:(CGFloat)yConst style:(ECBarItemStyle)style{
    CGFloat   btnWidth = (self.width - (EC_ButtonColumns + 1) * EC_ButtonMargin) / (CGFloat)EC_ButtonColumns;
    NSInteger count = titleArr.count;
    NSInteger rowCount = count / EC_ButtonColumns + ((count % EC_ButtonColumns) != 0 ? 1 : 0);
    for (NSInteger i = 0; i < rowCount; i++) {
        for (NSInteger j = 0; j < EC_ButtonColumns; j++) {
            CGRect  itemBtnRC = {EC_ButtonMargin * (j + 1) + btnWidth * j, EC_ContainerBarHeight * (i + 1) + yConst, btnWidth , EC_EditButtonHeight};
            NSInteger  index = i * EC_ButtonColumns + j;
            if(index < count){
                ECContainerBarItem  * itemBtn = [[ECContainerBarItem alloc]initWithFrame:itemBtnRC Style:style];
                itemBtn.delegate = self;
                itemBtn.title = titleArr[index];
                itemBtn.normalTitleColor = [UIColor blackColor];
                itemBtn.normalFontSize = _containerBarParam.fontSize;
                itemBtn.index = index;
                itemBtn.tag = index + 1;
                [view addSubview:itemBtn];
                [barItemArr addObject:itemBtn];
                [pointArr addObject:@[@(itemBtn.center.x),@(itemBtn.center.y)]];
            }
        }
    }
    return [[pointArr lastObject][1] floatValue] + EC_EditButtonHeight;
}


#pragma mark -----SAVEBARTITLEARR------
+ (void)saveContainerBarTitlesArr:(NSArray *)titlesArr laterTitlesArr:(NSArray *)laterTitlesArr DefaultsKey:(NSString *)key{
    [ECContainerBar saveContainerBarTitlesArr:titlesArr laterTitlesArr:laterTitlesArr DefaultsKey:key];
}


#pragma mark -----READBARTITLEARR------
+ (NSArray *)readContainerBarTitlesArrWithDefaultsKey:(NSString *)key{
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSArray      * titlesArr = nil;
    if(dict && dict.count > 0){
        titlesArr = dict[EC_ContainerTitlesArrKey];
    }
    return titlesArr;
}

#pragma mark -----READBARLATERTITLEARR------
+ (NSArray *)readContainerBarLaterTitlesArrWithDefaultsKey:(NSString *)key{
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSArray      * laterTitlesArr = nil;
    if(dict && dict.count > 0){
        laterTitlesArr = dict[EC_ContainerLaterTitlesArrKey];
    }
    return laterTitlesArr;
}


#pragma mark -----EDITCLICK------
- (void)clickEditViewButton:(UIButton*)sender{
    sender.selected = !sender.selected;
    NSInteger  tag = sender.tag;
    if(tag == EC_DropButtonTag){
        if(!(sender.selected)){
            if(_isSelectedEditBtn){
                [self clickEditViewButton:_editButton];
            }
            [ECContainerView saveContainerBarTitlesArr:_containerBarParam.titlesArr laterTitlesArr:_containerBarParam.laterTitlesArr DefaultsKey:_containerBarParam.defaults];
            
            [UIView animateWithDuration:EC_ShowAnimationDuring delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _editView.height = 0.0;
                _dropImageView.transform = CGAffineTransformMakeRotation(0);
                [_editView removeFromSuperview];
                
            } completion:^(BOOL finished) {
                _editView.frame = self.bounds;
                if(_isClickDrop){
                    [_containerBar updateContainer];
                }else{
                    [_containerBar updateContainerClickIndex:_clickItemBarIndex];
                }
                [_containerBar rotateDropBtnDuring:EC_ShowAnimationDuring];
                _isClickDrop = YES;
                [_containerBarParam.baseView sendSubviewToBack:self];
            }];
        }
    }else if (tag == EC_EditButtonTag){
        _isSelectedEditBtn = sender.selected;
        if(_isSelectedEditBtn){
            [sender setTitle:@"完成" forState:UIControlStateNormal];
            for (ECContainerBarItem * itemBar in _editView.subviews) {
                if([itemBar isKindOfClass:[ECContainerBarItem class]]){
                    [itemBar startEdit];
                }
            }
        }else{
            [sender setTitle:@"编辑" forState:UIControlStateNormal];
            for (ECContainerBarItem * itemBar in _editView.subviews) {
                if([itemBar isKindOfClass:[ECContainerBarItem class]]){
                    [itemBar stopEdit];
                }
            }
            
            [ECContainerView saveContainerBarTitlesArr:_containerBarParam.titlesArr laterTitlesArr:_containerBarParam.laterTitlesArr DefaultsKey:_containerBarParam.defaults];
        }
    }else{
        
    }
}



#pragma mark -----LONGPRESS------
- (NSInteger)longPressBarItemIndex:(CGPoint)point{
    int index = -1;
    for (ECContainerBarItem * barItem in _editView.subviews) {
        if([barItem isKindOfClass:[ECContainerBarItem class]] &&
           CGRectContainsPoint(barItem.frame, point)){
            index = (int)barItem.index;
            break;
        }
    }
    return index;
}



#pragma mark -------SAVEBARTITLE------
- (void)saveTitlesArrWithBarItemArr:(NSArray *)barItemArr{
    [_containerBarParam.titlesArr removeAllObjects];
    for (ECContainerBarItem * barItem in barItemArr) {
        [_containerBarParam.titlesArr addObject:barItem.title];
    }
}


#pragma mark ------LONGPRESS------
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture{
    
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:{
            _isTouchEnd = NO;
            _canMoveBarItem = NO;
            CGPoint longPressPoint = [longPressGesture locationInView:longPressGesture.view];
            _moveBarItemIndex = [self longPressBarItemIndex:longPressPoint];
            if(_moveBarItemIndex > -1){
                _canMoveBarItem = YES;
                _moveBarItem = ((ECContainerBarItem*)_barItemArr[_moveBarItemIndex]);
                _startPoint = _moveBarItem.center;
                [_editView bringSubviewToFront:_moveBarItem];
            }
            _addItemView.hidden = YES;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if(_canMoveBarItem){
                CGPoint  currentPoint = [longPressGesture locationInView:longPressGesture.view];
                _moveBarItem.center = currentPoint;
                if(_isAnimationMoving){
                    return;
                }
                NSInteger  currentBarItemIndex = [self longPressBarItemIndex:currentPoint];
                if(currentBarItemIndex > -1){
                    _isAnimationMoving = YES;
                    [UIView animateWithDuration:EC_ShowAnimationDuring delay:0.0
                                        options:UIViewAnimationOptionCurveEaseOut
                                     animations:^{
                                         if(currentBarItemIndex > _moveBarItemIndex){
                                             for (NSInteger i = currentBarItemIndex; i > _moveBarItemIndex; i--) {
                                                 ECContainerBarItem  * barItem = ((ECContainerBarItem*)_barItemArr[i]);
                                                 CGPoint  frontBarItemCenter = CGPointZero;
                                                 NSArray * point = _pointArr[i - 1];
                                                 frontBarItemCenter = CGPointMake([point[0] floatValue], [point[1] floatValue]);
                                                 if(i == _moveBarItemIndex + 1){
                                                     NSArray  * startPoint = _pointArr[_moveBarItemIndex];
                                                     frontBarItemCenter = CGPointMake([startPoint[0] floatValue], [startPoint[1] floatValue]);
                                                 }
                                                 barItem.center = frontBarItemCenter;
                                             }
                                         }else if (currentBarItemIndex < _moveBarItemIndex){
                                             for (NSInteger i = currentBarItemIndex; i < _moveBarItemIndex; i++) {
                                                 ECContainerBarItem  * barItem = ((ECContainerBarItem*)_barItemArr[i]);
                                                 CGPoint  nextBarItemCenter = CGPointZero;
                                                 NSArray * point = _pointArr[i + 1];
                                                 nextBarItemCenter = CGPointMake([point[0] floatValue], [point[1] floatValue]);
                                                 if(i == _moveBarItemIndex - 1){
                                                     NSArray  * startPoint = _pointArr[_moveBarItemIndex];
                                                     nextBarItemCenter = CGPointMake([startPoint[0] floatValue], [startPoint[1] floatValue]);
                                                 }
                                                 barItem.center = nextBarItemCenter;
                                             }
                                         }
                                         
                                     } completion:^(BOOL finished) {
                                         
                                         [_barItemArr exchangeObjectAtIndex:_moveBarItemIndex withObjectAtIndex:currentBarItemIndex];
                                         if(currentBarItemIndex > _moveBarItemIndex){
                                             for (NSInteger i = _moveBarItemIndex; i < currentBarItemIndex - 1; i++) {
                                                 [_barItemArr exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
                                             }
                                         }else if (currentBarItemIndex < _moveBarItemIndex){
                                             for (NSInteger i = _moveBarItemIndex; i > currentBarItemIndex + 1; i--) {
                                                 [_barItemArr exchangeObjectAtIndex:i withObjectAtIndex:(i - 1 < 0 ? 0 : i - 1)];
                                             }
                                         }
                                         for (NSInteger i = 0; i < _barItemArr.count; i++) {
                                             ECContainerBarItem  * barItem = ((ECContainerBarItem*)_barItemArr[i]);
                                             barItem.index = i;
                                         }
                                         NSArray  * currentPoint = _pointArr[currentBarItemIndex];
                                         
                                         _startPoint = CGPointMake([currentPoint[0] floatValue], [currentPoint[1] floatValue]);
                                         if(_isTouchEnd && (_startPoint.x != _moveBarItem.center.x ||
                                                            _startPoint.y != _moveBarItem.center.y)){
                                             _moveBarItem.center = _startPoint;
                                             [self saveTitlesArrWithBarItemArr:_barItemArr];
                                         }
                                         _moveBarItemIndex = currentBarItemIndex;
                                         _isAnimationMoving = NO;
                                     }];
                }
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            _moveBarItem.center = _startPoint;
            _addItemView.hidden = NO;
            _isTouchEnd = YES;
            [self saveTitlesArrWithBarItemArr:_barItemArr];
        }
            break;
        default:
            break;
    }
}

#pragma mark ------UIScrollViewDelegate------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isClickSwitch = NO;
    _currentPageIndex = floor((scrollView.contentOffset.x - scrollView.width / 2.0) / scrollView.width) + 1;
    CGPoint  ori = [scrollView.panGestureRecognizer velocityInView:scrollView];
    [_containerBar beginDynamicChangeStateOffsetX:scrollView.contentOffset.x pageIndex:_currentPageIndex oriX:ori.x];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!_isClickSwitch){
        CGPoint ori = [scrollView.panGestureRecognizer velocityInView:scrollView];
        [_containerBar dynamicChangeStateOffsetX:scrollView.contentOffset.x oriX:ori.x];
    }
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    _isClickSwitch = NO;
    if(_isBigSwitch){
        for (NSInteger i = 0; i < _containerBarParam.titlesArr.count; i++) {

        }
    }
    if(_delegate && [_delegate respondsToSelector:@selector(ECContainerView:loadContentForCurrentIndexTitle:currentIndex:)]){
        [_delegate ECContainerView:self loadContentForCurrentIndexTitle:_containerBarParam.titlesArr[_currentPageIndex] currentIndex:_currentPageIndex];
    }

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPageIndex = floor((scrollView.contentOffset.x - scrollView.width / 2.0) / scrollView.width) + 1;
    if(currentPageIndex != _currentPageIndex){
        if(_delegate && [_delegate respondsToSelector:@selector(ECContainerView:loadContentForCurrentIndexTitle:currentIndex:)]){
            [_delegate ECContainerView:self loadContentForCurrentIndexTitle:_containerBarParam.titlesArr[currentPageIndex] currentIndex:currentPageIndex];
        }
    }
    _currentPageIndex = currentPageIndex;
    [_containerBar endDynamicChangeStateOffsetX:scrollView.contentOffset.x currentPageIndex:currentPageIndex];
}



#pragma mark ------ECContainerBarDelegate------
- (void)ECContainerBar:(ECContainerBar *)containerBar clickIndex:(NSInteger)index animated:(BOOL)animated{
    _isClickSwitch = YES;
    _isBigSwitch = YES;
    void (^replaceViewPosition)(NSInteger) = ^(NSInteger symbol){
        
    };
    
    if(index > _currentPageIndex && index > _currentPageIndex + 1){
        replaceViewPosition(1);
    }else if (index < _currentPageIndex && index < _currentPageIndex - 1){
        replaceViewPosition(-1);
    }else{
        _isBigSwitch = NO;
    }
    _currentPageIndex = index;
    
    if(_delegate && [_delegate respondsToSelector:@selector(ECContainerView:loadContentForCurrentIndexTitle:currentIndex:)]){
        [_delegate ECContainerView:self loadContentForCurrentIndexTitle:_containerBarParam.titlesArr[_currentPageIndex] currentIndex:_currentPageIndex];
    }
}


- (void)ECContainerBar:(ECContainerBar *)containerBar clickDrop:(UIButton*)sender{
    
    [self clearMemoryArr:_addBarItemArr];
    [self clearMemoryArr:_addPointArr];
    [self clearMemoryArr:_barItemArr];
    [self clearMemoryArr:_pointArr];
    [_addBarItemArr removeAllObjects];
    [_addPointArr removeAllObjects];
    [_barItemArr removeAllObjects];
    [_pointArr removeAllObjects];
    
    [self layoutBarItemToView:_editView titleArr:_containerBarParam.titlesArr barItemArr:_barItemArr pointArr:_pointArr yConst:(EC_ContainerBarHeight - EC_EditButtonHeight) / 2.0 style:EDIT_SHOW];
    CGFloat sumHeight = [self layoutBarItemToView:_addScrollView titleArr:_containerBarParam.laterTitlesArr barItemArr:_addBarItemArr pointArr:_addPointArr yConst:-EC_EditButtonHeight style:ADD_SHOW];
    if(sumHeight > _addScrollView.contentSize.height){
        _addScrollView.contentSize = CGSizeMake(_addScrollView.width, sumHeight);
    }
    _dropBtn.selected = sender.selected;
    [self addSubview:_editView];
    [_editView sendSubviewToBack:_addItemView];
    [_containerBarParam.baseView bringSubviewToFront:self];
    _editView.height = 0.0;
    __weak typeof(self) sf = self;
    [UIView animateWithDuration:EC_ShowAnimationDuring delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _editView.height = sf.height;
        _dropImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark ------ECContainerBarItemDelegate------
- (void)ECContainerBarItem:(ECContainerBarItem*)barItem clickIndex:(NSInteger)index animated:(BOOL)animated{
    if(_isAddAnimation){
        return;
    }
    if([_barItemArr containsObject:barItem]){
        _isClickDrop = NO;
        _clickItemBarIndex = index;
        [self clickEditViewButton:_dropBtn];
    }else{
        _isAddAnimation = YES;
        [barItem removeFromSuperview];
        barItem.center = CGPointMake(barItem.center.x, barItem.center.y + _addItemView.y + EC_ContainerBarHeight + (EC_ContainerBarHeight - EC_EditButtonHeight) - _addScrollView.contentOffset.y);
        [_editView addSubview:barItem];
        BOOL       isAddRow = NO;
        BOOL       isDecRow = ((_addBarItemArr.count % EC_ButtonColumns) == 1 ? YES : NO);
        NSInteger  count = _barItemArr.count;
        _editRowCount = [self calcRowCount];
        CGPoint  centerPoint = CGPointZero;
        if(count < _editRowCount * EC_ButtonColumns){
            NSArray  * lastPoint = [_pointArr lastObject];
            centerPoint = CGPointMake([lastPoint[0] floatValue] + barItem.width + EC_ButtonMargin , [lastPoint[1] floatValue]);
        }else{
            isAddRow = YES;
            if(count > 0){
                NSArray  * lastPoint = _pointArr[count - EC_ButtonColumns];
                centerPoint = CGPointMake([lastPoint[0] floatValue] , [lastPoint[1] floatValue]  + barItem.height + EC_ButtonMargin / 2.0);
            }else{
                centerPoint = CGPointMake(EC_ButtonMargin + barItem.width / 2.0, EC_ContainerBarHeight + EC_ButtonMargin / 4.0 + barItem.height / 2.0);
            }
        }
        [UIView animateWithDuration:EC_ShowAnimationDuring animations:^{
            
            barItem.center = centerPoint;
            
        }completion:^(BOOL finished) {
            [barItem setItemStyle:EDIT_SHOW];
            if(_isSelectedEditBtn){
                [barItem startEdit];
            }
            barItem.index = _barItemArr.count;
            [_barItemArr addObject:barItem];
            [_pointArr addObject:@[@(barItem.center.x),@(barItem.center.y)]];
            CGFloat  incrementHeight = barItem.height + EC_ButtonMargin / 2.0;
            
            [UIView animateWithDuration:EC_ShowAnimationDuring animations:^{
                if(isAddRow){
                    _addItemView.center = CGPointMake(_addItemView.center.x, _addItemView.center.y + incrementHeight);
                    _addItemView.height -= incrementHeight;
                    _addScrollView.height -= incrementHeight;
                }
                for(NSInteger i = index; i < _addBarItemArr.count - 1; i++){
                    ECContainerBarItem  * barItem = _addBarItemArr[i + 1];
                    NSArray    *   pointArr = _addPointArr[i];
                    if(isAddRow){
                        barItem.center = CGPointMake([pointArr[0] floatValue], [pointArr[1] floatValue]);
                    }else{
                        barItem.center = CGPointMake([pointArr[0] floatValue], [pointArr[1] floatValue]);
                    }
                }
                if(isAddRow){
                    for (NSInteger i = 0; i < index; i++) {
                        ECContainerBarItem  * barItem = _addBarItemArr[i];
                        NSArray    *   pointArr = _addPointArr[i];
                        barItem.center = CGPointMake([pointArr[0] floatValue], [pointArr[1] floatValue]);
                    }
                }
            }completion:^(BOOL finished) {
                if(isDecRow){
                    _addScrollView.contentSize = CGSizeMake(_addScrollView.width, _addScrollView.contentSize.height - incrementHeight);
                }
                [_containerBarParam.titlesArr addObject:[NSString stringWithString:barItem.title]];
                [_containerBarParam.laterTitlesArr removeObjectAtIndex:index];
                [_addBarItemArr removeObjectAtIndex:index];
                [_addPointArr removeAllObjects];
                for (NSInteger i = 0; i < _addBarItemArr.count; i++) {
                    ECContainerBarItem  * barItem = _addBarItemArr[i];
                    barItem.index = i;
                    [_addPointArr addObject:@[@(barItem.center.x),@(barItem.center.y)]];
                }
                _isAddAnimation = NO;
            }];
        }];
    }
}


- (void)ECContainerBarItem:(ECContainerBarItem *)barItem clickDeleteBtn:(UIButton*)sender index:(NSInteger)index{
    if(_containerBarParam.mustSaveItemCount >= _barItemArr.count){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:EC_ShowAlertMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(_isDeleteAnimation){
        return;
    }
    _isDeleteAnimation = YES;
    [_editView bringSubviewToFront:barItem];
    BOOL       isDecRow = ((_barItemArr.count % EC_ButtonColumns != 1) ? NO : YES);
    BOOL       isAddRow = ((_addBarItemArr.count % EC_ButtonColumns == 0) ? YES : NO);
    if(_addBarItemArr.count == 0){
        isAddRow = NO;
    }
    CGPoint    barItemCenter = CGPointMake(EC_ButtonMargin + barItem.width / 2.0, _addItemView.y + EC_ContainerBarHeight + EC_ContainerBarHeight - EC_EditButtonHeight  + EC_EditButtonHeight / 2.0);
    NSInteger  count = _addBarItemArr.count;
    NSInteger  remainder = count % EC_ButtonColumns;
    NSArray  * lastPoint = [_addPointArr lastObject];
    if(remainder != 0){
        [_addPointArr addObject:@[@([lastPoint[0] floatValue] + barItem.width + (EC_ContainerBarHeight - EC_EditButtonHeight) * 2.0), lastPoint[1]]];
    }else{
        if(count == 0){
            [_addPointArr addObject:@[@(EC_ButtonMargin + barItem.width / 2.0), @((barItem.height + EC_ButtonMargin) / 2.0)]];
        }else{
            [_addPointArr addObject:@[@(EC_ButtonMargin + barItem.width / 2.0), @([lastPoint[1] floatValue] + barItem.height + EC_ButtonMargin / 2.0)]];
        }
    }
    CGFloat  incrementHeight = barItem.height + EC_ButtonMargin / 2.0;
    [UIView animateWithDuration:EC_ShowAnimationDuring animations:^{
        if(isDecRow){
            _addItemView.center = CGPointMake(_addItemView.center.x, _addItemView.center.y - incrementHeight);
            _addItemView.height += incrementHeight;
            _addScrollView.height += incrementHeight;
            barItem.center = CGPointMake(barItemCenter.x, barItemCenter.y - incrementHeight);
        }else{
            barItem.center = barItemCenter;
        }
        for (NSInteger i = count - 1; i >= 0; i--) {
            ECContainerBarItem  * tempBarItem = _addBarItemArr[i];
            NSArray  * tempBarItemPoint = _addPointArr[i + 1];
            tempBarItem.center = CGPointMake([tempBarItemPoint[0] floatValue], [tempBarItemPoint[1] floatValue]);
        }
        for (NSInteger i = index + 1; i < _barItemArr.count; i++) {
            ECContainerBarItem  * tempBarItem = _barItemArr[i];
            NSArray  * tempBarItemPoint = _pointArr[i - 1];
            tempBarItem.center = CGPointMake([tempBarItemPoint[0] floatValue], [tempBarItemPoint[1] floatValue]);
        }
    }completion:^(BOOL finished) {
        if(isAddRow){
            _addScrollView.contentSize = CGSizeMake(_addScrollView.width, _addScrollView.contentSize.height + incrementHeight);
        }
        [barItem stopEdit];
        [barItem setItemStyle:ADD_SHOW];
        [barItem removeFromSuperview];
        [_pointArr removeAllObjects];
        [_barItemArr removeObjectAtIndex:index];
        [_containerBarParam.titlesArr removeObjectAtIndex:index];
        [_containerBarParam.laterTitlesArr insertObject:barItem.title atIndex:0];
        for (NSInteger i = 0; i < _barItemArr.count; i++) {
            ECContainerBarItem  * tempBarItem = _barItemArr[i];
            tempBarItem.index = i;
            [_pointArr addObject:@[@(tempBarItem.center.x),@(tempBarItem.center.y)]];
        }
        barItem.center = CGPointMake(barItem.center.x, EC_ContainerBarHeight - EC_EditButtonHeight  + EC_EditButtonHeight / 2.0);
        [_addScrollView addSubview:barItem];
        [_addBarItemArr insertObject:barItem atIndex:0];
        for (NSInteger i = 0; i < _addBarItemArr.count; i++) {
            ECContainerBarItem  * tempBarItem = _addBarItemArr[i];
            tempBarItem.index = i;
        }
        _isDeleteAnimation = NO;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
