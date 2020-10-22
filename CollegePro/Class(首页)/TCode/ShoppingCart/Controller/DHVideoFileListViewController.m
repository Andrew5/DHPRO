//
//  DHVideoFileListVCViewController.m
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHVideoFileListViewController.h"
#import "FilePickAllTypeModel.h"
#import "UIApplication+scanLocalVideo.h"
#import "DHTFVideoCell.h"
#import "JPShopCarController.h"
@interface DHVideoFileListViewController ()

@end

@implementation DHVideoFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alldataArray = [NSMutableArray array];
    //tableView
    self.videoTBV = [[UITableView alloc] init];
    //    self.videoTBV.backgroundColor = [UIColor cyanColor];
    self.videoTBV.separatorStyle = UITableViewCellSeparatorStyleNone;//暂无线
    self.videoTBV.delegate = self;
    self.videoTBV.dataSource = self;
    [self.videoTBV registerClass:[DHTFVideoCell class] forCellReuseIdentifier:@"DHTFVideoCell"];
    self.videoTBV.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.videoTBV];
    
    //获取数据
    [self getAllListData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //更新tableVie frame
    self.videoTBV.frame = CGRectMake(0, 0.5, self.view.frame.size.width, self.view.frame.size.height);
}
- (void)getAllListData {
    //是否有权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        __weak typeof(self) weakSelf = self;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized)
                {
                    [weakSelf getPhAssetData];
                } else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请在\"设置\"->\"隐私\"->\"相册\"开启访问权限" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                    [alert show];
                }
            });
        }];
    } else if (status == PHAuthorizationStatusAuthorized) {
        [self getPhAssetData];
    }
}

//获取数据 组装model
- (void)getPhAssetData {
    PHFetchResult *assetArray = [[UIApplication sharedApplication]assetsFetchResults];
    for (int i = 0; i<assetArray.count; i++) {
        PHAsset *asset = assetArray[i];
        FilePickAllTypeModel *model = [[FilePickAllTypeModel alloc] init];
        model.asset = asset;//媒体
        model.Datatype = TypeVideoSource;//类型
        model.isSelected = NO;//(默认)
        [self.alldataArray addObject:model];
    }
    [self.videoTBV reloadData];
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alldataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DHTFVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DHTFVideoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.alldataArray.count)
    {
        FilePickAllTypeModel *model =  self.alldataArray[indexPath.row];
        cell.model = model;
        [cell setVideoSelected:model.isSelected];//改变状态
        cell.asset = model.asset;//媒体数据
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}
//点击处理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //打开文件 播放
//    PHAsset *asset = [[UIApplication sharedApplication]assetsFetchResults][indexPath.row];
//    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            playerViewController *MD = [[playerViewController alloc]init];
//            MD.playerItem = playerItem;
//            [self presentViewController:MD animated:YES completion:nil];
//        });
//    }];
    
    //获取根VC
    JPShopCarController *VC =  (JPShopCarController *)self.parentViewController.parentViewController;
    if (self.alldataArray.count) {
        FilePickAllTypeModel *model =  self.alldataArray[indexPath.row];
        if (model.isSelected) {
            model.isSelected = NO;
            //删除数据
            [VC.allSelectedDataArray removeObject:model];
            NSFileManager* manager = [NSFileManager defaultManager];
            if ([manager fileExistsAtPath:model.filePath]){
                [manager removeItemAtPath:model.filePath error:nil];
            }
        }else{
            
            if (VC.allSelectedDataArray.count >= [VC.selectMax integerValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您最多能选择%@个文件",VC.selectMax] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            if ([model.fileSize containsString:@"MB"]&&[[model.fileSize substringToIndex:model.fileSize.length-2] floatValue]>[VC.selectMaxSize integerValue]) {//不能大于30M
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您选择的文件最大不能超过%@MB",VC.selectMaxSize] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            //点击选中数据copy到沙河获取路径传给上传接口
            [[UIApplication sharedApplication] getCopyVideoFilepath:model.asset getFilePath:^(NSString *path){
                model.filePath = path;
            }];
            //标记状态
            model.isSelected = YES;
            //添加数据到根视图
            [VC.allSelectedDataArray addObject:model];
        }
    }
    
    //更新列表
    [self.videoTBV reloadData];
    //更新根VC选中数据
    [VC updateSendData];
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
