//
//  SpecialViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/22.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "SpecialViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "PrefixHeader.pch"
#import "SepecialCell.h"
#import "UIImageView+WebCache.h"
#import "TravailDeTailViewController.h"
@interface SpecialViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    int page;
    NSMutableArray *_dataArray;
    UICollectionView *_collectionView;
    BOOL _isRefresh;

}
@end

@implementation SpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray new];
    [self createCollectionView];
    [self createRefresh];
    [self requestData];
    
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
    
    page = 1;
    
    [self requestData];
}
-(void)pushRefresh
{
    _isRefresh = NO;
    
    page ++;//每次请求下一页数据
    
    [self requestData];
}

-(void)requestData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString* URL=[NSString stringWithFormat:SPECIALALL1,page,SPECIALALL2];
    [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = [rootDic objectForKey:@"data"];
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in array) {
            [_dataArray addObject:dic];
        }
        if (_isRefresh) {
            [_collectionView.mj_header endRefreshing];
        }
        else
        {
            [_collectionView.mj_footer endRefreshing];
        }
        
        [_collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
-(void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView  registerNib:[UINib nibWithNibName:@"SepecialCell" bundle:nil] forCellWithReuseIdentifier:@"SepecialCell"];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SepecialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SepecialCell" forIndexPath:indexPath];
    NSDictionary *dic = _dataArray[indexPath.row];
    NSString *photo = [dic objectForKey:@"photo"];
    [cell.iamgeV sd_setImageWithURL:[NSURL URLWithString:photo]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Screen_Width-10, 200);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
//设置最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.row];
    TravailDeTailViewController *DetailView = [[TravailDeTailViewController alloc]init];
    DetailView.url = [dic objectForKey:@"url"];
    [self.navigationController pushViewController:DetailView animated:YES];
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
