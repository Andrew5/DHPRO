//
//  MVPViewController.m
//  MVPDemo
//
//  Created by Cooci on 2018/3/31.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "MVPViewController.h"
#import "LMDataSource.h"
#import "MVPTableViewCell.h"
#import "Model.h"

#import "Present.h"

static NSString *const reuserId = @"reuserId";

@interface MVPViewController ()<UITableViewDelegate,PresentDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Present *pt;
@property (nonatomic, strong) LMDataSource *dataSource;

@end

@implementation MVPViewController
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[MVPTableViewCell class] forCellReuseIdentifier:reuserId];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pt = [[Present alloc] init];
    __weak typeof(self) weakSelf = self;
    //-------------tableView相关操作
    /**
     cellConfigureBefore:cell的数据设置
     selectBlock: 点击cell的回掉
     reloadData: 删除数据、添加数据后的回掉
     */
    self.dataSource = [[LMDataSource alloc] initWithIdentifier:reuserId configureBlock:^(MVPTableViewCell *cell, Model *model, NSIndexPath *indexPath) {
        
        cell.nameLabel.text = model.name;
        cell.numLabel.text  = model.num;
        cell.num = [model.num intValue];
        cell.indexPath      = indexPath;
        cell.delegate       = weakSelf.pt;
    } selectBlock:^(NSIndexPath *indexPath) {
        NSLog(@"点击了%ld行cell", (long)indexPath.row);
    } reloadData:^(NSMutableArray *array) {
        weakSelf.pt.dataArray = [array copy];
        [weakSelf reloadDataForUI];
    }];
    
    [self.dataSource addDataArray:self.pt.dataArray];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    //Present代理设置
    self.pt.delegate          = self;
    
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"合计:%d",[self.pt total]];
}

#pragma mark - PresentDelegate
- (void)reloadDataForUI{
    [self.dataSource addDataArray:self.pt.dataArray];
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"合计:%d",[self.pt total]];
}



- (void)didReceiveMemoryWarning {
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

@end
