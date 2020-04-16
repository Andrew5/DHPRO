//
//  ContentOffSetVC.m
//  Test
//
//  Created by Rillakkuma on 2016/10/20.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define kColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define UserCellIdetifeir @"UserCell"

#import "ContentOffSetVC.h"
#import "DHBAlertView.h"

@interface ContentOffSetVC ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
	UITextField *textF;
	int codeV;
}
@end

@implementation ContentOffSetVC
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = YES;
	self.navigationController.interactivePopGestureRecognizer.delegate = self;

}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
	[super viewDidLoad];
	[self backImageView];
	[self getNum];
	NSLog(@"初始化的数 %d",codeV);//88462
	
	[self createNaView];
	
	[self loadData];
	
	[self layoutTableView];
	
}
-(void)createNaView
{
	self.NavView=[[NaView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
	self.NavView.title = @"我的";
	self.NavView.color = [UIColor whiteColor];
	self.NavView.left_bt_Image = @"left_";
	self.NavView.right_bt_Image = @"Setting";
	self.NavView.delegate = self;
	[self.view addSubview:self.NavView];
}

-(void)loadData{
	
	_dataArray =[[NSMutableArray alloc]init];
    NSString *nilStr = nil;
    NSArray *array = @[@"chenfanfang", nilStr];
	for (int i = 0; i < 20; i++) {
		
		NSString * string=[NSString stringWithFormat:@"第%d行",i];
		
		[_dataArray addObject:string];
		
	}
	
}

-(void)backImageView{
	UIImage *image=[UIImage imageNamed:@"headerIcon"];//headerIcon
	
	_backgroundImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, image.size.height*0.8)];
	_backgroundImgV.image=image;
	_backgroundImgV.userInteractionEnabled=YES;
	[self.view addSubview:_backgroundImgV];
	_backImgHeight=_backgroundImgV.frame.size.height;
	_backImgWidth=_backgroundImgV.frame.size.width;
}
- (void)getNum{
	codeV =10000 +  (arc4random() % 90001);
	NSLog(@"初始化的数 %d",codeV);
	
}
-(void)layoutTableView
{
	if (!_tableView) {
		_tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
		_tableView.backgroundColor=[UIColor clearColor];
		_tableView.showsVerticalScrollIndicator=NO;
		_tableView.dataSource=self;
		_tableView.delegate=self;
		_tableView.tableFooterView = [[UIView alloc] init];
		[_tableView registerNib:[UINib nibWithNibName:UserCellIdetifeir bundle:nil] forCellReuseIdentifier:UserCellIdetifeir];
        
        // 解决方法二：直接使用tableView属性进行设置,修复该UI错乱
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 5;
        [_tableView setContentInset:UIEdgeInsetsMake(-35, 0, 0, 0)];
        // 解决方法三：添加以下代码关闭估算行高
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;

		[self.view addSubview:_tableView];
	}
	[_tableView setTableHeaderView:[self headImageView]];
}



-(UIImageView *)headImageView{
	if (!_headImageView) {
		_headImageView=[[UIImageView alloc]init];
		_headImageView.frame=CGRectMake(0, 64, WIDTH, 170);
		_headImageView.backgroundColor=[UIColor clearColor];
		_headImageView.userInteractionEnabled = YES;
		
		_headerImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-35, 50, 70, 70)];
		_headerImg.center=CGPointMake(WIDTH/2, 70);
		[_headerImg setImage:[UIImage imageNamed:@"header"]];
		[_headerImg.layer setMasksToBounds:YES];
		[_headerImg.layer setCornerRadius:35];
		_headerImg.backgroundColor=[UIColor whiteColor];
		_headerImg.userInteractionEnabled=YES;
		UITapGestureRecognizer *header_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(header_tap_Click:)];
		[_headerImg addGestureRecognizer:header_tap];
		[_headImageView addSubview:_headerImg];
		
		NSLog(@"改变的数 %@",[NSNumber numberWithInt:codeV]);
		
		_nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(147, 130, 105, 20)];
		_nameLabel.center = CGPointMake(WIDTH/2, 125);
		_nameLabel.text = @"Rainy";
		_nameLabel.userInteractionEnabled = YES;
		UITapGestureRecognizer *nick_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nick_tap_Click:)];
		[_nameLabel addGestureRecognizer:nick_tap];
		_nameLabel.textColor=[UIColor whiteColor];
		_nameLabel.textAlignment=NSTextAlignmentCenter;
		[_headImageView addSubview:_nameLabel];
	}
	return _headImageView;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	NSLog(@"dsfa --%@",textField.text);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	NSLog(@"dsfa --%@",textField.text);
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	
	
	return YES;
}
- (void)keyboardDidShow:(NSNotification *)notification{
	UIView *keyboardView = [self getKeyboardView];
	[[UIApplication sharedApplication].keyWindow addSubview:keyboardView];
}
- (UIView *)getKeyboardView{
	UIView *result = nil;
	NSArray *windowsArray = [UIApplication sharedApplication].windows;
	for (UIView *tmpWindow in windowsArray) {
		NSArray *viewArray = [tmpWindow subviews];
		for (UIView *tmpView  in viewArray) {
			if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIPeripheralHostView"]) {
				result = tmpView;
				break;
			}
		}
		
		if (result != nil) {
			break;
		}
	}
	
	return result;
}

