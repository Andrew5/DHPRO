//
//  MyfarmViewController.m
//  shiku
//
//  Created by Rilakkuma on 15/9/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//
#import "MyfarmViewController.h"

@interface MyfarmViewController ()

@end

@implementation MyfarmViewController
- (NSMutableArray *)willExecuteBlocks
{
    if (!_m_DataArr) {
        self.m_DataArr = [NSMutableArray array];
    }
    return _m_DataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的农场";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    self.m_DataArr = [[NSMutableArray alloc]init];
    [self loadData];

    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.tableFooterView = [UIView new];
    _myTableView.showsVerticalScrollIndicator = NO;
    // Do any additional setup after loading the view from its nib.
}

- (instancetype)initWithGoods:(COLLECT_GOODS *)anGoods {
    self = [self init];
    self.goods_id = anGoods.goods_id;
    return self;
}

-(void)loadData{
    
    AFHTTPRequestOperationManager *managerO = [AFHTTPRequestOperationManager manager];
    [managerO POST:[NSString stringWithFormat:@"%@/member_favs/lists",url_share] parameters:@{@"token":_usertoken} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self addloadData:responseObject[@"data"][@"list"]];
        [self  hideHUDView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}
-(void)addloadData:(NSMutableArray *)array{
    [self.m_DataArr removeAllObjects];
    for(int i = 0 ;i<[array count];i++)
    {
        NSDictionary * dict = [array objectAtIndex:i];
        MyfarNSObject *data = [MyfarNSObject new];
        data.title = dict[@"member_shop"][@"title"];
        data.midStr = dict[@"mid"];
        if ([dict[@"member_shop"][@"organic"] isEqualToString:@"0"]||[dict[@"member_shop"][@"areas"] isEqualToString:@"0"]||dict[@"member_shop"][@"organic"] == nil) {
            data.organicStr =@"有机含量:0.00mq/平方米    亩产量:0Kg";
        }
        else {
            data.organicStr = [NSString stringWithFormat:@"有机含量:%@mq/平方米    亩产量:%@Kg",dict[@"member_shop"][@"organic"],dict[@"member_shop"][@"areas"]];

        }
        data.coverImage = dict[@"member_shop"][@"cover"];
        [self.m_DataArr addObject:data];

    }
    [self Showprogress];
    [_myTableView reloadData];
    
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
    return self.m_DataArr.count;
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
    MyfarNSObject *data = self.m_DataArr[indexPath.row];

    MyfarmTableViewCell *cell = [MyfarmTableViewCell cellWithTableView:tableView];
    cell.labelTitle.text = data.title;
    cell.labelSubtitle.text = data.organicStr;
    cell.delegate = self;
    cell.model =data;
    NSString *url = [Helper checkImgType:data.coverImage];
    [cell.imageCover sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [cell.imageCover sd_setImageWithURL:[NSURL URLWithString:data.coverImage]];
        }
    }];
    if (data.midStr) {
        cell.btnShare.tag =[data.midStr integerValue];
        [cell.btnShare addTarget:self action:@selector(btnShareMethod:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    [cell.imageCover setContentScaleFactor:[[UIScreen mainScreen] scale]];
    cell.imageCover.userInteractionEnabled = YES;
    cell.imageCover.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell.imageCover.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageCover.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)shareGoods:(MyfarNSObject *)model{
    [self showSharedView:nil goodsID:nil couponCode:nil goodstitle:@"食库" goodsinfor:model.title imgUrl:nil shareUrl:nil];

}
-(void)btnShareMethod:(UIButton *)sender{


}
//选择cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    MyfarNSObject *data = self.m_DataArr[indexPath.row];
    HomeViewControllernew *info = [[HomeViewControllernew alloc]init];
    info.midStr = data.midStr;
    [self.navigationController pushViewController:info animated:YES];
    //喜欢
//    MyfarmTableViewCell *myfarmCell = (MyfarmTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    [myfarmCell.btnShare addTarget:self action:@selector(btnShareMethod) forControlEvents:(UIControlEventTouchUpInside)];


}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (screenSize.height/5*2);
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
