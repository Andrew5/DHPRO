//
//  DiscountViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/22.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "DiscountViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "DownMenuView.h"
#import "PrefixHeader.pch"
#import "discountSearchCell.h"
#import "TravailDeTailViewController.h"
@interface DiscountViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,DropDownMenuDataSource,DropDownMenuDelegate>
{
   
    int currentPage;
    BOOL _isRefresh;
    NSString* pathStrAll;
    NSString *pageStrAll;
}
@property(nonatomic,strong) NSMutableArray *dataSource;
//全部类型
@property(nonatomic,strong) NSMutableArray* typeArr;
//出发地
@property(nonatomic,strong) NSMutableArray* departArr;
//目的地
@property(nonatomic,strong) NSMutableArray* areaArr;
@property(nonatomic,strong) NSMutableArray* contryArr;
@property(nonatomic,strong) NSMutableArray* currentContryArr;
//时间
@property(nonatomic,strong) NSMutableArray* timeArr;
@property(nonatomic,strong)UICollectionView *collection;
@end

@implementation DiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage=1;
    [self addTitleViewWithTitle:@"抢折扣"];
    [self createHeadView];
    [self creatCollection];
    [self createData];
    //[self createRefresh];
}
//-(void)createRefresh
//{
//    _collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
//    
//    [_collection.mj_header beginRefreshing];
//    
//    _collection.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(pushRefresh)];
//    
//}
//-(void)pullRefresh
//{
//    _isRefresh = YES;
//    
//    currentPage = 1;
//    
//    [self createSearchPageData];
//}
//-(void)pushRefresh
//{
//    _isRefresh = NO;
//    
//    currentPage ++;//每次请求下一页数据
//    
//    [self createSearchPageData];
//}



-(void)createData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:DISCOUNT parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *data = [rootDic objectForKey:@"data"];
        NSArray *array = [data objectForKey:@"lastminutes"];
        for (NSDictionary *dic in array) {
            [self.dataSource addObject:dic];
        }
        [self.collection reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有查找到相关条目" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"清空筛选条件",nil];
        [alert show];
    }];

}

-(void)ceateMenuData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:DISCOUNTHEADER parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *data = [rootDic objectForKey:@"data"];
        [self.typeArr addObjectsFromArray:[data objectForKey:@"type"]];//类型
        [self.departArr addObjectsFromArray:[data objectForKey:@"departure"]];//出发地
        [self.timeArr addObjectsFromArray:[data objectForKey:@"times_drange"]];//时间
        [self.areaArr addObjectsFromArray:[data objectForKey:@"poi"]];
        //NSLog(@"%@",self.areaArr);
        for (NSDictionary *dic in self.areaArr) {
            [self.contryArr addObject:[dic objectForKey:@"country"]];//目的地
        }
//        for (NSDictionary *dic in self.areaArr)
//        {
//            NSArray *array = [dic objectForKey:@"country"];
//            for (NSDictionary *Dic in array) {
//                [self.contryArr addObject:Dic];
//            }
//        }
        self.currentContryArr=self.contryArr[0];
        //NSLog(@"===========%@",self.contryArr);
        //更新头部视图
        DownMenuView *menu1 = (DownMenuView*)[self.view viewWithTag:1001];
        [menu1.rightTableView reloadData];
        [menu1.leftTableView reloadData];
        DownMenuView *menu2 = (DownMenuView*)[self.view viewWithTag:1002];
        [menu2.rightTableView reloadData];
        [menu2.leftTableView reloadData];
        DownMenuView *menu3 = (DownMenuView*)[self.view viewWithTag:1003];
        [menu3.rightTableView reloadData];
        [menu3.leftTableView reloadData];
        DownMenuView *menu4 = (DownMenuView*)[self.view viewWithTag:1004];
        [menu4.rightTableView reloadData];
        [menu4.leftTableView reloadData];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有查找到相关条目" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"清空筛选条件",nil];
        [alert show];
    }];

}
-(void)createSearchData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:pathStrAll parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *data = [rootDic objectForKey:@"data"];
        NSArray *array = [data objectForKey:@"lastminutes"];
        if (self.dataSource.count!=0) {
            [self.dataSource removeAllObjects];
        }
        for (NSDictionary *dic in array) {
            [self.dataSource addObject:dic];
        }
        [self.collection reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有查找到相关条目" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"清空筛选条件",nil];
        [alert show];
    }];

}
-(void)createSearchPageData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:pageStrAll parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *data = [rootDic objectForKey:@"data"];
        NSArray *array = [data objectForKey:@"lastminutes"];
