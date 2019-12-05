//
//  NearbViewController.m
//  shiku
//
//  Created by Rilakkuma on 15/8/20.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "NearbViewController.h"
#import "NearTableViewCell.h"
#import "GoodsDetailViewController.h"//商品
#import "HomeViewControllernew.h"
#import "SearchViewController.h"//搜索
#import "AppDelegate.h"
@interface NearbViewController ()
{
    UIButton *anbtn;//top按钮
    NSMutableArray *m_DataArr;

}
@end

@implementation NearbViewController
-(void)clickleftButton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.navigationItem.leftBarButtonItem = [self tbarBackButtonWhite];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 10, 22, 22);
    [leftBtn setImage:[UIImage imageNamed:@"ic_lie_biao.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickleftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(0, 0, 200, 10);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"附近的农户";
    
    UILabel *subLabel = [[UILabel alloc]init];
    subLabel.frame = CGRectMake(0, 20, 200, 10);
    subLabel.text = self.subtitle;
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.font = [UIFont systemFontOfSize:12];
    subLabel.textColor = [UIColor whiteColor];
    
    
    UIView *navview = [UIView new];
    navview.backgroundColor = [UIColor clearColor];
    navview.frame = CGRectMake(50, 0, 200, 30);
    [navview addSubview:titleLabel];
    [navview addSubview:subLabel];
    self.navigationItem.titleView = navview;
    
    UIButton *rightNavigationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavigationBtn.frame = CGRectMake(0, 10, 30, 30);
    rightNavigationBtn.titleLabel.font=[UIFont fontWithName:@"iconfont" size:25];
    [rightNavigationBtn setTitle:@"\U0000B07A" forState:(UIControlStateNormal)];
    [rightNavigationBtn addTarget:self action:@selector(searchFieldTouched) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightNavigationBtn];

    self.navigationItem.rightBarButtonItem = rightBarBtnItem;

    _tableView.tableFooterView = [UIView new];

    m_DataArr = [NSMutableArray array];
    [self data];
    [_topBtn setTitle:@"\U0000D15A" forState:UIControlStateNormal];
    _topBtn.layer.cornerRadius=SCREEM_W*45/320/2.0;
    _topBtn.titleLabel.font=[UIFont fontWithName:@"iconfont" size:35];
    [_topBtn setTintColor:WHITE_COLOR];
    _topBtn.backgroundColor=MAIN_COLOR;
    _topBtn.layer.masksToBounds =YES;
    [_topBtn addTarget:self action:@selector(btnclickAnbtn:) forControlEvents:UIControlEventTouchUpInside];
    _topBtn.hidden=YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.viewController.tabBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.viewController.tabBarHidden = NO;
}
-(void)searchFieldTouched{
    SearchViewController *sc=[SearchViewController new];
    
    [self.navigationController pushViewController:sc animated:YES];
    //    GoodsListViewController *gl=[GoodsListViewController new];
    //    [self showNavigationViewMainColor:gl];
}
-(void)data{
    [self Showprogress];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"pos_lng\":\"%f\",\"pos_lat\":\"%f\"}",_longati,_lat]
                   forKey:@"data"];
    NSLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@/member_shop/lists",url_share];
    [mgr POST:url parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (responseObject[@"data"]) {
              NSLog(@"成功%@",responseObject[@"data"]);
              
              [self reloadDataArr:[responseObject objectForKey:@"data"]];
              
              [_tableView reloadData];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
      }];

}
-(void)reloadDataArr:(NSArray *)Arr
{
    [self hideHUDView];
    [m_DataArr removeAllObjects];
    for(int i = 0 ;i<[Arr count];i++)
    {
        NSDictionary * dict = [Arr objectAtIndex:i];
        
        NeardataObject *mode = [[NeardataObject alloc]init];
        mode.sales=dict[@"member"][@"sales"];//销量;
        mode.title = [dict objectForKey:@"title"];//产品标题
        mode.areas = [dict objectForKey:@"area"];//产地
        mode.catenmae = dict[@"cate"][@"name"];//主营
        mode.distance = [NSString stringWithFormat:@"%.2f",[dict[@"distance"] floatValue]];//距离
        mode.rates = dict[@"rates"];//评分
        mode.mid = dict[@"mid"];
        mode.goodsImage = [dict objectForKey:@"cover"];//[[dict objectForKey:@"pcate"] objectForKey:@"img"];

        [m_DataArr addObject:mode];
    }
    
    
    }
- (void)btnclickAnbtn:(UIButton *)sender{
    _tableView.contentOffset = CGPointMake(0, 0);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_tableView.contentOffset.y > [UIScreen mainScreen].bounds.size.height/2) {
        _topBtn.hidden = NO;
    }else{
        _topBtn.hidden = YES;
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

    NearTableViewCell *cell = [NearTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NeardataObject *o = m_DataArr[indexPath.row];
    
    NSString *url = [NSString string];
    if ([o.goodsImage containsString:@".jpg"]) {
        url = [o.goodsImage stringByReplacingOccurrencesOfString:@".jpg" withString:@"_small.jpg"];
    }
    else if ([o.goodsImage containsString:@".JPG"]) {
        url = [o.goodsImage stringByReplacingOccurrencesOfString:@".JPG" withString:@"_small.JPG"];

    }
    else if ([o.goodsImage containsString:@".gif"]) {
        url = [o.goodsImage stringByReplacingOccurrencesOfString:@".gif" withString:@"_middle.gif"];
    }
    else if ([o.goodsImage containsString:@".png"]) {
        url = [o.goodsImage stringByReplacingOccurrencesOfString:@".png" withString:@"_small.png"];
        
    }
    [cell.imageGoods setContentScaleFactor:[[UIScreen mainScreen] scale]];
    cell.imageGoods.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell.imageGoods.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageGoods.clipsToBounds = YES;

    [cell.imageGoods sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [cell.imageGoods sd_setImageWithURL:[NSURL URLWithString:url]];
        NSLog(@"成功");
        if (error) {
            [cell.imageGoods sd_setImageWithURL:[NSURL URLWithString:o.goodsImage]];
        }
    }];
    
    cell.labelGoodsTitle.text = o.title;
    cell.labelSalesNum.text = o.sales;//
    cell.labelMarlNum.text = o.rates;
    cell.labelDistance.text = [NSString stringWithFormat:@"%@KM",o.distance];
    cell.labelManagetitle.text = o.catenmae;
    cell.labelPlaceTitle.text = o.areas;
    
    return cell;
    
}
//选择cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    HomeViewControllernew *homeVC = [HomeViewControllernew new];
    
    
    NeardataObject *goodsID = m_DataArr[indexPath.row];
    GoodsDetailViewController *personInfo = [[GoodsDetailViewController alloc]init];
    NSString *str =goodsID.mid;
    
    id result;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    result=[f numberFromString:str];
    if(!(result))
    {
        result=str;
    }
    personInfo.goods_id = result;
    homeVC.midStr = result;
//去导航栏
//    [self showalphaNavigateControl:personInfo];
    [self.navigationController pushViewController:homeVC animated:YES];

    
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

@implementation NeardataObject



@end
