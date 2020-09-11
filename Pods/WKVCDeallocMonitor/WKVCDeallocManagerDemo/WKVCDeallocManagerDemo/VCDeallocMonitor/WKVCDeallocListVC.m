//
//  WKVCDeallocListVC.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/21.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKVCDeallocListVC.h"
#import "WKVCDeallocManager.h"
#import "WKVCDeallocCell.h"
#import "WKPopImageView.h"
#import "WKLifeCircleRecordListVC.h"
@interface WKVCDeallocListVC ()<UITableViewDelegate,UITableViewDataSource,WKVCDeallocCellDelegate>

@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray<WKDeallocModel *> *datasource;
@property (nonatomic,strong) WKPopImageView * popView;
@property (nonatomic,strong) UIButton * bottomBtn;


@end

@implementation WKVCDeallocListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.datasource = [WKVCDeallocManager sharedVCDeallocManager].warnningModels;
    
    [self.view addSubview:self.bottomBtn];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView reloadData];
    BOOL isWarnning = [WKVCDeallocManager sharedVCDeallocManager].isWarnning;
    self.nav.detailTitle = isWarnning ? @"关闭警告" : @"开启警告";
    self.nav.title = @"未释放VC";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)detailItemClick
{
    BOOL isWarnning = ![WKVCDeallocManager sharedVCDeallocManager].isWarnning;
    [WKVCDeallocManager sharedVCDeallocManager].isWarnning = isWarnning;
    self.nav.detailTitle = isWarnning ? @"关闭警告" : @"开启警告";
}

- (UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, WK_NAVIGATION_STATUS_HEIGHT, WK_SCREEN_WIDTH, WK_SCREEN_HEIGHT - WK_NAVIGATION_STATUS_HEIGHT - 40) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[WKVCDeallocCell class] forCellReuseIdentifier:@"WKVCDeallocCell"];
    }
    return _mainTableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKVCDeallocCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WKVCDeallocCell"];
    cell.model = self.datasource[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKDeallocModel * model = (WKDeallocModel *)[self.datasource objectAtIndex:indexPath.row];
    if (model.releaseTime > 0) {
        WKLifeCircleRecordListVC * vc = [WKLifeCircleRecordListVC new];
        vc.model = model;
        if (self.navigationController) {
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    else
    {
        self.popView.img = model.img;
        [self.popView showInView:self.view isShow:YES];
    }


}

- (NSMutableArray<WKDeallocModel *> *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (WKPopImageView *)popView
{
    if (!_popView) {
        _popView = [WKPopImageView new];
    }
    return _popView;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_bottomBtn setTitle:@"查看所有VC" forState:(UIControlStateNormal)];
        [_bottomBtn setTitle:@"查看未释放的VC" forState:(UIControlStateSelected)];
        [_bottomBtn setBackgroundColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1]];
        [_bottomBtn addTarget:self action:@selector(changeModel:) forControlEvents:(UIControlEventTouchUpInside)];
        _bottomBtn.frame = CGRectMake(0, WK_SCREEN_HEIGHT - 40, WK_SCREEN_WIDTH, 40);
    }
    return _bottomBtn;
}



- (void)changeModel:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.nav.title = sender.selected ? @"所有VC" : @"未释放VC";
    self.datasource = sender.selected ? [WKVCDeallocManager sharedVCDeallocManager].models : [WKVCDeallocManager sharedVCDeallocManager].warnningModels;
    [self.datasource sortUsingComparator:^NSComparisonResult(WKDeallocModel  *_Nonnull obj1, WKDeallocModel * _Nonnull obj2) {
        return obj1.isNeedRelease < obj2.isNeedRelease;
    }];
    [self.mainTableView reloadData];
}


- (void)clickWithImg:(UIImage *)img
{
    if (img) {
        self.popView.img = img;
        [self.popView showInView:self.view isShow:YES];
    }
    
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
