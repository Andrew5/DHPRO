//
//  CategoryViewController.m
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CategoryViewController.h"
#import "GoodsListViewController.h"

@interface CategoryViewController ()

@end
#define CollectionViewCell1 @"CategoryViewCL1CollectionViewCell"
#define CollectionViewCell2 @"CategoryViewCL2CollectionViewCell"
@implementation CategoryViewController

- (void)setup
{
//    App *app = [App shared];
//    @weakify(self)
//    [RACObserve(app, currentUser) subscribeNext:^(USER *user) {
//        @strongify(self);
//        self.user = user;
//        if ([user authorized])
//        {
//            [self loadData];
//            [ec.view removeFromSuperview];
//        }
//        else
//        {
//            ec=[EmptyViewController shared];
//            [self.view addSubview:[[EmptyViewController shared] view]];
//            ec.titleLabel.text=@"您还没有订单";
//            ec.iconLable.text=@"\U0000B01A";
//            ec.view.frame=self.navigationController.view.frame;
//        }
//    }];
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        @strongify(self)
//        
//        [self loadData];
//        
//        CGPoint point = self.tableView.contentOffset;
//        point.y = 0;
//        self.tableView.contentOffset = point;
//    }];
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        @strongify(self)
//        [self loadDataMore];
//    }];
//    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
//    [self.tableView.pullToRefreshView setTitle:@"立即刷新" forState:SVPullToRefreshStateTriggered];
//    self.tableView.showsInfiniteScrolling = NO;
    
}
-(instancetype)initWithBackBtn
{
    self=[self init];
    if (self) {
        isShowBackBtn=YES;
    }
    return self;
}
-(void)loadData
{
    [[self.backend requestCateList]
     subscribeNext:[self didLoadData]];
}
- (void(^)(RACTuple *))didLoadData
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        self.datalist1=[[NSMutableArray alloc] initWithArray:(NSArray *)parameters];
        if (self.datalist1.count>0) {
            [self.collectionView1 reloadData];
            CATEGORY *pc=[self.datalist1 objectAtIndex:0];
            self.datalist2=pc.children;
            
            [self.collectionView2 reloadData];
            [ec.view removeFromSuperview];
        }
        else
        {
            ec=[EmptyViewController shared];
            [self.view addSubview:[[EmptyViewController shared] view]];
            ec.titleLabel.text=@"该分类下没有商品";
            ec.iconLable.text=@"\U0000B01A";
            ec.view.frame=self.navigationController.view.frame;
            
        }
        
    };
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    UIView *searchFieldView=[self tToolbarSearchField:SEARCH_FIELD_WIDTH withheight:20
                               isbecomeFirstResponder:YES action:@selector(searchFieldTouched) textFieldDelegate:self];
    NSLog(@"%f",searchFieldView.frame.origin.x);
    searchFieldView.autoresizingMask=YES;
    self.navigationItem.titleView=searchFieldView;

    self.backend=[CateBackend new];
    
    screenSize=self.view.frame.size;

    if (isShowBackBtn) {
        self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    }else
        self.navigationItem.leftBarButtonItem=[self tBarIconButtonItem:@"\U0000A14A" action:@selector(leftBarButtonItemTouched)];
    //    self.navigationItem.rightBarButtonItem=[self tBarIconButtonItem:@"\U0000A08A" action:@selector(rightBarButtonItemTouched)];
        
        self.collectionView1.backgroundColor=BG_COLOR;
        [self.collectionView1 setDataSource:self];
        [self.collectionView1 setDelegate:self];
        [self.collectionView1 registerNib:[UINib nibWithNibName:CollectionViewCell1 bundle:nil] forCellWithReuseIdentifier:CollectionViewCell1];
        
        
        self.collectionView2.backgroundColor=WHITE_COLOR;
        [self.collectionView2 setDataSource:self];
        [self.collectionView2 setDelegate:self];
        [self.collectionView2 registerNib:[UINib nibWithNibName:CollectionViewCell2 bundle:nil] forCellWithReuseIdentifier:CollectionViewCell2];
        
        [self loadData];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackKeyboard)];
    [self.view addGestureRecognizer:tap];
}
-(void)tapBackKeyboard{
    [self.view endEditing:YES];
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [textField resignFirstResponder];
//
//    return YES;
//}// return NO to disallow editing.
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [textField resignFirstResponder];
//}// became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;

}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];

}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called



- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;

}// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;

}
#pragma mark - TopBar
-(void)leftBarButtonItemTouched
{
    CategoryViewController *cc=[[CategoryViewController alloc] initWithBackBtn];
    [self showNavigationViewMainColor:cc];
}
-(void)rightBarButtonItemTouched
{
}
-(void)searchFieldTouched
{
    
    SearchViewController *sc=[SearchViewController new];
    [self showNavigationViewMainColor:sc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView==self.collectionView2)
        return self.datalist2.count;
    return self.datalist1.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell * cell;
    if(collectionView==self.collectionView1)
    {
        CategoryViewCL1CollectionViewCell *_cell=[collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCell1 forIndexPath:indexPath];
        
        _cell.category=[self.datalist1 objectAtIndex:indexPath.row];
        [_cell bind];
        if (indexPath.row==0&&!hasSelect) {
            _cell.backgroundColor=[UIColor whiteColor];
            _cell.nameLabel.textColor=MAIN_COLOR;
            [_cell.layer setBorderWidth:0];
            firstcell=_cell;
        }
        cell = _cell;

    }
    else if(collectionView==self.collectionView2)
    {
        CategoryViewCL2CollectionViewCell *_cell=[collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCell2 forIndexPath:indexPath];
        _cell.category=[self.datalist2 objectAtIndex:indexPath.row];
        [_cell bind];
        cell = _cell;
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
   if(collectionView==self.collectionView2)
    {
        size=CGSizeMake(CGRectGetWidth(collectionView.bounds)/3.0, CGRectGetWidth(collectionView.bounds)/3.0+(ISIPHONE6?20:35));
    }
    else
    {
        size=CGSizeMake(collectionView.frame.size.width,collectionView.frame.size.height/11);
    }
    return size;
}

//定义section间 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets ei;
    if(collectionView==self.collectionView2)
    {
        collectionViewLayout.minimumLineSpacing=0;
        collectionViewLayout.minimumInteritemSpacing=0;
        ei=UIEdgeInsetsZero;
        
    }
    else
    {
        collectionViewLayout.minimumLineSpacing=0;
        collectionViewLayout.minimumInteritemSpacing=0;
        ei=UIEdgeInsetsZero;
    }
    return ei;
}
//设置页眉尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    //    if (section>=3) {
//    //        return CGSizeMake(screenSize.width, 30);
//    //    }
//    return CGSizeMake(screenSize.width, 0);
//}
////设置页脚尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    //    if (section>=2) {
//    //        return CGSizeMake(screenSize.width, 10);
//    //    }
//    return CGSizeZero;
//}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *headView;
//
//    if([kind isEqual:UICollectionElementKindSectionHeader])
//    {
//        HomeSectionHeaderViewCell *_headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SECTION_HEADER_VIEW forIndexPath:indexPath];
//        _headView.label.textColor=TEXT_COLOR;
//        if (indexPath.section==3) {
//            _headView.label.text=@"分类推荐";
//
//        }
//        else{
//            _headView.label.text=@"热门推荐";
//        }
//        headView=_headView;
//
//    }
//    else
//    {
//        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SECTION_FOOTER_VIEW forIndexPath:indexPath];
//    }
//    //    else if([kind isEqual:UICollectionElementKindSectionFooter])
//    //    {
//    //        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"hxwHeader" forIndexPath:indexPath];
//    //    }
//    return headView;
//}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.collectionView1) {
        hasSelect=YES;
         CategoryViewCL1CollectionViewCell * cell = (CategoryViewCL1CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (firstcell!=nil&&firstcell!=cell) {
            firstcell.nameLabel.textColor=[UIColor blackColor];
            firstcell.layer.borderColor=BG_COLOR.CGColor;
            firstcell.backgroundColor = BG_COLOR;
        }
        if (firstcell!=nil&&firstcell==cell) {
            firstcell=nil;
        }
        cell.layer.borderColor=WHITE_COLOR.CGColor;
        cell.backgroundColor = WHITE_COLOR;
        cell.nameLabel.textColor=MAIN_COLOR;
        
        
        CATEGORY *pc=[self.datalist1 objectAtIndex:indexPath.row];
        self.datalist2=pc.children;
        
        [self.collectionView2 reloadData];
    }
    else
    {
        CategoryViewCL2CollectionViewCell * cell = (CategoryViewCL2CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
     
        GoodsListViewController *gl=[[GoodsListViewController alloc] initWithCategory:cell.category];
        [self showNavigationViewMainColor:gl];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionView2==collectionView) {
        
    }
    else{
        CategoryViewCL1CollectionViewCell * cell = (CategoryViewCL1CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.layer.borderColor=BG_COLOR.CGColor;
        cell.backgroundColor = BG_COLOR;
        cell.nameLabel.textColor=[UIColor blackColor];
        
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}


@end
