//
//  DHAttachmentListVC.m
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHAttachmentListViewController.h"
#import "DHAttachmentListCell.h"
#import "JPShopCarController.h"
@interface DHAttachmentListViewController ()<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
@property(nonatomic,strong)NSMutableArray * SelectedDataArray;//附件数据数组
@property(nonatomic,strong)UITableView * allTableView;//列表
@property(nonatomic,strong)UIDocumentInteractionController * documentInteractionController;//调用第三方的APP打开文件

@end

@implementation DHAttachmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
     self.SelectedDataArray = [NSMutableArray array];
    
     //set tableView
     UITableView * alltableView = [[UITableView alloc]init];
     alltableView.backgroundColor = [UIColor whiteColor];
     alltableView.delegate = self;
     alltableView.dataSource = self;
     alltableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     alltableView.tableFooterView = [[UIView alloc]init];
     self.allTableView = alltableView;
     [self.view addSubview:alltableView];
     
     //获取所有附件数据
     [self getFujianData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //更新tableView frame
    self.allTableView.frame = CGRectMake(0, 0.5, self.view.frame.size.width, self.view.frame.size.height);
}
//获取所有的附件
- (void)getFujianData{}
//{
//    //    id ins = ((id (*)(id, SEL))objc_msgSend)(NSClassFromString(@"JHOADownLoadManager"), NSSelectorFromString(@"sharedOADownLoadSQLManager"));
//    //    self.fujianDataArray = ((NSMutableArray*(*)(id, SEL))objc_msgSend)(ins, NSSelectorFromString(@"selectFileRecord"));
//    //从数据库获取
//    NSArray * arrayAll = [[JHOADownLoadManager sharedOADownLoadSQLManager] selectFileRecordContentUserId];
//    NSMutableArray  *fujianDataArray = [NSMutableArray array];
//    NSMutableArray  *array = [NSMutableArray array];//筛选完UseId之后的数据
//
//    NSString *userId = [[LoginAndRegister sharedLoginAndRegister] getUserID];
//    for (int i = 0; i<arrayAll.count; i++) {
//        FileRecordModel * fileRecordModel = arrayAll[i];
//        if ([fileRecordModel.UserID isEqualToString:userId]) {
//            [array addObject:fileRecordModel];
//        }
//    }
//
//    if (array.count) {
//    //筛选数据
//        for (int i = 0; i<array.count; i++) {
//            FileRecordModel * fileRecordModel = array[i];
//            switch ([self.TypeVC integerValue]) {
//                case 0:{//文档
//                    if (   [fileRecordModel.path rangeOfString:@".doc"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".docx"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".ppt"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".key"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".xlsx"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".xls"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".txt"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".rtf"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".pdf"].location !=NSNotFound )
//                    {
//                        [fujianDataArray addObject:fileRecordModel];
//                    }
//
//                    break;
//                }
//                case 1:{//视频
//                    if (   [fileRecordModel.path rangeOfString:@".mp4"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".avi"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".rmvb"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".MP4"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".MOV"].location !=NSNotFound)
//                    {
//                        [fujianDataArray addObject:fileRecordModel];
//                    }
//                    break;
//                }
//                case 2:{//图片
//                    if (   [fileRecordModel.path rangeOfString:@".jpg"].location !=NSNotFound
//                        || [fileRecordModel.path rangeOfString:@".png"].location !=NSNotFound)
//                    {
//                        [fujianDataArray addObject:fileRecordModel];
//                    }
//                    break;
//                }
//                case 3:{//音频
//                    if ([fileRecordModel.path rangeOfString:@".mp3"].location !=NSNotFound)
//                    {
//                        [fujianDataArray addObject:fileRecordModel];
//                    }
//                    break;
//                }
//                case 4:{//其他
//                    if (   ![fileRecordModel.path containsString:@".doc"]
//                        && ![fileRecordModel.path containsString:@".docx"]
//                        && ![fileRecordModel.path containsString:@".ppt"]
//                        && ![fileRecordModel.path containsString:@".key"]
//                        && ![fileRecordModel.path containsString:@".xlsx"]
//                        && ![fileRecordModel.path containsString:@".xls"]
//                        && ![fileRecordModel.path containsString:@".txt"]
//                        && ![fileRecordModel.path containsString:@".rtf"]
//                        && ![fileRecordModel.path containsString:@".pdf"]
//                        && ![fileRecordModel.path containsString:@".mp4"]
//                        && ![fileRecordModel.path containsString:@".avi"]
//                        && ![fileRecordModel.path containsString:@".rmvb"]
//                        && ![fileRecordModel.path containsString:@".MP4"]
//                        && ![fileRecordModel.path containsString:@".jpg"]
//                        && ![fileRecordModel.path containsString:@".png"]
//                        && ![fileRecordModel.path containsString:@".mp3"]
//                        && ![fileRecordModel.path containsString:@".MOV"])
//                    {
//                        [fujianDataArray addObject:fileRecordModel];
//                    }
//                    break;
//                }
//                default:
//                    break;
//            }
//        }
//        //无数据展示UI
//        [self getNoDataUI:fujianDataArray];
//
//        //组装数据
//        for (int i = 0; i<fujianDataArray.count; i++)
//        {
//            FileRecordModel * FModel = fujianDataArray[i];
//            FilePickAllTypeModel *model = [[FilePickAllTypeModel alloc] init];
//            if (FModel.path) {//做这一步的目的是沙河路径每次启动会变
//                // 取得沙盒目录
//                NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//                // 要检查的文件目录
//                NSString *fileCurrentPath = [localPath  stringByAppendingPathComponent:FModel.path.lastPathComponent];
//                model.filePath = fileCurrentPath;
//            }
//            model.fileID = FModel.fileID;
//            if (!FModel.fileRealName) {
//                FModel.fileRealName = [[NSUUID UUID] UUIDString];
//            }
//            model.Datatype = self.dataType;//数据类型
//            model.fileName = FModel.fileRealName;
//            model.fileCreaTime = FModel.insertTime;
//            model.isSelected = NO;//(默认)
//            [self.SelectedDataArray addObject:model];
//        }
//
//        }else{
//            //无数据展示UI
//            [self getNoDataUI:fujianDataArray];
//        }
//
//       [self.allTableView reloadData];
//}

