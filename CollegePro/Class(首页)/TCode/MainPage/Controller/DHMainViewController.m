//
//  DHMainViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/7/27.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//
#include <ifaddrs.h>//MAC地址
#include <arpa/inet.h>//网络编程常见的头文件
#include <net/if.h>//配置ip地址,激活接口,配置MTU等接口信息
#import <mach/mach_time.h>
#import <DKNightVersion/DKNightVersion.h>
#include "WTTestC.h"
#import "WTTestObject.h"
#import "DHMainViewController.h"
#import "MeasurNetTools.h"
#import "QBTools.h"
#import "UIColor+Expanded.h"
#import "CollegePro-Swift.h"
#import "UIViewController+topmost.h"
#import <CoreLocation/CoreLocation.h>//定位
#import <MapKit/MapKit.h>//系统地图
#import <CoreMotion/CoreMotion.h>//提供实时的加速度值和旋转速度值,方向以及其他和方位或者位置有关的参数,
#import <AVFoundation/AVFoundation.h>//音视频
#import "ViewController.h"//主页
#import "THomeCollectionViewCell.h"//主页列表样式
//#import "GKHScanQCodeViewController.h"//二维码
//功能展示
//#import "T3DTouchViewController.h"//3DTouch
//#import "ContentOffSetVC.h"//滑动
//#import "LSTabBarViewController.h"//四个菜单栏
//#import "LBTabBarTextController.h"//中间突起的菜单栏
//#import "SignatureViewController.h"//签名
//#import "ZLDashboardViewController.h"//动画
//#import "ActionViewController.h"//咖啡机动画
//#import "TMotionViewController.h"//碰撞球
//#import "TShopAnimationViewController.h"//购物车动画
//#import "TSidebarViewController.h"//侧边栏
//#import "TGuideMViewController.h"//引导页
//#import "DHNoteViewController.h"//节点
//#import "DHZanViewController.h"//点赞
//#import "ScrollImageViewViewController.h"
//#import "DHImagePickerViewController.h"//高级定制添加图片
//#import "HealthViewController.h"//获取健康步数
//#import "PayViewController.h"//支付密码
//#import "NetTestViewController.h"//网络测试
//#import "CountdownViewController.h"//倒计时
//#import "SubparagraphRootViewController.h"//菜单栏
//#import "DropViewController.h"//拖拽
//#import "ScrollViewController.h"//滚动
//#import "WXPaoPaoViewController.h"//微信气泡聊天
//#import "BaseAdressBookViewController.h"//通讯刘
//#import "ShowViewController.h"//弹出框
//#import "QQListViewController.h"//仿照QQ列表
//#import "DisassemblyViewController.h"//手势解锁
//#import "ACEViewController.h"//textView自适应高度变化
//#import "DHNoteJoyViewController.h"//记事本
//#import "WaveProgressViewController.h"//水波动画
//#import "RoppleViewController.h"//水波动画
//#import "iCloudViewController.h"//获取iCloud文件
//#import "CustomKeyBoardViewController.h"//键盘
//#import "TRViewController.h"//闹铃
//#import "SmoothLineViewController.h"//画画板
//#import "Menu.h"//联网游戏XIB
//#import "IndexViewController.h"//苏宁小出、
//#import "AdaptionListViewController.h"//自适应列表
//#import "SectionsViewController.h"//铃声
//#import "MVPViewController.h"//MVP&MVVP架构
//#import "MVVMViewController.h"
//#import "CustomCollectionViewController.h"//长按拖动collectioncell
//#import "TurntableViewController.h"//转盘
//#import "MenuViewController.h"//storyboard
//#import "ExpandTableVC.h"//点击按钮出现下拉列表
//#import "CornerViewController.h"//圆角设置
//#import "DHMonthListlinkViewController.h"//日历
//#import "SlideMenuViewController.h"//侧边栏
//#import "JPShopCarController.h"//购物车
//#import "FFKPViewController.h"//图片找不同
//#import "IndexViewController.h"//消消乐
//#import "LuckyMainViewController.h"//抽奖
//#import "PhotoClipViewController.h"//图片裁剪
//#import "ScrollChangeViewController.h"//滑动切换控制器
//#import "LHCameraViewController.h"//水印相机
//#import "ShowcaseFilterListController.h"//图片滤镜处理
//#import "ActivityIndicator.h"//指示器
//#import "CodeViewController.h"//卡片
//#import "CardAnimateViewController.h"//卡片
//#import "DivisionCircleViewController.h"//表盘
//#import "CreditNumViewController.h"//分值表
//#import "IndicatorCrViewController.h"//分值表
//#import "MyRectangleViewController.h"//分值表
//#import "ThreeDimensionalSphericalLayout.h"//三维球型
//#import "MatrixDimensionalViewController.h"//三维球相册
//#import "anitimalViewController.h"//仪表
//#import "LabelMethodBlockVC.h"
//#import "LabelMethodBlockSubVC.h"
//#import "CardViewController.h"
//#import "IDCardViewController.h"
//#import "BankCardViewController.h"//信用卡识别
//#import "BankCartViewController.h"//银行卡扫描
//#import "DocumentViewController.h"//文档
//#import "AliRTCViewController.h"

