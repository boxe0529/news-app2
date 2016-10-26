//
//  HScrollview.m
//  新闻客户端
//
//  Created by 邓云方 on 15/10/3.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "HScrollview.h"

@implementation HScrollview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(HScrollview *)init
{
    self=[super init];
    if(self)
    {
        buttons=[[NSMutableArray alloc]initWithCapacity:10];
        self.backgroundColor=[UIColor whiteColor];
        self.scrollEnabled=YES;
        //取消滚动指示器
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
    }
    return  self;
}
-(void)addbutton:(UIButton *)button
{
    //滚动宽度
    NSInteger width=21;
    //得到最后那个按钮
    UIButton * lastbt=[buttons lastObject];
    if(lastbt)//计算宽度
    {
        width+=lastbt.frame.origin.x+lastbt.frame.size.width;
    }
    else
    {
        width=0;
    }
    CGRect frame=button.frame;
    
    frame.origin.x=width;
    frame.origin.y=0;
    button.frame=frame;
    button.titleLabel.font=[UIFont systemFontOfSize:20];
    //添加按钮到滚动视图
    [self addSubview:button];
    //把按钮放入集合
    [buttons addObject:button];
    //调节滚动范围
    if(width>self.frame.size.width)
    {
        self.contentSize=CGSizeMake(width+button.frame.size.width+5, 38);
    }
    
    
}
-(void)clearcolor
{
    for(UIButton * btn in buttons)
    {
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.backgroundColor=nil;
    }
}


@end
