//
//  iCloudViewController.m
//  Test
//
//  Created by Uwaysoft on 2018/8/8.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "iCloudViewController.h"
//缓存文件路径
#define CachesFilePath ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])

@interface iCloudViewController ()<UIDocumentPickerDelegate, UIDocumentMenuDelegate>
{
	__block NSString *currentFileName;
	UIDocumentPickerMode documentPickerMode;
	
	NSURL *lastURL;
	
	
	UITextField *titleTextField;
	UITextView *contTextView;
	
	UIActivityIndicatorView *activityView;

}
@end

@implementation iCloudViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	//创建按钮标题
	NSArray *arrtitle = @[@"新建",@"打开",@"导入",@"移动",@"导出",@"保存"];
	//创建按钮
	for (int i =0; i<arrtitle.count; i++) {
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.view addSubview:btn];
		[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[btn setTitle:arrtitle[i] forState:(UIControlStateNormal)];
		btn.titleLabel.font = [UIFont systemFontOfSize:16];
		btn.frame = CGRectMake(10+(DH_DeviceWidth-20)/arrtitle.count*i, 64, (DH_DeviceWidth-20)/arrtitle.count, 20);
		btn.tag = 10+i;
	}
	//
	titleTextField = [[UITextField alloc]init];
	titleTextField.layer.borderColor = [UIColor redColor].CGColor;
	titleTextField.layer.borderWidth = 1.0;
	titleTextField.frame = CGRectMake(0, 64+20+20, DH_DeviceWidth, 30);
	[self.view addSubview:titleTextField];
	
	contTextView = [[UITextView alloc]init];
	contTextView.layer.borderColor = [UIColor redColor].CGColor;
	contTextView.layer.borderWidth = 1.0;
	contTextView.frame = CGRectMake(0, 64+(30+20+20), DH_DeviceWidth, 150);
	[self.view addSubview:contTextView];
	//创建系统自带的加载控件
	activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
	
	[activityView setCenter:CGPointMake(self.view.center.x, 140)];//指定进度轮中心点
	
	[activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
	
	[self.view addSubview:activityView];

    // Do any additional setup after loading the view.
//	NSArray *documentTypes = @[@"com.microsoft.word.doc",@"com.microsoft.word.docx",@"com.microsoft.excel.xlsx", @"com.microsoft.excel.xls"];
//	UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeImport];
//	documentPickerViewController.delegate = self;
//	[self presentViewController:documentPickerViewController animated:YES completion:nil];
}
- (void)FountionGetiCouldFile:(UIButton *)btn{
	switch ((int)btn.tag) {
		case 10:
		{
			titleTextField.enabled = YES;
			
			documentPickerMode = 0;
			lastURL = nil;
			
			currentFileName = @"新建文件.txt";
			titleTextField.text = currentFileName;
			
			[titleTextField becomeFirstResponder];
			[self refreshBtnStatue];
		}
			break;
		case 11:
		{
			titleTextField.enabled = NO;
			documentPickerMode = UIDocumentPickerModeOpen;
//			[self displayDocumentPickerWithURIs:@[@"public.text", @"public.content"]];
			[self displayDocumentPickerWithURIs:@[@"com.microsoft.word.doc",@"com.microsoft.word.docx",@"com.microsoft.excel.xlsx", @"com.microsoft.excel.xls"]];
		}
			break;
		case 12:
		{
			//导入情况下，导入的文件会放在应用的临时文件目录里
			titleTextField.enabled = NO;
			documentPickerMode = UIDocumentPickerModeImport;
			[self displayDocumentPickerWithURIs:@[@"public.text", @"public.content"]];
		}
			break;
		case 13:
		{
			[self modify:nil];
			documentPickerMode = UIDocumentPickerModeMoveToService;
			NSURL *fileURL = [NSURL fileURLWithPath: [CachesFilePath stringByAppendingPathComponent: currentFileName]];
			[self displayDocumentPickerWithURL:fileURL];
		}
			break;
		case 14:
		{
			//1. 保存缓存文件
			[self modify:nil];
			documentPickerMode = UIDocumentPickerModeExportToService;
			NSURL *fileURL = [NSURL fileURLWithPath: [CachesFilePath stringByAppendingPathComponent: currentFileName]];
			
			//2.打开文件选择器
			[self displayDocumentPickerWithURL:fileURL];
		}
			break;
		case 15:
		{
			[self modify:nil];
		}
			break;
			
		default:
			break;
	}
}
- (void)modify:(UIButton *)btn{
	if(currentFileName.length > 0){
		if(![currentFileName isEqualToString: titleTextField.text]){
			//删除缓存中旧文件
			[self deleteLocalCachesData:currentFileName];
			currentFileName = titleTextField.text;
		}
		NSString *content = contTextView.text;
		
		if([self saveLocalCachesCont:content fileName: currentFileName]){
			NSLog(@"保存成功");
		}
		
		if(documentPickerMode == UIDocumentPickerModeOpen){
			//打开模式下，保存在文件打开的地址
			//1.通过文件协调器写入文件
			NSFileCoordinator *fileCoorDinator = [NSFileCoordinator new];
			NSError *error = nil;
			[fileCoorDinator coordinateWritingItemAtURL:lastURL
												options:NSFileCoordinatorWritingForReplacing
												  error:&error
											 byAccessor:^(NSURL * _Nonnull newURL) {
												 
												 //2.获取安全访问权限
												 BOOL access = [newURL startAccessingSecurityScopedResource];
												 
												 //3.写入数据
												 if(access && [content writeToURL:newURL atomically:YES encoding:NSUTF8StringEncoding error:nil]){
													 NSLog(@"保存原文件成功");
												 }
												 
												 //4.停止安全访问权限
												 [newURL stopAccessingSecurityScopedResource];
											 }];
		}
		
	}
}
- (void)displayDocumentPickerWithURL:(NSURL *)url {
	UIDocumentMenuViewController *importMenu = [[UIDocumentMenuViewController alloc] initWithURL:url inMode:documentPickerMode];
	importMenu.delegate = self;
	[self presentViewController:importMenu animated:YES completion:nil];
}

