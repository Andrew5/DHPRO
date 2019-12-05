//
//  ListContentViewController.m
//  Test
//
//  Created by Rillakkuma on 16/7/27.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//
//http://www.th7.cn/Program/IOS/201501/377135.shtml
//http://www.jianshu.com/p/ec6a037e4c6b
//http://download.csdn.net/download/rhljiayou/6477587
#import "ListContentViewController.h"
#import "UDTableViewCell.h"
@interface ListContentViewController ()<UITableViewDelegate,UITableViewDataSource>
{

}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * selectedRows;

@end

@implementation ListContentViewController
@synthesize selectedRows;
- (void)viewDidLoad {
    [super viewDidLoad];
    selectedRows = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, 300, 460)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UDTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UDTableViewCell"];
    
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(editCell)];
    self.navigationItem.rightBarButtonItem = item;

        // Do any additional setup after loading the view from its nib.
}
- (void)editCell{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing) {
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];//cell可编辑状态右导航切换主题
    }else{//进入不可编辑转态，就是还原了
        [self.navigationItem.rightBarButtonItem setTitle:@"Delete"];
//        if (self.removeList.count>0) {//大于零就进行移除操作
//            //逻辑：1，移除数组大于零，list执行移除remove里面的数组
//
//            [self.list removeObjectsInArray:self.removeList];
//            [self.tableView reloadData];
//            [self.removeList removeAllObjects];
        }
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"UITableViewCell";

    UDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    cell.row = indexPath.row;
    __weak typeof(self) weakSelf = self;
    cell.customSelectedBlock = ^ (BOOL selected, NSInteger row)
    {
        if (selected) {
            [weakSelf.selectedRows addObject:@(row)];
        }else
        {
            [weakSelf.selectedRows removeObject:@(row)];
        }
    };

    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UDTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedRows containsObject:@(cell.row)]) {
        [cell.btnSelect setTitle:@"🔴" forState:UIControlStateNormal];
    }else
    {
        [cell.btnSelect setTitle:@"⭕️" forState:UIControlStateNormal];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
