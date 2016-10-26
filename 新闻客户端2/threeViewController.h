//
//  threeViewController.h
//  新闻客户端2
//
//  Created by 邓云方 on 15/10/9.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface threeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *seachtext;
- (IBAction)searchtap:(id)sender;
@property (strong,nonatomic)NSMutableArray * allnews;
- (IBAction)closekey:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
