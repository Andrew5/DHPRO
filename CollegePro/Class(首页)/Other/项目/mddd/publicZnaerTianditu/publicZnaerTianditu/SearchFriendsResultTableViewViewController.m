//
//  SearchFriendsResultTableViewViewController.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/6.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "SearchFriendsResultTableViewViewController.h"
#import "FriendEntity.h"
#import "UIImageView+AFNetworking.h"
#import "FriendInfoViewController.h"
#import "BaseHandler.h"
@interface SearchFriendsResultTableViewViewController ()

@end

@implementation SearchFriendsResultTableViewViewController

#define CELL_HEIGHT 60.0f

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"查找好友"];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
  
    
    //去除多余的分割线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];

    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.imageView.frame = CGRectMake(0, 0, 55, 55);
        cell.imageView.layer.cornerRadius = 5.0f;
        cell.imageView.layer.masksToBounds = YES;
    }
    
    FriendEntity *friend = [self.data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = friend.equipName;
    
    NSString *placeHolderHead = (friend.gender == SEXMAN ? @"user_man.png" : @"user_woman.png");
    
    NSString *imageUrl = [BaseHandler retImageUrl:friend.equipIcon];
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    [cell.imageView setImageWithURL:url
                   placeholderImage:[UIImage imageNamed:placeHolderHead]];
    
   
    /**---------这固定imageview大小----------**/
    CGSize itemSize = CGSizeMake(50, 50);
    
    UIGraphicsBeginImageContext(itemSize);
    
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    
    [cell.imageView.image drawInRect:imageRect];
    
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    /**-----------END-------------------**/
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    //查看好友信息
    FriendInfoViewController *infoVC = [[FriendInfoViewController alloc]init];
    self.valueDelegate = infoVC;
    
    [self.valueDelegate setValue:self.data[indexPath.row]];
    
    [self.navigationController pushViewController:infoVC animated:YES];
    
    
}

#pragma mark - PassValueDelegate
- (void)setValue:(NSObject *)value{
    
    self.data = (NSArray *)value;
  
    [self.tableView reloadData];
}
@end
