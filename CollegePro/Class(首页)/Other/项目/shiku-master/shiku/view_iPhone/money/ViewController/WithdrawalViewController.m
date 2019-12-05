//
//  WithdrawalViewController.m
//  shiku
//
//  Created by yanglele on 15/9/9.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "WithdrawalViewController.h"
#import "MoneyBackend.h"
@interface WithdrawalViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    BOOL  isBool;

}
@property(nonatomic ,strong)MoneyBackend * m_Backend;

@property(nonatomic ,strong)UIButton * ZFButt;

@property(nonatomic ,strong)UIButton * WXButt;

@property(nonatomic ,strong)UIButton * YLButt;

@property(nonatomic ,strong)UITextField * m_NameTF;

@property(nonatomic ,strong)UITextField * m_CodeTF;

@property(nonatomic ,strong)UITextField * m_MoneyTF;

@property(nonatomic ,strong)UITextField * m_WhereTF;

@property(nonatomic ,strong)UITableView * m_TableView;

@property(nonatomic ,strong)NSString * Type;

@property(nonatomic ,strong)UIImageView * ImgZF;

@property(nonatomic ,strong)UIImageView * ImgWX;

@property(nonatomic ,strong)UIImageView * ImgYL;

@property(nonatomic ,strong)UIButton * m_RequestButt;

@end

@implementation WithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.leftBarButtonItem = [self leftBarBtnItem];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提现";
    self.m_Backend = [[MoneyBackend alloc]init];
    [self createTableView];
    [self createButt];
    
}