//左按钮
-(void)NaLeft
{
	NSLog(@"左按钮");
	[self.navigationController popViewControllerAnimated:YES];
}
//右按钮
-(void)NaRight
{
	NSLog(@"右按钮");
}//头像
-(void)header_tap_Click:(UITapGestureRecognizer *)tap
{
	NSLog(@"头像");
}
//昵称
-(void)nick_tap_Click:(UIButton *)item
{
	NSLog(@"昵称");
}




#pragma mark ---- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	return _dataArray.count;
	
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	UserCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCellIdetifeir forIndexPath:indexPath];
	
	cell.lab_text = [_dataArray objectAtIndex:indexPath.row];
	cell.img_name = @"cell";
	if (indexPath.row == 2) {
		textF = [[UITextField alloc]init];
		textF.delegate = self;
		textF.layer.borderColor = [UIColor redColor].CGColor;
		textF.layer.borderWidth = 0.3;
		textF.returnKeyType =UIReturnKeyDone;
		textF.frame = CGRectMake(100, 3, 100, 30);
		textF.placeholder = @"afd";
		[cell.contentView addSubview:textF];
	}
	
	
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if (indexPath.row == 2) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"提示",@"title",@"确认退出？",@"detail", nil];
        [[DHBAlertView sharedAlertView] showAlertWithMode:OkCancelType param:dict action:^(NSMutableDictionary *dic) {
            NSLog(@"点击确定后的回调处理");
         }];
		if ([textF.text isEqual:[NSString stringWithFormat:@"%d",codeV]]){
			NSLog(@"yiyang ");
		}
	}else{
		NSString *title = @"标题";
		UIImage *img = [UIImage imageNamed:@"headerIcon"];
		NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
		NSArray *array = @[title,img,url];
		UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];
//		avc.excludedActivityTypes = @[UIActivityTypePostToWeibo];

		[self presentViewController:avc animated:YES completion:^{}];
	}
	
}
// 有些界面以下使用代理方法来设置，发现并没有生效
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 1;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 1;
//}
// 这样的原理是因为之前只是实现了高度的代理方法，却没有实现View的代理方法，iOS10及以前这么写是没问题的，iOS11开启了行高估算机制引起的bug，因此有以下几种解决方法：
// 解决方法一：添加实现View的代理方法，只有实现下面两个方法，方法 (CGFloat)tableView: heightForFooterInSection: 才会生效
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	int contentOffsety = scrollView.contentOffset.y;
	NSLog(@"---%d",contentOffsety);
	if (scrollView.contentOffset.y<=146) {
		self.NavView.title = @"我的";
		
	}else if (scrollView.contentOffset.y>=138){
		self.NavView.title = _nameLabel.text;
		
	}
	if (scrollView.contentOffset.y<=170) {
		self.NavView.headBackView.alpha = scrollView.contentOffset.y/170;
		self.NavView.left_bt_Image = @"left_";
		self.NavView.right_bt_Image = @"Setting";
		self.NavView.color = [UIColor whiteColor];
		
		
		[[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
	}else{
		self.NavView.headBackView.alpha = 1;
		
		self.NavView.left_bt_Image = @"left@3x.png";
		self.NavView.right_bt_Image = @"Setting_";
		
		self.NavView.color = kColor(87, 173, 104, 1);
		[[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	}
	if (contentOffsety<0) {
		CGRect rect = _backgroundImgV.frame;
		rect.size.height = _backImgHeight-contentOffsety;
		rect.size.width = _backImgWidth* (_backImgHeight-contentOffsety)/_backImgHeight;
		rect.origin.x =  -(rect.size.width-_backImgWidth)/2;
		rect.origin.y = 0;
		_backgroundImgV.frame = rect;
		
	}else{
		CGRect rect = _backgroundImgV.frame;
		rect.size.height = _backImgHeight;
		rect.size.width = _backImgWidth;
		rect.origin.x = 0;
		rect.origin.y = -contentOffsety;
		_backgroundImgV.frame = rect;
		
		
	}
	
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
