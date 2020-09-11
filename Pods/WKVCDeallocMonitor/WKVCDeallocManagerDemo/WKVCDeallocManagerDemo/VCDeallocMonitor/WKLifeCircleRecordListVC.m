//
//  WKLifeCircleRecordListVC.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/22.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKLifeCircleRecordListVC.h"
#import "WKVCLifeCircleRecordManager.h"
#import "WKLifeCircleRecordCell.h"
#import "WKVCDeallocManager.h"
@interface WKLifeCircleRecordListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSArray<WKVCLifeCircleRecordModel *> *datasource;

@end

@implementation WKLifeCircleRecordListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setModel:(WKDeallocModel *)model
{
    _model = model;
    self.nav.title = model.className;
    self.datasource = [WKVCDeallocManager findRecordModelWithDeallocModel:model];
    [self.mainTableView reloadData];

}

- (UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.nav.frame.size.height, WK_SCREEN_WIDTH, WK_SCREEN_HEIGHT - self.nav.frame.size.height) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[WKLifeCircleRecordCell class] forCellReuseIdentifier:@"WKLifeCircleRecordCell"];
    }
    return _mainTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKLifeCircleRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WKLifeCircleRecordCell"];
    cell.model = self.datasource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
