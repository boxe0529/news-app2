//
//  DYFNews.h
//  新闻客户端
//
//  Created by 邓云方 on 15/10/7.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DYFNews : NSObject
@property (strong,nonatomic) NSNumber *clicks;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *subtitle;
@property (strong,nonatomic) NSString *picture;
@property (strong,nonatomic) NSString *time;
@property (strong,nonatomic) NSString *author;
@property (strong,nonatomic) NSNumber *iid;
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) NSNumber * fl;
@property (strong,nonatomic) UIImage * img;
@end
