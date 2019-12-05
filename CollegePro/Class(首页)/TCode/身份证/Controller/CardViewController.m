//
//  CardViewController.m
//  Test
//
//  Created by Rillakkuma on 16/7/12.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "CardViewController.h"
#import "myCell.h"
@interface CardViewController ()

@end

@implementation CardViewController
@synthesize array;
@synthesize month;
@synthesize imageName;
@synthesize title;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    NSDictionary * dic1 = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BabyCard" ofType:@"plist"]];
    self.array = [dic1 objectForKey:month];
    NSDictionary * dic2 = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Title" ofType:@"plist"]];
    titleArray = [[NSMutableArray alloc] init];
    titleArray = [dic2 objectForKey:title];
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(10, 10, 25, 31);
    [back setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [tableView addSubview:back];
}
#pragma -mark -doClickActions
-(void)back{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.7;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:animation forKey:@"animation"];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma -mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * str = [array objectAtIndex:indexPath.row];
    CGSize size=[str boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0]} context:nil].size;
    if(indexPath.row == 0)    {
    return size.height + 350;
    }
    else    {
        return size.height + 60;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    myCell * cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if(cell == nil){
    
        cell = [[myCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id"];
    }
    NSString * str = [array objectAtIndex:indexPath.row];
    CGSize size=[str boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0]} context:nil].size;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString * str2 = [NSString stringWithFormat:@" %@ ",[titleArray objectAtIndex:indexPath.row]];    CGSize size2=[str boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]} context:nil].size;
    cell.title.text = str2;
    if(indexPath.row == 0){
        cell.myImageView.hidden = NO;
        cell.myImageView.image = [UIImage imageNamed:imageName];
        cell.myImageView.frame = CGRectMake(0, 0, 320, 300);
        cell.myLabel.frame = CGRectMake(10, 350, 300, size.height);
        cell.title.frame = CGRectMake(10, 310, size2.width, 30);
    }else{
        cell.myImageView.hidden = YES;
        cell.myLabel.frame = CGRectMake(10, 50, 300, size.height);
        cell.title.frame = CGRectMake(10, 10,size2.width, 30);
    }
    cell.myLabel.text = str;
    return cell;
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
