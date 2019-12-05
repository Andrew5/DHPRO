//
//  ConnperativeMemberViewController.m
//  shiku
//
//  Created by Rilakkuma on 15/8/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "ConnperativeMemberViewController.h"
#import "CooperativeTwoTableViewCell.h"
#import "HomeGetdata.h"
#import "AlertView.h"
@interface ConnperativeMemberViewController ()
{
    NSMutableArray *m_DataArr;

}
@property (strong, nonatomic)AlertView*alertView;
@end

@implementation ConnperativeMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"合作社";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    _vbackground.backgroundColor = RGBCOLORV(0x7a9c5c);

    self.labelSociety.text = [NSString stringWithFormat:@"社长优惠码：%@",_scoiety];
    self.labelMoney.text = _money;//获得社会贡献
    //招募按钮
    [_btnRecruit addTarget:self action:@selector(recruitMethod) forControlEvents:(UIControlEventTouchUpInside)];
    //请求数据
    m_DataArr = [NSMutableArray array];
    [self loadData];
}
-(void)recruitMethod{
    _alertView= [AlertView STWordAndPhraseView];
    _alertView.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _alertView.bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    [_alertView bringSubviewToFront:_alertView];
//    [_alertView.beBtn addTarget:self action:@selector(beBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    _alertView.beBtn.layer.cornerRadius = 3;
//    _alertView.beBtn.layer.masksToBounds = YES;
    [_alertView.cancelBtn addTarget:self action:@selector(removeBgView) forControlEvents:(UIControlEventTouchUpInside)];
    [_alertView.certainBtn addTarget:self action:@selector(sureButMethod) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].windows[0] addSubview:_alertView];
    UITapGestureRecognizer * tapcomment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBgView)];//定义一个手势
    [_alertView addGestureRecognizer:tapcomment];//添加手势到View
}
-(void)sureButMethod{
    [_alertView removeFromSuperview];
    
    [self showSharedView:nil goodsID:nil couponCode:_scoiety goodstitle:nil goodsinfor:nil imgUrl:nil shareUrl:nil];
}
-(void)removeBgView{
    [_alertView removeFromSuperview];
}
-(void)loadData{

    App *app = [App shared];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%@",app.currentUser.token]forKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/cooperation/manage",url_share];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self reloadDataArr:responseObject[@"data"][@"list"]];
        _labelRecruit.text = responseObject[@"data"][@"count"];
        [_imageViewDimensional sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"qrcode"]]];
        [_imageViewDimensional setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _imageViewDimensional.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _imageViewDimensional.contentMode = UIViewContentModeScaleAspectFill;
        _imageViewDimensional.clipsToBounds = YES;
        [_tableView reloadData];
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];
    
}
-(void)reloadDataArr:(NSArray*)array{
    [m_DataArr removeAllObjects];
    for(int i = 0 ;i<[array count];i++)
    {
        NSDictionary * dict = [array objectAtIndex:i];
        Recruit *mode = [[Recruit alloc]init];
        mode.add_time=dict[@"add_time"];//添加时间;
        mode.discount_amount = dict[@"discount_amount"];//贡献值
        mode.prices = dict[@"prices"];//价格
        mode.status = dict[@"status"];//状态
        mode.img = dict[@"img"];//价格
        [m_DataArr addObject:mode];
        
    }

}
#pragma mark - Table view data source
//返回区域数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}
//返回某区域内的行数   返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return m_DataArr.count;
}
//配置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    //重用单元，当单元滚动出屏幕再出现在屏幕上时
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];//这里可以设置单元格的风格
//    }
    
    Recruit *model = m_DataArr[indexPath.row];
    CooperativeTwoTableViewCell *cell = [CooperativeTwoTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *timeStr = [model.add_time substringToIndex:10];
    cell.labelTime.text = timeStr;
    if ([model.status isEqualToString:@"1"]) {
        cell.labelContribute.text = [NSString stringWithFormat:@"贡献：+%@在路上",model.discount_amount];
  
    }
    else if ([model.status isEqualToString:@"2"]){
        cell.labelContribute.text = [NSString stringWithFormat:@"贡献：+%@已购买",model.discount_amount];
        cell.labelContribute.textColor = [UIColor colorWithRed:0.984 green:0.370 blue:0.111 alpha:1.000];
    }
//    cell.labelContribute.text = [NSString stringWithFormat:@"贡献：+%@在路上",model.discount_amount];
    cell.labelTitle.text = [NSString stringWithFormat:@"购买了%@元的商品",model.prices];
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
    return cell;

}
//选择cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
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
