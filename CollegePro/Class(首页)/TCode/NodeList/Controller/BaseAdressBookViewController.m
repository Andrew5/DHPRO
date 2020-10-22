//
//  BaseAdressBookViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/11/28.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "BaseAdressBookViewController.h"
#import "HanyuPinyinOutputFormat.h"
#import "PinyinHelper.h"
#import "NetWork.h"
#import "ContactModel.h"
#import "SearchResultViewController.h"
#import "UIColor+JFColor.h"

#import "BookDataViewModel.h"

@interface BaseAdressBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,LBSearchResultSelectedDelegate>
{
	NSMutableArray *_arr_ListContact;//获取的数据
	UILabel *_lb_SectionTitle;//当前选择字母显示
	UITableView *_tableViewMy;//列表
	NSArray *_arr_letter;//字母
	NSMutableDictionary *_dict_Name;//姓名
	NSTimer *_timer;
	
	UISearchController *_searchController;
	SearchResultViewController *_resultController;
	NSMutableArray *_arr_updata;
	NSMutableArray *_arr_Results;
}
@property (nonatomic, assign)CGFloat marginTop;
@property (nonatomic, strong) BookDataViewModel *infoModel;

@end

@implementation BaseAdressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr_ListContact = [[NSMutableArray alloc]init];
    _dict_Name = [NSMutableDictionary dictionary];
    _arr_letter = [NSArray array];
    _arr_updata = [[NSMutableArray alloc]init];
    _arr_Results = [[NSMutableArray alloc]init];

    [self setUPUI];
//    [self getData];
    [self setMVVM];
}
- (void)setMVVM{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [BookDataViewModel bookDataRequestOncompletion:^(ContactModel * _Nonnull responseResult) {
            self->_arr_ListContact = [ContactModel mj_objectArrayWithKeyValuesArray:responseResult];
            [self handleLettersArray];
            [self->_tableViewMy reloadData];
            NSLog(@"请求-1--");
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [BookDataViewModel add:^(id  _Nonnull responseData, NSError * _Nullable error) {
            NSLog(@"请求-2--");
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"123123123123");
    });
}

- (void)getData{
	NSDictionary *parameters;
	parameters = @{@"Url":@"http://kaifa.homesoft.cn/WebService/jsonInterface.ashx",
				   @"MethodType":@"GET",
				   @"Value":@"?json=GetUserInfoAll&UserID=2"
				   };
    
    [NetWork POSTWithUrl:@"https://www.homesoft.cn/WebInterface/HBInterface.ashx" parameters:parameters view:self.view ifMBP:YES success:^(id responseObject) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:@"http://kaifa.homesoft.cn/WebService/jsonInterface.ashx"]];//得到cookie
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookiess = [NSArray arrayWithArray:[cookieJar cookies]];
        for (NSHTTPCookie *cookie in cookiess) {
            if ([[cookie name] isEqualToString:@"HFSESSION"]) {
                
                NSLog(@"===%@",cookie);
            }
        }
        self->_arr_ListContact = [ContactModel mj_objectArrayWithKeyValuesArray:responseObject[@"UserInfo"]];
        [self handleLettersArray];
        [self->_tableViewMy reloadData];
    } fail:^(NSError * _Nonnull error) {
		
	}];
	
}


