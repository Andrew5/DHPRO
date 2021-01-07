//
//  TodayViewController.m
//  CollegeProWidge
//
//  Created by admin on 2020/8/5.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "DHTool.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <sys/mount.h>
#import "TodayTableHeaderView.h"
#import "TodayItemCell.h"
#import "TodayItemModel.h"
#import "MeasurNetTools.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import <CoreTelephony/CTCarrier.h>

#import <UIKit/UIKit.h>


@interface TodayViewController () <NCWidgetProviding, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong) UILabel *textLabel;
@property(nonatomic,strong) UILabel *labelNet;
@property(nonatomic,strong) UILabel *labelTitleName;
@property(nonatomic,strong) UILabel *labelUsedMemory;
@property (nonatomic, strong) UIImageView *progressImg;
@property (nonatomic, strong) UIImageView *trackImg;
/// 空间所剩标签展示
@property (nonatomic, strong) UILabel *progressLable;

@property(nonatomic,strong) UIView *subView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) float fileSystemSize;
@property (nonatomic, assign) float freeSize;
@property (nonatomic, assign) unsigned long long usedSize;
@property (nonatomic, assign) double usedRate;
@property (nonatomic, assign) CTTelephonyNetworkInfo *networkInfo;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 将小组件的展现模式设置为可展开 ”展开120=40 headview330=110  4x209+539=458“
    if (@available(iOS 10.0, *)) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
    [self.view addSubview:self.progressLable];
    [self.view addSubview:self.progressImg];
    [self.view addSubview:self.trackImg];
    [self.view addSubview:self.progressLable];
    //设置extension的size
    //    self.preferredContentSize = CGSizeMake(0, 80);
    [self.view addSubview:self.tableView];
    //    [self.view addSubview:self.labelTitleName];
    [self.view addSubview:self.labelUsedMemory];
    [self.view addSubview:self.labelNet];
    //    _labelUsedMemory.text = [NSString stringWithFormat:@"设备容量:%@",[DHTool diskSpaceType]];
    [self loadSpaceWishFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 20)];
    self.progressImg.image     = [self createImageWithColor:[UIColor greenColor]];
    self.trackImg.image        = [self createImageWithColor:[UIColor grayColor]];
    //        _labelTitleName.text = [NSString stringWithFormat:@"%.2f,%.2f,%.2f,%.2llu,%.2lld,%.2lld",self.fileSystemSize,self.usedRate,self.freeSize,self.usedSize,[self memoryUsage],[self diskMemory]];
    
    NSString *urlString = [NSString stringWithFormat:@"CollegeProTodayExtensionDemo://set/markCode=%@&code=%@&yesclose=%@&stockName=%@",@"10200",@"200",@"YES",[@"高晨阳" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSArray * array = @[
        @{@"icon":@"bangzhu",
          @"handerUrl":@"CollegeProTodayExtensionDemo://message",
          @"title":@"消息"},
        @{@"icon":@"fankui",
          @"handerUrl":@"CollegeProTodayExtensionDemo://adress",
          @"title":@"地址管理"},
        @{@"icon":@"gerenxinxi",
          @"handerUrl":@"CollegeProTodayExtensionDemo://work",
          @"title":@"工作"},
        @{@"icon":@"kefu",
          @"handerUrl":@"CollegeProTodayExtensionDemo://my",
          @"title":@"我的"},
        @{@"icon":@"shezhi",
          @"handerUrl":urlString,
          @"title":@"设置"},
    ];
    for (NSDictionary * dic in  array) {
        TodayItemModel*manageModel = [TodayItemModel new];
        manageModel.icon =dic[@"icon"];
        manageModel.handerUrl = dic[@"handerUrl"];
        manageModel.titlename = dic[@"title"];
        [self.dataArray addObject:manageModel];
    }
    [self.tableView reloadData];
    //        NSUserDefaults *userDefault = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.dhTool.selfpro.CollegeProExtension"];
    //        NSString *t = [userDefault valueForKey:@"network"];
    //        self.labelNet.text = [NSString stringWithFormat:@"当前网速是：%@",t];
    [self getInternetSpeet];
}
- (void)getInternetSpeet{
    MeasurNetTools * meaurNet = [[MeasurNetTools alloc] initWithblock:^(float speed) {
        //        NSString* speedStr = [NSString stringWithFormat:@"%@/S", [QBTools formattedFileSize:speed]];
        //        _lb_showinfo.text = @"";
        NSLog(@"当前网速：%@",[DHTool getByteRate]);
        self.labelNet.text = [NSString stringWithFormat:@"当前网速是：%@",[DHTool getByteRate]];
        //获取wifi信息
        NSDictionary *WIFImessage = [DHTool fetchSSIDInfo];
        //检测手机网络速度
        NSMutableDictionary *WIFIspeed = [DHTool getDataCounters];
        NSLog(@"获取wifi信息 = %@ ------------- 检测手机网络速度 = %@",WIFImessage,WIFIspeed);
    } finishMeasureBlock:^(float speed) {
        //        NSUserDefaults* userDefault = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.dhTool.selfpro.CollegeProExtension"];
        //        NSString* speedStr = [NSString stringWithFormat:@"%@/S", [QBTools formattedFileSize:speed]];
        //        NSLog(@"平均速度为：%@",speedStr);
        //        NSLog(@"相当于带宽：%@",[QBTools formatBandWidth:speed]);
        //        _lb_showinfo.text = [NSString stringWithFormat:@"平均速度为： %@---相当带宽：(时间间隔里的传输速率:)%@--%@",speedStr,[QBTools formatBandWidth:speed],[DHTool getByteRate]];
        //        [userDefault setObject:[DHTool getByteRate] forKey:@"network"];
        //        [userDefault setObject:@"2我是数据" forKey:@"myShareData"];
        //        [userDefault synchronize];
    } failedBlock:^(NSError *error) {
    }];
    [meaurNet startMeasur];
}
#pragma mark- lazy
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击跳转到APP
    [self.extensionContext openURL:[NSURL URLWithString:@"CollegeProTodayExtensionDemo://enterApp"] completionHandler:nil];
}
#pragma mark - UITableViewDataSource
//有多少个section需要加载到table里
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodayItemCell *descriptioncell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TodayItemCell class])];
    if (descriptioncell == nil) {
        descriptioncell = [[TodayItemCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:NSStringFromClass([TodayItemCell class])];
    }
    TodayItemModel*manageModel = self.dataArray[indexPath.row];
    descriptioncell.model = manageModel;
    return descriptioncell;
}

