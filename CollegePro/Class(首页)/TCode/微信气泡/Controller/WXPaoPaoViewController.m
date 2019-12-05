//
//  WXPaoPaoViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/11/22.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "WXPaoPaoViewController.h"

@interface WXPaoPaoViewController ()<UITableViewDelegate,UITableViewDataSource>{
	UITableView *_tableViewMy;
}
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation WXPaoPaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_tableViewMy = [[UITableView alloc]init];
	_tableViewMy.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	_tableViewMy.delegate = self;
	_tableViewMy.dataSource = self;
//	[_tableViewMy registerClass:[<#UITableViewCell#> class]forCellReuseIdentifier:NSStringFromClass([<#UITableViewCell#> class])];
	_tableViewMy.tableFooterView = [UIView new];
	[self.view addSubview:_tableViewMy];
    // Do any additional setup after loading the view.
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"name",@"微信团队欢迎你。很高兴你开启了微信生活，期待能为你和朋友们带来愉快的沟通体检。",@"content", nil];
	NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",@"he阿斯顿发斯蒂芬llo",@"content", nil];
	NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",@"0",@"content", nil];
	NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"name",@"谢谢反馈，已收录。",@"content", nil];
	NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",@"0",@"content", nil];
	NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"name",@"谢谢反馈，已收录。",@"content", nil];
	NSDictionary *dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",@"大数据测试，长数据测试，大数据测试，长数据测试，大数据测试，长数据测试，大数据测试，长数据34测试，大数据测试，长数据测试，大数32据测试，长数据测试。",@"content", nil];
	
	_resultArray = [NSMutableArray arrayWithObjects:dict,dict1,dict2,dict3,dict4,dict5,dict6, nil];
	
}

//泡泡文本
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position{
	
	//计算大小
	UIFont *font = [UIFont systemFontOfSize:14];
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
	
	// build single chat bubble cell with given text
	UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
	returnView.backgroundColor = [UIColor clearColor];
	
	//背影图片
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"SenderAppNodeBkg_HL":@"ReceiverTextNodeBkg" ofType:@"png"]];
	
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
	NSLog(@"%f,%f",size.width,size.height);
	
	
	//添加文本信息
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 20.0f, size.width+10, size.height+10)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
	bubbleText.text = text;
	
	bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
	
	if(fromSelf)
		returnView.frame = CGRectMake(self.view.frame.size.width-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
	else
		returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
	
	[returnView addSubview:bubbleImageView];
	[returnView addSubview:bubbleText];
	
	return returnView;
}

//泡泡语音
- (UIView *)yuyinView:(NSInteger)logntime from:(BOOL)fromSelf withIndexRow:(NSInteger)indexRow  withPosition:(int)position{
	
	//根据语音长度
	int yuyinwidth = 66+fromSelf;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.tag = indexRow;
	if(fromSelf)
		button.frame =CGRectMake(self.view.frame.size.width-position-yuyinwidth, 10, yuyinwidth, 54);
	else
		button.frame =CGRectMake(position, 10, yuyinwidth, 54);
	
	//image偏移量
	UIEdgeInsets imageInsert;
	imageInsert.top = -10;
	imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
	button.imageEdgeInsets = imageInsert;
	
	[button setImage:[UIImage imageNamed:fromSelf?@"SenderVoiceNodePlaying":@"ReceiverVoiceNodePlaying"] forState:UIControlStateNormal];
	UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"SenderVoiceNodeDownloading":@"ReceiverVoiceNodeDownloading"];
	backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
	[button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
	
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf?-30:button.frame.size.width, 0, 30, button.frame.size.height)];
	label.text = [NSString stringWithFormat:@"%ld''",(long)logntime];
	label.textColor = [UIColor grayColor];
	label.font = [UIFont systemFontOfSize:13];
	label.textAlignment = NSTextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	[button addSubview:label];
	
	return button;
}



#pragma -mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _resultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
	}else{
		for (UIView *cellView in cell.subviews){
			[cellView removeFromSuperview];
		}
	}
	
	NSDictionary *dict = [_resultArray objectAtIndex:indexPath.row];
	
	//创建头像
	UIImageView *photo ;
	if ([[dict objectForKey:@"name"]isEqualToString:@"rhl"]) {
		photo = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 10, 50, 50)];
		[cell addSubview:photo];
		photo.image = [UIImage imageNamed:@"photo1"];
		
		if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
			[cell addSubview:[self yuyinView:1 from:YES withIndexRow:indexPath.row withPosition:65]];
			
			
		}else{
			[cell addSubview:[self bubbleView:[dict objectForKey:@"content"] from:YES withPosition:65]];
		}
		
	}else{
		photo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
		[cell addSubview:photo];
		photo.image = [UIImage imageNamed:@"photo"];
		
		if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
			[cell addSubview:[self yuyinView:1 from:NO withIndexRow:indexPath.row withPosition:65]];
		}else{
			[cell addSubview:[self bubbleView:[dict objectForKey:@"content"] from:NO withPosition:65]];
		}
	}
	
	return cell;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *dict = [_resultArray objectAtIndex:indexPath.row];
	UIFont *font = [UIFont systemFontOfSize:14];
	CGSize size = [[dict objectForKey:@"content"] sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
	
	return size.height+44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
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