@interface DHMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAccelerometerDelegate,AVAudioPlayerDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate>{
    NSMutableArray *valueArr;
    UICollectionView *_collectionView;
    UILabel *_lb_showinfo;
    //测试
    NSTimer *timer;
    UILabel  *displayLabel;//提示语
    CLLocationCoordinate2D _currentLocationCoordinate;
}
//定位信息
@property(nonatomic,strong)CLLocationManager * locationManager;
@property(nonatomic,strong)MKPointAnnotation * annotation;
@property(nonatomic,strong)MKMapView * mapView;
@property (nonatomic,strong) CLGeocoder * geocoder;
@property(nonatomic,strong)AVAudioPlayer * audioPlayer;
//指针imageView
@property (nonatomic,strong) UIImageView * pointImageView;
//信号强度
@property (nonatomic,assign) float signalStrength;
//上行速度
@property (nonatomic,assign) float upstreamSpeed;
@property (nonatomic, strong) CMMotionManager *mgr; // 保证不死
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic ,strong) NSMutableArray *assets;//图片集合
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
///搜索功能
@property(nonatomic,strong)NSArray *tableData;
@property(nonatomic,strong)NSMutableArray *requltData;
@property(nonatomic,strong)NSArray *tableIndexData;
@property(nonatomic,strong)NSMutableArray *requltIndexData;
@property(nonatomic,assign)BOOL searchActive;
///搜索功能

@end

@implementation DHMainViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
//int main(int argc, const char * argv[]) {
//    @autoreleasepool {
//        [Person test];
//    }
//    return 0;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[DKNightVersionManager dk_manager] dawnComing];
    [[DKNightVersionManager dk_manager] nightFalling];
    //方法二
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    uint64_t start = mach_absolute_time();
    //方法一
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    [self setUPUI];
    self.isShowleftBtn = YES;
    printfHelloWord(); //此即为上面C文件的方法u
    WTTestObject *family = [WTTestObject new];
    [family addTommy];
    [family addLily];
    [family everyBodySayHello];

    //    [self createMap];
    //    applicationWillEnterForeground
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveHMethod:) name:@"applicationWillEnterForeground" object:nil];
    //    [self playVoiceBackground];
    CGFloat c = sqrt( pow(2, 3));
    NSLog(@"%.2f",c);
    [UIColor colorWithRGBHex:12];
    // 监听有物品靠近还是离开
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange) name:UIDeviceProximityStateDidChangeNotification object:nil];
//    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    //网络测速
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getinternet) userInfo:nil repeats:YES];
    [timer fireDate];
    //方法一
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"一方法耗时: %f ms", endTime * 1000.0);
    //方法二
    uint64_t end = mach_absolute_time();
    uint64_t cost = (end - start) * timebase.numer / timebase.denom;
    NSLog(@"二方法耗时: %f ms",(CGFloat)cost / NSEC_PER_SEC * 1000.0);
    NSLog(@"ceshi 内存 %@-%f-%f",[DHTool freeDiskSpace],[DHTool freeMemory],[DHTool appUsedMemory]);
//648953856-280.953125-176.453125
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //移除距离感应通知
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    [timer invalidate];
    timer = nil;
}
- (void)createMap{
    //请求定位服务
    self.locationManager = [[CLLocationManager alloc]init];
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    CGRect rect=[UIScreen mainScreen].bounds;
    self.mapView = [[MKMapView alloc]initWithFrame:rect];
    //设置地图类型
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    //缩放程度
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta=0.00001;
    theSpan.longitudeDelta=0.00001;
    //  定义一个区域（用定义的经纬度和范围来定义）
    MKCoordinateRegion theRegion;
    theRegion.span=theSpan;
    [self.mapView setRegion:theRegion];
    //设置代理
    self.mapView.delegate = self;
    self.mapView.zoomEnabled = YES;
    self.mapView.showsUserLocation = YES;//显示当前位置
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.scrollEnabled = YES;
    //是否显示建筑物
    self.mapView.showsBuildings = YES;
    //是否可以旋转
    self.mapView.rotateEnabled = NO;

    [self.view addSubview:self.mapView];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 5;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [_locationManager requestWhenInUseAuthorization];
}
- (void)setUPUI{
    //提示语
    displayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, DH_DeviceHeight, DH_DeviceWidth, 40)];
    displayLabel.backgroundColor = [UIColor colorWithRed:0.962 green:0.971 blue:1.000 alpha:1.000];
    displayLabel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    displayLabel.layer.shadowOffset = CGSizeMake(0, -5);
    displayLabel.layer.shadowOpacity = 0.5;
    displayLabel.layer.shadowRadius= 4;
    displayLabel.textColor = [UIColor blackColor];
    displayLabel.hidden = YES;
    displayLabel.lineBreakMode = NSLineBreakByWordWrapping;
    displayLabel.numberOfLines = 0;