- (void)setUPUI{
	//显示序列框
	_lb_SectionTitle = ({
		UILabel *sectionTitleView = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-100)/2,(self.view.bounds.size.height-100)/2,100,100)];
		sectionTitleView.textAlignment = NSTextAlignmentCenter;
		sectionTitleView.font = [UIFont boldSystemFontOfSize:60];
		sectionTitleView.textColor = [UIColor colorWithRed:0.169 green:0.737 blue:0.698 alpha:1.000];
		sectionTitleView.backgroundColor = [UIColor whiteColor];
		sectionTitleView.layer.cornerRadius = 6;
		sectionTitleView.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
		_lb_SectionTitle.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
		sectionTitleView;
	});
	[self.navigationController.view addSubview:_lb_SectionTitle];
	_lb_SectionTitle.hidden = YES;
	
	//创建列表
	_tableViewMy = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
	_tableViewMy.delegate = self;
	_tableViewMy.dataSource = self;
	_tableViewMy.sectionIndexBackgroundColor = [UIColor clearColor];
	_tableViewMy.tableFooterView = [UIView new];
	[_tableViewMy registerClass:[UITableViewCell class]forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

	[self.view addSubview:_tableViewMy];
	
	//搜做
	_resultController = [[SearchResultViewController alloc]init];
	_resultController.delegate = self;
	
	//searchController
	_searchController = [[UISearchController alloc] initWithSearchResultsController:_resultController];
	
	_searchController.searchBar.placeholder = @"搜索";
	_searchController.searchBar.tintColor = [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1];
	_searchController.searchBar.delegate = self;
	_searchController.searchResultsUpdater = _resultController;
	_tableViewMy.tableHeaderView = _searchController.searchBar;
	
	//解决iOS 8.4中searchBar看不到的bug
	UISearchBar *bar = _searchController.searchBar;
	bar.barStyle = UIBarStyleDefault;
	bar.translucent = YES;
	CGRect rect = bar.frame;
	rect.size.height = 44;
	bar.frame = rect;
	
	
	//    self.definesPresentationContext = NO;
	//设置searchBar的边框颜色，四周的颜色
	_searchController.searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
	UIImageView *view = [[[_searchController.searchBar.subviews objectAtIndex:0] subviews] firstObject];
	view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
	view.layer.borderWidth = 1;
	
	//把UISearchBar的右边图标显示出来
	//	searchController.searchBar.showsBookmarkButton = YES;
	//把UISearchBar的右边图标替换为VoiceSearchStartBtn这个图标
	//	[searchController.searchBar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
	// 将searchBar的cancel按钮改成中文的
	[[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
	self.definesPresentationContext = YES;
	[_searchController.view bringSubviewToFront:_searchController.searchBar];
	
}


-(void)handleLettersArray{
	NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
	for (ContactModel *contact in _arr_ListContact) {
		HanyuPinyinOutputFormat *format = [[HanyuPinyinOutputFormat alloc]init];
		format.caseType = CaseTypeLowercase;
		format.vCharType = VCharTypeWithV;
		format.toneType = ToneTypeWithoutTone;
		NSString *outputPinyin = [PinyinHelper toHanyuPinyinStringWithNSString:contact.Name withHanyuPinyinOutputFormat:format withNSString:@""];
		//字母大写
		[temDic setObject:contact forKey:[[[self transform:outputPinyin]substringToIndex:1]uppercaseString]];
	}
	_arr_letter = temDic.allKeys;
	for (NSString *str_Letter in _arr_letter)
	{
		NSMutableArray *arr_temp = [[NSMutableArray alloc]init];
		for (NSInteger i = 0; i<_arr_ListContact.count; i++) {
			ContactModel *contact = _arr_ListContact[i];
			HanyuPinyinOutputFormat *format = [[HanyuPinyinOutputFormat alloc]init];
			format.caseType = CaseTypeUppercase;
			format.vCharType = VCharTypeWithV;
			format.toneType = ToneTypeWithoutTone;
			//把friend的userName汉子转为汉语拼音，比如：张磊---->zhanglei
			NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:contact.Name withHanyuPinyinOutputFormat:format withNSString:@""];
			NSLog(@"outputPinyin：%@----friend.Name：%@---转义后：%@---首字母：%@",outputPinyin,contact.Name,[self transform:contact.Name],str_Letter);

			NSString *outPinyin=[self transform:contact.Name];
			//字母大写
			if ([str_Letter isEqualToString:[[outPinyin substringToIndex:1]uppercaseString] ]) {
				[arr_temp addObject:contact];
			}
		}
		[_dict_Name setObject:arr_temp forKey:str_Letter];
	}
	_arr_letter = temDic.allKeys;

	//排序，排序的根据是字母
	NSComparator cmptr = ^(id obj1,id obj2){
		//NSOrderedAscending的意思是：左边的操作对象小于右边的对象。
		if ([obj1 characterAtIndex:0]>[obj2 characterAtIndex:0]) {
			return (NSComparisonResult)NSOrderedDescending;
		}
		//NSOrderedDescending的意思是：左边的操作对象大于右边的对象。
		if ([obj1 characterAtIndex:0]<[obj2 characterAtIndex:0]) {
			return (NSComparisonResult)NSOrderedAscending;
		}

		return (NSComparisonResult)NSOrderedSame;
	};
	//数组排序
	_arr_letter = [[NSMutableArray alloc]initWithArray:[_arr_letter sortedArrayUsingComparator:cmptr]];
}
- (NSString *)transform:(NSString *)chinese
{
	NSMutableString *pinyin = [chinese mutableCopy];
	CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
	CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
	return [pinyin uppercaseString];
}
#pragma mark - private
- (void)timerHandler:(NSTimer *)sender
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:.3 animations:^{
            self->_lb_SectionTitle.alpha = 0;
		} completion:^(BOOL finished) {
            self->_lb_SectionTitle.hidden = YES;
		}];
	});
}

