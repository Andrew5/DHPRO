//
//  DHSystemFileViewController.m
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHSystemFileViewController.h"
#import <Photos/Photos.h>
#import "ZCAssetsPickerViewController.h"
#import "DHSegmentCommenMannager.h"
#import "DHVideoFileListViewController.h"

@interface DHSystemFileViewController ()<ZCAssetsPickerViewControllerDelegate>
@property (nonatomic,strong) DHSegmentCommenMannager *segmentViewSys;

@end

@implementation DHSystemFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加切换VC
    [self addSegmentChangeVC1];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //添加切换VC
    [self addSegmentChangeVC1];
}
//本机的分段视图
- (void)addSegmentChangeVC1{
    if (!self.segmentViewSys){
        //视频
        DHVideoFileListViewController *firstVC = [[DHVideoFileListViewController alloc]init];
        //图片
        ZCAssetsPickerViewController *picker = [[ZCAssetsPickerViewController alloc] init];
        picker.CollectionFrame = CGRectMake(0, 0, DH_DeviceWidth, self.view.size.height-50);
        picker.type = ChooseTypePhoto;
        picker.maximumNumbernMedia = 9;
        picker.delegate = self;
        
        NSArray *controllers=@[firstVC,picker];
        NSArray *titleArray =@[@"视频",@"图片"];
        self.segmentViewSys =  [[DHSegmentCommenMannager alloc] initWithFrame:self.view.bounds controllers:controllers titleArray:titleArray ParentController:self];
        [self.view addSubview:self.segmentViewSys];
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