//    [DHTool setBorderWithView:displayLabel top:NO left:NO bottom:NO right:YES borderColor:[UIColor clearColor] borderWidth:0 otherBorderWidth:1 topColor:[UIColor redColor] leftColor:[UIColor orangeColor] bottomColor:[UIColor grayColor] rightColor:[UIColor blueColor]];
    [self.view addSubview:displayLabel];
    [[UIApplication sharedApplication].keyWindow addSubview:displayLabel];
    //    self.navigationController.navigationBar.barTintColor = IWColor(255,155,0);
    //    //设置导航条的背景色
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    flowLayout.minimumLineSpacing = 0.0;//minimumLineSpacing cell上下之间的距离
    //    flowLayout.minimumInteritemSpacing = 5.0;//cell左右之间的距离
    //    flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 20);
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, DH_DeviceWidth-30, DH_DeviceHeight-64-34-64) collectionViewLayout:flowLayout];
    //    _collectionView=[[UICollectionView alloc] init];
    //    _collectionView.collectionViewLayout = flowLayout;
    //注册Cell，必须要有
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    [_collectionView registerClass:[THomeCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([THomeCollectionViewCell class])];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.with.right.equalTo(self.view);
//        make.height.offset(25);
    }];
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
#pragma mark -跳转页面
    [self addCell:@"上下滑动" class:@"ContentOffSetVC"];
    [self addCell:@"二维码" class:@"GKHScanQCodeViewController"];
    [self addCell:@"凸起菜单栏" class:@"LBTabBarTextController"];
    [self addCell:@"导航栏" class:@"LSTabBarViewController"];
    [self addCell:@"签名" class:@"SignatureViewController"];
    [self addCell:@"画板" class:@"SmoothLineViewController"];
    [self addCell:@"动画" class:@"ZLDashboardViewController"];
    [self addCell:@"咖啡机" class:@"ActionViewController"];
    [self addCell:@"碰撞球" class:@"TMotionViewController"];
    [self addCell:@"侧边栏" class:@"TSidebarViewController"];
    [self addCell:@"图片滚动" class:@"ScrollImageViewViewController"];
    [self addCell:@"添加图片" class:@"DHImagePickerViewController"];
    [self addCell:@"贝塞尔曲线" class:@"ScrollImageViewViewController"];
    [self addCell:@"支付密码框" class:@"PayViewController"];
    [self addCell:@"倒计时" class:@"CountdownViewController"];
    [self addCell:@"菜单栏" class:@"SubparagraphRootViewController"];
    [self addCell:@"键盘" class:@"CustomKeyBoardViewController"];
    [self addCell:@"拖拽" class:@"DropViewController"];
    [self addCell:@"小游戏" class:@"ScrollViewController"];
    [self addCell:@"微信气泡聊天" class:@"WXPaoPaoViewController"];
    [self addCell:@"通讯录" class:@"BaseAdressBookViewController"];
    [self addCell:@"弹出框" class:@"ShowViewController"];
    [self addCell:@"QQ联系人" class:@"QQListViewController"];
    [self addCell:@"3DTouch" class:@"T3DTouchViewController"];
    [self addCell:@"点赞" class:@"DHZanViewController"];

    //    [self addCell:@"身份证" class:@"IDCardViewController"];
    //    [self addCell:@"信用卡识别" class:@"BankCardViewController"];
    //    [self addCell:@"银行卡识别" class:@"BankCartViewController"];
    //    [self addCell:@"身份证识别" class:@"XLIDScanViewController"];
    [self addCell:@"MVP" class:@"MVPViewController"];
    [self addCell:@"MVVM" class:@"MVVMViewController"];
    [self addCell:@"手势解锁" class:@"DisassemblyViewController"];
    [self addCell:@"CEll自适应高度" class:@"ACEViewController"];
    [self addCell:@"记事本" class:@"DHNoteJoyViewController"];
    [self addCell:@"水波动画" class:@"WaveProgressViewController"];
    [self addCell:@"水波按钮" class:@"RoppleViewController"];
    [self addCell:@"游戏" class:@"IndexViewController"];
    [self addCell:@"自适应列表" class:@"AdaptionListViewController"];
    [self addCell:@"铃声" class:@"SectionsViewController"];
    [self addCell:@"闹铃" class:@"TRViewController"];
    [self addCell:@"托拽排序" class:@"CustomCollectionViewController"];
    [self addCell:@"storyboard" class:@"MenuViewController"];
    [self addCell:@"转盘" class:@"TurntableViewController"];
    [self addCell:@"联网游戏" class:@"Menu"];
    [self addCell:@"下拉列表" class:@"DHRefreshViewController"];//@"ExpandTableVC"];
    [self addCell:@"网络测试" class:@"NetTestViewController"];
    [self addCell:@"网速测试" class:@"NetworkSpeedViewController"];
    [self addCell:@"MethodBlock" class:@"LabelMethodBlockVC"];
    [self addCell:@"MethodBlockS" class:@"LabelMethodBlockSubVC"];
    [self addCell:@"布局知识" class:@"TShopAnimationViewController"];
    [self addCell:@"文档" class:@"DocumentViewController"];
    [self addCell:@"iCloud文件" class:@"iCloudViewController"];
    [self addCell:@"获取健康信息" class:@"HealthViewController"];
    [self addCell:@"圆角设置" class:@"CornerViewController"];
    [self addCell:@"日历" class:@"DHMonthListlinkViewController"];
    [self addCell:@"美食菜单" class:@"FoodListViewController"];
    [self addCell:@"富文本" class:@"CViewController"];
    [self addCell:@"侧边栏" class:@"SlideMenuViewController"];
    [self addCell:@"视频转音频" class:@"JPShopCarController"];
    [self addCell:@"图片找不同" class:@"FFKPViewController"];
    [self addCell:@"消消乐" class:@"IndexViewController"];
    [self addCell:@"抽奖" class:@"LuckyMainViewController"];
    [self addCell:@"图片裁剪" class:@"PhotoClipViewController"];
    [self addCell:@"滚动控制器" class:@"ScrollChangeViewController"];
    [self addCell:@"水印相机" class:@"LHCameraViewController"];
    [self addCell:@"图片滤镜处理" class:@"ShowcaseFilterListController"];
    [self addCell:@"指示器转载" class:@"ActivityIndicator"];
    [self addCell:@"卡片" class:@"CodeViewController"];
    [self addCell:@"卡片" class:@"CardAnimateViewController"];
    [self addCell:@"表盘" class:@"DivisionCircleViewController"];
    [self addCell:@"三维球" class:@"ThreeDimensionalSphericalLayout"];
    [self addCell:@"分值表" class:@"CreditNumViewController"];
    [self addCell:@"分值表" class:@"IndicatorCrViewController"];
    [self addCell:@"圆环" class:@"anitimalViewController"];
    [self addCell:@"分值表" class:@"MyRectangleViewController"];
    [self addCell:@"三维球相册" class:@"MatrixDimensionalViewController"];
    [self addCell:@"变换矩阵" class:@"DBSphereViewController"];
    [self addCell:@"蓝牙" class:@"BlueToothViewController"];
    [self addCell:@"WK交互" class:@"WKWebViewController"];
    [_collectionView reloadData];
    //它的本质就是建立了CATransaction这个事务上
