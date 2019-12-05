//
//  XFPhotoAlbumViewController.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFPhotoAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "XFAssetsLibraryAccessFailureView.h"
#import "XFAssetsLibraryModel.h"
#import "XFPhotoAlbumTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "XFAssetsPhotoViewController.h"
#import "SVProgressHUD.h"

static NSString *identifier = @"XFPhotoAlbumTableViewCell";

@interface XFPhotoAlbumViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSArray *groupArray;
@end

@implementation XFPhotoAlbumViewController

- (instancetype)init {
    self = [super init];
    
    if ( self ) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGrouop:) name:@"REFRESHGROUP" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相册";
    
    [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(didCancelBarButtonAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
}

- (void)didCancelBarButtonAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)refreshGrouop:(NSNotification *)noti {
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:(NSArray *)noti.object];
    [self.tableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFPhotoAlbumTableViewCell *cell = (XFPhotoAlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    XFAssetsLibraryModel *model = self.dataArray[indexPath.row];
    
    [cell setupModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFAssetsPhotoViewController *assetsPhotoViewController = [XFAssetsPhotoViewController new];
    XFAssetsLibraryModel *model = self.dataArray[indexPath.row];
    assetsPhotoViewController.assetsGroup = model.group;
    [self.navigationController pushViewController:assetsPhotoViewController animated:true];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if ( !_dataArray ) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