#pragma mark - UITableViewDelegate
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView *headerView = [[TodayTableHeaderView alloc]init];
//
//    return headerView;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 110;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TodayItemModel * model = self.dataArray[indexPath.row];
    [self.extensionContext openURL:[NSURL URLWithString:model.handerUrl] completionHandler:nil];
    
    //    NSString *path = [NSString stringWithFormat:@"CollegeProExtension://%zd",indexPath.row];
    //    NSURL *url = [NSURL URLWithString:path];
    //    [self openContainingAPPWithURL:url];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)openContainingAPPWithURL:(NSURL *)URL {
    [self.extensionContext openURL:URL completionHandler:nil];
}

#pragma mark - NCWidgetProviding
-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize  API_AVAILABLE(ios(10.0)){
    //maxSize：
    //虽说是最大的Size，但苹果还是把Widget的高度范围限制在了[110 ~ maxSize]之间
    //如果设置高度小于110，那么default = 110;
    //如果设置高度大于开发者设置的preferredContentSize.Heiget，那么default = maxSize;
    //折叠状态下，苹果将高度固定为110，这个时候设置preferredContentSize属性无效。
    NSLog(@"width = %lf-------height = %lf",maxSize.width,maxSize.height);
    
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        // 设置展开的新高度
        self.preferredContentSize = CGSizeMake(0, 5*70.0+110.0);
    }else{
        self.preferredContentSize = maxSize;//系统默认的高度为110
    }
}
//数据更新时调用的方法 系统会定期更新扩展
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    // 取出数据
    NSString * myData = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.dhTool.selfpro.CollegeProExtension"] valueForKey:@"myShareData"];
    NSLog(@"草泥马的数据呢？ %@",myData);
    [self.tableView reloadData];
    completionHandler(NCUpdateResultNewData);
    
}
//设置扩展UI边距
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsZero;
}
- (void)updateSizes
{
    // Retrieve the dictionary with the attributes from NSFileManager
    NSDictionary *dict = [[NSFileManager defaultManager]
                          attributesOfFileSystemForPath:NSHomeDirectory()
                          error:nil];
    
    // Set the values
    self.fileSystemSize = [[dict valueForKey:NSFileSystemSize]
                           floatValue]/1024/1024/1024;//磁盘大小：%.2f GB
    self.freeSize       = [[dict valueForKey:NSFileSystemFreeSize]
                           floatValue]/1024/1024;//可用空间：%.2f MB
    self.usedSize       = self.fileSystemSize - self.freeSize;
}
- (int64_t)memoryUsage {
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        NSLog(@"Memory in use (in bytes): %lld", memoryUsageInByte);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    return memoryUsageInByte;
}
- (void)updateInterface
{
    //    double rate = self.usedRate; // retrieve the cached value
    //    self.percentLabel.text = [NSString stringWithFormat:@"%.1f%%", (rate * 100)];
    //    self.barView.progress = rate;
}
-(void)updateDetailsLabel
{
    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
    [formatter setCountStyle:NSByteCountFormatterCountStyleFile];
    
    //    self.detailsLabel.text =
    //    [NSString stringWithFormat:@"Used:\t%@\nFree:\t%@\nTotal:\t%@",
    //     [formatter stringFromByteCount:self.usedSize],
    //     [formatter stringFromByteCount:self.freeSize],
    //     [formatter stringFromByteCount:self.fileSystemSize]];
}
//硬盘容量

