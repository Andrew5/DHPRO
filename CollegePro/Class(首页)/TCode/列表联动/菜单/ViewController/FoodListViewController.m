//
//  FoodListViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/7/5.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "FoodListViewController.h"
#import "DHDetailViewController.h"

@interface FoodListViewController ()<UITableViewDataSource, UITableViewDelegate,DHDetailDelegate>
//私有变量,不可以被子类调用，也不可以外部访问.
@property (nonatomic, strong) UITableView *tableView; // 菜单菜品种类列表
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) DHDetailViewController *detailController; // 菜单详情列表

@end

@implementation FoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowleftBtn = NO;
    // 为了不让系统自动调整滚动视图
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"国轩叫你喝粥了";
    self.tableView = [[UITableView alloc]init];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_offset(0);
        make.width.mas_equalTo(100.0);
    }];
    
    self.detailController = [[DHDetailViewController alloc]init];
    self.detailController.delegate = self;
    [self.view addSubview:self.detailController.view];
    [self.detailController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.tableView);
        make.left.mas_equalTo(self.tableView.mas_right);
        make.right.mas_offset(0);
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 开始选中第一行 ("冰粥")
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:0 scrollPosition:(UITableViewScrollPositionTop)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
#pragma mark - GXDetailDelegate
// 滚动菜单右侧滚动视图时，左侧菜品列表选中相应的菜品
- (void)tableViewSelectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    // 选中左侧不同的菜品时，右侧滚动视图滚动到相应的位置
    [self.detailController tableViewScrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"冰粥",@"原味粥",@"甜粥",@"咸粥",@"小咸菜",@"凉菜"];
    }
    return _dataSource;
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
