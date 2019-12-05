//
//  AppDelegate+DHCategory.m
//  Test
//
//  Created by Rillakkuma on 2017/7/28.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "AppDelegate+DHCategory.h"
#import "showView.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
@implementation AppDelegate (DHCategory)
+ (AppDelegate* )shareAppDelegate{
	//    发送通知信息
 [[NSNotificationCenter defaultCenter] postNotificationName:@"versionState" object:nil userInfo:@{@"updateState":[NSNumber numberWithBool:YES]}];
	
	return (AppDelegate*)[UIApplication sharedApplication].delegate;
	//	NSString *urld = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"1254310966"];
	
}
-(void)VersonUpdate{
	//定义的app的地址
	NSString *urld = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",@"125467893"];
	
	//网络请求app的信息，主要是取得我说需要的Version
	NSURL *url = [NSURL URLWithString:urld];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
														   cachePolicy:NSURLRequestReloadIgnoringCacheData
													   timeoutInterval:10];
	[request setHTTPMethod:@"POST"];
	
	NSURLSession *session = [NSURLSession sharedSession];
	
	NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
		if (data) {
			
			//data是有关于App所有的信息
			NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
			if ([[receiveDic valueForKey:@"resultCount"] intValue]>0) {
				
				[receiveStatusDic setValue:@"1" forKey:@"status"];
				[receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
				
				//请求的有数据，进行版本比较
				[self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
			}else{
				
				[receiveStatusDic setValue:@"-1" forKey:@"status"];
			}
		}else{
			[receiveStatusDic setValue:@"-1" forKey:@"status"];
		}
	}];
	
	[task resume];
}
-(void)receiveData:(id)sender
{
	//获取APP自身版本号
	NSString *localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
	
	NSArray *localArray = [localVersion componentsSeparatedByString:@"."];
	NSArray *versionArray = [sender[@"version"] componentsSeparatedByString:@"."];
	
	if ((versionArray.count == 3) && (localArray.count == versionArray.count)) {
		//测试 用 >  最终上线 用<
		if ([localArray[0] intValue] <  [versionArray[0] intValue]) {
			[self updateVersion];
		}else if ([localArray[0] intValue]  ==  [versionArray[0] intValue]){
			if ([localArray[1] intValue] <  [versionArray[1] intValue]) {
				[self updateVersion];
			}else if ([localArray[1] intValue] ==  [versionArray[1] intValue]){
				if ([localArray[2] intValue] <  [versionArray[2] intValue]) {
					[self updateVersion];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"versionState" object:nil userInfo:@{@"updateState":[NSNumber numberWithBool:YES]}];
				}
				
			}
		}
	}
}
-(void)updateVersion{
	//您是否喜欢这次升级？
	//感谢您的认可，请给五星好评。
	NSString *msg = [NSString stringWithFormat:@"春色满园关不住，一枝“红杏”出墙来。快来更新吧 ~ "];
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"现在升级" style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {

		
		NSString *encodingString = [[NSString stringWithFormat:@"https://itunes.apple.com/us/app/37"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		NSURL *url = [NSURL URLWithString:encodingString];
		[[UIApplication sharedApplication]openURL:url];
	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
		// 取消按键
		//                self.userOutput.text = @"Clicked 'OK'";
	}];
	[alertController addAction:cancelAction];
	[alertController addAction:otherAction];
	[self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
	
}
#pragma mark -本地时间记录
- (void)saveCurrentTime {
	
	NSDate *date = [NSDate date];
	NSTimeInterval interval = [date timeIntervalSince1970];
	
	NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
	NSNumber *timeNum = [NSNumber numberWithDouble:interval];
	
	[df setObject:timeNum forKey:@"timeSaved"];
	[df synchronize];
}
- (BOOL)isUpdate {
	
	NSDate *date = [NSDate date];
	NSTimeInterval interval = [date timeIntervalSince1970];
	
	NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
	
	NSTimeInterval savedTime = [[df objectForKey:@"timeSaved"] doubleValue];
	// 7天
	//	NSTimeInterval time = 60*60*24*7;
	NSTimeInterval time = 60;
	
	if (interval > (savedTime + time)) {
		return YES;
	} else {
		return NO;
	}
}
- (void)screenshot{
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
													  object:nil
													   queue:nil
												  usingBlock:^(NSNotification *note) {
													  // executes after screenshot

													  NSLog(@"截屏咯");
													  [self userDidTakeScreenshot];
												  }];
	
}
//截屏响应
- (void)userDidTakeScreenshot
{
	NSLog(@"检测到截屏");
	//人为截屏, 模拟用户截屏行为, 获取所截图片
	UIImage *image = [self imageWithScreenshot];
	[showView showWelcomeView:image];
}
/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot
{
	NSData *imageData = [self dataWithScreenshotInPNGFormat];
	return [UIImage imageWithData:imageData];
}

/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat
{
	CGSize imageSize = CGSizeZero;
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationIsPortrait(orientation))
		imageSize = [UIScreen mainScreen].bounds.size;
	else
		imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
	
	UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	for (UIWindow *window in [[UIApplication sharedApplication] windows])
	{
		CGContextSaveGState(context);
		CGContextTranslateCTM(context, window.center.x, window.center.y);
		CGContextConcatCTM(context, window.transform);
		CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
		if (orientation == UIInterfaceOrientationLandscapeLeft)
		{
			CGContextRotateCTM(context, M_PI_2);
			CGContextTranslateCTM(context, 0, -imageSize.width);
		}
		else if (orientation == UIInterfaceOrientationLandscapeRight)
		{
			CGContextRotateCTM(context, -M_PI_2);
			CGContextTranslateCTM(context, -imageSize.height, 0);
		} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
			CGContextRotateCTM(context, M_PI);
			CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
		}
		if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
		{
			[window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
		}
		else
		{
			[window.layer renderInContext:context];
		}
		CGContextRestoreGState(context);
	}
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return UIImagePNGRepresentation(image);
}
- (UIViewController *)getCurrentVC

{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal)
    
    {
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        for(UIWindow * tmpWin in windows)
        
        {
            
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            
            {
                
                window = tmpWin;
                
                break;
                
            }
            
        }
        
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    id nextResponder = [frontView nextResponder];
    
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
    
    result = nextResponder;
    
    else
    
    result = window.rootViewController;
    
    
    
    return result;
    
}
- (void)touch3D{
    if (@available(iOS 9.0, *)) {
        if ([UIApplication sharedApplication].shortcutItems.count == 0) {
            
            UIMutableApplicationShortcutItem *itemScan = [[UIMutableApplicationShortcutItem alloc]initWithType:@"Scan"  localizedTitle:@"扫一扫" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"hpdianzan"] userInfo:nil];
            UIMutableApplicationShortcutItem *itemWrite = [[UIMutableApplicationShortcutItem alloc]initWithType:@"listen" localizedTitle:@"去写作" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"SettingS"] userInfo:nil];
            
            [UIApplication sharedApplication].shortcutItems = @[itemScan,itemWrite];
        }
    } else {
        // Fallback on earlier versions
    }
}

@end
