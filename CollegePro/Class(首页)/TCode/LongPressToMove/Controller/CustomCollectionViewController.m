//
//  CustomCollectionViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/5/8.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "CustomCollectionViewController.h"
#import "ZQVariableMenuControl.h"
#import "ZQVariableMenuCell.h"
#define ShowMenusPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject] stringByAppendingPathComponent:@"Menus.txt"]

//菜单列数
static NSInteger ColumnNumber = 4;
//横向和纵向的间距
static CGFloat CellMarginX = 15.0f;
static CGFloat CellMarginY = 10.0f;

@interface CustomCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    NSArray *_currentMenus;
}
@property(strong,nonatomic) NSArray *currentMenus;

@property(strong,nonatomic)UICollectionView * collectionview;
/**
 section1 中的数据源
 */
@property(strong,nonatomic)NSMutableArray * dataArr;

@property(strong,nonatomic)NSMutableArray * myapplistArr;

@property(strong,nonatomic)NSMutableArray * mychangeapplistArr;

//类别数据源
@property(strong,nonatomic)NSMutableArray * headtitleArr;
/**
 是否保存
 */
@property(assign,nonatomic)BOOL isexp;
/**
 是否编辑
 */
@property(assign,nonatomic)BOOL ischange;
/**
 改变位置和删除
 */
@property(assign,nonatomic)BOOL changestate;

@end

@implementation CustomCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作台";
//    [self createRightBtnViewImage:@"" andRightBtnTitle:@"编辑"];
//    self.ischange = YES;
//    self.isexp = NO;
//    [self.view addSubview:self.collectionview];
//    [self getMyapplicationlist];
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showChannel)];
    [self buildUI];
    [self reloadCollectionView];
}

-(void)buildUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat cellWidth = (self.view.bounds.size.width - (ColumnNumber + 1) * CellMarginX)/ColumnNumber;
    flowLayout.itemSize = CGSizeMake(cellWidth,cellWidth+20);
    flowLayout.sectionInset = UIEdgeInsetsMake(CellMarginY, CellMarginX, CellMarginY, CellMarginX);
    flowLayout.minimumLineSpacing = CellMarginY;
    flowLayout.minimumInteritemSpacing = CellMarginX;
    flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 40);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ZQVariableMenuCell class] forCellWithReuseIdentifier:@"ZQVariableMenuCell"];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
}

- (void)reloadCollectionView
{
    self.currentMenus = [NSArray arrayWithContentsOfFile:ShowMenusPath];
    
    if (self.currentMenus.count>0) {
    }else
    {
        self.currentMenus = @[@"素材回传",@"内容库",@"直播",@"消息",@"UGC",@"选题管理",@"串联单",@"移动文稿"];
    }
    [_collectionView reloadData];
}


-(void)showChannel
{
    NSMutableArray *UnShowMenus = [NSMutableArray arrayWithArray:@[@"素材回传",@"内容库",@"直播",@"消息",@"UGC",@"移动文稿",@"任务",@"选题管理",@"串联单",@"线索"]];
    [UnShowMenus removeObjectsInArray:self.currentMenus];
    [[ZQVariableMenuControl shareControl] showChannelViewWithInUseTitles:self.currentMenus unUseTitles:UnShowMenus fixedNum:2 finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        [inUseTitles writeToFile:ShowMenusPath atomically:YES];
        [self reloadCollectionView];
    }];
    
    
    
}
#pragma mark CollectionViewDelegate&DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.currentMenus.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"ZQVariableMenuCell";
    ZQVariableMenuCell* item = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    item.title = self.currentMenus[indexPath.row];
    item.imageName = self.currentMenus[indexPath.row];
    item.backgroundColor = [UIColor whiteColor];
    
    item.isFixed = NO;
    return  item;
}
/*
#pragma mark CollectionViewDelegate&DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _currentMenus.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"ZQVariableMenuCell";
    ZQVariableMenuCell* item = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    item.title = _currentMenus[indexPath.row];
    item.imageName = _currentMenus[indexPath.row];
    item.backgroundColor = [UIColor whiteColor];
    
    item.isFixed = NO;
    return  item;
}


-(void)getMyapplicationlist{
    [self.myapplistArr removeAllObjects];

    self.myapplistArr = [@[
                      @{@"applicationName":@"文字1",@"fdImageUrl":@"图片1"},
                      @{@"applicationName":@"文字2",@"fdImageUrl":@"图片2"},
                      @{@"applicationName":@"文字3",@"fdImageUrl":@"图片3"},
                      @{@"applicationName":@"文字4",@"fdImageUrl":@"图片4"},
                      @{@"applicationName":@"文字5",@"fdImageUrl":@"图片5"},
                      @{@"applicationName":@"文字6",@"fdImageUrl":@"图片6"},
                      @{@"applicationName":@"文字7",@"fdImageUrl":@"图片7"},
                      @{@"applicationName":@"文字8",@"fdImageUrl":@"图片8"},
                      @{@"applicationName":@"文字9",@"fdImageUrl":@"图片9"},
                      @{@"applicationName":@"文字10",@"fdImageUrl":@"图片10"},
                      @{@"applicationName":@"文字11",@"fdImageUrl":@"图片11"},
                      @{@"applicationName":@"文字12",@"fdImageUrl":@"图片12"},
                      @{@"applicationName":@"文字13",@"fdImageUrl":@"图片13"},
                      @{@"applicationName":@"文字14",@"fdImageUrl":@"图片14"},
                      @{@"applicationName":@"文字15",@"fdImageUrl":@"图片15"}
                      ]mutableCopy];
    NSDictionary *dict = self.myapplistArr[0];
    NSLog(@"%@--%ld",self.myapplistArr[0],dict.allKeys.count);

    for (int index = 0; index<10; index++){
        NSLog(@"%@--%@",self.myapplistArr[index][@"fdImageUrl"],
              [[NSBundle mainBundle] pathForResource:self.myapplistArr[index][@"fdImageUrl"] ofType:@"png"]);
    }
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
