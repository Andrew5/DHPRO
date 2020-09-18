//
//  DHAttachmentVC.m
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHAttachmentViewController.h"
#import "DHVideoFileListViewController.h"
#import "DHSegmentCommenMannager.h"
#import "DHAttachmentListViewController.h"
@interface DHAttachmentViewController ()
@property (nonatomic,strong) DHSegmentCommenMannager *segmentViewAttacment;

@end

@implementation DHAttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加切换VC
    [self addSegmentChangeVC2];
}
//附件的分段视图
- (void)addSegmentChangeVC2 {
    if (!self.segmentViewAttacment) {
        DHAttachmentListViewController *wendangVC = [[DHAttachmentListViewController alloc]init];
        wendangVC.dataType = TypeOtherSource;
        wendangVC.TypeVC = @"0";
        
        DHAttachmentListViewController *shipinVC = [[DHAttachmentListViewController alloc]init];
        shipinVC.dataType = TypeVideoSource;
        shipinVC.TypeVC = @"1";

        DHAttachmentListViewController *tupianVC = [[DHAttachmentListViewController alloc]init];
        tupianVC.dataType = TypeOtherSource;
        tupianVC.TypeVC = @"2";

        DHAttachmentListViewController *yinpinVC = [[DHAttachmentListViewController alloc]init];
        yinpinVC.dataType = TypeAudioSource;
        yinpinVC.TypeVC = @"3";

        DHAttachmentListViewController *otherVC = [[DHAttachmentListViewController alloc]init];
        otherVC.dataType = TypeOtherSource;
        otherVC.TypeVC = @"4";

        NSArray *controllers=@[wendangVC,shipinVC,tupianVC,yinpinVC,otherVC];
        NSArray *titleArray =@[@"文档",@"视频",@"图片",@"音频",@"其他"];
        self.segmentViewAttacment =  [[DHSegmentCommenMannager alloc] initWithFrame:self.view.bounds controllers:controllers titleArray:titleArray ParentController:self];
        [self.view addSubview:self.segmentViewAttacment];
    }
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
