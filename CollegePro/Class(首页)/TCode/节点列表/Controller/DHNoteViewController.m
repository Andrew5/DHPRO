//
//  DHNoteViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/8/3.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "DHNoteViewController.h"
#import "SDAutoLayout.h"
#import "GZTableViewCell.h"
@interface DHNoteViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *GZTableView;
@property (nonatomic, strong) NSMutableArray *TimeLineData;

@end

static NSString *rell = @"cells";

@implementation DHNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
	[self TimeLineDatas];
	[self.GZTableView registerClass:[GZTableViewCell class] forCellReuseIdentifier:rell];
	self.GZTableView.backgroundColor = [UIColor whiteColor];

}
#pragma mark -- 返回多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
#pragma mark -- 每组返回多少个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.TimeLineData.count;
}
#pragma mark -- 每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id model = self.TimeLineData[indexPath.row];
	return [self.GZTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[GZTableViewCell class] contentViewWidth:[self cellContentViewWith]];
	
	//    GZTimeLineModel *model = self.TimeLineData[indexPath.row];
	//
	//    return [self.GZTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[GZTableViewCell class] contentViewWidth:self.view.frame.size.width];
}
#pragma mark -- 每个cell显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	GZTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:rell];
	if (!cell) {
		cell = [[GZTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rell];
		//        cell = [[[NSBundle mainBundle] loadNibNamed:@"GZTableViewCell" owner:nil options:nil] firstObject];
		
	}
	if (indexPath.row == 0) {
		cell.GZTopLine.backgroundColor = [UIColor clearColor];
	}else if (indexPath.row == self.TimeLineData.count - 1){
		cell.GZBoyttomLine.backgroundColor = [UIColor clearColor];
	}
	cell.model = self.TimeLineData[indexPath.row];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}
- (CGFloat)cellContentViewWith
{
	CGFloat width = [UIScreen mainScreen].bounds.size.width;
	
	// 适配ios7横屏
	if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
		width = [UIScreen mainScreen].bounds.size.height;
	}
	return width;
}

-(UITableView *)GZTableView{
	if (!_GZTableView) {
		_GZTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
		[self.view addSubview:_GZTableView];
		_GZTableView.delegate = self ;
		_GZTableView.dataSource = self ;
		self.GZTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
	}
	return _GZTableView ;
}

-(void)TimeLineDatas{
	self.TimeLineData = [[NSMutableArray alloc]init];
	
	NSArray *textArray = @[@" NSString *path = [[NSBundle mainBundle]pathForResource: ofType:];UIImage *image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@]];self.view.layer.contents = (id)image.CGImage;",
						   @"一个像样的App，首先要有一个像样的门面 ---app启动页，现在我就给大家分享下我做过的各种各样的启动页！",
						   @"使用UICollectionView可以布局各种各样的瀑布流，下面我写了两种不同布局的瀑布流样式如下显示",
						   @"此后还会更新更多的关瀑布流的东西。代码传送门：https://github.com/Gang679/GZWaterfall"
						   @"因为我们的App有商品兑换这一机制，故我们必须要有一个邮寄地址管理的页面，就在刚才自己简单的写了下实现单选和复选的问题，其实有两种方法，这里先给大家说下其中一种方法。",
						   @"否则在大屏上会显得字大，内容少，容易遭到用户投诉。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。"
						   , @"然后等比例拉伸到大屏。屏幕宽度返回 320否则在大屏上会显得字大长期处于这种模式下，否则在大屏上会显得字大，内容少这种情况下对界面不会",
						   @"在我们做选择时，必须在每次点击时记录cell的indexPath；下面给大家看下我的实现方法：单选：先定义一个变量，记录每次点击的cell：",
						   @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
						   @"容易遭到用户投诉。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",@"当你的 app 没有提供 3x 的LaunchImage 时。然后等比例拉伸屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任小。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
						   @"然后等比例拉伸到大屏。屏幕宽度返回 320否则在大屏上会显得字大长期处于这种模式下，否则在大屏上会显得字大，内容少这种情况下对界面不会",
						   @"长期处于这种模式下",
						   @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
						   @"否则在大屏上会显得字大，内容少，容易遭到用户投诉。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。"
						   , @"然后等比例拉伸到大屏。屏幕宽度返回 320否则在大屏上会显得字大长期处于这种模式下，否则在大屏上会显得字大，内容少这种情况下对界面不会",
						   @"内容少，容易遭到用户投诉。",
						   @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
						   @"容易遭到用户投诉。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。"];
	
	for (int i = 0; i<textArray.count; i++) {
		
		GZTimeLineModel *model = [[GZTimeLineModel alloc]init];
		model.title = textArray[i];
		model.time = [NSString stringWithFormat:@"2017年5月%d号",i];
		[self.TimeLineData addObject:model];
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
