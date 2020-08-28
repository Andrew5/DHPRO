//
//  JPShopCarController.m
//  回家吧
//
//  Created by 王洋 on 16/3/25.
//  Copyright © 2016年 ubiProject. All rights reserved.
//

#import "JPShopCarController.h"
#import "JPShopCarCell.h"
#import "JPShopHeaderCell.h"
#import "JPCarModel.h"


@interface JPShopCarController ()<UITableViewDataSource,UITableViewDelegate,JPShopCarDelegate>

@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *allBtn;

@property (nonatomic, assign) CGFloat totalPrice; // 所有选中的商品总价值

@end

@implementation JPShopCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购物车";
    [self setupTableView]; // tableView
    [self createAllBtn];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 10; i++) {
            JPCarModel *model = [[JPCarModel alloc]init];
            model.allSelect = NO;
//            model.selected = YES;
            for (int i = 0; i<3; i++) {
                JPCarModel *detailsmodel = [[JPCarModel alloc]init];
//                detailsmodel.allSelect = YES;
                detailsmodel.buyCount = 1;
                detailsmodel.selected = NO;
                detailsmodel.name = @"精品美甲";
                detailsmodel.price = @"9999.99";
                [model.numArray addObject:detailsmodel];
            }
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 全选按钮
- (void)createAllBtn
{
    self.allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.allBtn.frame = CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40);
    [self.allBtn setImage:[UIImage imageNamed:@"btn_address_W-1"] forState:UIControlStateNormal];
    [self.allBtn setImage:[UIImage imageNamed:@"btn_address"] forState:UIControlStateSelected];
    [self.allBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.allBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.allBtn];
}

- (void)btnClick:(UIButton *)btn
{
    self.allBtn.selected = !self.allBtn.selected;
    [self.dataArray enumerateObjectsUsingBlock:^(JPCarModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = self.allBtn.selected;
        obj.allSelect = self.allBtn.selected;
        [obj.numArray enumerateObjectsUsingBlock:^(JPCarModel *pro, NSUInteger idx, BOOL * _Nonnull stop) {
            pro.selected = obj.allSelect;
        }];
    }];
    
    // 计算总价格
    [self countingTotalPrice];
    [self.tableView reloadData];
}

/**
 *  setTableView
 */
- (void)setupTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.allowsSelection  = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

#pragma mark - JPShopCar 代理
// 点击了加号按钮
- (void)productCell:(JPShopCarCell *)cell didClickedPlusBtn:(UIButton *)plusBtn
{
    // 拿到点击的cell对应的indexpath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 拿到对应row的模型，购买数++
    JPCarModel *product = self.dataArray[indexPath.section];
    JPCarModel *pro = product.numArray[indexPath.row - 1];
    pro.buyCount++;
    
    // 刷新
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // 计算总显示价格
    [self countingTotalPrice];
}
// 点击了减号按钮
- (void)productCell:(JPShopCarCell *)cell didClickedMinusBtn:(UIButton *)minusBtn
{
    // 拿到点击的cell对应的indexpath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 拿到对应row的模型，购买数--
    JPCarModel *product = self.dataArray[indexPath.section];
    JPCarModel *pro = product.numArray[indexPath.row - 1];
    // 购买数量不能小于1
    if (pro.buyCount == 1) return;
    pro.buyCount--;
    
    // 刷新对应行
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // 计算总价格
    [self countingTotalPrice];
}

 /**
 *  计算总价格
 */
- (void)countingTotalPrice
{
    [self.dataArray enumerateObjectsUsingBlock:^(JPCarModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.numArray enumerateObjectsUsingBlock:^(JPCarModel *pro, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"bbb:%@,%lu,%d",pro.price,(unsigned long)idx,pro.buyCount);
            if (pro.isSelected) {
                self.totalPrice += pro.buyCount * [pro.price floatValue];
            }
        }];
    }];
    NSLog(@"%f", self.totalPrice);
    
    // 总价清零（每次要重新计算）
    self.totalPrice = 0;
}

#pragma mark - tableView Delegate dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JPCarModel *model = self.dataArray[section];
    return model.numArray.count + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        static NSString *ID = @"shopCell1";
        JPShopHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"JPShopHeaderCell" owner:nil options:nil].lastObject;
        }

        JPCarModel *product = self.dataArray[indexPath.section];
        cell.model = product;
        return cell;
    }else
    {
        static NSString *ID = @"shopCell2";
        JPShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"JPShopCarCell" owner:nil options:nil].lastObject;
        }
        JPCarModel *product = self.dataArray[indexPath.section];
        JPCarModel *pro = product.numArray[indexPath.row - 1];
        cell.delegate = self;
        cell.model = pro;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }else
    {
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        // 选中商店 全选商店对应的商品
        // 拿到点击行的数据模型
        JPCarModel *product = self.dataArray[indexPath.section];
        // 设置选中状态
        product.allSelect = !product.isAllSelect;
//        product.selected = product.allSelect;
        
        [product.numArray enumerateObjectsUsingBlock:^(JPCarModel *pro, NSUInteger idx, BOOL * _Nonnull stop) {
            pro.selected = product.allSelect;
        }];
        [self.tableView reloadData];
    } else
    {
        // 单独选中商品
        // 拿到点击行的数据模型
        JPCarModel *product = self.dataArray[indexPath.section];
        JPCarModel *pro = product.numArray[indexPath.row - 1];
        // 设置选中状态
        pro.selected = !pro.isSelected;

        // 刷新所选行
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    // 计算显示总价格
    [self countingTotalPrice];
    
}

// 复用队列
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.layer.transform = CATransform3DMakeScale(1.5, 1.5, 0);
//    cell.alpha = 0.0;
//    [UIView animateWithDuration:1 animations:^{
//        cell.layer.transform = CATransform3DIdentity;
//        cell.alpha = 1.0;
//    }];
//}
////增加点击动画
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    /*! 第二种：卡片式动画 */
//    static CGFloat initialDelay = 0.2f;
//    static CGFloat stutter = 0.06f;
//
//    cell.contentView.transform =  CGAffineTransformMakeTranslation(DH_DeviceWidth, 0);
//    [UIView animateWithDuration:1.0f delay:initialDelay + ((indexPath.row) * stutter) usingSpringWithDamping:0.6 initialSpringVelocity:1 options:0.5 animations:^{
//        cell.contentView.transform = CGAffineTransformIdentity;
//    } completion:NULL];
//
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
