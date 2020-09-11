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

static NSString *kUserCellIdetifeir = @"kUserCell";

#import "ContentOffSetVC.h"
#import "DHBAlertView.h"
#import "SearchistoryTableViewCell.h"

@interface ContentOffSetVC ()<UIGestureRecognizerDelegate>{
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
-(void)createNaView{
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
-(void)layoutTableView{
	if (!_tableView) {
		_tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
		_tableView.backgroundColor=[UIColor clearColor];
		_tableView.showsVerticalScrollIndicator=NO;
		_tableView.dataSource=self;
		_tableView.delegate=self;
		_tableView.tableFooterView = [[UIView alloc] init];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
		[_tableView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil] forCellReuseIdentifier:kUserCellIdetifeir];
        [_tableView registerClass:[SearchistoryTableViewCell class] forCellReuseIdentifier:@"kSearchistoryTableViewCell"];
        
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
-(void)NaLeft{
	NSLog(@"左按钮");
	[self.navigationController popViewControllerAnimated:YES];
}
//右按钮
-(void)NaRight{
	NSLog(@"右按钮");
}//头像
-(void)header_tap_Click:(UITapGestureRecognizer *)tap{
	NSLog(@"头像");
}
//昵称
-(void)nick_tap_Click:(UIButton *)item{
	NSLog(@"昵称");
}

#pragma mark ---- UITableViewDelegate
//返回分区数(默认为1)
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//返回每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
//返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TableViewCellIdentifier = @"cell";
    UITableViewCell *tableViewCell =[tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
    }
//    if (indexPath.row == 1) {
//        SearchistoryTableViewCell *cellSearchistory = [tableView dequeueReusableCellWithIdentifier:@"SearchistoryTableViewCell" forIndexPath:indexPath];
//        return cellSearchistory;
//    }else{
    
    if (indexPath.row == 1) {
        SearchistoryTableViewCell *cellSearchistory = [tableView dequeueReusableCellWithIdentifier:@"kSearchistoryTableViewCell" forIndexPath:indexPath];
        if (cellSearchistory == nil) {
            cellSearchistory = [[SearchistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kSearchistoryTableViewCell"];
        }
        return cellSearchistory;
    }else{
        UserCell *cellUser = [tableView dequeueReusableCellWithIdentifier:kUserCellIdetifeir forIndexPath:indexPath];
        if (cellUser == nil) {
            cellUser = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUserCellIdetifeir];
        }
        cellUser.lab_text = [_dataArray objectAtIndex:indexPath.row];
        cellUser.img_name = @"cell";
        return cellUser;
    }
    return tableViewCell;
//    }
//    return tableViewCell;
}
 //已经选中和已经取消选中后调用的函数
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.row == 2) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"提示",@"title",@"确认退出？",@"detail", nil];
        [[DHBAlertView sharedAlertView] showAlertWithMode:OkCancelType param:dict action:^(NSMutableDictionary *dic) {
            NSLog(@"点击确定后的回调处理");
         }];
		
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
//设置行高，头视图高度和尾视图高度的方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 100;
    }
    return 44;
}
//设置分区标题内容高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 1;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
// 解决方法一：添加实现View的代理方法，只有实现下面两个方法，方法 (CGFloat)tableView: heightForFooterInSection: 才会生效
//设置自定义头视图和尾视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
//设置cell是否可以高亮
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//cell将要显示时调用的方法
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//头视图将要显示时调用的方法
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
}
//尾视图将要显示时调用的方法
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    
}
//和上面的方法对应，这三个方法分别是cell，头视图，尾视图已经显示时调用的方法
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    
}
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section{
    
}
//设置行高，头视图高度和尾视图高度的估计值(对于高度可变的情况下，提高效率)
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 1;
}
 //cell高亮和取消高亮时分别调用的函数
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
 //当即将选中某行和取消选中某行时调用的函数，返回一直位置，执行选中或者取消选中
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
 //设置tableView被编辑时的状态风格，如果不设置，默认都是删除风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
 //下面这个方法是IOS8中的新方法，用于自定义创建tableView被编辑时右边的按钮，按钮类型为UITableViewRowAction。
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
 //设置编辑时背景是否缩进
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
 //将要编辑和结束编辑时调用的方法
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//移动特定的某行
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    return proposedDestinationIndexPath;
}
#pragma mark ----UITableViewDataSourc
//返回每个分区头部的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"返回每个分区头部的标题";
}
//返回每个分区的尾部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"返回每个分区的尾部标题";
}
//设置某行是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//设置某行是否可以被移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//tableView的cell被移动时调用的方法
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
}
//设置索引栏标题数组（实现这个方法，会在tableView右边显示每个分区的索引）
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;{
    return nil;
}
//设置索引栏标题对应的分区
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}
//左滑之后会出现的字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"左滑之后会出现的字";
}
//点击了删除 会调用这个,tableView接受编辑时调用的方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
// 从数据源中删除
    [_dataArray removeObjectAtIndex:indexPath.row];
// 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

//(1) scrollview滚动过程中，自动调用的方法；（惯性滚动也会调用）
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
//(2) scrollview 将要滚动的时候调用
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
//(3)scrollview将要停止滚动时，调用
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}
//(4)scrollview 已经停止滚动时，调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}
//(5)scrollview滚动减速完毕后，调用 。 （ps:并不是每次拖拽都会有减速情况;所以如果要判断scrollview是否停止滚动，可以用scrollViewDidEndDecelerating，scrollViewDidEndDragging一起使用来判断）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}
//(6)设置放大于缩小
//1.设置scrollview的代理
//2.实现如下方法
//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return self.imageview;
//}
//(7)正在所发过程中调用的方法
//-(void)scrollViewDidZoom:(UIScrollview *)scorllview{
//    
//}
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
