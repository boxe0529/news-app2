//
//  oneTableViewController.m
//  新闻客户端2
//
//  Created by 邓云方 on 15/10/7.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "oneTableViewController.h"
#import "HScrollview.h"
#import "DYFNews.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "detailViewController.h"
#import "MJRefresh/MJRefresh.h"
@interface oneTableViewController ()
{
    FMResultSet *rs;
   
}
@property(assign,nonatomic)int fl;
@end

@implementation oneTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"新闻";
    //创建定制的滚动视图
    HScrollview * hv=[[HScrollview alloc]init];
    //设定位置和大小
    hv.frame=CGRectMake(0, 20, 450, 38);
    //hv.backgroundColor=[UIColor redColor];
    hv.backgroundColor=[UIColor colorWithWhite:1 alpha:0];
    
    arr=[NSArray arrayWithObjects:@"新闻",@"国内",@"国际",@"社会",@"军事", @"科技",@"游戏",nil];
    for(int i=0;i<7;i++)
    {
        UIButton * b1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [b1 setTitle:arr[i] forState:UIControlStateNormal];
        b1.frame=CGRectMake(0, 0, 55, 30);
        if(i==0)
        {
            
            b1.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
        }
        //b1.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
        [b1 addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        b1.layer.cornerRadius=15;
        b1.tag=i;
        //b1.backgroundColor=[UIColor grayColor];
        [hv addbutton:b1];
    }
    
    self.navigationItem.titleView=hv;
    self.allnews=[[NSMutableArray alloc]initWithCapacity:100];
    //[self.tableView addHeaderWithTarget: self action:@selector(refreshtap)];
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
       [self loadDataWithID:1];
    }
    [SVProgressHUD dismiss];
    //UIBarButtonItem * bbi=[[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refresh:)];
    //self.navigationItem.rightBarButtonItem=bbi;
    //UISegmentedControl * seg=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"新闻",@"国内",@"国际",@"社会",@"军事", nil]];
    //self.navigationItem.titleView=seg;
    // Do any additional setup after loading the view.
    /*self.view.backgroundColor=[UIColor redColor];
     self.navigationItem.title=@"收藏";*/
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

-(void)tap:(UIButton *)sender

{
    self.fl=(int)sender.tag;
    //NSLog(@"%ld",(long)sender.tag);
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status= [reach currentReachabilityStatus];
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeGradient];
    if(status==NotReachable)
    {
        [self loadLocalData];
        //NSLog(@"没有网络");
    }
    
    else
    {
        [self loadDataWithID:self.fl+1];
    }

   
    [SVProgressHUD dismiss];
    
    HScrollview * hvv=(HScrollview *)self.navigationItem.titleView;
    [hvv clearcolor];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sender.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
}

// Uncomment the following line to preserve selection between presentations.
// self.clearsSelectionOnViewWillAppear = NO;

// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
// self.navigationItem.rightBarButtonItem = self.editButtonItem;


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
     NSLog(@"%lu",(unsigned long)self.allnews.count);
    return self.allnews.count;
    //NSLog(@"%lu",(unsigned long)self.allnews.count);
    
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
  //   NSLog(@"-------%@",self.allnews.count);
    /*
    NSString * imgName=[NSString stringWithFormat:@"http://127.0.0.1/news/images/%@",new.picture];
    //NSLog(@"%@",imgName);
    NSURL * ur=[NSURL URLWithString:imgName];
    NSURLRequest * request1=[NSURLRequest requestWithURL:ur];
    NSData * data=[NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    
    UIImage * img=[[UIImage alloc]initWithData:data];*/
    
    
    // Configure the cell...
    
    return cell;
}

