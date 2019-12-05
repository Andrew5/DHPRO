//
//  InputVertifyView.m
//  1.input
//
//  Created by cherish on 15/11/17.
//  Copyright © 2015年 杨飞龙 . All rights reserved.
//


#import "InputVertifyView.h"

#import "UIViewExt.h"


@interface InputVertifyView ()
{
    
    UITextField *backGround;
    
    NSMutableArray *_dataSource;
    
    
}
@end


@implementation InputVertifyView

#pragma mark - init Methods
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
       
        
        _dataSource = [[NSMutableArray alloc]init];
        
        
        [self _loadSearchView];
        
    }
    
    return self;
    
}//初始化方法


#pragma mark - Private Methods
- (void)_loadSearchView
{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    //请输入手机号码
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-20, 40)];
	lable.layer.borderColor = [UIColor redColor].CGColor;
	lable.layer.borderWidth = 1.0;
    lable.text = @"请输入用户手机号码的后四位查询";
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:18];
    [bgView addSubview:lable];
    
    
    CGFloat width = (KScreenWidth-20)/4;
    
    //底部的textfield
    backGround = [[UITextField alloc]initWithFrame:CGRectMake(10, lable.bottom+10, KScreenWidth-20, width)];
    backGround.hidden = YES;
    backGround.secureTextEntry = YES;
    backGround.keyboardType = UIKeyboardTypeNumberPad;
    [backGround addTarget:self action:@selector(txChange:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:backGround];
    

    //for循环创建4个按钮
    for (int i = 0; i < 4; i++) {
        
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10+i*width, lable.bottom+10, width, width)];
        
        
        button.titleLabel.font = [UIFont systemFontOfSize:30.0];
        
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [button addTarget:self action:@selector(touchBegin) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.borderWidth = 0.5;
        
        [_dataSource addObject:button];
        
        [bgView addSubview:button];
        
        
        
    }
    
    
    
    
    //创建查询按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30 , backGround.bottom+20, KScreenWidth-60, 40);
    [button setTitle:@"查询" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:129/255.0 green:135/255.0 blue:140/255.0 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickSearch:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 1;
    button.layer.borderColor =[UIColor colorWithRed:129/255.0 green:135/255.0 blue:140/255.0 alpha:1].CGColor;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [bgView addSubview:button];
    
    [self  addSubview:bgView];
    

}//输入手机号码查询视图


- (void)txChange:(UITextField*)tx
{
   
    NSString *text = tx.text;
    
    
    if (text.length == _dataSource.count) {
      
        //这里可以自动监听
		NSLog(@"结束 回收键盘");
		[tx resignFirstResponder];
        
    }
    
    
    
    for (int i = 0; i < _dataSource.count; i++) {
        
        
        UIButton *btn = [_dataSource objectAtIndex:i];
        
        
        NSString *str = @"";
        
        if (i < text.length) {
            
   
            str = [text substringWithRange:NSMakeRange(i, 1)];
            
            
        }

        [btn setTitle:str forState:UIControlStateNormal];
    }
 
}//监听，输入文字



- (void)touchBegin
{
    
    [backGround becomeFirstResponder];
    
}//成为第一响应者




#pragma mark - Action Methods
- (void)clickSearch:(UIButton*)sender
{
    
    
    NSMutableString *str = [NSMutableString string];
    
    for (int i = 0; i < _dataSource.count; i++) {
        
        
        UIButton *button = _dataSource[i];
        
        
        if (button.currentTitle.length == 0) {
            
            
        }else{
            
            [str appendString:button.currentTitle];
        }
    
    }
    
    
    if (str.length < 4) {
        
        
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入用户手机号码后四位查询" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
        
        
    }else if (str.length == 4){
        
        
     [[[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
        
        //这里直接去查询
        [backGround resignFirstResponder];
        
 
        if (_clickSearch != nil) {
            
            _clickSearch(str);
        }
        
        
    }
    

    
}//点击查询








@end
