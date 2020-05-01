//
//  YSYPreviewViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/10/9.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "YSYPreviewViewController.h"
#import "LBTabBarTextController.h"
#import "UILabel+Extension.h"
#import "NSString+Extension.h"
static UIImage *currentImage;
@interface YSYPreviewViewController (){
	NSArray *arrayEmployeeName;
	NSInteger countint;
	UILabel *label;
	UIView *view_root;
	UIButton *btn_AddPersion;
}
@end

@implementation YSYPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *verText = [@"北冥有鱼，其名为鲲。" VerticalString];
	label = [[UILabel alloc] initWithFrame:(CGRectMake((self.view.bounds.size.width-300) * 0.5, 100, 300, 600))];
	label.text = verText;
	label.numberOfLines = 0;
	label.textColor = [UIColor redColor];
	[label sizeToFit];//顶部显示
	[self.view addSubview:label];
	
	label.layer.borderColor = [UIColor redColor].CGColor;
	label.layer.borderWidth = 1.0;
	
	UIButton *btn_TabBar = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn_TabBar setFrame:CGRectMake(100.0 ,0.0 ,100.0 ,30.0)];
	btn_TabBar.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜色
	[btn_TabBar setTitle:@"返回" forState:0];
	[btn_TabBar setTitleColor:[UIColor redColor] forState:0];
	[btn_TabBar addTarget:self action:@selector(tabBar) forControlEvents:(UIControlEventTouchUpInside)];
	[self.view addSubview:btn_TabBar];
	_previewImageView.image=currentImage;
	
	
	
	arrayEmployeeName = @[@"束带",@"束带",@"束带",@"束带",@"束带",@"束带",@"束带",@"束带",@"束带",@"束带",@"束带",@"束带",@"束带",@"束带"];
	NSInteger allCount = arrayEmployeeName.count;
	countint = 1+arc4random() % allCount;
	
	
	view_root = [[UIView alloc]init];
	view_root.frame = CGRectMake(5, label.bottom+10, self.view.frame.size.width-10, 200);
	view_root.layer.borderColor = [UIColor blueColor].CGColor;
	view_root.layer.borderWidth = 1.0;
	[self.view addSubview:view_root];
	
	btn_AddPersion = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn_AddPersion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[btn_AddPersion setTitle:@"->" forState:(UIControlStateNormal)];
	btn_AddPersion.layer.borderColor = [UIColor blueColor].CGColor;
	btn_AddPersion.layer.borderWidth = 1.0;
	[view_root addSubview:btn_AddPersion];
	
	int columns=4;//每行的个数
	CGFloat viewWidth=view_root.frame.size.width;//视图宽
	//视图总宽 - 子控件之间的间距*个数 再次平分剩余空间 = 每个子控件宽度
	CGFloat appW=(viewWidth-20*(columns-1)-20)/columns;//子控件宽度
	CGFloat appH=20;//子控件高度
	CGFloat marginTop = 10;//第一行顶部距离位置
	CGFloat marginX=20;//横向marginX的间距值
	CGFloat marginY=20;//Y间距的值跟X一样
	
	
	for (int i = 0;i<countint;i++){
		UIButton *view = [[UIButton alloc]init];
		view.layer.borderColor = [UIColor redColor].CGColor;
		view.layer.borderWidth = 1.0;
		int xId= i%columns;//得到列索引
		//取每个控件的X位置
		CGFloat appX =marginTop+xId*(appW+marginX);
		int yId = i/columns;//得到行索引
		CGFloat appY=marginTop+yId*(appH+marginY);//取每个控件的Y位置
		//添加view
		view.frame = CGRectMake(appX, appY, appW, appH);
		[view setTitle:[NSString stringWithFormat:@"%@_%d列%d行",arrayEmployeeName[i],xId,yId] forState:(UIControlStateNormal)];
		[view setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		view.titleLabel.font = [UIFont systemFontOfSize:12];
		view.tag = i;
		[view_root addSubview:view];
		
		if (xId==3) {
			btn_AddPersion.frame = CGRectMake(marginTop, marginTop+(appH+marginY)*(yId+1), appW, appH);
			
			view_root.frame = CGRectMake(5, 40, self.view.frame.size.width-10, marginTop*2+marginY*(yId+1)+appH*(yId+2));
		}
		else{
			btn_AddPersion.frame = CGRectMake(marginTop+(appW+marginX)*(xId+1), marginTop+(appH+marginY)*yId, appW, appH);
			
			view_root.frame = CGRectMake(5, 40, self.view.frame.size.width-10, marginTop*2+marginY*yId+appH*(yId+1));
			
		}
	}
	
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void)tabBar{
	
	disVC;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (IBAction)deleteSelectedImage:(id)sender {
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"要删除这张照片吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    [action showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==actionSheet.cancelButtonIndex)
    {
        return;
    }
    else
    {
        [PostTableViewController deleteSelectedImageWithImage:currentImage];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
+(void)setPreviewImage:(UIImage *)image{
    currentImage=image;
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