-(void)loadDataWithID:(int)fl
{
    [self.allnews removeAllObjects];
    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * db=app.db;
    NSString * strurl=[NSString stringWithFormat:@"http://127.0.0.1/news/getnews.php?iid=%d",fl];
    NSLog(@" momomomo %@",strurl);
    NSURL * url=[NSURL URLWithString:strurl];
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
              if(self.fl==0)
              {
                   [db executeUpdate:@"delete from mews"];
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
                BOOL b=[db executeUpdate:@"insert into mews(iid,title,subtitle,picture,content,author,fl,time,clicks,pic) values(?,?,?,?,?,?,?,?,?,?)",xinwen.iid,xinwen.title,xinwen.subtitle,xinwen.picture,xinwen.content,xinwen.author,xinwen.fl,xinwen.time,xinwen.clicks,data];
                  }
             
                  
              }
            if(self.fl==1)
              {
                   [db executeUpdate:@"delete from guonei"];
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
                  BOOL b=[db executeUpdate:@"insert into guonei(iid,title,subtitle,picture,content,author,fl,time,clicks,pic) values(?,?,?,?,?,?,?,?,?,?)",xinwen.iid,xinwen.title,xinwen.subtitle,xinwen.picture,xinwen.content,xinwen.author,xinwen.fl,xinwen.time,xinwen.clicks,data];
                  }
                      
              }
            if(self.fl==2)
              {
                   [db executeUpdate:@"delete from guoji"];
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
                  BOOL b=[db executeUpdate:@"insert into guoji(iid,title,subtitle,picture,content,author,fl,time,clicks,pic) values(?,?,?,?,?,?,?,?,?,?)",xinwen.iid,xinwen.title,xinwen.subtitle,xinwen.picture,xinwen.content,xinwen.author,xinwen.fl,xinwen.time,xinwen.clicks,data];
                  }
                      
              }
              if(self.fl==3)
              {
                   [db executeUpdate:@"delete from shehui"];
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
                  BOOL b=[db executeUpdate:@"insert into shehui(iid,title,subtitle,picture,content,author,fl,time,clicks,pic) values(?,?,?,?,?,?,?,?,?,?)",xinwen.iid,xinwen.title,xinwen.subtitle,xinwen.picture,xinwen.content,xinwen.author,xinwen.fl,xinwen.time,xinwen.clicks,data];
                  }
              }
             if(self.fl==4)
              {
                   [db executeUpdate:@"delete from junshi"];
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
                  BOOL b=[db executeUpdate:@"insert into junshi(iid,title,subtitle,picture,content,author,fl,time,clicks,pic) values(?,?,?,?,?,?,?,?,?,?)",xinwen.iid,xinwen.title,xinwen.subtitle,xinwen.picture,xinwen.content,xinwen.author,xinwen.fl,xinwen.time,xinwen.clicks,data];
                  }
                      
              }
             if(self.fl==5)
              {
                   [db executeUpdate:@"delete from keji"];
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
                  BOOL b=[db executeUpdate:@"insert into keji(iid,title,subtitle,picture,content,author,fl,time,clicks,pic) values(?,?,?,?,?,?,?,?,?,?)",xinwen.iid,xinwen.title,xinwen.subtitle,xinwen.picture,xinwen.content,xinwen.author,xinwen.fl,xinwen.time,xinwen.clicks,data];
                  }
              }
            if(self.fl==6)
              {
                   [db executeUpdate:@"delete from youxi"];
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
                  BOOL b=[db executeUpdate:@"insert into youxi(iid,title,subtitle,picture,content,author,fl,time,clicks,pic) values(?,?,?,?,?,?,?,?,?,?)",xinwen.iid,xinwen.title,xinwen.subtitle,xinwen.picture,xinwen.content,xinwen.author,xinwen.fl,xinwen.time,xinwen.clicks,data];
                      
                  }

               }
            
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
   if(self.fl==0)
   {
    rs= [db executeQuery:@"select * from mews"];
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
    }[self.tableView reloadData];
   }
    if(self.fl==1)
    {
    rs= [db executeQuery:@"select * from guonei"];
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
       }[self.tableView reloadData];
    }
    if(self.fl==2)
    {
        rs= [db executeQuery:@"select * from guoji"];
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
        }[self.tableView reloadData];
    }
    if(self.fl==3)
    {
        rs= [db executeQuery:@"select * from shehui"];
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
        }[self.tableView reloadData];
    }
    if(self.fl==4)
    {
        rs= [db executeQuery:@"select * from junshi"];
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
        }[self.tableView reloadData];
    }
    if(self.fl==5)
    {
        rs= [db executeQuery:@"select * from keji"];
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
        }[self.tableView reloadData];
    }
    if(self.fl==6)
    {
        rs= [db executeQuery:@"select * from youxi"];
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
        }[self.tableView reloadData];
        NSLog(@"-------%@",self.allnews.count);
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 100;
}
@end
