//
//  TravailViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/20.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "TravailViewController.h"
#import "PrefixHeader.pch"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "FootBigCell.h"
#import "FootCell.h"
#import "MiddleBigCell.h"
#import "MiddleCell.h"
#import "LastCell.h"
#import "headView.h"
#import "footView.h"
#import "adViewView.h"
#import "TravailDeTailViewController.h"
#import "DiscountViewController.h"
#import "adviseViewController.h"
#import "SpecialViewController.h"
@interface TravailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,footViewDelegate,adViewViewDelegate>
{
    int currentPage;
    UICollectionView *_collectionView;
    BOOL _isRefresh;
}
@end

@implementation TravailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage=1;
    _dataArray = [[NSMutableArray alloc]initWithCapacity:3];
    [_dataArray addObject:@[]];
    [_dataArray addObject:@[]];
    [_dataArray addObject:@[]];
    [self addTitleViewWithTitle:@"小豌旅行"];

    [self createCollectionView];
    [self requestDatatop];
    [self requestDataFoot];
    [self createRefresh];
}

-(void)createRefresh
{
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    
    [_collectionView.mj_header beginRefreshing];
    
    _collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(pushRefresh)];
    
}
-(void)pullRefresh
{
    _isRefresh = YES;
    
    currentPage = 1;
    
    [self requestDataFoot];
}
-(void)pushRefresh
{
    _isRefresh = NO;
    
    currentPage ++;//每次请求下一页数据
    
    [self requestDataFoot];
}

