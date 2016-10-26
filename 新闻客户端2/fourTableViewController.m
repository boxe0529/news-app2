//
//  fourTableViewController.m
//  新闻客户端2
//
//  Created by 邓云方 on 15/10/9.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "fourTableViewController.h"
#import "DYFNews.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "AppDelegate.h"
#import "detailViewController.h"
#import "MJRefresh/MJRefresh.h"
@interface fourTableViewController ()
@property (assign,nonatomic) int a0;
@property (assign,nonatomic) int a;
@end

@implementation fourTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"收藏";
     self.allnews=[[NSMutableArray alloc]initWithCapacity:100];
    [self loadLocalData];
    self.a=12;self.a0=0;
    [self.tableView addHeaderWithTarget: self action:@selector(refreshtap)];
    //下拉加载 分页功能
    [self.tableView addFooterWithTarget:self action:@selector(jiazaitap)];
    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * db=app.db;
    FMResultSet * rs= [db executeQuery:@"select * from saves limit ?,?",[NSNumber numberWithInt:self.a0],[NSNumber numberWithInt:self.a]];
    while ([rs next])
    {
        DYFNews * xinwen=[[DYFNews alloc]init];
        
        xinwen.title=[rs stringForColumn:@"title"];
        xinwen.subtitle=[rs stringForColumn:@"subtitle"];
        xinwen.content=[rs stringForColumn:@"content"];
        xinwen.iid=[NSNumber numberWithInt:[rs intForColumn:@"iid"]];
        xinwen.author=[rs stringForColumn:@"author"];
        xinwen.picture=[rs stringForColumn:@"picture"];
        xinwen.clicks=[NSNumber numberWithInt:[rs intForColumn:@"clicks"]];
        xinwen.fl=[NSNumber numberWithInt:[rs intForColumn:@"fl"]];
        xinwen.time=[rs stringForColumn:@"time"];
        //NSData * data=[rs dataNoCopyForColumn:@"pic"];
        xinwen.img=[UIImage imageWithData:[rs dataNoCopyForColumn:@"pic"]];
        [self.allnews addObject:xinwen];
    }
    [self.tableView reloadData];
}
-(void)jiazaitap
{
    self.a0= 0;
    self.a=self.a+5;
     [self loadLocalData];
    [self.tableView footerEndRefreshing];
}
-(void)refreshtap
{
    self.a0=0;self.a=12;
    [self loadLocalData];
    [self.tableView headerEndRefreshing];
   
}
-(void)loadLocalData
{
    [self.allnews removeAllObjects];
    //NSLog(@"loadLocalData");
    //获得数据库的对象
    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * db=app.db;
    FMResultSet * rs= [db executeQuery:@"select * from saves limit ?,?",[NSNumber numberWithInt:self.a0],[NSNumber numberWithInt:self.a]];
    while ([rs next])
    {
        DYFNews * xinwen=[[DYFNews alloc]init];
        
        xinwen.title=[rs stringForColumn:@"title"];
        xinwen.subtitle=[rs stringForColumn:@"subtitle"];
        xinwen.content=[rs stringForColumn:@"content"];
        xinwen.iid=[NSNumber numberWithInt:[rs intForColumn:@"iid"]];
        xinwen.author=[rs stringForColumn:@"author"];
        xinwen.picture=[rs stringForColumn:@"picture"];
        xinwen.clicks=[NSNumber numberWithInt:[rs intForColumn:@"clicks"]];
        xinwen.fl=[NSNumber numberWithInt:[rs intForColumn:@"fl"]];
        xinwen.time=[rs stringForColumn:@"time"];
        //NSData * data=[rs dataNoCopyForColumn:@"pic"];
        xinwen.img=[UIImage imageWithData:[rs dataNoCopyForColumn:@"pic"]];
        [self.allnews addObject:xinwen];
    }
    [self.tableView reloadData];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.allnews.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator ;
    }
    DYFNews * new=self.allnews[indexPath.row];
    cell.textLabel.text=new.title;
    cell.detailTextLabel.text=new.subtitle;
    cell.imageView.image=new.img;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailViewController * detail=[[detailViewController alloc]initWithNibName:nil bundle:nil];
    //导航视图进占视图
    detail.newss =self.allnews[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
    
}


@end