//        if (_dataSource.count!=0) {
//            [_dataSource removeAllObjects];
//        }
        for (NSDictionary *dic in array) {
            [self.dataSource addObject:dic];
        }
//        if (_isRefresh) {
//            [_collection.mj_header endRefreshing];
//        }
//        else
//        {
//            [_collection.mj_footer endRefreshing];
//        }

        [self.collection reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有查找到相关条目" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"清空筛选条件",nil];
        [alert show];
    }];
    
}
#pragma mark -UIAlertViewDelegate
//点击alertView上得某一个
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //NSLog(@"确定");
        }
            break;
        case 1:
        {
            //NSLog(@"清空筛选条件");
            UIButton* btn1 = (UIButton*)[self.view viewWithTag:501];
            [btn1 setTitle:@"全部类型" forState:UIControlStateNormal];
            NSDictionary *dict1 = @{NSFontAttributeName:btn1.titleLabel.font};
            CGSize size1 = [@"全部类型" boundingRectWithSize:CGSizeMake(150, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
            btn1.imageEdgeInsets = UIEdgeInsetsMake(11, size1.width+25, 11, 0);
            
            UIButton* btn2 = (UIButton*)[self.view viewWithTag:502];
            [btn2 setTitle:@"出发地 " forState:UIControlStateNormal];
            NSDictionary *dict2 = @{NSFontAttributeName:btn2.titleLabel.font};
            CGSize size2 = [@"全部类型" boundingRectWithSize:CGSizeMake(150, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict2 context:nil].size;
            btn2.imageEdgeInsets = UIEdgeInsetsMake(11, size2.width+25, 11, 0);
            
            UIButton* btn3 = (UIButton*)[self.view viewWithTag:503];
            [btn3 setTitle:@"目的地 " forState:UIControlStateNormal];
            NSDictionary *dict3 = @{NSFontAttributeName:btn3.titleLabel.font};
            CGSize size3 = [@"全部类型" boundingRectWithSize:CGSizeMake(150, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict3 context:nil].size;
            btn3.imageEdgeInsets = UIEdgeInsetsMake(11, size3.width+25, 11, 0);
            
            UIButton* btn4 = (UIButton*)[self.view viewWithTag:504];
            [btn4 setTitle:@"旅行时间" forState:UIControlStateNormal];
            NSDictionary *dict4 = @{NSFontAttributeName:btn4.titleLabel.font};
            CGSize size4 = [@"全部类型" boundingRectWithSize:CGSizeMake(150, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict4 context:nil].size;
            btn4.imageEdgeInsets = UIEdgeInsetsMake(11, size4.width+25, 11, 0);
            
            [self resetItemSizeWithMenuTag:0 By:nil];
        }
        default:
            break;
    }
    
}


/********头部的视图***************/
-(void)createHeadView
{
    UIView* headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    //headerView.backgroundColor=[UIColor colorWithWhite:1 alpha:1.f];
    headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"PayOnlineBackgroudImg"]];
    [self.view addSubview:headerView];
    
    NSArray* headArray=@[@"全部类型",@"出发地 ",@"目的地 ",@"旅行时间"];
    for (int i=0; i<4; i++) {
        UIButton *activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0+(headerView.frame.size.width/4)*i, 0, headerView.frame.size.width/4, 30)];
        activityBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [activityBtn setTitle:headArray[i] forState:UIControlStateNormal];
        [activityBtn setImage:[UIImage imageNamed:@"expandableImage"] forState:UIControlStateNormal];
        
        NSDictionary *dict = @{NSFontAttributeName:activityBtn.titleLabel.font};
        CGSize size = [headArray[i] boundingRectWithSize:CGSizeMake(150, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        activityBtn.imageEdgeInsets = UIEdgeInsetsMake(11, size.width+25, 11, 0);
        
        
        activityBtn.tag=501+i;
        [activityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [activityBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:activityBtn];
        
        DownMenuView *menu = [[DownMenuView alloc] initWithOrigin:CGPointMake(0, 30) andHeight:300];
        menu.transformView = activityBtn.imageView;
        menu.tag = 1001+i;
        menu.dataSource = self;
        menu.delegate = self;
        [self.view addSubview:menu];
    }

}
/**********按钮点击事件***********/
-(void)btnPressed:(id)sender{
    if (self.typeArr.count==0||self.departArr.count==0||self.areaArr.count==0||self.timeArr.count==0) {
        [self ceateMenuData];
    }
    UIButton* btn=(UIButton* )sender;
    DownMenuView *menu1 = (DownMenuView*)[self.view viewWithTag:1001];
    DownMenuView *menu2 = (DownMenuView*)[self.view viewWithTag:1002];
    DownMenuView *menu3 = (DownMenuView*)[self.view viewWithTag:1003];
    DownMenuView *menu4 = (DownMenuView*)[self.view viewWithTag:1004];
    if (btn.tag==501) {
        [UIView animateWithDuration:0.2 animations:^{
            
        } completion:^(BOOL finished) {
            [menu1 menuTapped];
            if (menu2.show==YES) {
                [menu2 menuTapped];
            }
            if (menu3.show==YES) {
                [menu3 menuTapped];
            }
            if (menu4.show==YES) {
                [menu4 menuTapped];
            }
        }];
    }else if(btn.tag==502){
        [UIView animateWithDuration:0.2 animations:^{
            
        } completion:^(BOOL finished) {
            [menu2 menuTapped];
            if (menu1.show==YES) {
                [menu1 menuTapped];
            }
            if (menu3.show==YES) {
                [menu3 menuTapped];
            }
            if (menu4.show==YES) {
                [menu4 menuTapped];
            }
        }];
    }else if (btn.tag==503) {
        [UIView animateWithDuration:0.2 animations:^{
            
        } completion:^(BOOL finished) {
            [menu3 menuTapped];
            if (menu1.show==YES) {
                [menu1 menuTapped];
            }
            if (menu2.show==YES) {
                [menu2 menuTapped];
            }
            if (menu4.show==YES) {
                [menu4 menuTapped];
            }
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            
        } completion:^(BOOL finished) {
            [menu4 menuTapped];
            if (menu1.show==YES) {
                [menu1 menuTapped];
            }
            if (menu2.show==YES) {
                [menu2 menuTapped];
            }
            if (menu3.show==YES) {
                [menu3 menuTapped];
            }
        }];
    }
    
}

-(void)creatCollection{
    UICollectionViewFlowLayout* layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    self.collection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    self.collection.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
//    _collection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-145) collectionViewLayout:layout];
    self.collection.dataSource=self;
    self.collection.delegate=self;
    self.collection.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.f];
    [self.view addSubview:self.collection];
    [self.collection  registerNib:[UINib nibWithNibName:@"discountSearchCell" bundle:nil] forCellWithReuseIdentifier:@"discountSearchCell"];
    
    
}
#pragma mark collection的代理
-(NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    discountSearchCell* disCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"discountSearchCell" forIndexPath:indexPath];
    if (self.dataSource.count!=0) {
        NSString* imageStr=self.dataSource[indexPath.row][@"pic"];
        [disCell.imageV sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        disCell.imageV.layer.cornerRadius = 10;
        disCell.imageV.layer.masksToBounds = YES;
        disCell.info.text=self.dataSource[indexPath.row][@"title"];
        disCell.count.text=self.dataSource[indexPath.row][@"departureTime"];
       
        NSString* strPrice=self.dataSource[indexPath.row][@"price"];
        NSString* search = @"(>)(\\w+)(<)";
        NSRange range = [strPrice rangeOfString:search options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            
            disCell.price.text = [NSString stringWithFormat:@"%@元起", [strPrice substringWithRange:NSMakeRange(range.location + 1, range.length - 2)]];
            
        }
        
        //disCell.disDiscountLabel.text=_dataSource[indexPath.row][@"lastminute_des"];
    }
    
    return disCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(182*(Screen_Width/375.0), 180*(Screen_Height/667.0));
}

//设置collectionView当前页距离四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 2.5*(Screen_Width/375.0), 0, 2.5*(Screen_Width/375.0));
}

