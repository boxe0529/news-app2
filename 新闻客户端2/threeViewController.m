//
//  threeViewController.m
//  新闻客户端2
//
//  Created by 邓云方 on 15/10/9.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "threeViewController.h"
#import "DYFNews.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "Reachability.h"
#import "detailViewController.h"
@interface threeViewController ()

@end

@implementation threeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"搜索新闻";
    self.allnews=[[NSMutableArray alloc]initWithCapacity:100];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allnews.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    NSString * strurl=[NSString stringWithFormat:@"http://127.0.0.1/news/show2.php?iid=%d",(int)detail.newss.iid];
    
    NSURL * url=[NSURL URLWithString:strurl];
    NSURLRequest * request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (IBAction)searchtap:(id)sender {
    [self.allnews removeAllObjects];
    NSString * str=self.seachtext.text;
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(str.length==0)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"搜索内容不能为空" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        self.seachtext.text=@"";
        [self.seachtext becomeFirstResponder];
        return;
    }
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status= [reach currentReachabilityStatus];
    if(status==NotReachable)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"没有可用的网络连接" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        self.seachtext.text=@"";
        [self.seachtext becomeFirstResponder];
        return;

    }
    else
    {
        NSString * str1=[NSString stringWithFormat:@"http://localhost/news/getsearch.php?content=%@",str];
        NSURL * url=[NSURL URLWithString:str1];
        NSLog(@"====%@====",[NSString stringWithFormat:@"http://localhost/news/getsearch.php?content=%@",str]);
        
        NSURLRequest * request=[NSURLRequest requestWithURL:url];
        //同步请求 使用数据量小
        NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if(data==nil)
        {
          UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"  " message:@"没123有响应搜索内容" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
          [alert show];
            

        }
        else
        {
            //对数据进行json解析 到数组上
            NSArray * news=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if(!news)
            {
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"  " message:@"没有新闻" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
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

                }
            }
            //[self.tableview reloadData];
        }
    }
    [self.tableview reloadData];

}
- (IBAction)closekey:(id)sender
{
    
}
@end
