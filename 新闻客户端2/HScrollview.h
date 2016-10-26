//
//  HScrollview.h
//  新闻客户端
//
//  Created by 邓云方 on 15/10/3.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HScrollview : UIScrollView
{
    NSMutableArray * buttons;//按钮集合
}
-(HScrollview *)init;
-(void)addbutton:(UIButton * )button;

-(void)clearcolor;
@end