//    [_collectionView beginUpdates];
//    // do some work
//    [_collectionView endUpdates];
#pragma mark- 底部网络状态显示
    _lb_showinfo = [[UILabel alloc]init];
    _lb_showinfo.backgroundColor = [UIColor brownColor];
    _lb_showinfo.textColor = [UIColor redColor];
    _lb_showinfo.font = DH_FontSize(12);
    _lb_showinfo.layer.borderColor = [UIColor redColor].CGColor;
    _lb_showinfo.layer.borderWidth = 1.0;
//    _lb_showinfo.frame = CGRectMake(0, DH_DeviceHeight, DH_DeviceWidth, 25);
//    [self.view addSubview:_lb_showinfo];
//    [_lb_showinfo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view);
//        make.left.with.right.equalTo(self.view);
//        make.height.offset(25);
//    }];
//    _lb_showinfo.text = [self getSignalStrength];
}

/**
 将传进来的数据模型分组并排序  分成若干个分组  每个分组也进行排序 并删除分组中为空的分组

 @param objects 初始的对象数组
 @param selector 属性名称
 @param empty 清空与否
 @return 返回一个大数组 数组中是小数组  小数组中存储模型对象
 */
-(NSArray *)groupingSortingWithObjects:(NSArray *)objects withSelector:(SEL)selector isEmptyArray:(BOOL)empty{
    
    //UILocalizedIndexedCollation的分组排序建立在对对象的操作之上
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得到collation索引数量（26个字母和1个#）
    NSMutableArray *indexArray = [NSMutableArray arrayWithArray:collation.sectionTitles];
    NSUInteger sectionNumber = [indexArray count];//sectionNumber = 27
    
    //建立每个section数组
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:sectionNumber];
    for (int index = 0; index < sectionNumber; index++) {
        NSMutableArray *subArray = [NSMutableArray array];
        [sectionArray addObject:subArray];
    }
    
