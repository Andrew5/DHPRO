//
//  MyViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/20.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "MyViewController.h"
#import "UIImageView+WebCache.h"
#import "KVNProgress.h"
#import "MapViewController.h"
#import "DownWebViewController.h"
#import "aboutViewController.h"
#import "callViewController.h"
#import "PrefixHeader.pch"
#import "adviseViewController.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *view;
    
}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createUI];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


-(void)createUI
{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 200)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_guide@3x"]];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-100)/2, 50, 100, 100)];
    image.image = [UIImage imageNamed:@"iTunesArtwork"];
    image.layer.cornerRadius = 50;
    image.layer.masksToBounds = YES;
    [view addSubview:image];
    _tableView.tableHeaderView = view;
    //[self.view addSubview:view];
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }else{
        return 4;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id1"];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id1"];
            cell.textLabel.text = @"我的位置";
            cell.imageView.image = [UIImage imageNamed:@"icon_map_pin_red@3x"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor colorWithRed:128 / 255.0 green:127 / 255.0 blue:125 / 255.0 alpha:1];
            return cell;
        }else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"i1"];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"i1"];
            cell.textLabel.text = @"清除缓存";
            cell.imageView.image = [UIImage imageNamed:@"icon_delete_40@3x"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor colorWithRed:128 / 255.0 green:127 / 255.0 blue:125 / 255.0 alpha:1];
            return cell;
        }
    }else
    {
        if (indexPath.row==0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id2"];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id2"];
            cell.textLabel.text = @"我的锦囊";
            cell.imageView.image = [UIImage imageNamed:@"button_sticker_experience"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor colorWithRed:128 / 255.0 green:127 / 255.0 blue:125 / 255.0 alpha:1];
            return cell;

        }else if (indexPath.row==1)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"i3"];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"i3"];
            cell.textLabel.text = @"关于小豌旅行";
            cell.imageView.image = [UIImage imageNamed:@"unconnected5@3x"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor colorWithRed:128 / 255.0 green:127 / 255.0 blue:125 / 255.0 alpha:1];
            return cell;
        }else if (indexPath.row==3)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"i4"];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"i4"];
            cell.imageView.image = [UIImage imageNamed:@"unconnected2@3x"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor colorWithRed:128 / 255.0 green:127 / 255.0 blue:125 / 255.0 alpha:1];
            cell.textLabel.text = @"联系我吧";
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"i2"];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"i2"];
            cell.textLabel.text = @"版本号";
            cell.imageView.image = [UIImage imageNamed:@"avatar_placeholder@3x"];
            
            cell.textLabel.textColor = [UIColor colorWithRed:128 / 255.0 green:127 / 255.0 blue:125 / 255.0 alpha:1];
            UILabel *versionLabel = [UILabel new];
            versionLabel.text = @"小豌旅行 1.0";
            versionLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
            [versionLabel sizeToFit];
            cell.accessoryView = versionLabel;
            return cell;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            MapViewController *mapVC =[[MapViewController alloc] init];
           [self presentViewController:mapVC animated:YES completion:nil];
        }
        else
        {
            [self clearCache];
        }
    }else{
        if (indexPath.row==0) {
            //DownWebViewController *down = [[DownWebViewController alloc]init];
            //[self presentViewController:down animated:YES completion:nil];
//            adviseViewController *advise = [[adviseViewController alloc]init];
//            [self.navigationController pushViewController:advise animated:YES];
        }else if (indexPath.row==1)
        {
            aboutViewController *about = [[aboutViewController alloc]init];
            
            [self presentViewController:about animated:YES completion:nil];
        }else if (indexPath.row==3){
            callViewController *call = [[callViewController alloc]init];
            
            [self presentViewController:call animated:YES completion:nil];
        }
    }
}
- (void)clearCache
{
    SDImageCache * imageChache = [SDImageCache sharedImageCache];
    NSUInteger cacheSize = [imageChache getSize]; // 单位为：byte
    NSUInteger cacheNum = [imageChache getDiskCount]; // 缓存的图片数量
    NSString * msg = [NSString stringWithFormat:@"缓存文件总共%lu个，大小%.2fM，是否清除？", cacheNum, cacheSize / 1024 / 1024.0];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"清除缓存" message:msg preferredStyle:UIAlertControllerStyleAlert];
    // 创建AlertAction
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        // 清除缓存
        
        [imageChache clearMemory];
        [imageChache clearDisk];
        [KVNProgress showSuccessWithStatus:@"清除成功"];
    }];
    
    // 将UIAlertAction添加到UIAlertController中
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    // present显示
    [self presentViewController:alertController animated:YES completion:nil];
    
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
