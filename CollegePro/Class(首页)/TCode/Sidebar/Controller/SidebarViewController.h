//
//  SidebarViewController.h
//  LLBlurSidebar
//
//  Created by Lugede on 14/11/20.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLBlurSidebar.h"
typedef void (^ReturnBlock)(NSString *showText);

@interface SidebarViewController : LLBlurSidebar
@property (nonatomic, copy) ReturnBlock myReturnTextBlock;

+ (SidebarViewController *)sharedInstance;
@end
