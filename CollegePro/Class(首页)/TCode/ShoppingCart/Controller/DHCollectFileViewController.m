//
//  DHCollectFileViewController.m
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHCollectFileViewController.h"
#import "DHSegmentCommenMannager.h"
#import "DHVideoFileListViewController.h"
@interface DHCollectFileViewController ()
@property (nonatomic,strong) DHSegmentCommenMannager *segmentViewStore;

@end

@implementation DHCollectFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加切换VC
    [self addSegmentChangeVC];
}
//收藏的分段视图(默认)
-(void)addSegmentChangeVC
{
    if (!self.segmentViewStore) {
        DHVideoFileListViewController * firstVC = [[DHVideoFileListViewController alloc]init];
        //    firstVC.type = @"0";
        DHVideoFileListViewController * SecondVC = [[DHVideoFileListViewController alloc]init];
        //    SecondVC = @"1";
        DHVideoFileListViewController * thirdVC = [[DHVideoFileListViewController alloc]init];
        //    thirdVC.type = @"2";
        DHVideoFileListViewController * fourthVC = [[DHVideoFileListViewController alloc]init];
        DHVideoFileListViewController * fifthVC = [[DHVideoFileListViewController alloc]init];

        NSArray *controllers=@[firstVC,SecondVC,thirdVC,fourthVC,fifthVC];
        NSArray *titleArray =@[@"文档1",@"视频",@"图片",@"音频",@"其他"];
        self.segmentViewStore =  [[DHSegmentCommenMannager alloc] initWithFrame:self.view.bounds controllers:controllers titleArray:titleArray ParentController:self];
        [self.view addSubview:self.segmentViewStore];
    }
    
}

//底部悬浮View高
- (CGFloat)bottomViewHigt
{
    //兼容iphoneX
    CGFloat bottomHigt = 60 ;
//    if (kDevice_Is_iPhoneX) {
//        bottomHigt = 94;
//    }
    return bottomHigt;
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
