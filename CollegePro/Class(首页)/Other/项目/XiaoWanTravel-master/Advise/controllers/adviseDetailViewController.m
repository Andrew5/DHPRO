//
//  adviseDetailViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/29.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "adviseDetailViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "PrefixHeader.pch"
#import "detailModel.h"
#import "MJExtension.h"
#import "SSZipArchive.h"
#import "UIImageView+WebCache.h"
#import "infoTableViewCell.h"
#import "authorsTableViewCell.h"
#import "relateTableViewCell.h"
#import "adviseHead.h"
#import "DownWebViewController.h"
@interface adviseDetailViewController ()<UITableViewDataSource,UITableViewDelegate,adviseHeadDelegate,NSURLSessionDownloadDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *relateArray;
@property(nonatomic,copy)NSString *info;
@property(nonatomic,copy)NSString *imagev;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,strong)NSMutableDictionary *DIC;
@property(nonatomic,assign)CGFloat H1;
@property(nonatomic,assign)CGFloat H2;//文字高度
@property(nonatomic,strong)MobileModel *mobile;
@property(nonatomic,strong)NSURLSession* session;//创建下载任务对象
@property(nonatomic,strong)NSData* data;//定义一个NSData类型的变量 接受下载下来的数据

@property(nonatomic,strong)NSURLSessionDownloadTask* task;
@property(nonatomic,strong)NSURLRequest* downloadrequest;//创建请求对象 NSURL

@property(nonatomic,strong)NSString* downPath;

@end

