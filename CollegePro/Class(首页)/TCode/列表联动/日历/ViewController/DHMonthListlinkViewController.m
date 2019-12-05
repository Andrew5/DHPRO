//
//  DHMonthListlinkViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/7/4.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "DHMonthListlinkViewController.h"
#import "DHMonthListViewController.h"//左边的列表展示
#import "DHMonthDetailViewController.h"//右边的列表展示
#import "Masonry.h"//布局文件
@interface DHMonthListlinkViewController ()<DHMonthListViewControllerDelegate,DHMonthDetailViewControllerDelegate>
@property (nonatomic, strong) NSArray *months;

@property (nonatomic, strong) DHMonthListViewController *leftController;
@property (nonatomic, strong) DHMonthDetailViewController *rightController;
@end

@implementation DHMonthListlinkViewController
- (NSArray *)months
{
    if (!_months) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger month = [calendar component:(NSCalendarUnitMonth) fromDate:[NSDate date]];
        NSArray *months = @[@"十二月",@"十一月",@"十月",@"九月",@"八月",@"七月",@"六月",@"五月",@"四月",@"三月",@"二月",@"一月"];
        _months = [months subarrayWithRange:NSMakeRange(12 - month, month)];
    }
    return _months;
}

- (DHMonthListViewController *)leftController
{
    if (!_leftController) {
        _leftController = [[DHMonthListViewController alloc]init];
        _leftController.delegate = self;
        _leftController.months = self.months;
    }
    return _leftController;
}

- (DHMonthDetailViewController *)rightController
{
    if (!_rightController) {
        _rightController = [[DHMonthDetailViewController alloc]init];
        _rightController.delegate = self;
        _rightController.months = self.months;
    }
    return _rightController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加显示控件
    [self addChildViewController:self.leftController];
    [self addChildViewController:self.rightController];
    [self.view addSubview:_leftController.view];
    [self.view addSubview:_rightController.view];
    //安装显示控件
    [self hd_constraints];
    self.isShowleftBtn = NO;
}
- (void)hd_constraints
{
    [_leftController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_offset(0);
        make.width.mas_equalTo(100.0);
    }];
    
    [_rightController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_offset(0);
        make.left.equalTo(self->_leftController.view.mas_right);
    }];
}
#pragma mark --关键
#pragma mark -两个列表点击事件代理:处理
//左侧列表代理
- (void)
monthListTableView:(UITableView *)tableView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *targetPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.row];
    [_rightController collectionViewScrollToItemAtIndexpath:targetPath];
}
//右侧列表代理
- (void)monthDetailCollectionView:(UICollectionView *)collectionView didScrollToIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *targetPath = [NSIndexPath indexPathForRow:indexPath.section inSection:0];
    [_leftController tableViewSelectCellAtIndexpath:targetPath];
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
