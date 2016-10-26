//
//  twoTableViewController.m
//  新闻客户端2
//
//  Created by 邓云方 on 15/10/9.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "twoTableViewController.h"
#import "DYFNews.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "detailViewController.h"
@interface twoTableViewController ()

@end

@implementation twoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"排行榜";
    self.allnews=[[NSMutableArray alloc]initWithCapacity:100];
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeGradient];
    
    //网络判定及加载数据
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status= [reach currentReachabilityStatus];
    if(status==NotReachable)
    {
        [self loadLocalData];
        //NSLog(@"没有网络");
    }
    else
    {
        [self loadData];
    }
    [SVProgressHUD dismiss];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)loadData
{
    [self.allnews removeAllObjects];
    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * db=app.db;
    [db executeUpdate:@"delete from orders"];
   // NSString * strurl=[NSString stringWithFormat:@"http://127.0.0.1/news/getorders.php"];
   
    NSURL * url=[NSURL URLWithString:@"http://127.0.0.1/news/getorders.php"];
    NSURLRequest * request=[NSURLRequest requestWithURL:url];
    //同步请求 使用数据量小
    NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data!=nil)
    {
        //对数据进行json解析 到数组上
        NSArray * news=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if(!news)
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"  " message:@"新闻加载失败，请稍后再试" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        NSLog(@" %lu ",(unsigned long)[news count]);
        if([news count]>0)
        {
            for( NSDictionary * dict in news)
            {
                // NSLog(@"%@",dict);
                NSArray * keys=[dict allKeys];
                DYFNews * xinwen=[[DYFNews alloc]init];
                
                for(NSString * str in keys)
                {
                    //NSLog(@"%@",str);
                    //对对象对属性一一赋值
                    [xinwen setValue:[dict objectForKey:str] forKey:str];
                }
                [self.allnews addObject:xinwen];
                NSString * imgName=[NSString stringWithFormat:@"http://127.0.0.1/news/images/%@",xinwen.picture];
                NSURL * ur=[NSURL URLWithString:imgName];
                NSURLRequest * request1=[NSURLRequest requestWithURL:ur];
                NSData * data=[NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
                xinwen.img=[UIImage imageWithData:data];
                //NSLog(@"%@",imgName);
                
                BOOL b=[db executeUpdate:@"insert into orders(iid,title,subtitle,picture,content,author,fl,time,clicks,pic) values(?,?,?,?,?,?,?,?,?,?)",xinwen.iid,xinwen.title,xinwen.subtitle,xinwen.picture,xinwen.content,xinwen.author,xinwen.fl,xinwen.time,xinwen.clicks,data];
                
                if(!b)
                {
                    NSLog(@"insert failed");
                }
            }
            
            /*for(DYFNews * n in self.allnews)
             {
             NSLog(@"%@",n.title);
             }*/
            //NSLog(@"%@",self.allnews);
        }
        [self.tableView reloadData];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"  " message:@"新闻加载失败，请稍后再试" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}
-(void)loadLocalData
{
    [self.allnews removeAllObjects];
    //NSLog(@"loadLocalData");
    //获得数据库的对象
    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * db=app.db;
    FMResultSet * rs= [db executeQuery:@"select * from orders"];
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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailViewController * detail=[[detailViewController alloc]initWithNibName:nil bundle:nil];
    //导航视图进占视图
    detail.newss =self.allnews[indexPath.row];
    
    NSString * strurl=[NSString stringWithFormat:@"http://127.0.0.1/news/show2.php?iid=%d",(int)detail.newss.iid];
    
    NSURL * url=[NSURL URLWithString:strurl];
    NSURLRequest * request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    [self.navigationController pushViewController:detail animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
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
    
    /*
     NSString * imgName=[NSString stringWithFormat:@"http://127.0.0.1/news/images/%@",new.picture];
     //NSLog(@"%@",imgName);
     NSURL * ur=[NSURL URLWithString:imgName];
     NSURLRequest * request1=[NSURLRequest requestWithURL:ur];
     NSData * data=[NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
     
     UIImage * img=[[UIImage alloc]initWithData:data];*/
 
    return cell;
}


@end
