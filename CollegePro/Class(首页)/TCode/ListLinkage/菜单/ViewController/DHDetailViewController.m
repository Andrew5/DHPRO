//
//  DHDetailViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/7/15.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "DHDetailViewController.h"
#import "MedalModel.h"

@interface DHDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableViewMy;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger lastSection; // 上次界面上第一个cell所在的section
@property (nonatomic, assign) BOOL selectScroll; // 滚动视图滚动是否是由左侧选中菜品种类所触发

@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation DHDetailViewController


#pragma  mark - Lazy Load
- (UITableView *)tableViewMy
{
    if (!_tableViewMy) {
        _tableViewMy = [[UITableView alloc]init];
        _tableViewMy.dataSource = self;
        _tableViewMy.delegate = self;
        
    }
    return _tableViewMy;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"Detail" ofType:@"plist"];
        _dataSource = [NSArray arrayWithContentsOfFile:path];
        [_tableViewMy reloadData];
    }
    return _dataSource;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableViewMy];
    [self.tableViewMy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_offset(0);
    }];
    [self dataSource];

}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *members = self.dataSource[section][@"members"];
    return members.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    
    //    MedalModel *model = self.arr[indexPath.section][@"members"][indexPath.row];
    //    cell.textLabel.text = model.name;
    //    cell.detailTextLabel.text = model.dataStr;
    
    NSDictionary *member = self.dataSource[indexPath.section][@"members"][indexPath.row];
    cell.textLabel.text = member[@"name"];
    cell.detailTextLabel.text = member[@"price"];
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.dataSource[section][@"name"];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 拖动视图，说明视图滚动不是由选择左侧菜品所触发的
    self.selectScroll = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 滚动是由选择左侧菜品所导致的，则直接返回
    if (self.selectScroll) {
        return;
    }
    // 下面是由拖动视图，导致视图滚动
    NSIndexPath *indexPath = [self.tableViewMy indexPathsForVisibleRows].firstObject;
    NSInteger section = indexPath.section;
    // 如果此次要选中的row和已经选中的row相同，则不进行下面的选中处理
    if (section != self.lastSection ) {
        self.lastSection = section;
        // 让左侧菜品列表选中相应的菜品
        if (_delegate && [_delegate respondsToSelector:@selector(tableViewSelectRowAtIndexPath:animated:scrollPosition:)]) {
            indexPath = [NSIndexPath indexPathForRow:section inSection:0];
            [_delegate tableViewSelectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionTop)];
        }
    }
}

#pragma mark - Public Methods
// 选中左侧不同的菜品时，右侧滚动视图滚动到相应的位置
- (void)tableViewScrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    self.selectScroll = YES;
    [self.tableViewMy scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
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