-(void)requestDatatop
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:OTHER parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *data = [rootDic objectForKey:@"data"];
        
        NSArray *array1 = [data objectForKey:@"subject"];//发现下一站的数据
       
        NSMutableArray *array2 = [NSMutableArray new];//中间部分的数据
        
        NSArray *arraydis = [data objectForKey:@"discount_subject"];
        if (arraydis.count !=0) {
            [array2 addObject:arraydis[0]];
        }
        NSArray *arraydiscount = [data objectForKey:@"discount"];
        for (NSDictionary *discount in arraydiscount) {
            [array2 addObject:discount];
        }
        [_dataArray replaceObjectAtIndex:0 withObject:array1];
        [_dataArray replaceObjectAtIndex:1 withObject:array2];//装入大数组
      
        if (self.adArray.count !=0) {
            [self.adArray removeAllObjects];
        }
        
        NSArray *slide = [data objectForKey:@"slide"];//广告数据
        for (NSDictionary *slideDic in slide) {
            [self.adArray addObject:slideDic[@"photo"]];
            [self.urlArray addObject:slideDic[@"url"]];
        }
        if ([_dataArray[0] count]!=0) {
            [_collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)requestDataFoot
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString* URL=[NSString stringWithFormat:TRAVELNOTE1,currentPage,TRAVELONTE2];
    [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *data = [rootDic objectForKey:@"data"];
        if(currentPage > 1){
             for (NSDictionary *dic in data) {
                 [_dataArray[2] addObject:dic];
             }
        }else{
               NSMutableArray *array3 = [NSMutableArray new];
//        if (_isRefresh) {
//            [_dataArray removeObjectAtIndex:2];
//        }
//        for (NSDictionary *dic in _dataArray[2]) {
//            [array3 addObject:dic];//防止为空
//        }
              for (NSDictionary *dic in data) {
             [array3 addObject:dic];
              }
              [_dataArray replaceObjectAtIndex:2 withObject:array3];//底部数据装入大数组
        }
        
        if (_isRefresh) {
            [_collectionView.mj_header endRefreshing];
        }
        else
        {
            [_collectionView.mj_footer endRefreshing];
        }

        [_collectionView reloadData];//一定要reloadData;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
-(void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//水平方向滑动
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
     _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_collectionView];
    //_collectionView.backgroundColor=[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];//灰色背景
    _collectionView.backgroundColor = [UIColor whiteColor];
    //_collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PayOnlineBackgroudImg"]];
    //创建五个不同的cell，登记注册
    [_collectionView  registerNib:[UINib nibWithNibName:@"FootBigCell" bundle:nil] forCellWithReuseIdentifier:@"FootBigCell"];
    [_collectionView  registerNib:[UINib nibWithNibName:@"FootCell" bundle:nil] forCellWithReuseIdentifier:@"FootCell"];
    [_collectionView  registerNib:[UINib nibWithNibName:@"MiddleBigCell" bundle:nil] forCellWithReuseIdentifier:@"MiddleBigCell"];
    [_collectionView  registerNib:[UINib nibWithNibName:@"MiddleCell" bundle:nil] forCellWithReuseIdentifier:@"MiddleCell"];
    [_collectionView  registerNib:[UINib nibWithNibName:@"LastCell" bundle:nil] forCellWithReuseIdentifier:@"LastCell"];
    //创建广告头部
     [_collectionView registerClass:[adViewView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"adViewView"];
    //创建每组的头和尾
    [_collectionView registerClass:[headView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    [_collectionView registerClass:[footView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
    
}
#pragma mark 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    if ([_dataArray[0] count] == 0) {
        return 0;
    }
    return _dataArray.count;//返回组数
 
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray[section] count];//返回每一组的个数Item
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)//第一组
    {
        if (indexPath.row==0)
        {
            FootBigCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FootBigCell" forIndexPath:indexPath];
            NSDictionary *dic = _dataArray[indexPath.section][indexPath.row];
            NSString *photo = [dic objectForKey:@"photo"];
            [cell.imagV sd_setImageWithURL:[NSURL URLWithString:photo]];
            cell.imagV.layer.cornerRadius = 10;
            cell.imagV.layer.masksToBounds = YES;
            return cell;
        }
        else
        {
            FootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FootCell" forIndexPath:indexPath];
            NSDictionary *dic = _dataArray[indexPath.section][indexPath.row];
            NSString *photo = [dic objectForKey:@"photo"];
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:photo]];
            cell.icon.layer.cornerRadius = 8;
            cell.icon.layer.masksToBounds = YES;
            return cell;
        }
    }else if (indexPath.section==1)//第二组
    {
        if (indexPath.row==0)
        {
            MiddleBigCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MiddleBigCell" forIndexPath:indexPath];
             NSDictionary *dic = _dataArray[indexPath.section][indexPath.row];
            [cell.iamgeBig sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"default.jpeg"]];
            cell.iamgeBig.layer.cornerRadius = 5;
            cell.iamgeBig.layer.masksToBounds = YES;
            return cell;
        }
        MiddleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MiddleCell" forIndexPath:indexPath];
        NSDictionary *dic = _dataArray[indexPath.section][indexPath.row];
        NSString *photo = [dic objectForKey:@"photo"];
        [cell.MiddleImagev sd_setImageWithURL:[NSURL URLWithString:photo]];
        cell.MiddleImagev.layer.cornerRadius = 5;
        cell.MiddleImagev.layer.masksToBounds = YES;
        cell.infoLabel.text = [dic objectForKey:@"title"];
        cell.discountLabel.text = [dic objectForKey:@"priceoff"];
        NSString *strPrice = [dic objectForKey:@"price"];
        NSString* search = @"(>)(\\w+)(<)";
        NSRange range = [strPrice rangeOfString:search options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            cell.PriceLabel.text = [NSString stringWithFormat:@"%@元起", [strPrice substringWithRange:NSMakeRange(range.location + 1, range.length - 2)]];
        }

        return cell;
    }else//第三组
    {
        LastCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LastCell" forIndexPath:indexPath];
        NSDictionary *dic = _dataArray[indexPath.section][indexPath.row];
        [cell.iconV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"photo"]]];
        cell.iconV.layer.cornerRadius = 10;
        cell.iconV.layer.masksToBounds = YES;
        cell.authour.text = [dic objectForKey:@"username"];
        cell.authour.font = [UIFont boldSystemFontOfSize:16];
        cell.TitleLabel.text = [dic objectForKey:@"title"];
        cell.TitleLabel.textColor = [UIColor whiteColor];
        cell.TitleLabel.font = [UIFont boldSystemFontOfSize:22];
        cell.readLabel.text = [dic objectForKey:@"replys"];
        cell.likeLabel.text = [dic objectForKey:@"likes"];
        return cell;
    }
}
#pragma mark 设置大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return CGSizeMake(Screen_Width, 200*(Screen_Height/667.0));
        }
        else{
            return CGSizeMake((Screen_Width-6)/2, 160*(Screen_Height/667.0));
        }
    }else if (indexPath.section==1)
    {
        if (indexPath.row==0) {
            return CGSizeMake(Screen_Width, 200*(Screen_Height/667.0));
        }
        else{
            return CGSizeMake((Screen_Width-6)/2, 180*(Screen_Height/667.0));
        }

    }else
    {
        return CGSizeMake(Screen_Width, 180*(Screen_Height/667.0));
    }
}
//设置collectionView当前页距离四周的边距
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(1, 1, 1, 1);
//}
//设置最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if(section==1){
        return 1;
    }else{
        return 1;
    }
}
//设置最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if(section==1){
        return 1;
    }else{
        return 1;
    }
}