@implementation adviseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self createhead];
    
    
    [self createTableView];
    [self requestData];
    
}
-(void)btnLeftClick
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)requestData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:LATESTDETAIL,self.detailID] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        detailModel *model = [[detailModel alloc]mj_setKeyValues:rootDic];
        self.info = model.data.info;
        self.imagev = model.data.cover;
        self.time = model.data.cover_updatetime;
        NSLog(@"---%@",self.imagev);
        NSLog(@"=====%@",self.time);
        //self.dataArray = model.data.authors;
        self.DIC = model.data.authors[0];
        self.relateArray = model.data.related_guides;
        self.mobile = model.data.mobile;
        [self createhead];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"infoTableViewCell" bundle:nil] forCellReuseIdentifier:@"infoTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"authorsTableViewCell" bundle:nil] forCellReuseIdentifier:@"authorsTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"relateTableViewCell" bundle:nil] forCellReuseIdentifier:@"relateTableViewCell"];
    
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
        return _relateArray.count;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            infoTableViewCell * labelCell=[tableView dequeueReusableCellWithIdentifier:@"infoTableViewCell"];
            if (labelCell==nil) {
                labelCell=[[infoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoTableViewCell"];
            }
            labelCell.title.text=@"锦囊简介";
            labelCell.info.text=self.info;
            self.H1 = [labelCell.info.text boundingRectWithSize:CGSizeMake(Screen_Width - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size.height;
            return labelCell;
        }else{
            AuthorsModel *model = self.DIC;
            
            authorsTableViewCell * labelCell=[tableView dequeueReusableCellWithIdentifier:@"authorsTableViewCell"];
            if (labelCell==nil) {
                labelCell=[[authorsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"authorsTableViewCell"];
            }
            labelCell.name.text=@"锦囊作者";
            labelCell.authors.text = model.username;
            [labelCell.touxiang setImageWithURL:[NSURL URLWithString:model.avatar]];
            labelCell.touxiang.layer.cornerRadius = 25;
            labelCell.info.text= model.intro;
            self.H2 = [labelCell.info.text boundingRectWithSize:CGSizeMake(Screen_Width - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size.height;
            return labelCell;
        }
    }else{
            relateTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"relateTableViewCell"];
            if (cell==nil) {
                cell=[[relateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"relateTableViewCell"];
            }
            RelateModel *model = self.relateArray[indexPath.row];
            
            NSString* imageStr=[NSString stringWithFormat:@"%@/260_390.jpg?cover_updatetime=%@",model.cover,model.cover_updatetime];
            [cell.imageV setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:nil];
            cell.imageV.layer.cornerRadius = 5;
            cell.imageV.layer.masksToBounds = YES;
            cell.cname.text = [NSString stringWithFormat:@"%@/%@",model.cnname,model.enname];
            cell.ename.text = [NSString stringWithFormat:@"%@/%@",model.category_title,model.country_name_cn];
            if (model.download>10000) {
                cell.where.text=[NSString stringWithFormat:@"%ld万次下载",model.download/10000];
            }else{
                cell.where.text=[NSString stringWithFormat:@"%ld次下载",model.download];
            }
            long count= [model.update_time longLongValue];
            time_t it;
            it=(time_t)count;
            struct tm *local;
            local=localtime(&it);
            char buf[80];
            strftime(buf, 80, "%Y-%m-%d", local);
            cell.time.text=[NSString stringWithFormat:@"%s更新",buf];
            return cell;
    }
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        adviseDetailViewController* view=[[adviseDetailViewController alloc]init];
        RelateModel *model = self.relateArray[indexPath.row];
        NSString *url = [NSString stringWithFormat:@"%ld",model.ID];
        view.detailID = url;
        //[self.navigationController pushViewController:view animated:YES];
        [self presentViewController:view animated:YES completion:nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return (40+self.H1)*(Screen_Height/667.0);
        }else{
            return (85+self.H2)*(Screen_Height/667.0);
        }
    }else{
        
        return 140*(Screen_Height/667.0);
        
    }
    
}


#pragma mark 懒加载
//重写getter方法，用到的时候才初始化，经典的引用就是视图控制器的view

-(NSMutableArray *)relateArray
{
    if (_relateArray == nil) {
        _relateArray = [[NSMutableArray alloc]init];
    }
    return _relateArray;
}
-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)createhead
{
    adviseHead* Head=[[adviseHead alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 250)];
    NSString* imageStr=[NSString stringWithFormat:@"%@/670_420.jpg?cover_updatetime=%@",self.imagev,self.time];
    NSLog(@"%@",imageStr);
    [Head.imageHeader setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:nil];
    Head.delegate=self;
    //NSLog(@"%@",path);
    Head.tag=500;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 10, 50, 50);
    [button setImage:[UIImage imageNamed:@"login_close_icon@3x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnLeftClick) forControlEvents:UIControlEventTouchUpInside];
    [Head addSubview:button];
    
    self.downPath=[NSString stringWithFormat:@"%@?modified=%@",self.mobile.file,self.time];
    NSFileManager* manger=[NSFileManager defaultManager];
    NSString* filePath=[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),self.time];
    BOOL isExist= [manger fileExistsAtPath:filePath];
    if (isExist) {
        [Head.downlondBtn setTitle:@"打开" forState:UIControlStateNormal];
    }else{
        
    }
    _tableView.tableHeaderView = Head;
    //[_tableView reloadData];


}
#pragma mark 关于下载
-(void)downloandSleeve:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"下载"]) {
        adviseHead* Head=(id)[self.view viewWithTag:500];
        Head.progress.hidden=NO;
        NSLog(@"开始下载");
        [btn setImage:[UIImage imageNamed:@"icon_trip_download@3x"] forState:UIControlStateNormal];
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
        //<1>//创建NSURLSession的配置信息
        NSURLSessionConfiguration* configuration=[NSURLSessionConfiguration defaultSessionConfiguration];
        //<2>创建session对象 将配置信息与Session对象进行关联
        self.session=[NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        //<3>将路径准化成NSURL
        NSURL* url=[NSURL URLWithString:_downPath];
        //NSLog(@"%@",downPath);
        //<4>请求对象
        self.downloadrequest=[NSURLRequest requestWithURL:url];
        
        //<5>进行数据请求
        self.task= [_session downloadTaskWithRequest:_downloadrequest];
        //开始请求
        [_task resume];
    }else if([btn.titleLabel.text isEqualToString:@"暂停"]){
        [btn setTitle:@"继续" forState:UIControlStateNormal];
        //<>暂停
        [btn setImage:[UIImage imageNamed:@"icon_trip_download_pause@3x"] forState:UIControlStateSelected];
        [_task cancelByProducingResumeData:^(NSData *resumeData) {
            //resumData中存放的就是下载下来的数据
            _data= resumeData;
        }];
    }else if([btn.titleLabel.text isEqualToString:@"继续"]){
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_trip_download@3x"] forState:UIControlStateNormal];
        if (!_data) {
            NSURL* url=[NSURL URLWithString:_downPath];
            _downloadrequest=[NSURLRequest requestWithURL:url];
            _task=[_session downloadTaskWithRequest:_downloadrequest];
        }else{
            //继续下载
            _task= [_session downloadTaskWithResumeData:_data];
        }
        [_task resume];
    }else{
        //打开锦囊
        DownWebViewController *down = [[DownWebViewController alloc]init];
        down.url = self.time;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:down];
        [self presentViewController:nav animated:YES completion:nil];

    }
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    //    SleDetailHeaderView* sleDetailHeader=(id)[self.view viewWithTag:600];
    //<1>获取存放信息的路径
    //[NSHomeDirectory() stringByAppendingString:@"/aa.txt"]
    NSString* sleevepath=[NSString stringWithFormat:@"%@/%@.zip",NSHomeDirectory(),self.time];
    NSString* destinationPath=[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),self.time];
    
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath isDirectory:&isDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error: nil];
    }
    
    NSURL* url=[NSURL fileURLWithPath:sleevepath];
    //<2>通过文件管理对象将下载下来的文件路径移到URL路径下
    NSFileManager* manager=[NSFileManager defaultManager];
    [manager moveItemAtURL:location toURL:url error:nil];
    [SSZipArchive unzipFileAtPath:sleevepath toDestination:destinationPath];
    [manager removeItemAtURL:url error:nil];
}
//获取下载进度
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    //totalBytesWritten此时下载的二进制数据大小（进度）  totalBytesExpectedToWrite预期下载量
    CGFloat progress=(totalBytesWritten* 1.0)/totalBytesExpectedToWrite;
    //修改主线成
    dispatch_async(dispatch_get_main_queue(), ^{
        adviseHead* Head=(id)[self.view viewWithTag:500];
        Head.progress.progress=progress;
        if (progress==1.0) {
            [Head.downlondBtn setTitle:@"打开" forState:UIControlStateNormal];
            Head.progress.hidden=YES;
        }
    });
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
