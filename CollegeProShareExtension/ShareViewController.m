//
//  ShareViewController.m
//  CollegeProShareExtension
//
//  Created by jabraknight on 2019/11/20.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    NSUserDefaults *userShare= [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dhTool.selfpro.CollegeProShareExtension"];
    [userShare setURL:[NSURL URLWithString:@"https://baidu.com"] forKey:@"URL"];
    [userShare setValue:@"value" forKey:@"key"];
    [userShare synchronize];
    // Do validation of contentText and/or NSExtensionContext attachments here
    
    //获取分组的共享目录
    NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.dhTool.selfpro.CollegeProShareExtension"];
    NSURL *fileURL = [groupURL URLByAppendingPathComponent:@"demo.txt"];
    
    //写入文件
    [@"abc" writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //读取文件
    NSString *str = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"str = %@", str);
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost
{
    __block BOOL hasExistsUrl = NO;
    [self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem * _Nonnull extItem, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@-----------%@",extItem.attributedTitle,extItem.attributedContentText);
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dhTool.selfpro.CollegeProShareExtension"];
        NSAttributedString *strings = [extItem.attributedContentText attributedSubstringFromRange:NSMakeRange(0, extItem.attributedContentText.length)];
        NSArray *array = [strings.string componentsSeparatedByString:@"\n"];
        NSString *firstString = array[0];
        NSLog(@"%@",firstString);
        [userDefaults setValue:firstString forKey:@"share-content"];
        [extItem.attachments enumerateObjectsUsingBlock:^(NSItemProvider * _Nonnull itemProvider, NSUInteger idx, BOOL * _Nonnull stop) {
            //用于判断是否有typeIdentifier(UTI)所指定的资源存在。
            if ([itemProvider hasItemConformingToTypeIdentifier:@"public.url"])
            {
                //加载typeIdentifier指定的资源
                [itemProvider loadItemForTypeIdentifier:@"public.url"
                                                options:nil
                                      completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                                          
                                          if ([(NSObject *)item isKindOfClass:[NSURL class]])
                                          {
                                              NSLog(@"分享的URL = %@", item);
//                                              self.urlString = [NSString stringWithFormat:@"%@",item];
//                                              NSString *urlStr = [NSString stringWithFormat:@"shareP://?articleTitle=%@&articleUrl=%@",[self encode:self.titleString], [self encode:self.urlString]];
//                                              NSString *urlStr =@"http://www.baidu.com";
//
//                                              if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
////                                                  //可以调起APP
////                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
////                                                  NSLog(@"调起成功");
//
//                                                  //直接退出
//                                                  [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
//                                              }
                                                                                                [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
                                                          [self.extensionContext openURL:[NSURL URLWithString:@"CollegeProShareExtension://enterApp"] completionHandler:nil];
                                          }
                                          
                                      }];
                
                hasExistsUrl = YES;
                *stop = YES;
            }
            if ([itemProvider hasItemConformingToTypeIdentifier:@"public.image"])
            {
                //加载typeIdentifier指定的资源
                [itemProvider loadItemForTypeIdentifier:@"public.image"
                                                options:nil
                                      completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                                          
                                          if ([(NSObject *)item isKindOfClass:[NSURL class]])
                                              
                                          {
                                              NSLog(@"分享的URL = %@", item);
                                              
                                              [userDefaults setValue:((NSURL *)item).absoluteString forKey:@"share-image-url"];
                                              
                                              //用于标记是新的分享
                                              [userDefaults setBool:YES forKey:@"has-new-share"];
                                              
                                              [self.extensionContext completeRequestReturningItems:@[extItem] completionHandler:nil];
                                              [self.extensionContext openURL:[NSURL URLWithString:@"CollegeProShareExtension://enterApp"] completionHandler:nil];
                                          }
                                          
                                      }];
                
                hasExistsUrl = YES;
                *stop = YES;
            }
            if ([itemProvider hasItemConformingToTypeIdentifier:@"public.text"])
            {
                //加载typeIdentifier指定的资源
                [itemProvider loadItemForTypeIdentifier:@"public.text"
                                                options:nil
                                      completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                                          
                                          if ([(NSObject *)item isKindOfClass:[NSURL class]])
                                              
                                          {
                                              NSLog(@"分享的URL = %@", item);
                                              
                                              [userDefaults setValue:((NSURL *)item).absoluteString forKey:@"share-text-url"];
                                              
                                              //用于标记是新的分享
                                              [userDefaults setBool:YES forKey:@"has-new-share"];
                                              
                                              [self.extensionContext completeRequestReturningItems:@[extItem] completionHandler:nil];
                                              [self.extensionContext openURL:[NSURL URLWithString:@"CollegeProShareExtension://enterApp"] completionHandler:nil];
                                          }
                                          
                                      }];
                
                hasExistsUrl = YES;
                *stop = YES;
            }
            
        }];
        
        if (hasExistsUrl)
        {
            *stop = YES;
        }
    }];
    
    if (!hasExistsUrl)
    {
        //直接退出
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    }
    
    
// This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
// Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    
    //定义两个配置项，分别记录用户选择是否公开以及公开的权限，然后根据配置的值
    static BOOL isPublic = NO;
    static NSInteger act = 0;
    
    NSMutableArray *items = [NSMutableArray array];
    
    //创建是否公开配置项
    SLComposeSheetConfigurationItem *item = [[SLComposeSheetConfigurationItem alloc] init];
    item.title = @"是否公开";
    item.value = isPublic ? @"是" : @"否";
    
    __weak ShareViewController *theController = self;
    __weak SLComposeSheetConfigurationItem *theItem = item;
    item.tapHandler = ^{
        
        isPublic = !isPublic;
        theItem.value = isPublic ? @"是" : @"否";
        
        
        [theController reloadConfigurationItems];
    };
    
    [items addObject:item];
    
    if (isPublic)
    {
        //如果公开标识为YES，则创建公开权限配置项
        SLComposeSheetConfigurationItem *actItem = [[SLComposeSheetConfigurationItem alloc] init];
        
        actItem.title = @"公开权限";
        
        switch (act)
        {
            case 0:
                actItem.value = @"所有人";
                break;
            case 1:
                actItem.value = @"好友";
                break;
            default:
                break;
        }
        
        actItem.tapHandler = ^{
            NSLog(@"粉丝昂完毕");
//            //设置分享权限时弹出选择界面
//            ShareViewController *actVC = [[ShareViewController alloc] init];
//            [theController pushConfigurationViewController:actVC];
//
//            [actVC onSelected:^(NSIndexPath *indexPath) {
//
//                //当选择完成时退出选择界面并刷新配置项。
//                act = indexPath.row;
//                [theController popConfigurationViewController];
//                [theController reloadConfigurationItems];
//
//            }];
            
        };
        
        [items addObject:actItem];
    }
    
    return items;
}
@end
