//
//  mymoneyViewController.m
//  shiku
//
//  Created by yanglele on 15/9/9.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "mymoneyViewController.h"
#import "MoneyBackend.h"
#import "MyMoneyTableViewCell.h"
#import "WithdrawalViewController.h"
@interface mymoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView * The_balanceView;

@property(nonatomic,strong)NSMutableArray * m_DataArr;

@property(nonatomic,strong)UILabel * The_balanceLabel;

@property(nonatomic,strong)UIButton * withdrawalButt;

@property(nonatomic,strong)UITableView * m_TableView;

@property(nonatomic,strong)MoneyBackend * m_Backend;

@end

@implementation mymoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [self leftBarBtnItem];
    self.m_DataArr =[NSMutableArray array];
    self.m_Backend = [[MoneyBackend alloc]init];
    [self createView];
    [self createTableView];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self.m_Backend GetTheBalance] subscribeNext:[self ReceiveTheBalance]];
}

-(void (^)(RACTuple *))ReceiveTheBalance
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
       ResponseResult *rs = (ResponseResult *) parameters;
        NSLog(@"%@",rs.data);
        if (rs.data) {
            if ([[rs.data objectForKey:@"money"] isEqualToString:@""]) {
                self.The_balanceLabel.text = @"0.00";
            }
            else
            {
                self.The_balanceLabel.text = [rs.data objectForKey:@"money"];
            }
            self.m_DataArr = [rs.data objectForKey:@"list"];
            [self.m_TableView reloadData];
        }
        
    };



}

-(void)createView
{
    //172
    NSInteger width = [[UIScreen mainScreen] bounds].size.width;
    self.The_balanceView = [[UIView alloc]initWithFrame:CGRectMake((DeviceWidth-93)/2, 26, 93, 93)];
    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 93, 93)];
    img.image = [UIImage imageNamed:@"ic_mywallet_circle.png"];

    [self.The_balanceView addSubview:img];
    [self.view addSubview:self.The_balanceView];
    UILabel * m_Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 16.5, 93, 20)];
    m_Label.text = @"余额/元";
    m_Label.font = [UIFont systemFontOfSize:13];
    m_Label.textAlignment = NSTextAlignmentCenter;
    m_Label.backgroundColor = [UIColor clearColor];
    m_Label.textColor = [UIColor whiteColor];
    [self.The_balanceView addSubview:m_Label];
    
    self.The_balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 93, 40)];
    self.The_balanceLabel.text = @"0.00";
    self.The_balanceLabel.textAlignment = NSTextAlignmentCenter;
    self.The_balanceLabel.font = [UIFont systemFontOfSize:22];
    self.The_balanceLabel.backgroundColor = [UIColor clearColor];
    self.The_balanceLabel.textColor = [UIColor whiteColor];
    [self.The_balanceView addSubview:self.The_balanceLabel];
    
    UIImageView * imag = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8.25, 18, 13.5)];
    imag.image = [UIImage imageNamed:@"ic_ti_jiao.png"];
    
    self.withdrawalButt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.withdrawalButt.frame = CGRectMake((DeviceWidth-93)/2, 131, 93, 30);
    self.withdrawalButt.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.withdrawalButt setTitle:@"提现" forState:UIControlStateNormal];
    [self.withdrawalButt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.withdrawalButt.backgroundColor = [UIColor clearColor];
    self.withdrawalButt.layer.borderColor = [UIColor grayColor].CGColor;
    self.withdrawalButt.layer.borderWidth = .3;
    self.withdrawalButt.layer.cornerRadius = 5;

    [self.withdrawalButt addTarget:self action:@selector(withdrawalClick) forControlEvents:UIControlEventTouchUpInside];
    [self.withdrawalButt addSubview:imag];
    [self.view addSubview:self.withdrawalButt];
    
    UILabel * Linelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 191, (width-80)/2, 1)];
    Linelabel.backgroundColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1.0];
    [self.view addSubview:Linelabel];
    
    UILabel * withdrawal = [[UILabel alloc]initWithFrame:CGRectMake((DeviceWidth-80)/2, 180, 80, 20)];
    withdrawal.textColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1.0];
    withdrawal.text = @"提款明细";
    withdrawal.textAlignment = NSTextAlignmentCenter;
    withdrawal.font = [UIFont systemFontOfSize:14];
    withdrawal.backgroundColor = [UIColor clearColor];
    [self.view addSubview:withdrawal];
    
    UILabel * Line_label = [[UILabel alloc]initWithFrame:CGRectMake((DeviceWidth-80)/2+80, 191, (CGRectGetWidth(self.view.frame)-80)/2, 1)];
    Line_label.backgroundColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1.0];
    [self.view addSubview:Line_label];

}

-(void)createTableView
{
    self.m_TableView = [[UITableView alloc]initWithFrame:CGRectMake(1,200,DeviceWidth-2,DeviceHeight-190) style:UITableViewStylePlain];
    self.m_TableView.delegate = self;
    self.m_TableView.dataSource = self;
    self.m_TableView.backgroundColor = [UIColor clearColor];
    self.m_TableView.showsVerticalScrollIndicator = NO;
    self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.m_TableView];
    [self.m_TableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_DataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellName = [NSString stringWithFormat:@"CellName"];
    MyMoneyTableViewCell * Cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (nil==Cell) {
        Cell = [[MyMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
        [Cell awakeFromNib];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [Cell reloadMode:[self.m_DataArr objectAtIndex:indexPath.row]];
    }
    
    return Cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



-(void)withdrawalClick
{
    WithdrawalViewController * withdrawalVC = [[WithdrawalViewController alloc]init];
    [self showNavigationView:withdrawalVC];


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
