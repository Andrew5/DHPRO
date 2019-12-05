//
//  adviseViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/28.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "adviseViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "PrefixHeader.pch"
#import "leftModel.h"
#import "rightModel.h"
#import "leftCell.h"
#import "rightCell.h"
#import "headView.h"
#import "adviseDetailViewController.h"
@interface adviseViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UITableView *leftTableView;
@property (strong, nonatomic) UICollectionView *rightcollectionView;
@property(nonatomic,strong)NSMutableArray *leftArray;
@property(nonatomic,strong)NSMutableArray *rightArray;
@end

@implementation adviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleViewWithTitle:@"看锦囊"];

    [self createcollectionView];
    [self createTableView];
    [self requestData];
    [self requestLeftData];
    [self requestRightData];
}
- (void)addTitleViewWithTitle:(NSString *)title
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.navigationItem.titleView = titleView;
    // 设置字体
    titleView.font = [UIFont systemFontOfSize:20];
    // 设置颜色
    titleView.textColor = [UIColor blackColor];
    // 设置文字居中
    titleView.textAlignment = NSTextAlignmentCenter;
    // 设置文本
    titleView.text = title;
    
    
}
-(void)requestLeftData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:LEFTVIEW parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = [rootDic objectForKey:@"data"];
        for (NSDictionary *dic in array) {
            leftModel *model = [[leftModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.leftArray addObject:model];
        }
        NSLog(@"%@",self.leftArray);
        [self.leftTableView reloadData];
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
-(void)requestData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:LATEST parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [_rightArray removeAllObjects];
        rightModel *model = [[rightModel alloc]mj_setKeyValues:rootDic];
        self.rightArray = model.data;
        [self.rightcollectionView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
-(void)requestRightData
{
    leftModel *model = _leftArray[_leftTableView.indexPathForSelectedRow.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:RIGHT1,model.id,RIGHT2];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [_rightArray removeAllObjects];
        rightModel *model = [[rightModel alloc]mj_setKeyValues:rootDic];
        self.rightArray = model.data;
        [self.rightcollectionView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}

-(void)createcollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _rightcollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(80, 0, Screen_Width-80, Screen_Height) collectionViewLayout:layout];
    self.rightcollectionView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    _rightcollectionView.dataSource = self;
    _rightcollectionView.delegate = self;
    _rightcollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_rightcollectionView];
    _rightcollectionView.backgroundColor = [UIColor whiteColor];
    
    [_rightcollectionView  registerNib:[UINib nibWithNibName:@"rightCell" bundle:nil] forCellWithReuseIdentifier:@"rightCell"];
    [_rightcollectionView registerClass:[headView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:@"headView"];

}

-(void)createTableView
{
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, Screen_Height) style:UITableViewStylePlain];
    _leftTableView.dataSource= self;
    _leftTableView.delegate = self;
    _leftTableView.rowHeight = 70;
//    _leftTableView.bounces = NO;
    _leftTableView.showsHorizontalScrollIndicator = NO;
    _leftTableView.showsVerticalScrollIndicator = NO;
    [self.leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([leftCell class]) bundle:nil] forCellReuseIdentifier:@"leftCell"];
    
    
    // 设置inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.leftTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    
    [self.view addSubview:self.leftTableView];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    leftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
    leftModel *model = self.leftArray[indexPath.row];
    cell.textLabel.text = model.cnname;
    return cell;
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    leftModel *model = self.leftArray[indexPath.row];
//    self.ID = model.id;
    
    [self requestRightData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _rightArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    DaModel *model = _rightArray[section];
    return model.guides.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    rightCell *right = [collectionView dequeueReusableCellWithReuseIdentifier:@"rightCell" forIndexPath:indexPath];
    DaModel *dataModel = self.rightArray[indexPath.section];
    GuidesModel *model = dataModel.guides[indexPath.row];
    NSString* imageStr=[NSString stringWithFormat:@"%@/260_390.jpg?cover_updatetime=%@",model.cover,model.cover_updatetime];
    [right.imageV sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    right.imageV.layer.cornerRadius = 5;
    right.imageV.layer.masksToBounds = YES;
    return right;

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((Screen_Width-90)/3, 160);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
//设置最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
#pragma mark 设置头视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    headView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headView" forIndexPath:indexPath];
    DaModel *model = _rightArray[indexPath.section];
    head.titleLabel.text = [NSString stringWithFormat:@"  %@",model.name];
    return head;

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
   
    return CGSizeMake(Screen_Width-80, 25*(Screen_Height/667.0));
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    adviseDetailViewController * view =[[adviseDetailViewController alloc]init];
    DaModel *model = _rightArray[indexPath.section];
    GuidesModel *guide = model.guides[indexPath.row];
    view.detailID = guide.guide_id;
    [self presentViewController:view animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 懒加载
//重写getter方法，用到的时候才初始化，经典的引用就是视图控制器的view

-(NSMutableArray *)leftArray
{
    if (_leftArray == nil) {
        _leftArray= [[NSMutableArray alloc]init];
    }
    return _leftArray;
}
-(NSMutableArray *)rightArray
{
    if (_rightArray == nil) {
        _rightArray= [[NSMutableArray alloc]init];
    }
    return _rightArray;
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
