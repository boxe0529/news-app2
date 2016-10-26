//
//  AppDelegate.h
//  新闻客户端2
//
//  Created by 邓云方 on 15/10/7.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fmdb/FMDatabase.h"
#import "detailViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    detailViewController * detail;
}
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) FMDatabase * db;

@end