//    for (PersonData *model in objects) {
//        //根绝SEL方法返回的字符串判断对象应该处于哪个分区
//        //将每个人按name分到某个section下
//        NSInteger index = [collation sectionForObject:model collationStringSelector:selector];//获取name属性的值所在的位置，比如“林”首字母是L,则就把林放在L组中
//        NSMutableArray *tempArray = sectionArray[index];
//        [tempArray addObject:model];
//    }
    
    //对每个section中的数组按照name属性排序
    for (NSMutableArray *arr in sectionArray) {
        NSArray *sortArr = [collation sortedArrayFromArray:arr collationStringSelector:selector];
        [arr removeAllObjects];
        [arr addObjectsFromArray:sortArr];
    }
    
    //是不是删除空数组
    if (empty) {
        [sectionArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.count == 0) {
                [sectionArray removeObjectAtIndex:idx];
                [indexArray removeObjectAtIndex:idx];
            }
        }];
    }
    //第一个数组为tableView的数据源  第二个数组为索引数组 A B C......
    return @[sectionArray,indexArray];
}



- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}
#pragma mark -- UICollectionViewDataSource
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _titles.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    static NSString * CellIdentifier = @"THomeCollectionViewCell";
    THomeCollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THomeCollectionViewCell class]) forIndexPath:indexPath];
    _cell.imageName = @"Facebook";
    //    _cell.layer.shouldRasterize = YES;
    //    _cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _cell.title = indexPath.row>9?[NSString stringWithFormat:@"%ld_%@",(long)indexPath.row,_titles[indexPath.row]]:[NSString stringWithFormat:@"0%ld_%@",(long)indexPath.row,_titles[indexPath.row]];
    _cell.layer.borderColor = DHColorHex(@"#cde6fe").CGColor;
    _cell.layer.borderWidth = 1.0;
    _cell.layer.cornerRadius = 5.0;
    return _cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_collectionView deselectItemAtIndexPath:indexPath animated:NO];
    //动态加载控制器
