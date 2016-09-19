//
//  ECContainerBarItem.m
//  ECContainerView
//
//  Created by Jame on 16/3/25.
//  Copyright © 2016年 Jame. All rights reserved.
//

#import "ECContainerBarItem.h"

#define EC_DeleteButtonSize (15.0)          //删除按钮尺寸
#define EC_RotateAngle (1.0)                //编辑时抖动角度
#define EC_RotateDuring (0.1)               //编辑时抖动周期

@interface ECContainerBarItem ()
{
    
    UIButton              * _barItemBtn;      //选项按钮
    UIButton              * _deleteBtn;       //删除按钮
    ECBarItemStyle         _itemStyle;        //按钮样式
    
    UITapGestureRecognizer * _tapGesture;     //单击手势
}


@end


@implementation ECContainerBarItem


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initUILayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Style:(ECBarItemStyle)style{
    self = [super initWithFrame:frame];
    if(self){
        _itemStyle = style;
        [self initUILayout];
    }
    return self;
}

- (void)initSet{
    _barItemBtn.backgroundColor = [UIColor whiteColor];
    _barItemBtn.layer.cornerRadius = 5.f;
    _barItemBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _barItemBtn.layer.borderWidth = 0.5;
    _barItemBtn.layer.masksToBounds = YES;
}


- (void)initUILayout{
    self.backgroundColor = [UIColor clearColor];
    _barItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _barItemBtn.frame = self.bounds;
    [_barItemBtn addTarget:self action:@selector(clickBarItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_barItemBtn];
    
    if(_itemStyle == ADD_SHOW ||
       _itemStyle == EDIT_SHOW){
        [self initSet];
        if(_itemStyle == EDIT_SHOW){
            [self addDeleteButton];
        }
    }
}

- (void)addDeleteButton{
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(-5.0, -5.0, EC_DeleteButtonSize, EC_DeleteButtonSize);
    _deleteBtn.layer.cornerRadius = EC_DeleteButtonSize / 2.0;
    _deleteBtn.layer.masksToBounds = YES;
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"gray_x"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteBtn];
    _deleteBtn.hidden = YES;
}


#pragma mark - handleTapGesture -
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture{
    [self clickBarItem:_barItemBtn];
}

#pragma mark - propertyOverride -

- (void)setItemStyle:(ECBarItemStyle)style{
    _itemStyle = style;
    if(_itemStyle == EDIT_SHOW){
        if(_deleteBtn){
            if (![self.subviews containsObject:_deleteBtn]) {
                [self addSubview:_deleteBtn];
            }
        }else{
            [self addDeleteButton];
        }
    }else{
        if(_deleteBtn){
            if([self.subviews containsObject:_deleteBtn]){
                [_deleteBtn removeFromSuperview];
                
            }
            _deleteBtn = nil;
        }
    }
}

- (void)setTitle:(NSString *)title{
    if(title == nil){
        title = @"";
    }
    _title = nil;
    _title = title;
    [_barItemBtn setTitle:_title forState:UIControlStateNormal];
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    _barItemBtn.tag = index;
}

- (void)setNormalFontSize:(CGFloat)normalFontSize{
    _normalFontSize = normalFontSize;
    _barItemBtn.titleLabel.font = [UIFont systemFontOfSize:_normalFontSize];
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor{
    _normalTitleColor = nil;
    _normalTitleColor = normalTitleColor;
    [_barItemBtn setTitleColor:normalTitleColor forState:UIControlStateNormal];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor{
    _selectedTitleColor = nil;
    _selectedTitleColor = selectedTitleColor;
}

- (void)dynamicChangeBackgroudColor:(UIColor *)color{
    _barItemBtn.backgroundColor = color;
}

- (void)dynamicChangeTextColor:(UIColor *)color{
    [_barItemBtn setTitleColor:color forState:UIControlStateNormal];
}

- (void)dynamicChangeTextSize:(UIFont *)font{
    _barItemBtn.titleLabel.font = font;
}


- (void)startEdit{
    _deleteBtn.hidden = NO;
    double (^angle)(double) = ^(double deg) {
        return deg / 180.0 * M_PI;
    };
    CABasicAnimation * ba = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ba.fromValue = @(angle(-EC_RotateAngle));
    ba.toValue = @(angle(EC_RotateAngle));
    ba.repeatCount = MAXFLOAT;
    ba.duration = EC_RotateDuring;
    ba.autoreverses = YES;
    [self.layer addAnimation:ba forKey:nil];
}

- (void)stopEdit{
    _deleteBtn.hidden = YES;
    [self.layer removeAllAnimations];
}

#pragma mark - barItemAction -
- (void)clickBarItem:(UIButton*)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(ECContainerBarItem:clickIndex: animated:)]){
        [_delegate ECContainerBarItem:self clickIndex:sender.tag animated:YES];
    }
}

- (void)clickDeleteBtn:(UIButton*)sender{
    sender.tag = _index;
    
    if(_delegate && [_delegate respondsToSelector:@selector(ECContainerBarItem:clickDeleteBtn:index:)]){
        [_delegate ECContainerBarItem:self clickDeleteBtn:sender index:_index];
    }
}

#pragma mark - other -
- (void)setSelected:(BOOL)selected{
    _barItemBtn.selected = selected;
    if(selected){
        [self dynamicChangeTextSize:[UIFont systemFontOfSize:_selectedFontSize]];
        [self dynamicChangeTextColor:_selectedTitleColor];
        _barItemBtn.backgroundColor = _selectedBackgroundColor;
    }else{
        [self dynamicChangeTextSize:[UIFont systemFontOfSize:_normalFontSize]];
        [self dynamicChangeTextColor:_normalTitleColor];
        _barItemBtn.backgroundColor = _normalBackgroundColor;
    }
}

- (BOOL)selected{
    return _barItemBtn.selected;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