-(void)createButt
{
    NSInteger width = self.view.bounds.size.width;
    NSLog(@"%ld",(long)width);
    UIImageView * imagZF = [[UIImageView alloc]initWithFrame:CGRectMake(50, 11, 58, 58)];
    imagZF.image = [UIImage imageNamed:@"ic_alipay.png"];
    self.Type = @"1";
    self.ImgZF = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
    self.ImgZF.image = [UIImage imageNamed:@"icon1_10.png"];
//    self.ImgZF.hidden = YES;
    self.ZFButt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ZFButt.frame = CGRectMake(1, 5, (width-4)/2, 80);
    self.ZFButt.titleLabel.font = [UIFont systemFontOfSize:13];
    self.ZFButt.backgroundColor = [UIColor whiteColor];
    self.ZFButt.tag = 1;
    self.ZFButt.layer.borderColor = [UIColor grayColor].CGColor;
    self.ZFButt.layer.borderWidth = .3;
    self.ZFButt.layer.cornerRadius = 5;
    [self.ZFButt addTarget:self action:@selector(withdrawaClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ZFButt addSubview:imagZF];
    [self.ZFButt addSubview:self.ImgZF];
    [self.view addSubview:self.ZFButt];
    
    UIImageView * imagWX = [[UIImageView alloc]initWithFrame:CGRectMake(30, 16, 48, 48)];
    imagWX.image = [UIImage imageNamed:@"ic_weichat.png"];
    
    self.ImgWX = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
    self.ImgWX.image = [UIImage imageNamed:@"icon1_10.png"];
    self.ImgWX.hidden = YES;
    self.WXButt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.WXButt.frame = CGRectMake((width-4)/3+2, 5, (width-4)/3, 80);
    self.WXButt.titleLabel.font = [UIFont systemFontOfSize:13];
    self.WXButt.backgroundColor = [UIColor whiteColor];
    self.WXButt.tag = 2;
    self.WXButt.layer.borderColor = [UIColor grayColor].CGColor;
    self.WXButt.layer.borderWidth = .3;
    self.WXButt.layer.cornerRadius = 5;
    [self.WXButt addTarget:self action:@selector(withdrawaClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.WXButt addSubview:imagWX];
    [self.WXButt addSubview:self.ImgWX];
//    [self.view addSubview:self.WXButt];

    UIImageView * imagYL = [[UIImageView alloc]initWithFrame:CGRectMake(40, 16, 78, 48.5)];
    imagYL.image = [UIImage imageNamed:@"ic_card.png"];
    self.ImgYL = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
    self.ImgYL.image = [UIImage imageNamed:@"icon1_10.png"];
    self.ImgYL.hidden = YES;
    self.YLButt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.YLButt.frame = CGRectMake((width-4)/2+2+3, 5, (width-4)/2-3, 80);
    self.YLButt.titleLabel.font = [UIFont systemFontOfSize:13];
    self.YLButt.backgroundColor = [UIColor whiteColor];
    self.YLButt.tag = 3;
    self.YLButt.layer.borderColor = [UIColor grayColor].CGColor;
    self.YLButt.layer.borderWidth = .3;
    self.YLButt.layer.cornerRadius = 5;
    [self.YLButt addTarget:self action:@selector(withdrawaClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.YLButt addSubview:imagYL];
    [self.YLButt addSubview:self.ImgYL];
    [self.view addSubview:self.YLButt];
    
    
    self.m_RequestButt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.m_RequestButt.frame = CGRectMake(40,CGRectGetMaxY(self.m_TableView.frame)+30,width-80, 40);
    self.m_RequestButt.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.m_RequestButt setTitle:@"提现" forState:UIControlStateNormal];
    [self.m_RequestButt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.m_RequestButt setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.m_RequestButt.backgroundColor = [UIColor orangeColor];
    self.m_RequestButt.layer.borderColor = [UIColor grayColor].CGColor;
    self.m_RequestButt.layer.borderWidth = .3;
    self.m_RequestButt.layer.cornerRadius = 5;
    [self.m_RequestButt addTarget:self action:@selector(requestClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.m_RequestButt];
}

-(void)withdrawaClick:(UIButton *)sender
{
    NSInteger width = self.view.bounds.size.width;
    switch (sender.tag) {
        case 1:
        {
            self.ImgZF.hidden = NO;
            self.ImgWX.hidden = YES;
            self.ImgYL.hidden = YES;
            isBool = NO;
        }
            break;
        case 2:
        {
            self.ImgZF.hidden = YES;
            self.ImgWX.hidden = NO;
            self.ImgYL.hidden = YES;
            
        }
            break;
        case 3:
        {
            self.ImgZF.hidden = YES;
            self.ImgWX.hidden = YES;
            self.ImgYL.hidden = NO;
            isBool = YES;
        }
            break;
            
        default:
            break;
    }
    
    self.m_TableView.frame =CGRectMake(1,86,CGRectGetWidth(self.view.frame)-2,(isBool?4:3)*50);
    self.m_RequestButt.frame = CGRectMake(40,CGRectGetMaxY(self.m_TableView.frame)+30,width-80, 40);
    [self.m_TableView reloadData];
    self.Type = [NSString stringWithFormat:@"%ld",(long)sender.tag];

}

-(void)requestClick:(UIButton *)sender
{
    if (self.Type&&[self.Type length]>0) {
        if (self.m_NameTF&&self.m_NameTF.text.length>0&&self.m_CodeTF&&self.m_CodeTF.text.length>0&&self.m_MoneyTF&&self.m_MoneyTF.text.length>0) {
           [[self.m_Backend GetWithdrawalUserName:self.m_NameTF.text money:self.m_MoneyTF.text card_no:self.m_CodeTF.text type:self.Type] subscribeNext:[self didGetWithdrawal]];
        }
        else
        {
            UIAlertView * alv = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alv show];
        }
        
    }
    else
    {
        UIAlertView * alv = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择账户类型" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alv show];
    }
}

-(void(^)(RACTuple *))didGetWithdrawal
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs = (ResponseResult *) parameters;
        if (rs.success) {
            [self.view showHUD:rs.messge afterDelay:1.0];
        }
        else
        {
            NSLog(@"%@",rs.messge);
            [self.view showHUD:rs.messge afterDelay:1.0];

        }
        
    };

}

-(void)createTableView
{
    self.m_TableView = [[UITableView alloc]initWithFrame:CGRectMake(1,86,CGRectGetWidth(self.view.frame)-2,(isBool?4:3)*50) style:UITableViewStylePlain];
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
    return isBool?4:3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger w = self.view.frame.size.width;
    NSString * CellName = [NSString stringWithFormat:@"CellName%ld",indexPath.row];
    UITableViewCell * Cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (Cell) {
        return Cell;
    }
    if (nil==Cell) {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (isBool) {
        switch (indexPath.row) {
            case 0:
            {
                
                UILabel * m_Label = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 93, 40)];
                m_Label.text = @"用户名:";
                m_Label.font = [UIFont systemFontOfSize:13];
                m_Label.textAlignment = NSTextAlignmentCenter;
                m_Label.backgroundColor = [UIColor clearColor];
                m_Label.textColor = [UIColor blackColor];
                [Cell.contentView addSubview:m_Label];
                if (!self.m_NameTF) {
                    self.m_NameTF = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, w - 120, 40)];
                    self.m_NameTF.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
                    self.m_NameTF.font = [UIFont systemFontOfSize:15.0];
                    self.m_NameTF.textAlignment = NSTextAlignmentLeft;
                    self.m_NameTF.backgroundColor = [UIColor clearColor];
                    self.m_NameTF.clearButtonMode = UITextFieldViewModeNever;
                    self.m_NameTF.placeholder = @"请输入真实姓名";
                    
                    self.m_NameTF.delegate = self;
                    self.m_NameTF.returnKeyType = UIReturnKeyNext;
                    self.m_NameTF.keyboardType = UIKeyboardTypeDefault;
                }
                
                
                [Cell.contentView addSubview:self.m_NameTF];
                
            }
                break;
            case 1:
            {
                UILabel * m_Label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 93, 40)];
                m_Label.text = @"用户账号:";
                m_Label.font = [UIFont systemFontOfSize:13];
                m_Label.textAlignment = NSTextAlignmentCenter;
                m_Label.backgroundColor = [UIColor clearColor];
                m_Label.textColor = [UIColor blackColor];
                [Cell.contentView addSubview:m_Label];
                if (!self.m_CodeTF) {
                    self.m_CodeTF = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, w - 120, 40)];
                    self.m_CodeTF.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
                    self.m_CodeTF.font = [UIFont systemFontOfSize:15.0];
                    self.m_CodeTF.textAlignment = NSTextAlignmentLeft;
                    self.m_CodeTF.backgroundColor = [UIColor clearColor];
                    self.m_CodeTF.clearButtonMode = UITextFieldViewModeNever;
                    self.m_CodeTF.placeholder = @"请输入收款账户";
                    self.m_CodeTF.delegate = self;
                    self.m_CodeTF.returnKeyType = UIReturnKeyNext;
                    self.m_CodeTF.keyboardType = UIKeyboardTypeDefault;
                }
                
                [Cell.contentView addSubview:self.m_CodeTF];
                
            }
                break;
                
            case 2:
            {
                UILabel * m_Label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 93, 40)];
                m_Label.text = @"提现金额:";
                m_Label.font = [UIFont systemFontOfSize:13];
                m_Label.textAlignment = NSTextAlignmentCenter;
                m_Label.backgroundColor = [UIColor clearColor];
                m_Label.textColor = [UIColor blackColor];
                [Cell.contentView addSubview:m_Label];
                if (!self.m_MoneyTF) {
                    self.m_MoneyTF = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, w - 120, 40)];
                    self.m_MoneyTF.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
                    self.m_MoneyTF.font = [UIFont systemFontOfSize:15.0];
                    self.m_MoneyTF.textAlignment = NSTextAlignmentLeft;
                    self.m_MoneyTF.backgroundColor = [UIColor clearColor];
                    self.m_MoneyTF.clearButtonMode = UITextFieldViewModeNever;
                    self.m_MoneyTF.placeholder = @"请输入提现金额";
                    self.m_MoneyTF.delegate = self;
                    self.m_MoneyTF.returnKeyType = UIReturnKeyNext;
                    self.m_MoneyTF.keyboardType = UIKeyboardTypeNumberPad;
                    
                    
                }
                [Cell.contentView addSubview:self.m_MoneyTF];
                
            }
                break;
                
            case 3:
            {
                UILabel * m_Label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 93, 40)];
                m_Label.text = @"开户行:";
                m_Label.font = [UIFont systemFontOfSize:13];
                m_Label.textAlignment = NSTextAlignmentCenter;
                m_Label.backgroundColor = [UIColor clearColor];
                m_Label.textColor = [UIColor blackColor];
                [Cell.contentView addSubview:m_Label];
                if (!self.m_WhereTF) {
                    self.m_WhereTF = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, w - 120, 40)];
                    self.m_WhereTF.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
                    self.m_WhereTF.font = [UIFont systemFontOfSize:15.0];
                    self.m_WhereTF.textAlignment = NSTextAlignmentLeft;
                    self.m_WhereTF.backgroundColor = [UIColor clearColor];
                    self.m_WhereTF.clearButtonMode = UITextFieldViewModeNever;
                    self.m_WhereTF.placeholder = @"请输入开户行";
                    self.m_WhereTF.delegate = self;
                    self.m_WhereTF.returnKeyType = UIReturnKeyNext;
                    self.m_WhereTF.keyboardType = UIKeyboardTypeDefault;
                }
                
                [Cell.contentView addSubview:self.m_WhereTF];
                
            }
                break;
                
                
            default:
                break;
        }
 
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                
                UILabel * m_Label = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 93, 40)];
                m_Label.text = @"用户名:";
                m_Label.font = [UIFont systemFontOfSize:13];
                m_Label.textAlignment = NSTextAlignmentCenter;
                m_Label.backgroundColor = [UIColor clearColor];
                m_Label.textColor = [UIColor blackColor];
                [Cell.contentView addSubview:m_Label];
                if (!self.m_NameTF) {
                    self.m_NameTF = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, w - 120, 40)];
                    self.m_NameTF.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
                    self.m_NameTF.font = [UIFont systemFontOfSize:15.0];
                    self.m_NameTF.textAlignment = NSTextAlignmentLeft;
                    self.m_NameTF.backgroundColor = [UIColor clearColor];
                    self.m_NameTF.clearButtonMode = UITextFieldViewModeNever;
                    self.m_NameTF.placeholder = @"请输入真实姓名";
                    
                    self.m_NameTF.delegate = self;
                    self.m_NameTF.returnKeyType = UIReturnKeyNext;
                    self.m_NameTF.keyboardType = UIKeyboardTypeDefault;
                }
                
                
                [Cell.contentView addSubview:self.m_NameTF];
                
            }
                break;
            case 1:
            {
                UILabel * m_Label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 93, 40)];
                m_Label.text = @"用户账号:";
                m_Label.font = [UIFont systemFontOfSize:13];
                m_Label.textAlignment = NSTextAlignmentCenter;
                m_Label.backgroundColor = [UIColor clearColor];
                m_Label.textColor = [UIColor blackColor];
                [Cell.contentView addSubview:m_Label];
                if (!self.m_CodeTF) {
                    self.m_CodeTF = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, w - 120, 40)];
                    self.m_CodeTF.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
                    self.m_CodeTF.font = [UIFont systemFontOfSize:15.0];
                    self.m_CodeTF.textAlignment = NSTextAlignmentLeft;
                    self.m_CodeTF.backgroundColor = [UIColor clearColor];
                    self.m_CodeTF.clearButtonMode = UITextFieldViewModeNever;
                    self.m_CodeTF.placeholder = @"请输入收款账户";
                    self.m_CodeTF.delegate = self;
                    self.m_CodeTF.returnKeyType = UIReturnKeyNext;
                    self.m_CodeTF.keyboardType = UIKeyboardTypeDefault;
                }
                
                [Cell.contentView addSubview:self.m_CodeTF];
                
            }
                break;
                
            case 2:
            {
                UILabel * m_Label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 93, 40)];
                m_Label.text = @"提现金额:";
                m_Label.font = [UIFont systemFontOfSize:13];
                m_Label.textAlignment = NSTextAlignmentCenter;
                m_Label.backgroundColor = [UIColor clearColor];
                m_Label.textColor = [UIColor blackColor];
                [Cell.contentView addSubview:m_Label];
                if (!self.m_MoneyTF) {
                    self.m_MoneyTF = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, w - 120, 40)];
                    self.m_MoneyTF.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
                    self.m_MoneyTF.font = [UIFont systemFontOfSize:15.0];
                    self.m_MoneyTF.textAlignment = NSTextAlignmentLeft;
                    self.m_MoneyTF.backgroundColor = [UIColor clearColor];
                    self.m_MoneyTF.clearButtonMode = UITextFieldViewModeNever;
                    self.m_MoneyTF.placeholder = @"请输入提现金额";
                    self.m_MoneyTF.delegate = self;
                    self.m_MoneyTF.returnKeyType = UIReturnKeyNext;
                    self.m_MoneyTF.keyboardType = UIKeyboardTypeNumberPad;
                    
                    
                }
                [Cell.contentView addSubview:self.m_MoneyTF];
                
            }
                break;
            default:
                break;
        }
    
    
    }
        UIImageView * lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    lineImg.image = [UIImage imageNamed:@"line.png"];
    [Cell.contentView addSubview:lineImg];
    
    return Cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self hidenKeyboard];

}

-(void)viewText:(UIView *)View
{
    for (UIView * subview  in [View subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            [subview resignFirstResponder];
        }
        else
        {
            [self viewText:subview];
        }
    }
}

//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-30,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 64.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations]; 
}

//隐藏键盘的方法
// m_NameTF;
-(void)hidenKeyboard
{
    [self.m_NameTF resignFirstResponder];
    [self.m_MoneyTF resignFirstResponder];
    [self.m_CodeTF resignFirstResponder];
    [self.m_WhereTF resignFirstResponder];
    [self resumeView];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hidenKeyboard];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