-(void)showSectionTitle:(NSString*)title{

	[_lb_SectionTitle setText:title];
	_lb_SectionTitle.hidden = NO;
	_lb_SectionTitle.alpha = 1;
	[_timer invalidate];
	_timer = nil;
	_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
#pragma mark
#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	
	
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if (searchText) {
		[_arr_updata removeAllObjects];
		if ([PinyinHelper isIncludeChineseInString:searchText]) {// 如果是中文
			for(int i=0;i<_arr_ListContact.count;i++)
			{
				ContactModel *friends = _arr_ListContact[i];
				if ([friends.Name rangeOfString:searchText].location!=NSNotFound) {
					[_arr_updata addObject:friends];
				}
				
			}
		}else{//如果是拼音
			for(int i=0;i<_arr_ListContact.count;i++)
			{
				HanyuPinyinOutputFormat *formatter =  [[HanyuPinyinOutputFormat alloc] init];
				formatter.caseType = CaseTypeUppercase;
				formatter.vCharType = VCharTypeWithV;
				formatter.toneType = ToneTypeWithoutTone;
				//zhengshuang  e
				ContactModel *friends = _arr_ListContact[i];
				
				NSString *outputPinyin=[[PinyinHelper toHanyuPinyinStringWithNSString:friends.Name withHanyuPinyinOutputFormat:formatter withNSString:@""] lowercaseString];
				
				
				if ([[outputPinyin lowercaseString]rangeOfString:[searchText lowercaseString]].location!=NSNotFound) {
					[_arr_updata addObject:friends];
				}
				
				
			}
		}
		
		
	}
	[_resultController updateAddressBookData:_arr_updata];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	_searchController.searchBar.showsCancelButton = YES;
	
	//    UIButton *canceLBtn = [searchController.searchBar valueForKey:@"cancelButton"];
	//    [canceLBtn setTitle:@"取消" forState:UIControlStateNormal];
	//    [canceLBtn setTitleColor:[UIColor colorWithRed:14.0/255.0 green:180.0/255.0 blue:0.0/255.0 alpha:1.00] forState:UIControlStateNormal];
	//    searchBar.showsCancelButton = YES;
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
	
	[searchBar resignFirstResponder];
}



-(void)selectPersonWithUserId:(NSString *)userId userName:(NSString *)userName photo:(NSString *)photo HX_UserID:(NSString *)hxID{
	_searchController.searchBar.text = @"";
}
#pragma -mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

	return _arr_letter.count;
	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == _tableViewMy) {
		NSArray *arr_Name = [_dict_Name objectForKey:_arr_letter[section]];
		return arr_Name.count;
	}else{
		return _arr_ListContact.count;
	}
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellId = @"cellId";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
	}