- (float)getTotalDiskSpace

{
    
    float totalSpace;
    
    NSError * error;
    
    NSDictionary * infoDic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[self getHomeDirectory] error: &error];
    
    if (infoDic) {
        
        NSNumber * fileSystemSizeInBytes = [infoDic objectForKey: NSFileSystemSize];
        
        totalSpace = [fileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
        
        return totalSpace;
        
    } else {
        
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
        
        return 0;
        
    }
    
}

- (NSString *)getHomeDirectory

{
    
    NSString * homePath = NSHomeDirectory();
    
    return homePath;
    
}

/*
 
 如何获取设备的总容量和可用容量
 
 */
/*
 {
 NSFileSystemFreeNodes = 312021030;
 NSFileSystemFreeSize = 8764469248;
 NSFileSystemNodes = 312294760;
 NSFileSystemNumber = 16777222;
 NSFileSystemSize = 31978983424;
 }
 */
+ (NSNumber *)totalDiskSpace{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

//总容量
- (long long)diskMemory{
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if(statfs("/private/var", &buf) >= 0){
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    return totalspace;
}
//
- (long long)freeMemory{
    struct statfs buf;
    long long freespace;
    freespace = 0;
    if(statfs("/private/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace;
}
// 获取当前设备可用内存(单位：MB）

- (double)availableMemory{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}
/**
 *  加载剩余空间
 */
- (void)loadSpaceWishFrame:(CGRect)frame{
    
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    //总空间
    float   space     =   [[fattributes objectForKey:NSFileSystemSize] floatValue];
    //所剩空间
    float   freespace =   [[fattributes objectForKey:NSFileSystemFreeSize] floatValue];
    
    
    float free_m  =  freespace / 1024 / 1024 / 1024;
    float space_m =  space / 1024 / 1024 / 1024;//局部总空间
    float proportion = free_m / space_m;
    
    
    self.progressImg.frame      = CGRectMake(0, 0,(1 - proportion) * frame.size.width, frame.size.height);
    self.trackImg.frame         = CGRectMake((1 - proportion) * frame.size.width , 0, [UIScreen mainScreen].bounds.size.width - (1 - proportion) * frame.size.width , frame.size.height);
    self.progressLable.text     = [NSString stringWithFormat:@"总空间%@G/剩余%.1fG",[DHTool diskSpaceType],free_m];
    self.progressLable.frame    = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, frame.size.height -2);
    
}
-(UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, 110, self.view.frame.size.width-8, 70*5);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[TodayItemCell class] forCellReuseIdentifier:NSStringFromClass([TodayItemCell class])];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (UILabel *)labelTitleName {
    if (!_labelTitleName) {
        _labelTitleName = [[UILabel alloc]init];
        _labelTitleName.frame  =CGRectMake(10, 0, self.view.frame.size.width-10, 15);
        _labelTitleName.numberOfLines = 0;
        _labelTitleName.text = @"精灵球";
    }
    return _labelTitleName;
}
- (UILabel *)labelUsedMemory {
    if (!_labelUsedMemory) {
        _labelUsedMemory = [[UILabel alloc]init];
        _labelUsedMemory.numberOfLines = 2;
        _labelUsedMemory.frame  = CGRectMake(10, 20, 25*15, 40);
        //        [_labelUsedMemory sizeToFit];
    }
    return _labelUsedMemory;
}
- (UILabel *)labelNet {
    if (!_labelNet) {
        _labelNet = [[UILabel alloc]init];
        _labelNet.numberOfLines = 2;
        _labelNet.frame  = CGRectMake(10, 20, 15*15, 40);
    }
    return _labelNet;
}
- (UILabel *)progressLable{
    if (!_progressLable) {
        _progressLable         = [[UILabel alloc]init];
        _progressLable.font    = [UIFont systemFontOfSize:12];
        _progressLable.textColor =  [UIColor whiteColor];
        _progressLable.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLable;
}

- (UIImageView *)progressImg{
    if (!_progressImg) {
        _progressImg      = [[UIImageView alloc]init];
    }
    return _progressImg;
}
- (UIImageView *)trackImg{
    if (!_trackImg) {
        _trackImg         = [[UIImageView alloc]init];
    }
    return _trackImg;
}
@end