- (void)displayDocumentPickerWithURIs:(NSArray<NSString *> *)UTIs {
	UIDocumentMenuViewController *importMenu = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:UTIs inMode:documentPickerMode];
	importMenu.delegate = self;
	[self presentViewController:importMenu animated:YES completion:nil];
}

#pragma mark - UIDocumentMenuDelegate
-(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker
{
//	documentPicker.documentPickerMode = UIDocumentPickerModeImport;
	documentPicker.delegate = self;
	[self presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - UIDocumentPickerDelegate
-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
	lastURL = url;
	[controller dismissViewControllerAnimated:YES completion:nil];
	switch (controller.documentPickerMode) {
		case UIDocumentPickerModeImport:
		{
			[self refreshBtnStatue];
			[self importFile: url];
		}
			break;
		case UIDocumentPickerModeOpen:
		{
			[self refreshBtnStatue];
			[self openFile: url];
		}
			break;
		case UIDocumentPickerModeExportToService:
		{
			NSLog(@"保存到此位置：%@", url);
		}
			break;
		case UIDocumentPickerModeMoveToService:
		{
			//可以删除本地对应的文件
			NSLog(@"移动到此位置：%@", url);
		}
			break;
			
		default:
			break;
	}
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
	[controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)importFile:(NSURL *)url
{
	[activityView startAnimating];
    __weak typeof(self) ws = self;
    //1.通过文件协调工具来得到新的文件地址，以此得到文件保护功能
	NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
	[fileCoordinator coordinateReadingItemAtURL:url options:NSFileCoordinatorReadingWithoutChanges error:nil byAccessor:^(NSURL * _Nonnull newURL) {
        __strong typeof(ws) ss = ws;
		[ss ->activityView stopAnimating];
		
		//2.直接读取文件
		NSString *fileName = [newURL lastPathComponent];
		NSString *contStr = [NSString stringWithContentsOfURL:newURL encoding:NSUTF8StringEncoding error:nil];
		
		//3.把数据保存在本地缓存
		[self saveLocalCachesCont:contStr fileName:fileName];
		
		//4.显示数据
		ss ->currentFileName = fileName;
		ss ->titleTextField.text = fileName;
		ss ->contTextView.text = contStr;
		
	}];
}

- (void)openFile:(NSURL *)url
{
	//1.获取文件授权
	BOOL accessing = [url startAccessingSecurityScopedResource];
	
	if(accessing){
		[activityView startAnimating];
		
		//2.通过文件协调器读取文件地址
		NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
		[fileCoordinator coordinateReadingItemAtURL:url
											options:NSFileCoordinatorReadingWithoutChanges
											  error:nil
										 byAccessor:^(NSURL * _Nonnull newURL) {
											 
											 [self ->activityView stopAnimating];
											 
											 //3.读取文件协调器提供的新地址里的数据
											 NSString *fileName = [newURL lastPathComponent];
											 NSString *contStr = [NSString stringWithContentsOfURL:newURL encoding:NSUTF8StringEncoding error:nil];
											 
											 //4.把数据保存在本地缓存
											 [self saveLocalCachesCont:contStr fileName:fileName];
											 
											 //5.显示数据
											 self ->currentFileName = fileName;
											 self ->titleTextField.text = fileName;
											 self ->contTextView.text = contStr;
										 }];
		
	}
	
	//6.停止授权
	[url stopAccessingSecurityScopedResource];
}

//把文件保存在本地缓存
- (BOOL)saveLocalCachesCont:(NSString *)cont fileName:(NSString *)fileName
{
	NSString *filePath = [CachesFilePath stringByAppendingPathComponent: fileName];
	return [cont writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)deleteLocalCachesData:(NSString *)fileName
{
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *filePath = [CachesFilePath stringByAppendingPathComponent: fileName];
	if([fileMgr fileExistsAtPath:filePath]){
		[fileMgr removeItemAtPath:filePath error:nil];
	}
}

- (void)refreshBtnStatue{
	UIButton *moveBtnItem = (UIButton *)[self.view viewWithTag:13];
	moveBtnItem.enabled = YES;
	UIButton *exportBtnItem = (UIButton *)[self.view viewWithTag:14];
	exportBtnItem.enabled = YES;
	UIButton *saveBtnItem = (UIButton *)[self.view viewWithTag:15];
	saveBtnItem.enabled = YES;
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