//	if (tableView == _tableViewMy) {
		ContactModel *friend = [[_dict_Name objectForKey:[_arr_letter objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
		cell.textLabel.text = friend.Name;
	
//	}
//	else{
//		NSString *userName = _arr_Results[indexPath.row];
//		ContactModel *friends = [[ContactModel alloc]init];
//		for (NSInteger i = 0 ;i<_arr_ListContact.count; i++) {
//			NSMutableArray *tempArray = [[NSMutableArray alloc]init];
//			if ([userName isEqualToString:friends.Name]) {
//				[tempArray addObject:friends];
//			}
//			ContactModel *frends = [tempArray objectAtIndex:0];
//			cell.textLabel.text = [NSString stringWithFormat:@"%@",frends.Name];
////			[cell.photoIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[USERDEFAULTS objectForKey:@"url"],friends.HeadUrl]] placeholderImage:[UIImage imageNamed:@"EaseUIResource.bundle/user"]];
////			cell.photoIV.backgroundColor = [UIColor lightGrayColor];
//		}
//	}

		return cell;
}
//添加索引列
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return _arr_letter;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//	for (UIView *aView in _tableViewMy.subviews) {
//		if ([aView isKindOfClass:NSClassFromString(@"UITableViewIndex")]) {
////            NSLog(@"aveiw = %@,  class = %@",aView,NSStringFromClass(aView.class));
//		} if ([aView isKindOfClass:NSClassFromString(@"UISearchBar")]) {
//			[self.view bringSubviewToFront:aView];
//		}
//	}
	return [_arr_letter objectAtIndex:section];

}
//索引列点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{

    NSInteger count = 0;
	for(NSString *letter in _arr_letter)
	{
		if([letter isEqualToString:title])
		{
			return count;
		}
		[self showSectionTitle:title];

		count++;
	}
	return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	ContactModel *friends;
//	if (tableView==_tableViewMy) {
		friends = [[_dict_Name objectForKey:[_arr_letter objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
//		[self myEvent:friends.HX_UserID employeeName:friends.Name iconUrl:[NSString stringWithFormat:@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[USERDEFAULTS objectForKey:@"url"],friends.HeadUrl]]]];
//		NSLog(@"lettersArray %@",[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[USERDEFAULTS objectForKey:@"url"],friends.HeadUrl]]);
//	}else{
//		friends = _arr_ListContact[indexPath.row];
//	}
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    //设置导航字体颜色、字体、背景色
//    for (UIView* subview in [_tableViewMy subviews])
//    {
//        if ([subview isKindOfClass:NSClassFromString(@"UITableViewIndex")])
//        {
//            if([subview respondsToSelector:@selector(setIndexColor:)])
//            {
//                [subview performSelector:@selector(setIndexColor:) withObject:[UIColor redColor]];
//            }
//            if([subview respondsToSelector:@selector(setFont:)])
//            {
//                [subview performSelector:@selector(setFont:) withObject:[UIColor redColor]];
//            }
//            if([subview respondsToSelector:@selector(setBackgroundColor:)])
//            {
//                [subview performSelector:@selector(setBackgroundColor:) withObject:[UIColor redColor]];
//            }
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    //改变右侧的索引列表属性
//    for (UIView *view in [tableView subviews]) {
//        if ([view isKindOfClass:[NSClassFromString(@"UITableViewIndex") class]]) {
//            // 设置字体大小
//            [view setValue:[UIFont systemFontOfSize:14] forKey:@"_font"];
//            //设置文字颜色
////            [view setValue:[UIColor orangeColor] forKey:@"_indexColor"];
////            [view setValue:[UIColor orangeColor] forKey:@"_indexBackgroundColor"];
//            //设置view的大小
//            view.bounds = CGRectMake(0, 0, 30, 30);
//            //单单设置其中一个是无效的
//        }
//    }
    //改变header的字体属性
//    view.tintColor = [UIColor redColor];
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.contentView.backgroundColor=[UIColor whiteColor];
////    header.textLabel.textAlignment=NSTextAlignmentCenter;
//    [header.textLabel setTextColor:[UIColor greenColor]];
}
- (void)setIndexColor:(id)co{
    
}
- (void)setFont:(id)co{
    
}
- (void)setBackgroundColor:(id)co{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //返回tableView可见的cell数组
    NSArray * array = [_tableViewMy visibleCells];
    //返回cell的IndexPath
    NSIndexPath * indexPath = [_tableViewMy indexPathForCell:array.firstObject];
    NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:self.view];
    NSLog(@"滑动的点%f-%f",translation.y, point.y);


    UITableViewHeaderFooterView *header = [_tableViewMy headerViewForSection:indexPath.section];
    if (translation.y>0) {
        NSLog(@"滑动操作：下");
        [UIView animateWithDuration:0.3 animations:^{
            [header.textLabel setTextColor:[UIColor colorWithHexString:@"#1b1b1b"]];
        }];
    }else{
        NSLog(@"滑动操作：上");
        [UIView animateWithDuration:0.3 animations:^{
            [header.textLabel setTextColor:[UIColor greenColor]];

        }];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate){
        NSLog(@"停下来了 %i",decelerate);
////        //返回tableView可见的cell数组
//        NSArray * array = [_tableViewMy visibleCells];
//        //返回cell的IndexPath
//        NSIndexPath * indexPath = [_tableViewMy indexPathForCell:array.firstObject];
//        NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
//        CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
//        UITableViewHeaderFooterView *header = [_tableViewMy headerViewForSection:indexPath.section];
//        if (translation.y>0) {
//            NSLog(@"上");
//            [UIView animateWithDuration:0.3 animations:^{
//                [header.textLabel setTextColor:[UIColor colorWithHexString:@"#1b1b1b"]];
//            }];
//        }else{
//            NSLog(@"下");
//            [UIView animateWithDuration:0.3 animations:^{
//                [header.textLabel setTextColor:[UIColor greenColor]];
//
//            }];
//        }
    }
 }
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"777");
//    //        //返回tableView可见的cell数组
//    NSArray * array = [_tableViewMy visibleCells];
//    //返回cell的IndexPath
//    NSIndexPath * indexPath = [_tableViewMy indexPathForCell:array.firstObject];
//    NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
//    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
//    UITableViewHeaderFooterView *header = [_tableViewMy headerViewForSection:indexPath.section];
//    [header.textLabel setTextColor:[UIColor greenColor]];

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