#pragma mark -创建tableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.SelectedDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DHAttachmentListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DHAttachmentListCell"];
    if (cell == nil)
    {
        cell = [[DHAttachmentListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DHAttachmentListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.SelectedDataArray.count) {
        FilePickAllTypeModel * model = [self.SelectedDataArray objectAtIndex:indexPath.row];
        cell.dataType = self.dataType;//数据类型
        [cell assignmentCellWithFileRecordModel:model];
        [cell setFileSelected:model.isSelected];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //打开详情
//    FileRecordModel * fileRecordModel = [self.fujianDataArray objectAtIndex:indexPath.row];
//    AttachmentOpenVC * fujianOpenViewController = [[AttachmentOpenVC alloc]init];
//    fujianOpenViewController.localPath =fileRecordModel.path;
//    fujianOpenViewController.fileName = fileRecordModel.fileRealName;
//
//    [self presentViewController:fujianOpenViewController animated:YES completion:nil];
    
    //获取根VC
    JPShopCarController *VC =  (JPShopCarController *)self.parentViewController.parentViewController;
    
    if (self.SelectedDataArray.count) {
        FilePickAllTypeModel *model =  self.SelectedDataArray[indexPath.row];
        if (model.isSelected) {
            model.isSelected = NO;
            //删除数据到根视图
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
                model.filePath = [self getTempFilePath:model.filePath];
            //标记状态
            model.isSelected = YES;
            //添加数据到根视图
            [VC.allSelectedDataArray addObject:model];
        }
    }
    //更新根VC选中数据
    [VC updateSendData];
    
    //刷新当前UI
    [self.allTableView reloadData];
    
}

//拷贝一份到临时路径
- (NSString *)getTempFilePath:(NSString *)path
{
    NSString *filePath;
    //拷贝一份到临时路径
    NSString*tmpDir = NSTemporaryDirectory();/* tem目录*/
    NSString *timeChuoWithName = [NSString stringWithFormat:@"%@%@",[self createTimestamp],path.lastPathComponent];
    filePath = [tmpDir stringByAppendingPathComponent:timeChuoWithName];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    NSError *error;
    [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
    return filePath;
}

//生成时间戳
- (NSString *)createTimestamp {
    NSDate *datenow=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    return [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
}

//无数据UI
- (void) getNoDataUI:(NSMutableArray *)fujianDataArray{
    //无数据UI
    if (fujianDataArray.count == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-150, 200, 20)];
        label.text = @"暂无数据";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:label];
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
