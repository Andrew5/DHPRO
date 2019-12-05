//
//  T3DTouchViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/7/9.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "T3DTouchViewController.h"
#import "GZBaseViewController.h"

@interface T3DTouchViewController ()
<UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate,GZBaseViewControllerDelegate>

//  tableView属性：
@property (nonatomic,strong) UITableView *tableViews;
@property (nonatomic,strong)NSMutableArray *items;
@property (nonatomic,weak)UITableViewCell *selectedCell;
@end

@implementation T3DTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.title = @"3DTouch(GZ)" ;
	self.view.backgroundColor = [UIColor whiteColor];
	self.tableViews.backgroundColor = [UIColor orangeColor];
	//1.该页面必需遵循UIViewControllerPreviewingDelegate代理
	// 重要 注册3dtouch功能
    /**
     *  如果支持3DTouch，就添加3DTouch的代理
     */
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
//    [NSString stringWithFormat:@"****妈妈再也不用担心我装逼了****\n\n我的设备: %@\n\n我的内存: %.2f MB\n\n我的储空间: %qi GB\n\n********************************",[PhoneInfoManager getCurrentDeviceModel],[PhoneInfoManager logMemoryInfo],[PhoneInfoManager freeDiskSpaceInBytes]];
}
#pragma mark - UIViewControllerPreviewingDelegate（实现代理的方法）
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
	self.selectedCell = [self searchCellWithPoint:location];
	previewingContext.sourceRect = self.selectedCell.frame;
	
	GZBaseViewController *GZVC = [[GZBaseViewController alloc] init];
	GZVC.delegate = self;
	GZVC.navTitle = self.selectedCell.textLabel.text;
	return GZVC;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
	[self tableView:self.tableViews didSelectRowAtIndexPath:[self.tableViews indexPathForCell:self.selectedCell]];
    //然后3秒后移除
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [viewControllerToCommit dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

// 根据一个点寻找对应cell并返回cell
- (UITableViewCell *)searchCellWithPoint:(CGPoint)point {
	UITableViewCell *cell = nil;
	for (UIView *view in self.tableViews.subviews) {
		NSString *class = [NSString stringWithFormat:@"%@",view.class];
		if (![class isEqualToString:@"UITableViewWrapperView"]) continue;
		for (UIView *tempView in view.subviews) {
			if ([tempView isKindOfClass:[UITableViewCell class]] && CGRectContainsPoint(tempView.frame, point)) {
				cell = (UITableViewCell *)tempView;
				break;
			}
		}
		break;
	}
	return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	//.自定义Cell方法
	static NSString *rid= @"cells";
	
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
	
	if(cell==nil){
		
		cell=[[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
	}
	cell.textLabel.text = self.items[indexPath.row];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
	
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 160 ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.items.count ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	GZBaseViewController *GZVC = [[GZBaseViewController alloc] init];
	GZVC.navTitle = self.items[indexPath.row];
	
	[self.navigationController pushViewController:GZVC animated:YES];
}


#pragma mark - GZBaseViewControllerDelegate
- (void)GZViewControllerDidSelectedBackItem:(GZBaseViewController *)GZVC {
	NSLog(@"back");
}

- (void)GZViewController:(GZBaseViewController *)GZVC DidSelectedDeleteItem:(NSString *)navTitle {
	[self.items removeObject:navTitle];
	[self.tableViews reloadData];
}
- (NSMutableArray *)items {
	if (!_items) {
		_items = [[NSMutableArray alloc]init];
		for (NSInteger i = 0; i < 20; i++) {
			[_items addObject:[NSString stringWithFormat:@"3DTouch((⁄ ⁄•⁄ω⁄•⁄ ⁄))--%li",(long)i]];
		}
	}
	return _items;
}

-(UITableView *)tableViews{
	if (!_tableViews) {
		_tableViews = [[UITableView alloc]initWithFrame:self.view.bounds];
		[self.view addSubview:_tableViews];
		_tableViews.delegate = self ;
		_tableViews.dataSource = self ;
	}
	return _tableViews ;
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