//    NSDictionary *parameter =  @{
//                                 @"className":@"BViewController",
//                                 @"propertys":@{
//                                         @"headimg":@"开始",
//                                         @"username":@"结束"
//                                         },
//                                 @"method":@"changesFame:"
//                                 };
//
//    Class class = NSClassFromString(parameter[@"className"]);
//    UIViewController *classVC = [[class alloc] init];
//    NSDictionary *paramete = parameter[@"propertys"];
//    [paramete enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        // 在属性赋值时，做容错处理，防止因为后台数据导致的异常
//        if ([classVC respondsToSelector:NSSelectorFromString(key)]) {
//            [classVC setValue:obj forKey:key];
//        }
//    }];
//    // 从字典中获取方法名，并调用对应的方法
//    SEL selector = NSSelectorFromString(parameter[@"method"]);
//    [classVC  performSelector:selector];
    NSString *className = self.classNames[indexPath.row];
    UIViewController *controller = [[NSClassFromString(className) alloc]initWithNibName:className bundle:nil];
    if ([className isEqualToString:@"SubparagraphRootViewController"]) {
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
//        navController.navigationBarHidden = YES;
//        [UIApplication sharedApplication].keyWindow.rootViewController = navController;
        return;
    }
    //storyboard
    if ([className isEqualToString:@"MenuViewController"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SliderMainStoryboard" bundle:[NSBundle mainBundle]];
        pushVC([storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"]);
        return;
    }
    if ([className isEqualToString:@"BlueToothViewController"]) {
        // 使用Swift的类
        present(controller);
    }
    /*
     NSURL *appBUrl = [NSURL URLWithString:@"mqqOpensdkSSoLogin://"];
     // 2.判断手机中是否安装了对应程序 参考 http://www.cnblogs.com/isItOk/p/4869499.html
     if ([[UIApplication sharedApplication] canOpenURL:appBUrl]) {
     // 3. 打开应用程序App-B
     [[UIApplication sharedApplication] openURL:appBUrl];
     } else {
     NSLog(@"没有安装");
     }
     */
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        pushVC(ctrl);
    }
    /* //ios 13
     [AppDelegate sharedAppDelegate].rootTabbar = [[RootViewController alloc]init];
     [AppDelegate sharedAppDelegate].rootTabbar.modalPresentationStyle = UIModalPresentationFullScreen;
     [self presentViewController:[AppDelegate sharedAppDelegate].rootTabbar animated:YES completion:^{
      }];
     */
}
//l多少列
#define BRANDSECTION 4
//每列间距
#define BRANDDEV 10
//item 宽度
#define LISTCELLWIDTH (DH_DeviceWidth - (BRANDSECTION + 1) * BRANDDEV)/BRANDSECTION
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小(cell的宽高)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat width = ((self.view.frame.size.width-15)/5);//间隙
    return CGSizeMake(LISTCELLWIDTH,LISTCELLWIDTH+10);
}
////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10, 15, 10, 15);//(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
//}
//minimumLineSpacing 上下item之间的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 5;
}
//minimumInteritemSpacing 左右item之间的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return 5;
}
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
}
- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
}
- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
}
- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return CGSizeZero;
}
- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
}
- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
}
- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator  API_AVAILABLE(ios(9.0)){
}
- (void)setNeedsFocusUpdate {
}
-(BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context  API_AVAILABLE(ios(9.0)){
    return YES;
}
#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
//            weakSelf.addressString = placemark.name;
            NSLog(@"---%@---%@---%@---%@---%@---%@---%@---%@---%@---%@---%@",placemark.name,placemark.thoroughfare,placemark.subThoroughfare,placemark.locality,placemark.subLocality,placemark.administrativeArea,placemark.ISOcountryCode,placemark.country,placemark.inlandWater,placemark.ocean,placemark.addressDictionary);
            [self removeToLocation:userLocation.coordinate];
        }
    }];
}
- (void)removeToLocation:(CLLocationCoordinate2D)locationCoordinate{
    _currentLocationCoordinate = locationCoordinate;
    float zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(_currentLocationCoordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    CLLocation * tapLocation = [[CLLocation alloc] initWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
    //根据经纬度反向地理编译出地址信息
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:tapLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0){
            CLPlacemark * placemark = placemarks.lastObject;
            NSDictionary *address = [placemark addressDictionary];
            //City（市） Country(国家)  CountryCode（） FormattedAddressLines（）   Name（）  State(省)  Street(路) SubLocality(区县)  Thoroughfare（）
            NSLog(@"15779938054  18624617204 address %@",address.allKeys);
        }
    }];
    [self createAnnotationWithCoords:_currentLocationCoordinate];
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    if (error.code == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[error.userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey]
                                                           delegate:nil
                                                  cancelButtonTitle:NSEaseLocalizedString(@"ok", @"OK")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}
