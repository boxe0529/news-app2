//
//  AppDelegate.m
//  新闻客户端2
//
//  Created by 邓云方 on 15/10/7.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "AppDelegate.h"
#import "mainNav.h"
#import "oneTableViewController.h"
#import "twoTableViewController.h"
#import "threeViewController.h"
#import "fourTableViewController.h"
#import "fmdb/FMDatabase.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor redColor];
    oneTableViewController * one=[[oneTableViewController alloc]init];
    twoTableViewController * two=[[twoTableViewController alloc]init];
    threeViewController * three=[[threeViewController alloc]init];
    fourTableViewController * four=[[fourTableViewController alloc]init];
    UINavigationController * nav1=[[UINavigationController alloc]initWithRootViewController:one];
    UINavigationController * nav2=[[UINavigationController alloc]initWithRootViewController:two];
    UINavigationController * nav3=[[UINavigationController alloc]initWithRootViewController:three];
    UINavigationController * nav4=[[UINavigationController alloc]initWithRootViewController:four];
    mainNav * mainview=[[mainNav alloc]init];
    mainview.viewControllers=[NSArray arrayWithObjects:nav1,nav2,nav3,nav4, nil];
    nav1.tabBarItem.title=@"新闻";
    nav1.tabBarItem.image=[UIImage imageNamed:@"tab_0.png"];
    nav2.tabBarItem.title=@"排行榜";
    nav2.tabBarItem.image=[UIImage imageNamed:@"tab_1.png"];
    nav3.tabBarItem.title=@"搜索";
    nav3.tabBarItem.image=[UIImage imageNamed:@"tab_2.png"];
    nav4.tabBarItem.title=@"收藏";
    nav4.tabBarItem.image=[UIImage imageNamed:@"tab_3.png"];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithWhite:1 alpha:0.8]];
    [[UINavigationBar appearance] setTintColor:[UIColor blueColor]];
    self.window.rootViewController=mainview;
    
    NSArray * paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
   // NSURL * url=[NSURL ur];
    path=[path stringByAppendingPathComponent:@"news.db"];
    self.db=[FMDatabase databaseWithPath:path];
    BOOL b=[self.db open];
    if(!b)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"open failed" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    NSString * sql=@"create table if not exists mews(iid integer,title text,subtitle text,picture text,content text,author text,fl integer,time text,clicks integer,pic blob)";
    b=[self.db executeUpdate:sql];
    if(!b)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"create table failed" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    NSLog(@"%@",path);
    
    [self.window makeKeyAndVisible];
        // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
