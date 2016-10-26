//
//  detailViewController.m
//  新闻客户端2
//
//  Created by 邓云方 on 15/10/8.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "detailViewController.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "AppDelegate.h"
@interface detailViewController ()

@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"新闻内容";
    UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStyleDone target:self action:@selector(soucang:)];
    self.navigationItem.rightBarButtonItem=right;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)soucang:(id)sender
{
  AppDelegate * app=  [UIApplication sharedApplication].delegate;
    FMDatabase *db=app.db;
    
     NSString *sql=[NSString stringWithFormat:@"select count(*) as rows from saves where iid=%@",self.newss.iid];
    FMResultSet * rs=[db executeQuery:sql];
    [rs next];
    int rscount=[rs intForColumn: @"rows"];
    if(rscount >0)
    {
        [SVProgressHUD showSuccessWithStatus:@"已经收藏！"];
        NSLog(@"已经收藏");
        [SVProgressHUD dismiss];
        return;
    }
    
    NSString *sql1=[NSString stringWithFormat:@"select pic from mews where iid=%@",self.newss.iid];
    FMResultSet * rs1=[db executeQuery:sql1];
    [rs1 next];
    NSData * data=[rs1 dataForColumn:@"pic"];
    BOOL b=[db executeUpdate:@"insert into saves(iid,title,subtitle,picture,content,author,fl,time,clicks,pic) values(?,?,?,?,?,?,?,?,?,?)",self.newss.iid,self.newss.title,self.newss.subtitle,self.newss.picture,self.newss.content,self.newss.author,self.newss.fl,self.newss.time,self.newss.clicks,data];
    
    if(!b)
    {
        NSLog(@"insert failed");
    }
    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
    [SVProgressHUD dismiss];

    
}
-(void)viewDidAppear:(BOOL)animated
{
    self.titlelable.text=self.newss.title;
    self.author.text=self.newss.author;
    self.content.text=self.newss.content;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
