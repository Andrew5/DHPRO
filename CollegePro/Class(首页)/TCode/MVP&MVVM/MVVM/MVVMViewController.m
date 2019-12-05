//
//  MVVMViewController.m
//  003--MVP
//
//  Created by chriseleee on 2018/8/29.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "MVVMViewController.h"

#import "LMDataSource.h"
#import "MVPTableViewCell.h"
#import "Model.h"
#import "MVVMViewModel.h"

static NSString *const reuserId = @"reuserId1";

@interface MVVMViewController ()<UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MVVMViewModel *vm;
@property (nonatomic, strong) LMDataSource *dataSource;


@end

@implementation MVVMViewController

#pragma mark lazy
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"合计：" style:(UIBarButtonItemStyleDone) target:self action:nil];
    
    __weak __typeof(self) weakSelf = self;
    
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
        cell.delegate       = weakSelf.vm;
    } selectBlock:^(NSIndexPath *indexPath) {
        NSLog(@"点击了%ld行cell", (long)indexPath.row);
    } reloadData:^(NSMutableArray *array) {
        weakSelf.vm.dataArray = array;
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    
   
    //--------------ViewModel的操作
    self.vm = [[MVVMViewModel alloc]init];
    [self.vm initWithBlock:^(id data) {

        weakSelf.dataSource.dataArray = [weakSelf.vm.dataArray mutableCopy];
        [weakSelf.tableView reloadData];
        weakSelf.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"合计:%d",[weakSelf.vm total]];
        
        
    } fail:nil];
    
    
    //加载数据
    [self.vm loadData];

}


-(void)dealloc{
    NSLog(@"dealloc--%@",self);
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
