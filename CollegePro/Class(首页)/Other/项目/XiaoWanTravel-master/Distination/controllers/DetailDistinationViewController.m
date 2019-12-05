//
//  DetailDistinationViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/23.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "DetailDistinationViewController.h"
#import "AFNetworking.h"
#import "PrefixHeader.pch"
#import "UIImageView+WebCache.h"
#import "DetailDistinationModel.h"
#import "headView.h"
#import "DisHeadView.h"
#import "HotCityCell.h"
#import "discountCell.h"
#import "TravailDeTailViewController.h"
@interface DetailDistinationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
    NSMutableArray *_adArray;//广告栏
    NSMutableArray *_hotcityArray;
    NSMutableArray *_discountArray;
    NSString *cname;
    NSString *ename;
    NSString *info;
}


@end

@implementation DetailDistinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray new];
    _adArray = [NSMutableArray new];
    _hotcityArray = [NSMutableArray new];
    _discountArray = [NSMutableArray new];
    [self createCollectionView];
    [self requestData];
}
-(void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    
    [_collectionView  registerNib:[UINib nibWithNibName:@"HotCityCell" bundle:nil] forCellWithReuseIdentifier:@"HotCityCell"];
   
    [_collectionView  registerNib:[UINib nibWithNibName:@"discountCell" bundle:nil] forCellWithReuseIdentifier:@"discountCell"];
    
    [_collectionView registerClass:[headView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:@"headView"];
    [_collectionView registerClass:[DisHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:@"DisHeadView"];
}
-(void)requestData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:ASIADESTINATIONDETAIL,self.DetialID,pa];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        DetailDistinationModel *detailModel=[[DetailDistinationModel alloc]mj_setKeyValues:dic];
        
        cname = detailModel.data.cnname;
        ename = detailModel.data.enname;
        info = detailModel.data.entryCont;
        _adArray = detailModel.data.photos;

        NSArray *array = detailModel.data.hot_city;
        for (NSDictionary *dic in array)
        {
            [_hotcityArray addObject:dic];
        }
        NSArray *disArray = detailModel.data.discount;
        for (NSDictionary *discount in disArray) {
            [_discountArray addObject:discount];
        }
        
        [_collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        return _hotcityArray.count;
    }else{
        return _discountArray.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        HotCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotCityCell" forIndexPath:indexPath];
        HotcityModel *model = _hotcityArray[indexPath.row];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.photo]];
        cell.imageV.layer.cornerRadius = 8;
        cell.imageV.layer.masksToBounds = YES;
        cell.cname.text = model.cnname;
        cell.ename.text = model.enname;
        return cell;
        
    }else
    {
        discountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"discountCell" forIndexPath:indexPath];
        DiscountModel *model = _discountArray[indexPath.row];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.photo]];
        cell.icon.layer.cornerRadius = 5;
        cell.icon.layer.masksToBounds = YES;
        cell.title.text = model.title;
        cell.discount.text = model.priceoff;
        NSString *strPrice = model.price;
        NSString* search = @"(>)(\\w+)(<)";
        NSRange range = [strPrice rangeOfString:search options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            cell.price.text = [NSString stringWithFormat:@"%@元起", [strPrice substringWithRange:NSMakeRange(range.location + 1, range.length - 2)]];
        }

        return cell;
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return CGSizeMake((Screen_Width-4)/2, 120*(Screen_Height/667.0));
    }else{
        return CGSizeMake(Screen_Width-4, 100*(Screen_Height/667.0));
    }
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3;
}
//设置最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
#pragma mark 点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TravailDeTailViewController * webView=[[TravailDeTailViewController alloc]init];
    DiscountModel *model = _discountArray[indexPath.row];
    webView.ID= model.ID;
//    [self.navigationController pushViewController:webView animated:YES];
    [self presentViewController:webView animated:YES completion:nil];

}
#pragma mark 设置头视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        DisHeadView *disview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DisHeadView" forIndexPath:indexPath];
        disview.tag = 100;
        [self createAD];
        return disview;
    }else{
        headView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headView" forIndexPath:indexPath];
        head.titleLabel.text = @"  超值自由行";
        return head;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return CGSizeMake(Screen_Width, 250*(Screen_Height/667.0));
    }else{
        return CGSizeMake(Screen_Width, 25*(Screen_Height/667.0));
    }
}

#pragma mark 实现代理方法
-(void)createAD
{
    DisHeadView *adview = (DisHeadView *)[self.view viewWithTag:100];
    adview.array = _adArray;
    adview.scrollView.contentSize = CGSizeMake(_adArray.count*Screen_Width, 250);
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(5, 10, 50, 50);
    [button1 setImage:[UIImage imageNamed:@"icon_trip_cancel@3x"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(btnLeftClick) forControlEvents:UIControlEventTouchUpInside];
    [adview addSubview:button1];
    for (UIView *subview in adview.scrollView.subviews)
    {
        [subview removeFromSuperview];//移除
    }
    //点击图片能够滑动,跳转
    for (int i=0; i<_adArray.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.userInteractionEnabled = YES;
        imageV.frame = CGRectMake(i*Screen_Width, 0, Screen_Width, 250);
        [imageV sd_setImageWithURL:[NSURL URLWithString:_adArray[i]]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;//轻触的次数
        [imageV addGestureRecognizer:tap];
        [adview.scrollView addSubview:imageV];
        UILabel *cnameLabel = [self creatLabelWithText:cname andWithFrame:CGRectMake(20+i*Screen_Width, 150, 100, 20) andWithFont:[UIFont systemFontOfSize:18] andColor:[UIColor whiteColor]];
        UILabel *enameLabel = [self creatLabelWithText:ename andWithFrame:CGRectMake(20+i*Screen_Width, 170, 100, 20) andWithFont:[UIFont systemFontOfSize:16] andColor:[UIColor whiteColor]];
        UILabel *infoLabel = [self creatLabelWithText:info andWithFrame:CGRectMake(20+i*Screen_Width, 200, Screen_Width-50, 50) andWithFont:[UIFont systemFontOfSize:16] andColor:[UIColor whiteColor]];
        [adview.scrollView addSubview:cnameLabel];
        [adview.scrollView addSubview:enameLabel];
        [adview.scrollView addSubview:infoLabel];
    }
    
}
-(void)btnLeftClick
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UILabel *)creatLabelWithText:(NSString *)text andWithFrame:(CGRect)frame andWithFont:(UIFont *)font andColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DisHeadView *adview = (DisHeadView *)[self.view viewWithTag:100];
    CGFloat offsetY = adview.scrollView.contentOffset.y;
    
    if (offsetY < 0)
    {
        CGFloat scale = 1 - offsetY/100;
        adview.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
