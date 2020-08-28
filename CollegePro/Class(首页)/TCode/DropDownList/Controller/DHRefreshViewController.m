//
//  DHRefreshViewController.m
//  CollegePro
//
//  Created by jabraknight on 2020/1/31.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHRefreshViewController.h"
#import "TopicItem.h"
#import "MJExtension.h"

@interface DHRefreshViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) AFHTTPSessionManager *mgr;

/** 全部的帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;

/******** 下拉刷新-header ********/
/** 下拉刷新控件 */
@property (nonatomic, strong) UIView *header;
/** 下拉刷新控件里面的文字 */
@property (nonatomic, strong) UILabel *headerLabel;
/** 是否为"松开立即刷新" */
@property(nonatomic, assign, getter=isWillLoadingNewData) BOOL willLoadingNewData;
/** 是否为"正在刷新" */
@property(nonatomic, assign, getter=isLoadingNewData) BOOL loadingNewData;
/******** 下拉刷新-header ********/

/******** 上拉刷新-footer ********/
/** 上拉刷新控件 */
@property (nonatomic, strong) UIView *footer;
/** 上拉刷新控件里面的文字 */
@property (nonatomic, strong) UILabel *footerLabel;
/** 是否正在加载更多数据 */
@property(nonatomic, assign, getter=isLoadingMoreData) BOOL loadingMoreData;
/******** 上拉刷新-footer ********/

@property (nonatomic,strong)UITableView *mainTableView;

@end

@implementation DHRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRefresh];
    // Do any additional setup after loading the view.
}
- (void)createRefresh{
    _mainTableView = [[UITableView alloc]init];
    _mainTableView.frame = CGRectMake(0, 0, DH_DeviceWidth, DH_DeviceHeight);
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.estimatedRowHeight = 50;
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.tableFooterView = [UIView new];
//    [_mainTableView registerClass:[<#UITableViewCell#> class] forCellReuseIdentifier:@"<#UITableViewCell#>"];
    [self.view addSubview:_mainTableView];
    self.mainTableView.contentInset = UIEdgeInsetsMake(61, 0, 0, 0);
    
    // 集成刷新控件
    [self setUpRefresh];
    
    [self loadNewTopics];
}
/**
 * 集成刷新控件
 */
- (void)setUpRefresh
{
    // 下拉刷新:加载最新的数据
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor yellowColor];
    header.height = 60;
    header.width = self.mainTableView.width;
    header.y = - header.height;
    [self.mainTableView addSubview:header];
    self.header = header;
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = @"下拉可以刷新";
    headerLabel.width = self.mainTableView.width;
    headerLabel.height = header.height;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:headerLabel];
    self.headerLabel = headerLabel;
    
    // 上拉刷新:加载更多的数据
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor orangeColor];
    footer.height = 35;
    footer.hidden = YES;
    self.mainTableView.tableFooterView = footer;
    self.footer = footer;
    
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.text = @"上拉可以加载更多";
    footerLabel.width = self.mainTableView.width;
    footerLabel.height = footer.height;
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:footerLabel];
    self.footerLabel = footerLabel;
}

#pragma mark - 数据处理
/**
 * 加载最新的帖子数据
 */
- (void)loadNewTopics
{
    NSDictionary *parameters;
    parameters = @{@"Url":@"http://kaifa.homesoft.cn/WebService/jsonInterface.ashx",
                   @"MethodType":@"GET",
                   @"Value":@"?json=GetUserInfoAll&UserID=2"
                   };
    self.mgr = [AFHTTPSessionManager manager];
    self.mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//                manager.requestSerializer= [AFJSONRequestSerializer serializer];
    self.mgr.requestSerializer.timeoutInterval = 30.0f;
    self.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    [self.mgr POST:@"https://www.homesoft.cn/WebInterface/HBInterface.ashx" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"请求进度 - %@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        // 字典数组 -> 模型数组
        self.topics = [TopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 刷新表格
        [self.mainTableView reloadData];
        
        // 结束刷新
        self.loadingNewData = NO;
        // 恢复顶部的内边距
        [UIView animateWithDuration:0.25 animations:^{
            UIEdgeInsets inset = self.mainTableView.contentInset;
            inset.top -= self.header.height;
            self.mainTableView.contentInset = inset;
        }];
        
        // 有数据了
        self.footer.hidden = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败 - %@", error);
        // 结束刷新
        self.loadingNewData = NO;
        // 恢复顶部的内边距
        [UIView animateWithDuration:0.25 animations:^{
            UIEdgeInsets inset = self.mainTableView.contentInset;
            inset.top -= self.header.height;
            self.mainTableView.contentInset = inset;
        }];
    }];
 
}

/**
 * 加载更多的帖子数据
 */
- (void)loadMoreTopics
{
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @"1";
    parameters[@"maxtime"] = self.maxtime;
    
    // 发送请求
    [self.mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数组
        NSArray *moreTopics = [TopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:moreTopics];
        
        // 刷新表格
        [self.mainTableView reloadData];
        
        // 结束刷新
        self.loadingMoreData = NO;
        self.footerLabel.text = @"上拉可以加载更多";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败 - %@", error);
        
        // 结束刷新
        self.loadingMoreData = NO;
        self.footerLabel.text = @"上拉可以加载更多";
    }];
}

#pragma mark - 代理方法
/**
 * 当scrollView在滚动,就会调用这个代理方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 处理下拉刷新
    [self dealLoadNewData];
    
    // 处理上拉加载更多
    [self dealLoadMoreData];
}

/**
 * 当用户手松开(停止拖拽),就会调用这个代理方法
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.willLoadingNewData == NO || self.loadingNewData) return;
    
    // 增加顶部的内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.mainTableView.contentInset;
        inset.top += self.header.height;
        self.mainTableView.contentInset = inset;
    }];
    
    // 修改文字
    self.headerLabel.text = @"正在刷新数据...";
    
    // 正在刷新
    self.loadingNewData = YES;
    
    // 发送请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadNewTopics];
    });
}

/**
 * 处理下拉刷新
 */
- (void)dealLoadNewData
{
    if (self.loadingNewData) return;
    
    CGFloat offsetY =  - (64 + self.header.height);
    if (self.mainTableView.contentOffset.y <= offsetY) {
        self.headerLabel.text = @"松开立即刷新";
        self.willLoadingNewData = YES;
    } else {
        self.headerLabel.text = @"下拉可以刷新";
        self.willLoadingNewData = NO;
    }
}

/**
 * 处理上拉加载更多
 */
- (void)dealLoadMoreData
{
    // 如果没有数据 或者 正在上拉刷新, 直接返回
    if (self.topics.count == 0 || self.loadingMoreData) return;
    
    CGFloat offsetY = self.mainTableView.contentSize.height + self.mainTableView.contentInset.bottom - self.mainTableView.height;
    if (self.mainTableView.contentOffset.y >= offsetY) {
        self.loadingMoreData = YES;
        
        // 更改文字
        self.footerLabel.text = @"正在加载更多的数据...";
        
        // 加载更多的帖子数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadMoreTopics];
        });
    }
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    TopicItem *item = self.topics[indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.text;
    
    return cell;
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
