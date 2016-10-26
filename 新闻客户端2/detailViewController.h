//
//  detailViewController.h
//  新闻客户端2
//
//  Created by 邓云方 on 15/10/8.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYFNews.h"
@interface detailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titlelable;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UITextView *content;

@property (strong, nonatomic) DYFNews * newss;
@end
