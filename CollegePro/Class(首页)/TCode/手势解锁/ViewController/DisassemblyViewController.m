//
//  DisassemblyViewController.m
//  Test
//
//  Created by Rillakkuma on 2018/1/4.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "DisassemblyViewController.h"
#import "DisassemblyView.h"
@implementation DisassemblyViewController
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	DisassemblyView *disV = [[DisassemblyView alloc]init];
	disV.frame = self.view.frame;
	[self.view addSubview:disV];
}
@end
