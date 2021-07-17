//
//  AutoRecScrollerViewController.m
//  CollegePro
//
//  Created by jabraknight on 2021/7/11.
//  Copyright © 2021 jabrknight. All rights reserved.
//  以下代码由 磊哥 提供

#import "AutoRecScrollerViewController.h"
#import "RecFifTableViewCell.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
@interface AutoRecScrollerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tabelView;
@end

@implementation AutoRecScrollerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-88)style:UITableViewStyleGrouped];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    self.tabelView.backgroundColor= [UIColor whiteColor];
    self.tabelView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tabelView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tabelView];
    [self.tabelView registerClass:[RecFifTableViewCell class] forCellReuseIdentifier:@"RecFifTableViewCell"];
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
//区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 290;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecFifTableViewCell *fourthCell = [tableView dequeueReusableCellWithIdentifier:@"RecFifTableViewCell"];
    fourthCell.selectionStyle = 0;
    return fourthCell;
}

#define headerHeight 92*PIX
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView*headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    return headerView;
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
