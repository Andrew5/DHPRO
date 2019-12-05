//
//  ExpandTableVC.m
//  点击按钮出现下拉列表
//
//  Created by 杜甲 on 14-3-26.
//  Copyright (c) 2014年 杜甲. All rights reserved.
////http://www.th7.cn/Program/IOS/201501/377135.shtml
//http://www.jianshu.com/p/ec6a037e4c6b
//http://download.csdn.net/download/rhljiayou/6477587

#import "ExpandTableVC.h"
#import "ExpandCell.h"
#import "TodayItemModel.h"

@interface ExpandTableVC ()
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation ExpandTableVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.m_ContentArr = [NSArray array];
    /*
     设置哭鏖战
     */
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"切换标题" style:UIBarButtonItemStylePlain target:self action:@selector(clickSwitchTitleEvent)];
    self.navigationItem.rightBarButtonItem = rightItem;

	 self.view.backgroundColor = [UIColor colorWithRed:167.0f / 255.0f green:255.0f/ 255.0f blue:253.0f/ 255.0f alpha:0.3f];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;


}
//切换通知栏标题
-(void)clickSwitchTitleEvent{
    NSArray * arr = @[@"生活有度，人生添寿。 —— 书摘",@"理想是人生的太阳。 —— 德莱赛",@"不是老人变坏了，而是坏人变老了",@"人生苦短，必须性感"];
    NSInteger index = arc4random() % 4;
    // 存储数据
    [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.dhtest.CollegePro.CollegeProExtension"] setValue:arr[index] forKey:@"myShareData"];
}
#pragma mark- lazy
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        NSArray * array = @[
                            @{@"icon":@"bangzhu",@"handerUrl":@"CollegeProExtension://message",@"title":@"消息"},
                            @{@"icon":@"fankui",@"handerUrl":@"CollegeProExtension://adress",@"title":@"地址管理"},
                            @{@"icon":@"gerenxinxi",@"handerUrl":@"CollegeProExtension://work",@"title":@"工作"},
                            @{@"icon":@"kefu",@"handerUrl":@"CollegeProExtension://my",@"title":@"我的"},
                            @{@"icon":@"shezhi",@"handerUrl":@"CollegeProExtension://set",@"title":@"设置"},
                            ];
        _dataArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary * dic in  array) {
            TodayItemModel*manageModel = [TodayItemModel new];
            manageModel.icon =dic[@"icon"];
            manageModel.handerUrl = dic[@"handerUrl"];
            manageModel.titlename = dic[@"title"];
            [self.dataArray addObject:manageModel];
        }
        [self.tableView reloadData];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
    TodayItemModel * model = self.dataArray[indexPath.row];
//    cell.textLabel.text = @"素数";
    
    ExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ExpandCell class])];
    if (nil == cell) {
        cell = [[ExpandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ExpandCell class])];
    }
    
    [cell setCellContentData:model.titlename];
//    cell.textLabel.text = [self.m_ContentArr objectAtIndex:indexPath.row];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.textLabel.backgroundColor = [UIColor clearColor];
	
    return cell;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate_ExpandTableVC respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_delegate_ExpandTableVC tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end