//设置最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10*(Screen_Height/667.0);
}
//设置最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5*(Screen_Width/375.0);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TravailDeTailViewController * webView=[[TravailDeTailViewController alloc]init];
    webView.url=self.dataSource[indexPath.row][@"url"];
    //[self.navigationController pushViewController:webView animated:YES];
    [self presentViewController:webView animated:YES completion:nil];
}

#pragma mark - reset button size
/**************通过菜单按钮的tag 值得到需要拼接的字符串******************/
-(void)resetItemSizeWithMenuTag:(NSInteger )tag By:(NSString*)str{
    UIButton* btn;
    if (tag==1001) {
        btn = (UIButton*)[self.view viewWithTag:501];
    }else if (tag==1002){
        btn = (UIButton*)[self.view viewWithTag:502];
    }else if (tag==1003){
        btn = (UIButton*)[self.view viewWithTag:503];
    }else if (tag==1004){
        btn = (UIButton*)[self.view viewWithTag:504];
    }else{
        
    }
    if (tag>=1001&&tag<=1004) {
        
        [btn setTitle:str forState:UIControlStateNormal];
        NSDictionary *dict = @{NSFontAttributeName:btn.titleLabel.font};
        CGSize size = [str boundingRectWithSize:CGSizeMake(150, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y,size.width+33, 30);
        btn.imageEdgeInsets = UIEdgeInsetsMake(11, size.width+23, 11, 0);
    }
    if ((tag>=1001&&tag<=1004)||tag==0) {
        UIButton* btn1 = (UIButton*)[self.view viewWithTag:501];
        NSString* str1=btn1.titleLabel.text;
        UIButton* btn2 = (UIButton*)[self.view viewWithTag:502];
        NSMutableString* str2=[[NSMutableString alloc]initWithString:btn2.titleLabel.text];
        UIButton* btn3 = (UIButton*)[self.view viewWithTag:503];
        NSMutableString* str3=[[NSMutableString alloc]initWithString:btn3.titleLabel.text];
        UIButton* btn4 = (UIButton*)[self.view viewWithTag:504];
        NSMutableString* str4=[[NSMutableString alloc]initWithString:btn4.titleLabel.text];
        
        if ([str2 isEqualToString:@"出发地 "]) {
            [str2 setString:@"全部出发地"];
        }
        if ([str3 isEqualToString:@"目的地 "]) {
            [str3 setString:@"全部目的地"];
        }
        if ([str4 isEqualToString:@"旅行时间"]) {
            [str4 setString:@"全部时间"];
        }
        //NSLog(@"%@,%@,%@,%@",str1,str2,str3,str4);
        
        //查找_type组的index值,找到拼接id
        int index=0;
        for (int i=0; i<self.typeArr.count; i++) {
            if ([self.typeArr[i][@"catename"] isEqualToString:str1]) {
                index=i;
            }
        }
        //NSLog(@"%@",_typeArr);
        NSString* pathStr1=self.typeArr[index][@"id"];
        
        //查找_departArr组的index值,找到拼接id
        index=0;
        for (int i=0; i<self.departArr.count; i++) {
            if ([self.departArr[i][@"city_des"] isEqualToString:str2]) {
                index=i;
            }
        }
        NSString* pathStr2=self.departArr[index][@"city"];
        
        //查找_areaArr数组 和_currentContryArr数组 的index值,找到拼接id
        index=0;
        int indexArea=0;
        int indexContry=0;
        NSMutableString* pathStr3=[[NSMutableString alloc]init];
        NSMutableString* pathStr4=[[NSMutableString alloc]init];
        for (int i=0; i<self.areaArr.count; i++) {
            //NSLog(@"%d",i);
            NSMutableArray* tempArr=[[NSMutableArray alloc]init];
            [tempArr addObjectsFromArray:self.areaArr[i][@"country"]];
            for (int j=0; j<tempArr.count; j++) {
                //NSLog(@"%d",j);
                if ([tempArr[j][@"country_name"] isEqualToString:str3]) {
                    indexContry=j;
                    indexArea=i;
                }
            }
        }
        [pathStr3 setString:[NSString stringWithFormat:@"%@",self.areaArr[indexArea][@"continent_id"]]];
        [pathStr4 setString:[NSString stringWithFormat:@"%@",self.currentContryArr[indexContry][@"country_id"]]];
        
        //查找_timeArr组的index值,找到拼接id
        index=0;
        for (int i=0; i<self.timeArr.count; i++) {
            if ([self.timeArr[i][@"description"] isEqualToString:str4]) {
                index=i;
            }
        }
        NSString* pathStr5=self.timeArr[index][@"times"];
        //NSLog(@"%@ %@ %@ %@ %@",pathStr1,pathStr2,pathStr3,pathStr4,pathStr5);
        //14c&page=%d&page_size=20&product_type=%@&times=%@%@"
        NSString *str =[NSString stringWithFormat:DISCOUNTSMAL1,pathStr3,pathStr4,pathStr2,pathStr1,pathStr5,DISCOUNTSMAL2];
        pathStrAll = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //NSLog(@"%@",pathStr3);
        //NSLog(@"%@",pathStrAll);
        [self createSearchData];
        
    }else{
        //        _typeArr=[[NSMutableArray alloc]init];
        //
        //        _departArr=[[NSMutableArray alloc]init];
        //
        //        _areaArr=[[NSMutableArray alloc]init];
        //        _contryArr=[[NSMutableArray alloc]init];
        //        _currentContryArr=[[NSMutableArray alloc]init];
        //
        //        _timeArr=[[NSMutableArray alloc]init];
        if (self.typeArr.count==0&&self.departArr.count==0&&self.timeArr.count==0&&self.areaArr.count==0&&self.contryArr.count==0&&self.currentContryArr.count==0) {
            
            pageStrAll=[NSString stringWithFormat:DISCOUNTSMAL111,currentPage,DISCOUNTSMAL2];
//            NSString *str =[NSString stringWithFormat:DISCOUNTSMAL111,currentPage,DISCOUNTSMAL2];
//            pageStrAll = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%d",currentPage);
            //NSLog(@"%@",pathStr3);
            //NSLog(@"%@",pathStrAll);
            [self createSearchPageData];
            
        }else{
            //NSLog(@"%d",tag);
            UIButton* btn1 = (UIButton*)[self.view viewWithTag:501];
            NSString* str1=btn1.titleLabel.text;
            UIButton* btn2 = (UIButton*)[self.view viewWithTag:502];
            NSMutableString* str2=[[NSMutableString alloc]initWithString:btn2.titleLabel.text];
            UIButton* btn3 = (UIButton*)[self.view viewWithTag:503];
            NSMutableString* str3=[[NSMutableString alloc]initWithString:btn3.titleLabel.text];
            UIButton* btn4 = (UIButton*)[self.view viewWithTag:504];
            NSMutableString* str4=[[NSMutableString alloc]initWithString:btn4.titleLabel.text];
            
            if ([str2 isEqualToString:@"出发地 "]) {
                [str2 setString:@"全部出发地"];
            }
            if ([str3 isEqualToString:@"目的地 "]) {
                [str3 setString:@"全部目的地"];
            }
            if ([str4 isEqualToString:@"旅行时间"]) {
                [str4 setString:@"全部时间"];
            }
            //NSLog(@"%@,%@,%@,%@",str1,str2,str3,str4);
            
            //查找_type组的index值,找到拼接id
            int index=0;
            for (int i=0; i<self.typeArr.count; i++) {
                if ([self.typeArr[i][@"catename"] isEqualToString:str1]) {
                    index=i;
                }
            }
            //NSLog(@"%@",_typeArr);
            NSString* pathStr1=self.typeArr[index][@"id"];
            
            //查找_departArr组的index值,找到拼接id
            index=0;
            for (int i=0; i<self.departArr.count; i++) {
                if ([self.departArr[i][@"city_des"] isEqualToString:str2]) {
                    index=i;
                }
            }
            NSString* pathStr2=self.departArr[index][@"city"];
            
            //查找_areaArr数组 和_currentContryArr数组 的index值,找到拼接id
            index=0;
            int indexArea=0;
            int indexContry=0;
            NSMutableString* pathStr3=[[NSMutableString alloc]init];
            NSMutableString* pathStr4=[[NSMutableString alloc]init];
            for (int i=0; i<self.areaArr.count; i++) {
                //NSLog(@"%d",i);
                NSMutableArray* tempArr=[[NSMutableArray alloc]init];
                [tempArr addObjectsFromArray:self.areaArr[i][@"country"]];
                for (int j=0; j<tempArr.count; j++) {
                    //NSLog(@"%d",j);
                    if ([tempArr[j][@"country_name"] isEqualToString:str3]) {
                        indexContry=j;
                        indexArea=i;
                    }
                }
            }
            [pathStr3 setString:[NSString stringWithFormat:@"%@",self.areaArr[indexArea][@"continent_id"]]];
            [pathStr4 setString:[NSString stringWithFormat:@"%@",self.currentContryArr[indexContry][@"country_id"]]];
            
            //查找_timeArr组的index值,找到拼接id
            index=0;
            for (int i=0; i<self.timeArr.count; i++) {
                if ([self.timeArr[i][@"description"] isEqualToString:str4]) {
                    index=i;
                }
            }
            NSString* pathStr5=self.timeArr[index][@"times"];
            //NSLog(@"%@ %@ %@ %@ %@",pathStr1,pathStr2,pathStr3,pathStr4,pathStr5);

            //14c&page=%d&page_size=20&product_type=%@&times=%@%@"
            pageStrAll=[NSString stringWithFormat:DISCOUNTSMAL11,pathStr3,pathStr4,pathStr2,currentPage,pathStr1,pathStr5,DISCOUNTSMAL2];
//            NSString *str =[NSString stringWithFormat:DISCOUNTSMAL11,pathStr3,pathStr4,pathStr2,currentPage,pathStr1,pathStr5,DISCOUNTSMAL2];
//            pageStrAll = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%d",currentPage);
            //NSLog(@"%@",pathStr3);
            //NSLog(@"%@",pathStrAll);
            [self createSearchPageData];
           
        }
        
    }
    
}


#pragma mark - FSDropDown datasource & delegate

- (NSInteger)menu:(DownMenuView *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (menu.tag==1001) {
        if (tableView == menu.rightTableView) {
            return 1;
        }else{
            return self.typeArr.count;
        }
    }else if (menu.tag==1002){
        if (tableView == menu.rightTableView) {
            return 1;
        }else{
            return self.departArr.count;
        }
    }else if (menu.tag==1003) {
        if (tableView == menu.rightTableView) {
            return self.areaArr.count;
        }else{
            return self.currentContryArr.count;
        }
    }else{
        if (tableView == menu.rightTableView) {
            return 1;
        }else{
            return self.timeArr.count;
        }
    }
    
}
- (NSString *)menu:(DownMenuView *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (menu.tag==1001) {
        if (tableView == menu.rightTableView) {
            
            return @"全部类型";
        }else{
            return self.typeArr[indexPath.row][@"catename"];
        }
    }else if (menu.tag==1002){
        if (tableView == menu.rightTableView) {
            
            return @"全部出发地";
        }else{
            return self.departArr[indexPath.row][@"city_des"];
        }
    }else if (menu.tag==1003) {
        if (tableView == menu.rightTableView) {
            
            return self.areaArr[indexPath.row][@"continent_name"];
        }else{
            return self.currentContryArr[indexPath.row][@"country_name"];
        }
    }else{
        if (tableView == menu.rightTableView) {
            
            return @"全部时间";
        }else{
            return self.timeArr[indexPath.row][@"description"];
        }
    }
}


- (void)menu:(DownMenuView *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"%ld",menu.tag);
    if (menu.tag==1001) {
        if(tableView == menu.rightTableView){
            
        }else{
            [self resetItemSizeWithMenuTag:menu.tag By:self.typeArr[indexPath.row][@"catename"]];
        }
    }else if (menu.tag==1002){
        if(tableView == menu.rightTableView){
            
        }else{
            [self resetItemSizeWithMenuTag:menu.tag By:self.departArr[indexPath.row][@"city_des"]];
        }
    }else if (menu.tag==1003) {
        if(tableView == menu.rightTableView){
            if (_contryArr.count!=0) {
                self.currentContryArr = self.contryArr[indexPath.row];
                [menu.leftTableView reloadData];
            }
        }else{
            [self resetItemSizeWithMenuTag:menu.tag By:self.currentContryArr[indexPath.row][@"country_name"]];
        }
    }else{
        if(tableView == menu.rightTableView){
            
        }else{
            [self resetItemSizeWithMenuTag:menu.tag By:self.timeArr[indexPath.row][@"description"]];
        }
    }
}



#pragma mark 懒加载
//重写getter方法，用到的时候才初始化，经典的引用就是视图控制器的view

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource= [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(NSMutableArray *)typeArr
{
    if (_typeArr == nil) {
        _typeArr= [[NSMutableArray alloc]init];
    }
    return _typeArr;
}
-(NSMutableArray *)departArr
{
    if (_departArr == nil) {
        _departArr= [[NSMutableArray alloc]init];
    }
    return _departArr;
}
-(NSMutableArray *)areaArr
{
    if (_areaArr == nil) {
        _areaArr= [[NSMutableArray alloc]init];
    }
    return _areaArr;
}
-(NSMutableArray *)contryArr
{
    if (_contryArr == nil) {
        _contryArr= [[NSMutableArray alloc]init];
    }
    return _contryArr;
}
-(NSMutableArray *)currentContryArr
{
    if (_currentContryArr == nil) {
        _currentContryArr= [[NSMutableArray alloc]init];
    }
    return _currentContryArr;
}
-(NSMutableArray *)timeArr
{
    if (_timeArr == nil) {
        _timeArr= [[NSMutableArray alloc]init];
    }
    return _timeArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
