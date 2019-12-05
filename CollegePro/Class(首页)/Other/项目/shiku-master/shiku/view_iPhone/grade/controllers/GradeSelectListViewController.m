//
//  GradeViewController.m
//  shiku
//
//  Created by txj on 15/5/25.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GradeSelectListViewController.h"
#define CollectionViewCell2 @"GradeCollectionV2ViewCell"
#define SECTION_HEADER_VIEW @"GradeHeaderCollectionReusableView"
@interface GradeSelectListViewController ()

@end

@implementation GradeSelectListViewController
- (void)setup
{
        App *app = [App shared];
    self.backend=[UserBackend shared];
        @weakify(self)
        [RACObserve(app, currentUser) subscribeNext:^(USER *user) {
            @strongify(self);
            self.user = user;
            if ([user authorized])
            {
                [self loadData];
                [ec.view removeFromSuperview];
            }
            else
            {
                ec=[EmptyViewController shared];
                [self.view addSubview:[[EmptyViewController shared] view]];
                ec.titleLabel.text=@"您还没有相关的品位";
                ec.iconLable.text=@"\U0000B01A";
                ec.view.frame=self.navigationController.view.frame;
            }
        }];
        [self.collectionView addPullToRefreshWithActionHandler:^{
            @strongify(self)
    
            [self loadData];
    
            CGPoint point = self.collectionView.contentOffset;
            point.y = 0;
            self.collectionView.contentOffset = point;
        }];
//        [self.tableView addInfiniteScrollingWithActionHandler:^{
//            @strongify(self)
//            [self loadDataMore];
//        }];
        [self.collectionView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
        [self.collectionView.pullToRefreshView setTitle:@"立即刷新" forState:SVPullToRefreshStateTriggered];
        self.collectionView.showsInfiniteScrolling = NO;
    [self loadData];
}
-(instancetype)initWithGradeList:(NSArray *)anList
{
    self=[self init];
    if (self) {
        self.datalist=[[NSMutableArray alloc] initWithArray:anList];
    }
    return self;
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
    [[self.backend requestGradeAddList]
     subscribeNext:[self didLoadData]];
}
- (void(^)(RACTuple *))didLoadData
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        self.datalist=[[NSMutableArray alloc] initWithArray:(NSArray *)parameters];
        if (self.datalist.count>0) {
            [self.collectionView reloadData];
            [ec.view removeFromSuperview];
        }
        else
        {
            ec=[EmptyViewController shared];
            [self.view addSubview:[[EmptyViewController shared] view]];
            ec.titleLabel.text=@"没有品位";
            ec.iconLable.text=@"\U0000B01A";
            ec.view.frame=self.navigationController.view.frame;
            
        }
        [self.collectionView.pullToRefreshView stopAnimating];
    };
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"我的品位";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
 
    [self.addBtn setBackgroundColor:MAIN_COLOR];
    self.addBtn.layer.cornerRadius=5;
    self.view.backgroundColor=BG_COLOR;
    self.collectionView.backgroundColor=BG_COLOR;
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView registerNib:[UINib nibWithNibName:CollectionViewCell2 bundle:nil] forCellWithReuseIdentifier:CollectionViewCell2];
     [self.collectionView registerNib:[UINib nibWithNibName:SECTION_HEADER_VIEW bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SECTION_HEADER_VIEW];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    CATEGORY *c=[self.datalist objectAtIndex:section];
//    return c.children.count;
    return self.datalist.count;
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
    GradeCollectionV2ViewCell *_cell=[collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCell2 forIndexPath:indexPath];
    _cell.category=[self.datalist objectAtIndex:indexPath.row];
    [_cell bind];
    cell = _cell;
    cell.backgroundColor=WHITE_COLOR;
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
  
    size=CGSizeMake(CGRectGetWidth(collectionView.bounds)/3.0, CGRectGetWidth(collectionView.bounds)/3.0+(ISIPHONE6?20:35));
    return size;
}

//定义section间 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets ei;
    collectionViewLayout.minimumLineSpacing=0;
    collectionViewLayout.minimumInteritemSpacing=0;
    ei=UIEdgeInsetsMake(0, 0, 0, 0);
    return ei;
}
//设置页眉尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //    if (section>=3) {
    //        return CGSizeMake(screenSize.width, 30);
    //    }
    return CGSizeMake(screenSize.width, 40);
}
////设置页脚尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    //    if (section>=2) {
//    //        return CGSizeMake(screenSize.width, 10);
//    //    }
//    return CGSizeZero;
//}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headView;

    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        GradeHeaderCollectionReusableView *_headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SECTION_HEADER_VIEW forIndexPath:indexPath];
//        _headView._headView.titleLabel1.textColor=TEXT_COLOR;
        if (indexPath.section==0) {
            _headView.titleLabel1.text=@"品位列表";

        }
        else{
            _headView.titleLabel1.text=@"向你推荐的品位";
        }
        headView=_headView;

    }
//    else
//    {
//        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SECTION_FOOTER_VIEW forIndexPath:indexPath];
//    }
    //    else if([kind isEqual:UICollectionElementKindSectionFooter])
    //    {
    //        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"hxwHeader" forIndexPath:indexPath];
    //    }
    return headView;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GradeCollectionV2ViewCell * cell = (GradeCollectionV2ViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CATEGORY *grade=[self.datalist objectAtIndex:indexPath.section];
    if ([cell.coverView isHidden]) {
        [cell.coverView setHidden:NO];
        [[self.backend requestAddOrRemoveGrade:[grade.rec_id integerValue]  isDelete:NO]
         subscribeNext:[self didUpdate:@"添加成功"]];
    }
    else
    {
        [cell.coverView setHidden:YES];
        [[self.backend requestAddOrRemoveGrade:[grade.rec_id integerValue] isDelete:YES]
         subscribeNext:[self didUpdate:@"删除成功"]];

    }
    
//    if (collectionView==self.collectionView1) {
//        CategoryViewCL1CollectionViewCell * cell = (CategoryViewCL1CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        if (firstcell!=nil&&firstcell!=cell) {
//            firstcell.nameLabel.textColor=[UIColor blackColor];
//            firstcell.layer.borderColor=BG_COLOR_LIGHT.CGColor;
//            firstcell.backgroundColor = BG_COLOR_LIGHT;
//        }
//        if (firstcell!=nil&&firstcell==cell) {
//            firstcell=nil;
//        }
//        cell.layer.borderColor=WHITE_COLOR.CGColor;
//        cell.backgroundColor = WHITE_COLOR;
//        cell.nameLabel.textColor=MAIN_COLOR;
//        
//        
//        CATEGORY *pc=[self.datalist1 objectAtIndex:indexPath.row];
//        self.datalist2=pc.children;
//        
//        [self.collectionView2 reloadData];
//    }
//    else
//    {
//        CategoryViewCL2CollectionViewCell * cell = (CategoryViewCL2CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        
//        
//        GoodsListViewController *gl=[[GoodsListViewController alloc] initWithCategory:cell.category];
//        [self showNavigationView:gl];
//    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    GradeCollectionViewCell * cell = (GradeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [cell.coverView setHidden:YES];
//    if (self.collectionView2==collectionView) {
//        
//    }
//    else{
//        CategoryViewCL1CollectionViewCell * cell = (CategoryViewCL1CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.layer.borderColor=BG_COLOR_LIGHT.CGColor;
//        cell.backgroundColor = BG_COLOR_LIGHT;
//        cell.nameLabel.textColor=[UIColor blackColor];
//        
//    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addBtnTapped:(id)sender {
}
@end
