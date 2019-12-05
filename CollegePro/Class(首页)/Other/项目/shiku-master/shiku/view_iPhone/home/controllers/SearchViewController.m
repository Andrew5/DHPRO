//
//  SearchViewController.m
//  shiku
//
//  Created by txj on 15/5/22.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHistoryCell.h"
#define nibHname @"CollectionCell"

@interface SearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL isbool;

}
@property(nonatomic ,strong)NSMutableArray * m_DataArr;

@property(nonatomic ,strong)UICollectionView * m_CollectionView;

@property(nonatomic ,strong)UILabel * label;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.m_DataArr = [NSMutableArray array];
   
#pragma mark - TopBar
    
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(10, 10, 8, 13);
//    [leftBtn setImage:[UIImage imageNamed:@"iii_03"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(leftBarButtonItemTouched) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    
    self.navigationItem.leftBarButtonItem = [self tbarBackButtonWhite];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [rightBtn setFrame:CGRectMake(0, 0, 30, 15)];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(callBack) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightBarBtnItem;
    //[self tBarIconButtonItem:@"\U0000A10A" action:@selector(rightBarButtonItemTouched)];
    UIView *searchFieldView = [self tToolbarSearchField:[UIScreen mainScreen].bounds.size.width-100 withheight:20
                                 isbecomeFirstResponder:YES action:nil textFieldDelegate:self];
    
    searchFieldView.autoresizingMask=YES;
    self.navigationItem.titleView=searchFieldView;
   
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 23)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"搜索历史";
    _label.textColor = [UIColor grayColor];
    _label.font = [UIFont systemFontOfSize:14];
    _label.hidden = YES;
    [self.view addSubview:_label];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     self.m_DataArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"SwarchHistory"];
    if (self.m_DataArr.count>0) {
        _label.hidden = NO;
    }
    else
    {
        _label.hidden = YES;
    
    }
     [self CreateCollerView];
    [self.m_CollectionView reloadData];
}

-(void)CreateCollerView
{
    //创建CollectionView
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.5;
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.m_CollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(30, 40, [UIScreen mainScreen].bounds.size.width-60, [UIScreen mainScreen].bounds.size.height-64) collectionViewLayout:flowLayout];
     self.m_CollectionView.delegate = self;
     self.m_CollectionView.dataSource = self;
     self.m_CollectionView.backgroundColor = [UIColor whiteColor];
    //注册相对应的CollectionView
    [self.m_CollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    [self.view addSubview:self.m_CollectionView];
}

-(void)callBack{
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [textField resignFirstResponder];
//    
//    return YES;
//}// return NO to disallow editing.
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [textField resignFirstResponder];
//}// became first responder
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    [textField resignFirstResponder];
//    
//    return YES;
//    
//}
// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    NSLog(@"textfield 搜索结果");
//
//    return YES;
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [textField resignFirstResponder];
//    
//}
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called



//- (BOOL)textFieldShouldClear:(UITextField *)textField{
//    [textField resignFirstResponder];
//    
//    return YES;
//    
//}
// called when clear button pressed. return NO to ignore (no notifications)


#pragma mark - TopBar
-(void)leftBarButtonItemTouched
{
    [self.navigationController popViewControllerAnimated:NO];
//    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)rightBarButtonItemTouched
{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        isbool = NO;
        if (!filter) {
            filter=[FILTER new];
        }
            filter.keywords=textField.text;
        NSArray * Arr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"SwarchHistory"];
        NSMutableArray * SwarchHistory = [[NSMutableArray alloc]initWithArray:Arr];
        for (int i = 0; i<[SwarchHistory count]; i++) {
            NSString * str = [SwarchHistory objectAtIndex:i];
            if ([str isEqualToString:textField.text]||textField.text.length==0) {
                isbool = YES;
            }
        }
        if (!isbool) {
            [SwarchHistory addObject:textField.text];
        }
        [[NSUserDefaults standardUserDefaults] setObject:SwarchHistory forKey:@"SwarchHistory"];
        [[NSUserDefaults standardUserDefaults] synchronize];
            GoodsListViewController *plcv=[[GoodsListViewController alloc] initWithFilter:filter];
                //[self showNavigationView:plcv];
//        [self showViewController:plcv sender:self];
            [self.navigationController pushViewController:plcv animated:NO];
        
                //            在这里做你响应return键的代码
                //            self.searchModel.keywords=textField.text;
                //            [self doSearch];
                              
        
        
            return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

//+ (instancetype)shared
//{
//    static SearchViewController *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[SearchViewController alloc] init];
//        // Do any other initialisation stuff here
//    });
//    return sharedInstance;
//}

#pragma mark --UICollectionViewDelegate


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
       return self.m_DataArr.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 23)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [self.m_DataArr objectAtIndex:indexPath.row];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    [cell addSubview:label];
       return  cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    return CGSizeMake(70,23);
}
//- (CGFloat)minimumInteritemSpacing {
//    return 0;
//}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [[self layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        NSLog(@"------YY---%@", NSStringFromCGRect([attr frame]));
    }
    return attributes;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!filter) {
        filter=[FILTER new];
    }
    filter.keywords=[self.m_DataArr objectAtIndex:indexPath.row];
    GoodsListViewController *plcv=[[GoodsListViewController alloc] initWithFilter:filter];
    [self.navigationController pushViewController:plcv animated:NO];
}


@end
