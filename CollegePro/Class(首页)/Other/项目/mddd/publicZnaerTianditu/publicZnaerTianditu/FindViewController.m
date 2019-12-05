//
//  FindViewController.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//
#import "FindViewController.h"
#import "MJRefresh.h"
#import "FriendManagerHandler.h"
#import "SVProgressHUD.h"
#import "MainTabBarController.h"
#import "UIImageView+AFNetworking.h"
#import "ContactsViewController.h"

#define ROW_HEIGHT 60
@implementation FindViewController
{
    FriendManagerHandler *_handler;
    TUserLocation    *_userLocation;
}
@synthesize findView;

-(void)loadView{
    [super loadView];
    
    self.findView = [[FindView alloc]initWithController:self];
    
    [self.view addSubview:self.findView];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setTitle:@"附近的人"];
    
    [self hideLeftBackBtn];
    
    self.findView.tableView.delegate = self;
    self.findView.tableView.dataSource = self;
    
    _handler = [[FriendManagerHandler alloc]init];
    
    __unsafe_unretained FindViewController *safeSelf = self;
    _handler.successBlock = ^(id obj){
        
        int opt = [[obj objectForKey:REQUEST_ACTION]intValue];
        if (opt == SEARCH_NEARY_FRIEND_OPT) {
            safeSelf.datas = [obj objectForKey:RET_RESULT];
        }
        [safeSelf.findView.tableView reloadData];
        [safeSelf.findView.tableView headerEndRefreshing];
    };
    
    [self setupRefresh];
    
    self.findView.baseViewDelegate = self;
}



/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.findView.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.findView.tableView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.findView.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.findView.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.findView.tableView.headerRefreshingText = @"正在加载...";
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
    [self requestData];
}

//请求数据
-(void)requestData{
    
    _userLocation = ((AppDelegate *)[UIApplication sharedApplication].delegate).myLocation;
    
    if (_userLocation == nil) {
        [SVProgressHUD showErrorWithStatus:@"未定位成功，请稍后操作"];
        [self.findView.tableView headerEndRefreshing];
        return;
    }

    
    NSString *lonlat = [NSString stringWithFormat:@"%f,%f",_userLocation.location.coordinate.longitude,_userLocation.location.coordinate.latitude];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:lonlat forKey:@"center"];
    
    [params setObject:[NSString stringWithFormat:@"%d",self.findView.distanceParam] forKey:@"distance"];
    
    if (self.findView.sexParam != all) {
        [params setObject:[NSString stringWithFormat:@"%d",self.findView.sexParam] forKey:@"gender"];
    }
    
    [_handler searchNearFriend:params];
    
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identity = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identity];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identity];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
        imageView.layer.cornerRadius = 5.0f;
        imageView.layer.masksToBounds = YES;
        imageView.tag = 300;
        [cell.contentView addSubview:imageView];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, self.view.bounds.size.width - 100, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.tag = 400;
        [cell.contentView addSubview:titleLabel];
        
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, self.view.bounds.size.width - 100, 15)];
        addressLabel.textColor = [UIColor grayColor];
        addressLabel.font = [UIFont systemFontOfSize:12.0f];
        addressLabel.tag = 500;
        [cell.contentView addSubview:addressLabel];
        
    }
    
    
    NSDictionary *item = self.datas[indexPath.row];
    int gender = [[item objectForKey:@"gender"]intValue];
    NSString *headImage = [item objectForKey:@"equipIcon"];
    NSString *name = [item objectForKey:@"equipName"];
    NSString *address = [item objectForKey:@"address"];
    
    NSString *placeHolderHead = (gender == SEXMAN ? @"user_man.png" : @"user_woman.png");
    
    NSString *imageUrl = [BaseHandler retImageUrl:headImage];
    NSURL *url = [NSURL URLWithString:imageUrl];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:300];
    [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:placeHolderHead]];
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:400];
    nameLabel.text = name;
    
    UILabel *addressLabel = (UILabel *)[cell.contentView viewWithTag:500];
    addressLabel.text = address;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = self.datas[indexPath.row];
    [self.valueDelegate setValue:item];
    
    [(MainTabBarController *)self.tabBarController backFirstVC];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - BaseViewDelegate
-(void)btnClick:(id)obj{
    //条件选择后请求
    [self.findView.tableView headerBeginRefreshing];
}

@end