-(void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords{
    if (_annotation == nil) {
        _annotation = [[MKPointAnnotation alloc] init];
    }
    else{
        [_mapView removeAnnotation:_annotation];
    }
    _annotation.coordinate = coords;
    [_mapView addAnnotation:_annotation];
}
//- (void)GKHScanQCodeViewController:(GKHScanQCodeViewController *)lhScanQCodeViewController readerScanResult:(NSString *)result {
//    NSLog(@"GKHScanQCodeViewController---%@",result);
//}
- (void)updateFocusIfNeeded {
}
//后台播放声音
- (void)playVoiceBackground{
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^(void) {
        NSError *audioSessionError = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession setCategory:AVAudioSessionCategoryPlayback error:&audioSessionError]){
            NSLog(@"Successfully set the audio session.");
        } else {
            NSLog(@"Could not set the audio session");
        }
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath = [mainBundle pathForResource:@"noVoice" ofType:@"mp3"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        if (self.audioPlayer != nil){
            self.audioPlayer.delegate = self;
            [self.audioPlayer setNumberOfLoops:-1];
            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]){
                NSLog(@"Successfully started playing...");
            } else {
                NSLog(@"Failed to play.");
            }
        }
    });
}
- (void)receiveHMethod:(NSNotification *)notif{
    NSDictionary *dict = notif.userInfo;
    NSString*str_data= [dict valueForKey:@"dict"];
    NSLog(@"str_data %@",str_data);
    //    [self showHint:[NSString stringWithFormat:@"后台执行时间 %@",str_data] yOffset:10];
    [MBProgressHUD showWarnMessage:[NSString stringWithFormat:@"后台执行时间 %@",str_data]];
}
//- (id)transformedValue:(id)value﻿
//{﻿
//       double convertedValue = [value doubleValue];﻿
//       int multiplyFactor = 0;﻿
//       NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@“PB”, @“EB”, @“ZB”, @“YB”,nil];﻿
//       while (convertedValue > 1024) {﻿
//               convertedValue /= 1024;﻿
//               multiplyFactor++;﻿
//           }﻿
//       return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];﻿
//
//}
- (void)getinternet{
    MeasurNetTools * meaurNet = [[MeasurNetTools alloc] initWithblock:^(float speed) {
        //        NSString* speedStr = [NSString stringWithFormat:@"%@/S", [QBTools formattedFileSize:speed]];
//        _lb_showinfo.text = @"";
        NSLog(@"当前网速：%@",[DHTool getByteRate]);
        //获取wifi信息
        NSDictionary *WIFImessage = [DHTool fetchSSIDInfo];
        //检测手机网络速度
        NSMutableDictionary *WIFIspeed = [DHTool getDataCounters];
        NSLog(@"获取wifi信息 = %@ ------------- 检测手机网络速度 = %@",WIFImessage,WIFIspeed);
    } finishMeasureBlock:^(float speed) {
        NSUserDefaults* userDefault = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.dhTool.selfpro.CollegeProExtension"];
        NSString* speedStr = [NSString stringWithFormat:@"%@/S", [QBTools formattedFileSize:speed]];
        NSLog(@"平均速度为：%@",speedStr);
        NSLog(@"相当于带宽：%@",[QBTools formatBandWidth:speed]);
        _lb_showinfo.text = [NSString stringWithFormat:@"平均速度为： %@---相当带宽：(时间间隔里的传输速率:)%@--%@",speedStr,[QBTools formatBandWidth:speed],[DHTool getByteRate]];
        [userDefault setObject:[DHTool getByteRate] forKey:@"network"];
        [userDefault setObject:@"2我是数据" forKey:@"myShareData"];
        [userDefault synchronize];
        } failedBlock:^(NSError *error) {
        }];
    [meaurNet startMeasur];
}
- (CMMotionManager *)mgr{
    if (_mgr == nil) {
        _mgr = [[CMMotionManager alloc] init];
    }
    return _mgr;
}
- (BOOL)whetherConnectedNetwork
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    
    struct sockaddr_storage zeroAddress;//IP地址
    
    bzero(&zeroAddress, sizeof(zeroAddress));//将地址转换为0.0.0.0
    zeroAddress.ss_len = sizeof(zeroAddress);//地址长度
    zeroAddress.ss_family = AF_INET;//地址类型为UDP, TCP, etc.
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    //根据获得的连接标志进行判断
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
}
- (NSString *)getNetworkType {
    if (![self whetherConnectedNetwork]) return @"NONE";
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *type = @"NONE";
    for (id subview in subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    type = @"NONE";
                    break;
                case 1:
                    type = @"2G";
                    break;
                case 2:
                    type = @"3G";
                    break;
                case 3:
                    type = @"4G";
                    break;
                case 5:
                    type = @"WIFI";
                    break;
            }
        }
    }
    return type;
}
- (NSString *)getSignalStrength {
    if (![self whetherConnectedNetwork]) return @"";
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;
    NSString *signalStrength = @"";
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]] && [[self getNetworkType] isEqualToString:@"WIFI"] && ![[self getNetworkType] isEqualToString:@"NONE"]) {
            dataNetworkItemView = subview;
            signalStrength = [NSString stringWithFormat:@"%@dBm",[dataNetworkItemView valueForKey:@"_wifiStrengthRaw"]];
            break;
        }
        if ([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]] && ![[self getNetworkType] isEqualToString:@"WIFI"] && ![[self getNetworkType] isEqualToString:@"NONE"]) {
            dataNetworkItemView = subview;
            signalStrength = [NSString stringWithFormat:@"%@dBm",[dataNetworkItemView valueForKey:@"_signalStrengthRaw"]];
            break;
        }
    }
    return signalStrength;
}
- (void)developer{
    // 1.获取单例对象
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    // 2.设置代理
    accelerometer.delegate = self;
    // 3.设置采样间隔
    accelerometer.updateInterval = 0.3;
    // 1.判断加速计是否可用
    if (!self.mgr.isAccelerometerAvailable) {
        NSLog(@"加速计不可用");
        return;
    }
    // 2.设置采样间隔
    self.mgr.accelerometerUpdateInterval = 0.3;
    // 3.开始采样
    [self.mgr startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) { // 当采样到加速计信息时就会执行
        if (error) return;
        // 4.获取加速计信息
        //        CMAcceleration acceleration = self.mgr.accelerometerData.acceleration;
            CMAcceleration acceleration = accelerometerData.acceleration;
        NSLog(@"4/n获取加速计信息 x:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
                _lb_showinfo.text = [NSString stringWithFormat:@"获取的X:%.2f,获取的Y:%.2f,获取的Z:%.2f",acceleration.x, acceleration.y, acceleration.z];
            //        NSLog(@"速度:%@",[NSByteCountFormatter stringFromByteCount:[DHTool getInterfaceBytes] countStyle:NSByteCountFormatterCountStyleFile]);
        //
        //        NSLog(@"获取网速:%.4lld KB--网速是%@",[DHMainViewController getInterfaceBytes],[DHMainViewController getByteRate]);
        }];
    if (![CMPedometer isStepCountingAvailable]) {
        NSLog(@"计步器不可用");
        return;
    }
    CMPedometer *stepCounter = [[CMPedometer alloc] init];
    [stepCounter startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData *pedometerData, NSError *error) {
        if (error) return;
        // 4.获取采样数据
        NSLog(@"获取采样数据 = %@", pedometerData.numberOfSteps);
    }];
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [button setFrame:CGRectMake(100.0 ,100.0 ,100.0 ,40.0)];
    //    button.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜色
    //    [button setTitle:@"点击" forState:0];
    //    [button addTarget:self action:@selector(btnModelInCurrViewTouchupInside:) forControlEvents:(UIControlEventTouchUpInside)];
    //    [self.view addSubview:button];
    //
    //    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [button1 setFrame:CGRectMake(100.0 ,200.0 ,100.0 ,40.0)];
    //    [button1 setTitle:@"点击11" forState:0];
    //    button1.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜色
    //    [button1 addTarget:self action:@selector(cancelRun:) forControlEvents:(UIControlEventTouchUpInside)];
    //    [self.view addSubview:button1];
}
- (void)proximityStateDidChange{
    if ([UIDevice currentDevice].proximityState) {
        NSLog(@"有物品靠近");
    } else {
        NSLog(@"有物品离开");
    }
}
//- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
//{
//    NSLog(@"加速驾驶 /nx:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
//}
- (void)btnModelInCurrViewTouchupInside:(id)sender {
    [self performSelector:@selector(didRuninCurrModel:) withObject:[NSNumber numberWithBool:YES] afterDelay:3.0f];
    [self performSelector:@selector(didRuninCurrModelNoArgument) withObject:nil afterDelay:3.0f];
    NSLog(@"Test start....");
}
- (void)cancelRun:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didRuninCurrModel:) object:[NSNumber numberWithBool:YES]];//true
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didRuninCurrModel:) object:[NSNumber numberWithBool:NO]];//false
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didRuninCurrModel:) object:nil];//false
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didRuninCurrModelNoArgument) object:nil];//true
    [NSObject cancelPreviousPerformRequestsWithTarget:self];//all ok
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}
- (void)didRuninCurrModel:(NSNumber *)numFin{
    NSLog(@"- (void)didRuninCurrModel:%@", numFin.boolValue ? @"YES":@"NO");
}
- (void)didRuninCurrModelNoArgument{
    NSLog(@"- (void)didRuninCurrModelNoArgument");
}
//测试
- (void)showPromptlanguage:(NSString *)string{
    [UIView animateWithDuration:1.0 animations:^{
        displayLabel.text = string;
        displayLabel.hidden = NO;
            //自适应高度
        CGRect txtFrame = displayLabel.frame;
            displayLabel.frame = CGRectMake(0, DH_DeviceHeight, DH_DeviceWidth,
                                        txtFrame.size.height =[string boundingRectWithSize:
                                                               CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:displayLabel.font,NSFontAttributeName, nil] context:nil].size.height);
        NSLog(@"执行");
        } completion:^(BOOL finished) {
        timer = [NSTimer scheduledTimerWithTimeInterval:10.5f
                                                 target:self
                                               selector:@selector(hiddenDataPicker)
                                               userInfo:nil
                                                repeats:YES];
        [timer fire];
        NSLog(@"完成");
    }];
}
- (void)hiddenDataPicker{
    [UIView animateWithDuration:0.5 animations:^{
        displayLabel.frame = CGRectMake(0, DH_DeviceHeight, DH_DeviceWidth, 20);
        NSLog(@"执行隐藏");
    } completion:^(BOOL finished) {
        NSLog(@"执行完毕");
        [timer invalidate];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)receiveMessage:(NSNotification *)nof{
    NSDictionary *dict = nof.userInfo;
//    self.test = dict[@"content"];
}
-(void)dealloc{
    //移除距离感应通知
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}
@end

