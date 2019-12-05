//
//  RegionView.m
//  shiku
//
//  Created by yanglele on 15/8/26.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "RegionView.h"
#import "RegionBackend.h"
#import "RegionMode.h"
#import "CartBackend.h"
@interface RegionView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger m_Tag;

}
@property(nonatomic ,strong)UITableView * m_TableView;

@property(nonatomic ,strong)NSMutableArray * m_DataArr;

@property(nonatomic ,strong)RegionBackend * m_RegionBackend;

@property(nonatomic ,strong)CartBackend * m_CartBackend;

@end

@implementation RegionView

-(id)initWithFrame:(CGRect)frame Pid:(NSString *)pid Tag:(NSInteger)Tag
{
    self = [super initWithFrame:frame];

    if (self) {
        self.m_RegionBackend = [RegionBackend new];
        self.backgroundColor = [UIColor whiteColor];
        [[self.m_RegionBackend requestRegion:pid] subscribeNext:[self DisRegion]];
        m_Tag = Tag;
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame cartGoods_id:(NSNumber *)Goods_id
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.m_CartBackend = [CartBackend new];
        self.backgroundColor = [UIColor whiteColor];
        [[self.m_CartBackend requestGetLogistics:Goods_id] subscribeNext:[self DisLogistics]];
        }
    
    return self;

}

-(void)cartGoods_id:(NSNumber *)Goods_id
{
    [[self.m_CartBackend requestGetLogistics:Goods_id] subscribeNext:[self DisLogistics]];
}

-(void)ReloadView:(NSString *)Pid Tag:(NSInteger)Tag
{
    [self.m_DataArr removeAllObjects];
    [self.m_TableView reloadData];
    [[self.m_RegionBackend requestRegion:Pid] subscribeNext:[self DisRegion]];
    m_Tag = Tag;
}

-(void)createTableView
{
    self.m_TableView = [[UITableView alloc]initWithFrame:CGRectMake(1,1,CGRectGetWidth(self.frame)-2,CGRectGetHeight(self.frame)-2) style:UITableViewStylePlain];
    self.m_TableView.delegate = self;
    self.m_TableView.dataSource = self;
    self.m_TableView.backgroundColor = [UIColor clearColor];
    self.m_TableView.showsVerticalScrollIndicator = NO;
    self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.m_TableView];
    [self.m_TableView reloadData];
}

-(void (^)(RACTuple *))DisRegion
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs = (ResponseResult *) parameters;
        NSLog(@"%@",rs.data);
        if (rs.data) {
            NSMutableArray * m_arr = [NSMutableArray array];
            for (int i = 0; i<[(NSArray *)[rs.data objectForKey:@"list"] count]; i++) {
                RegionMode * mode = [RegionMode new];
                [mode SetassignmentRegionMode:[[rs.data objectForKey:@"list"] objectAtIndex:i]];
                [m_arr addObject:mode];
            }
            self.m_DataArr = [NSMutableArray arrayWithArray:m_arr];
           [self createTableView];
        }
    };
}

-(void (^)(RACTuple *))DisLogistics
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs = (ResponseResult *) parameters;
        NSLog(@"%@",rs.data);
        if (rs.data) {
            NSMutableArray * m_arr = [NSMutableArray array];
            for (int i = 0; i<[(NSArray *)[rs.data objectForKey:@"expressList"] count]; i++) {
                RegionMode * mode = [RegionMode new];
                [mode SetassignmentRegionMode:[[rs.data objectForKey:@"expressList"] objectAtIndex:i]];
                [m_arr addObject:mode];
            }
            self.m_DataArr = [NSMutableArray arrayWithArray:m_arr];
            [self createTableView];
        }
    };
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_DataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString * CellName = [NSString stringWithFormat:@"CellName%ld",(long)indexPath.row];
    UITableViewCell * Cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (nil==Cell) {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
        RegionMode * mode = [self.m_DataArr objectAtIndex:indexPath.row];
//        UILabel * Label = [[UILabel alloc]initWithFrame:CGRectMake(5, 1, CGRectGetWidth(self.frame)-10, 28)];
//        Label.text = mode.Name;
//        Label.textAlignment = NSTextAlignmentCenter;
//        Label.backgroundColor = [UIColor clearColor];
//        Label.font = [UIFont systemFontOfSize:12];
//        [Cell.contentView addSubview:Label];
        UIButton * m_Butt = [UIButton buttonWithType:UIButtonTypeCustom];
        m_Butt.frame = CGRectMake(5, 1, CGRectGetWidth(self.frame)-10, 28);
        [m_Butt setTitle:mode.Name forState:UIControlStateNormal];
        [m_Butt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_Butt.backgroundColor = [UIColor clearColor];
        m_Butt.titleLabel.font = [UIFont systemFontOfSize:12];
        m_Butt.tag = indexPath.row;
        [m_Butt addTarget:self action:@selector(SelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [Cell.contentView addSubview:m_Butt];
    }
   
    return Cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    RegionMode * mode = [self.m_DataArr objectAtIndex:indexPath.row];
//    [self.m_delegate SelecateCell:mode Tag:m_Tag];
//}

-(void)SelectClick:(UIButton *)sender
{
    RegionMode * mode = [self.m_DataArr objectAtIndex:sender.tag];
    [self.m_delegate SelecateCell:mode Tag:m_Tag];


}

@end