#pragma mark  点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1 && (indexPath.row>1&&indexPath.row<4)) {
        NSDictionary *dic = _dataArray[indexPath.section][indexPath.row];
        TravailDeTailViewController *DetailView = [[TravailDeTailViewController alloc]init];
        DetailView.ID = [dic objectForKey:@"id"];
        [self presentViewController:DetailView animated:YES completion:nil];
    }
    if (indexPath.section ==2) {
        NSDictionary *dic = _dataArray[indexPath.section][indexPath.row];
        TravailDeTailViewController *DetailView = [[TravailDeTailViewController alloc]init];
        DetailView.url = [dic objectForKey:@"view_url"];
        [self presentViewController:DetailView animated:YES completion:nil];
    }else
    {
        NSDictionary *dic = _dataArray[indexPath.section][indexPath.row];
        TravailDeTailViewController *DetailView = [[TravailDeTailViewController alloc]init];
        DetailView.url = [dic objectForKey:@"url"];
        [self presentViewController:DetailView animated:YES completion:nil];
    }
}
#pragma mark 设置头视图和脚视图


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            static NSString* adview=@"adViewView";//定义一个全局断点
            adViewView *ADview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:adview forIndexPath:indexPath];
            ADview.tag = 100;
            [self createAD];
            ADview.delegate = self;
            return ADview;
        }else{
            static NSString *footV = @"footView";
            footView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footV forIndexPath:indexPath];
            [foot.button setTitle:@"查看更多精彩专题>" forState:UIControlStateNormal];
            foot.delegate = self;
            return foot;
            
        }
    }else if (indexPath.section==1){
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            static NSString *headV = @"headView";
            headView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headV forIndexPath:indexPath];
            head.titleLabel.text = @"  抢特价折扣";
            return head;
        }else
        {
            static NSString *footV = @"footView";
            footView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footV forIndexPath:indexPath];
            [foot.button setTitle:@"查看全部特价折扣  >" forState:UIControlStateNormal];
            foot.delegate = self;
            return foot;
        }
    }else
    {
        static NSString *headV = @"headView";
        headView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headV forIndexPath:indexPath];
        head.titleLabel.text = @"  看热门游记";
        return head;
    }
}
#pragma mark 设置每组头部和尾部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return CGSizeMake(Screen_Width, 300);
    }
    else
    {
        return CGSizeMake(Screen_Width, 30);
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    //return CGSizeMake(Screen_Width, 30);
    if (section ==2) {
        return CGSizeMake(0, 0);
    }else{
        return CGSizeMake(Screen_Width, 30);
    }
}
#pragma mark 实现两个代理方法
-(void)sendadButton:(UIButton *)button
{
    if (button.tag ==500) {
        adviseViewController *advise = [[adviseViewController alloc]init];
        [self.navigationController pushViewController:advise animated:YES];
    }
    else if (button.tag==501)
    {
        DiscountViewController *dis = [[DiscountViewController alloc]init];
        [self.navigationController pushViewController:dis animated:YES];
    }
}
-(void)sendButton:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"查看全部特价折扣  >"]) {
        DiscountViewController *dis = [[DiscountViewController alloc]init];
        [self.navigationController pushViewController:dis animated:YES];
    }else{
        SpecialViewController *special = [[SpecialViewController alloc]init];
        [self.navigationController pushViewController:special animated:YES];
    }
}
-(void)createAD
{
    adViewView *adview = (adViewView *)[self.view viewWithTag:100];
    adview.array = _adArray;
    adview.scrollView.contentSize = CGSizeMake(_adArray.count*Screen_Width, 200);
    for (UIView *subview in adview.scrollView.subviews) {
        [subview removeFromSuperview];//移除
    }
    //点击图片能够滑动,跳转
    for (int i=0; i<_adArray.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.userInteractionEnabled = YES;
        imageV.frame = CGRectMake(i*Screen_Width, 0, Screen_Width, 200);
        [imageV sd_setImageWithURL:[NSURL URLWithString:_adArray[i]]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;//轻触的次数
        imageV.tag = 300+i;
        [imageV addGestureRecognizer:tap];
        [adview.scrollView addSubview:imageV];
        //i ++;
    }
    adview.page.currentPage = 0;
    adview.page.numberOfPages = _adArray.count;
}
-(void)tap:(UITapGestureRecognizer *)tap
{
    int value = (int)[(UIImageView *)tap.view tag];
    TravailDeTailViewController *detail = [[TravailDeTailViewController alloc]init];
    detail.url = _urlArray[value-300];
    //[self.navigationController pushViewController:detail animated:YES];
    [self presentViewController:detail animated:YES completion:nil];
}
#pragma mark 懒加载
//重写getter方法，用到的时候才初始化，经典的引用就是视图控制器的view

-(NSMutableArray *)adArray
{
    if (_adArray == nil) {
        _adArray = [[NSMutableArray alloc]init];
    }
    return _adArray;
}
-(NSMutableArray *)urlArray
{
    if (_urlArray == nil) {
        _urlArray = [[NSMutableArray alloc]init];
    }
    return _urlArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
