//
//  AutoLayoutViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/10/17.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//
#define BA_SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

#import "AutoLayoutViewController.h"
#import "AddCellViewController.h"

#import "TableViewAnimationA.h"
#import "UITableView+DHAnimationA.h"

@interface AutoLayoutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, assign) NSInteger cellNum;

@end

@implementation AutoLayoutViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor redColor];
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(-44 , 0, 0, 0));
        }];
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.title = @"的份";
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage=[UIImage new];
//    self.navigationController.navigationBar.translucent=YES;
    [self tableView];

    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.5];
    // Do any additional setup after loading the view.
}
- (void)loadData{
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld行,请不要挤我",(long)indexPath.row];
    return cell;
    
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    /*! 第二种：卡片式动画 */
//    static CGFloat initialDelay = 0.2f;
//    static CGFloat stutter = 0.06f;
//    //usingSpringWithDamping的范围为0.0f到1.0f，数值越小「弹簧」的振动效果越明显。
//    //initialSpringVelocity则表示初始的速度，数值越大一开始移动越快。
//    cell.contentView.transform =  CGAffineTransformMakeTranslation(BA_SCREEN_WIDTH, 0);
//    [UIView animateWithDuration:1.0f delay:initialDelay + ((indexPath.row) * stutter) usingSpringWithDamping:0.6 initialSpringVelocity:1 options:0.5 animations:^{
//        cell.contentView.transform = CGAffineTransformIdentity;
//    } completion:NULL];
//
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        NSMutableArray* testArray = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"11",@"12",@"13",@"14", nil];
        
        AddCellViewController *addVC = [[AddCellViewController alloc]init];
        [self.navigationController pushViewController:addVC animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeLabelTextNotification" object: self userInfo:@{@"text":testArray}];
    }
    [TableViewAnimationA showWithAnimationType:indexPath.row tableView:_tableView];
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
