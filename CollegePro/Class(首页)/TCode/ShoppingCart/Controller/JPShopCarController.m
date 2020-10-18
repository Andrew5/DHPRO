//
//  JPShopCarController.m
//  回家吧
//
//  Created by 王洋 on 16/3/25.
//  Copyright © 2016年 ubiProject. All rights reserved.
//

#import "JPShopCarController.h"
#import "JPShopCarCell.h"
#import "JPShopHeaderCell.h"
#import "JPCarModel.h"
#import "ZCAssetsPickerViewController.h"
#import "DHSystemFileViewController.h"
#import "DHAttachmentViewController.h"
#import "DHCollectFileViewController.h"

#import "SBApplicationController.h"
#import "SBApplication.h"

#import <CollageProExtensionKit/DHTool.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPVolumeView.h>
#import <Photos/Photos.h>
#import <objc/runtime.h>
#import <WebKit/WebKit.h>
#define TopsHight 50
#define segmentWide 130
#define segmentHeight 30
#define SubVCFrameY (TopsHight+segmentHeight+20)

@interface JPShopCarController ()<UITableViewDataSource,UITableViewDelegate,JPShopCarDelegate,ZCAssetsPickerViewControllerDelegate>
{
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    UIButton *u;
}
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *allBtn;

@property (nonatomic, assign) CGFloat totalPrice; // 所有选中的商品总价值
@property (nonatomic, strong) UILabel *labelVoice;
@property (nonatomic, strong) CALayer *layerVoice;
///自定义照片选择
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) DHSystemFileViewController *systemFileVC;
@property (nonatomic, strong) DHAttachmentViewController *attachmentVC;
@property (nonatomic, strong) DHCollectFileViewController *collectionVC;



@property (nonatomic, strong) UILabel *lblHelloWorld;

@end

@implementation JPShopCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频转音频";
//    [self setupTableView]; // tableView
//    [self createAllBtn];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"B206760E60639441A7876D27110082AC" ofType:@"MOV"];
//    [JPShopCarController videoChangeGetBackgroundMiusicWithVideoUrl:[NSURL fileURLWithPath:path] completion:nil];
//    [self getAppPlist];
//    [self createUI];
//    [self futext];
//    [self QNRTC];
//    [self createHello];
//    [self getLocalEquipmentAppList];
//    [self getiphone];
}
- (void)getiphone{
    NSMutableString *phoneNumber = [[NSMutableString alloc]initWithFormat:@"tel:%@",@"18510251335"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
- (void)getLocalEquipmentAppList{
//    Class LSApplicationWorkspace_class = NSClassFromString(@"LSApplicationWorkspace");
//    NSObject *workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
//    NSArray *arrAPP = [workspace performSelector:@selector(allApplications)];
//    NSLog(@"arrAPP: %@",arrAPP);
//    
////    SBApplicationController *sbApplicationCtrl=[SBApplicationController sharedInstance];
//    SBApplicationController *sbApplicationCtrl=%c(SBApplicationController) sharedInstance];
//    NSArray *appArray=[sbApplicationCtrl allApplications];
//    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
//    for(SBApplication *sbApp in appArray)
//    {
//        //根据提供的app的显示名称来查找其bundleindentity
////        NSString *appName = [userinfo valueForKeyPath:@"appName"];
////        NSString *displayName=[sbApp displayName];
////        if ([displayName isEqualToString:appName])
////        {
////            NSString *bundleIdentifier=[sbApp bundleIdentifier];
////            int dataUsage=[sbApp dataUsage];
////            NSNumber *number=[NSNumber numberWithInt:dataUsage];
////            [dic setObject:bundleIdentifier forKey:@"bundleIdentity"];
////            [dic setObject:number forKey:@"dataUsage"];
////            break;
////        }
//    }
    
}

- (void)createHello{
    self.lblHelloWorld = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 120, 50)];
    [self.lblHelloWorld setText:@"Hello World"];
    self.lblHelloWorld.backgroundColor = [UIColor orangeColor];
    self.lblHelloWorld.textColor = [UIColor redColor];
    self.lblHelloWorld.font = [UIFont systemFontOfSize:14];
    [self.lblHelloWorld setTextColor:[UIColor redColor]];
    [self.view addSubview:self.lblHelloWorld];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];button.frame = CGRectMake(100, 100, 80, 30);
    [button setTitle:self forState:(UIControlStateNormal)];
    [button.titleLabel setText:@"Hide"];
    [button addTarget:self action:@selector(doBtnHide) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}
- (void)doBtnHide:(id)sender{
    [self.lblHelloWorld setHidden:![self.lblHelloWorld isHidden]];
    [sender setTitle:[self.lblHelloWorld isHidden]?@"show":@"Hide"forState:UIControlStateNormal];
}

- (void)futext{

    //这个类主要用来做native与JavaScript的交互管理
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
    //JS调用OC 添加处理脚本
    [wkUController addScriptMessageHandler:self name:@"jsInvokeOCMethod"];
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = wkUController;
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.processPool = [[WKProcessPool alloc] init];
    // 设置偏好设置对象
    config.preferences = preference;
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    
    WKWebView *WKView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 10, DH_DeviceWidth-20, 200) configuration:config];
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    WKView.allowsBackForwardNavigationGestures = YES;
    WKView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    WKView.autoresizesSubviews = YES;
//    [self.view addSubview:WKView];
   
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"testHtml" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [WKView loadHTMLString:html baseURL:nil];

    
//    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"testHtml" ofType:@"html"];
//    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [WKView loadHTMLString:html baseURL:baseURL];
    
    //第三种方法： NSString类方法读取内容
    NSString* content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Text" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"NSString类方法读取的内容是：\n%@",content);
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, DH_DeviceWidth-20, 200)];
    label.attributedText = attributedString;
    label.numberOfLines = 0;
    [self.view addSubview:label];
}

//html  转 NSString
-(NSString*)getStrFormHtml:(NSString *)htmStr
{
    
    NSString * htmlString = htmStr;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = attrStr;
    label.numberOfLines = 0;
    label.font =[UIFont systemFontOfSize:11.0];
    return label.text;
}

- (void)createUI{
    //分段控件
    [self addSysSegmentView];
    //创建底部悬浮View
    [self createBottomView];
    //取消按钮
    [self addLeftBtn];
    //默认显示本机
    [self addSegmentChangeVCLocal];

//    NSString *path = [[NSBundle mainBundle] pathForResource:@"B206760E60639441A7876D27110082AC" ofType:@"MOV"];
//    [JPShopCarController videoChangeGetBackgroundMiusicWithVideoUrl:[NSURL fileURLWithPath:path] completion:nil];
}
- (void)addSysSegmentView{
    NSArray *segmentedArray = @[@"本机",@"附件",@"收藏"];//@"收藏"
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0, 0, segmentWide, segmentHeight);
    segmentedControl.centerX = [UIScreen mainScreen].bounds.size.width/2;
    
    // 设置默认选择项索引
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor blackColor];
    [segmentedControl addTarget:self action:@selector(didSegmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    self.segmentedControl = segmentedControl;
    
    self.selectMax = @"6";
    self.selectMaxSize = @"100";

}
- (void)didSegmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %ld", (long)Index);
        switch (Index)
        {
            case 0:
                [self addSegmentChangeVCLocal];
                self.systemFileVC.view.hidden = NO;
                self.attachmentVC.view.hidden = YES;
//                
                break;
            case 1:
                [self addSegmentChangeVCVideo];
                self.attachmentVC.view.hidden = NO;
                self.systemFileVC.view.hidden = YES;
                break;
            case 2:
                [self addSegmentChangeVC];
                self.collectionVC.view.hidden = YES;
                self.systemFileVC.view.hidden = YES;
                self.attachmentVC.view.hidden = NO;
                break;
            default:
                break;
        }
}
- (void)addSegmentChangeVCLocal{
    if (!self.systemFileVC) {
        self.systemFileVC = [[DHSystemFileViewController alloc] init];
        [self addChildViewController:self.systemFileVC];
        self.systemFileVC.view.frame = CGRectMake(0, SubVCFrameY, DH_DeviceWidth,DH_DeviceHeight-SubVCFrameY-[self bottomViewHigt]);
        [self.view addSubview:self.systemFileVC.view];
    }
}
- (void)addSegmentChangeVCVideo {
  if (!self.attachmentVC) {
        self.attachmentVC = [[DHAttachmentViewController alloc] init];
        [self addChildViewController:self.attachmentVC];
        self.attachmentVC.view.frame = CGRectMake(0, SubVCFrameY, DH_DeviceWidth,DH_DeviceHeight-SubVCFrameY-[self bottomViewHigt]);
        [self.view addSubview:self.attachmentVC.view];
    }
}
- (void)addSegmentChangeVC{
    self.collectionVC = [[DHCollectFileViewController alloc] init];
    [self addChildViewController:self.collectionVC];
        self.collectionVC.view.frame = CGRectMake(0, 0, DH_DeviceHeight,(DH_DeviceHeight-TopsHight)-[self bottomViewHigt]);
    [self.view addSubview:self.collectionVC.view];
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
//更新选中数据
- (void)updateSendData{}
//{
//    if (self.allSelectedDataArray.count) {
//        [self.sendBtn setTitle:[NSString stringWithFormat:@"发送%ld",self.allSelectedDataArray.count] forState:UIControlStateNormal];
//        self.sendBtn.backgroundColor = [UIColor colorWithRed:85/255.0 green:143/255.0 blue:255/255 alpha:1.0];
//    }else{
//        [self.sendBtn setTitle:[NSString stringWithFormat:@"发送"] forState:UIControlStateNormal];
//        self.sendBtn.backgroundColor = [UIColor lightGrayColor];
//    }
//}
//创建底部悬浮view
- (void)createBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, DH_DeviceHeight-[self bottomViewHigt], DH_DeviceWidth, [self bottomViewHigt])];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    //顶部线
    UIView *lineViewT = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DH_DeviceWidth, 1)];
    lineViewT.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:lineViewT];
    //发送按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DH_DeviceWidth-90, 10, 70, 40);
//    btn.backgroundColor = [UIColor colorWithRed:85/255.0 green:143/255.0 blue:255/255 alpha:1.0];
    btn.backgroundColor = [UIColor lightGrayColor];

    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [bottomView addSubview:btn];

    //底部线
    UIView *lineViewB = [[UIView alloc] initWithFrame:CGRectMake(0, 58, DH_DeviceWidth, 1)];
    lineViewB.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:lineViewB];
}
//发送按钮事件
- (void)sendBtnAction:(UIButton *)sender {
    if (self.allSelectedDataArray.count) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {

    }
}
//取消按钮
- (void)addLeftBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(CGRectGetMaxX(self.view.frame)-80, TopsHight, 80, 30);
    //    btn.backgroundColor = [UIColor lightGrayColor];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//文字靠右
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dissSelfVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (NSMutableArray *)allSelectedDataArray {
    if (!_allSelectedDataArray) {
        _allSelectedDataArray = [NSMutableArray array];
    }
    return _allSelectedDataArray;
}



//取消按钮事件
- (void)dissSelfVC
{
    //清空删除文件上传的名字数组
    NSMutableArray *deleteWithLastArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"deleteWithLastArray"];
    if (deleteWithLastArray.count) {
        [[deleteWithLastArray mutableCopy] removeAllObjects];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 10; i++) {
            JPCarModel *model = [[JPCarModel alloc]init];
            model.allSelect = NO;
//            model.selected = YES;
            for (int i = 0; i<3; i++) {
                JPCarModel *detailsmodel = [[JPCarModel alloc]init];
//                detailsmodel.allSelect = YES;
                detailsmodel.buyCount = 1;
                detailsmodel.selected = NO;
                detailsmodel.name = @"精品美甲";
                detailsmodel.price = @"9999.99";
                [model.numArray addObject:detailsmodel];
            }
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 全选按钮
- (void)createAllBtn
{
    self.allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.allBtn.frame = CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40);
    [self.allBtn setImage:[UIImage imageNamed:@"btn_address_W-1"] forState:UIControlStateNormal];
    [self.allBtn setImage:[UIImage imageNamed:@"btn_address"] forState:UIControlStateSelected];
    [self.allBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.allBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.allBtn];
}

- (void)btnClick:(UIButton *)btn
{
    self.allBtn.selected = !self.allBtn.selected;
    [self.dataArray enumerateObjectsUsingBlock:^(JPCarModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = self.allBtn.selected;
        obj.allSelect = self.allBtn.selected;
        [obj.numArray enumerateObjectsUsingBlock:^(JPCarModel *pro, NSUInteger idx, BOOL * _Nonnull stop) {
            pro.selected = obj.allSelect;
        }];
    }];
    
    // 计算总价格
    [self countingTotalPrice];
    [self.tableView reloadData];
}

/**
 *  setTableView
 */
- (void)setupTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.allowsSelection  = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}
#pragma mark - getAppPlist 代理
- (void)getAppPlist {
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSLog(@"apps: %@", [workspace performSelector:@selector(allApplications)]);
    NSArray*apps = [workspace performSelector:@selector(allApplications)];
    NSMutableArray*appsIconArr = [NSMutableArray array];
    NSMutableArray*appsNameArr = [NSMutableArray array];
    NSLog(@"apps: %@",apps );
//    [apps enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL* stop) {
//        NSDictionary *boundIconsDictionary = [obj performSelector:@selector(boundIconsDictionary)];
//        NSString *iconPath = [NSString stringWithFormat:@"%@/%@.png", [[obj performSelector:@selector(resourcesDirectoryURL)]path], [[[boundIconsDictionary objectForKey:@"CFBundlePrimaryIcon"]objectForKey:@"CFBundleIconFiles"]lastObject]];
//        UIImage *image = [[UIImage alloc]initWithContentsOfFile:iconPath];
//        id name = [obj performSelector:@selector(localizedName)];
//        if(image){
//            [appsIconArr addObject:image];
//            [appsNameArr addObject: name];
//        }
//        NSLog(@"iconPath = %@", iconPath);
//        NSLog(@"name = %@", name);
//        NSLog(@"%@",[self properties_aps:obj]);
//        NSLog(@"_____________________________________________\n");
//    }];
}


- (NSDictionary *)properties_aps:(id)objc {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([objc class], &outCount);
    for (i = 0; i<outCount; i++){
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [objc valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}
#pragma mark - JPShopCar 代理
// 点击了加号按钮
- (void)productCell:(JPShopCarCell *)cell didClickedPlusBtn:(UIButton *)plusBtn
{
    // 拿到点击的cell对应的indexpath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 拿到对应row的模型，购买数++
    JPCarModel *product = self.dataArray[indexPath.section];
    JPCarModel *pro = product.numArray[indexPath.row - 1];
    pro.buyCount++;
    
    // 刷新
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // 计算总显示价格
    [self countingTotalPrice];
}
// 点击了减号按钮
- (void)productCell:(JPShopCarCell *)cell didClickedMinusBtn:(UIButton *)minusBtn
{
    // 拿到点击的cell对应的indexpath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 拿到对应row的模型，购买数--
    JPCarModel *product = self.dataArray[indexPath.section];
    JPCarModel *pro = product.numArray[indexPath.row - 1];
    // 购买数量不能小于1
    if (pro.buyCount == 1) return;
    pro.buyCount--;
    
    // 刷新对应行
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // 计算总价格
    [self countingTotalPrice];
}

 /**
 *  计算总价格
 */
- (void)countingTotalPrice
{
    [self.dataArray enumerateObjectsUsingBlock:^(JPCarModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.numArray enumerateObjectsUsingBlock:^(JPCarModel *pro, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"bbb:%@,%lu,%d",pro.price,(unsigned long)idx,pro.buyCount);
            if (pro.isSelected) {
                self.totalPrice += pro.buyCount * [pro.price floatValue];
            }
        }];
    }];
    NSLog(@"%f", self.totalPrice);
    
    // 总价清零（每次要重新计算）
    self.totalPrice = 0;
}

#pragma mark - tableView Delegate dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JPCarModel *model = self.dataArray[section];
    return model.numArray.count + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        static NSString *ID = @"shopCell1";
        JPShopHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"JPShopHeaderCell" owner:nil options:nil].lastObject;
        }

        JPCarModel *product = self.dataArray[indexPath.section];
        cell.model = product;
        return cell;
    }else
    {
        static NSString *ID = @"shopCell2";
        JPShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"JPShopCarCell" owner:nil options:nil].lastObject;
        }
        JPCarModel *product = self.dataArray[indexPath.section];
        JPCarModel *pro = product.numArray[indexPath.row - 1];
        cell.delegate = self;
        cell.model = pro;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }else
    {
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        // 选中商店 全选商店对应的商品
        // 拿到点击行的数据模型
        JPCarModel *product = self.dataArray[indexPath.section];
        // 设置选中状态
        product.allSelect = !product.isAllSelect;
//        product.selected = product.allSelect;
        
        [product.numArray enumerateObjectsUsingBlock:^(JPCarModel *pro, NSUInteger idx, BOOL * _Nonnull stop) {
            pro.selected = product.allSelect;
        }];
        [self.tableView reloadData];
    } else
    {
        // 单独选中商品
        // 拿到点击行的数据模型
        JPCarModel *product = self.dataArray[indexPath.section];
        JPCarModel *pro = product.numArray[indexPath.row - 1];
        // 设置选中状态
        pro.selected = !pro.isSelected;

        // 刷新所选行
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    // 计算显示总价格
    [self countingTotalPrice];
    
}
#pragma mark  App音量调节
#define KNotificationApplicationSystemVolumeDidChange                        @"AVSystemController_SystemVolumeDidChangeNotification"
- (void)checkerji{
    /*
     1、检测有线耳机、蓝牙耳机输入
     2、检测外设状态变化
     3、锁频停止录音，进入重新开启
     4、来电检测，其他音乐app播放检测
     */
    
    NSError *sessionError = nil;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    
    float volume = [[AVAudioSession sharedInstance] outputVolume];
    
    if (volume <= 30) {
//        [MBProgressHUD showMessage:@"您的设备处于静音状态" ToView:nil RemainTime:3];
//        NSLog(@"您的设备处于静音状态");
//        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//        hud.userInteractionEnabled = YES;
//        [ViewController showHUD:@"正在加载" andView:self.view andHUD:hud];
        [SVProgressHUD showWithStatus:@"加载中，请稍后。。。"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // time-consuming task
            dispatch_async(dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
                [SVProgressHUD dismissWithDelay:5];
            });
        });


    }
    u = [UIButton buttonWithType:UIButtonTypeCustom];
    u.frame = CGRectMake(100, 200, 100, 100);
        u.layer.borderColor = [UIColor redColor].CGColor;
        u.layer.borderWidth = 1.0;
        [u addTarget:self action:@selector(touchView:)
    forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:u];
        [u setTitle:@"开始点击" forState:(UIControlStateNormal)];
        [u setTitle:@"结束点击" forState:(UIControlStateSelected)];

//    BOOL stateVolume = [self isMuted];//0:NO 1:YES
    BOOL ru = [self isHeadsetPluggedInIn];///
    if (ru) {
        NSLog(@"耳机接入");
        BOOL mutedLister = [self addMutedListener];
        if (mutedLister) {
            NSLog(@"耳机接入");
        }else{
            NSLog(@"未接入耳机");
        }
    }else{
        NSLog(@"请接入耳机");
    }
//    [self checkDevice];
//    [self 监听耳机事件];
    [self.view addSubview:self.labelVoice];
    
    /*
     AVAudionSessionMode
     AVAudioSessionModeDefault
     默认的模式，适用于所有的场景
     AVAudioSessionModeVoiceChat
     适用类别 AVAudioSessionCategoryPlayAndRecord ，应用场景VoIP
     AVAudioSessionModeGameChat
     适用类别 AVAudioSessionCategoryPlayAndRecord ，应用场景游戏录制，由GKVoiceChat自动设置，无需手动调用
     AVAudioSessionModeVideoRecording
     适用类别 AVAudioSessionCategoryPlayAndRecord，AVAudioSessionCategoryRecord 应用场景视频录制
     AVAudioSessionModeMoviePlayback
     适用类别 AVAudioSessionCategoryPlayBack 应用场景视频播放
     AVAudioSessionModeVideoChat
     适用类别 AVAudioSessionCategoryPlayAndRecord ，应用场景视频通话
     AVAudioSessionModeMeasurement
     适用类别AVAudioSessionCategoryPlayAndRecord，AVAudioSessionCategoryRecord，AVAudioSessionCategoryPlayback
     AVAudioSessionModeSpokenAudio
    */
    /*
     AVAudioSessionCategoryOptions
     AVAudioSessionCategoryOptionMixWithOthers
     适用于AVAudioSessionCategoryPlayAndRecord, AVAudioSessionCategoryPlayback, and AVAudioSessionCategoryMultiRoute， 用于可以和其他app进行混音
     AVAudioSessionCategoryOptionDuckOthers
     适用于AVAudioSessionCategoryAmbient, AVAudioSessionCategoryPlayAndRecord, AVAudioSessionCategoryPlayback, and AVAudioSessionCategoryMultiRoute, 用于压低其他声音播放的音量，使期音量变小
     AVAudioSessionCategoryOptionAllowBluetooth
     适用于AVAudioSessionCategoryRecord and AVAudioSessionCategoryPlayAndRecord, 用于是否支持蓝牙设备耳机等
     AVAudioSessionCategoryOptionDefaultToSpeaker
     适用于AVAudioSessionCategoryPlayAndRecord ，用于将声音从Speaker播放，外放，即免提
     AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers
     适用于AVAudioSessionCategoryPlayAndRecord, AVAudioSessionCategoryPlayback, and AVAudioSessionCategoryMultiRoute, iOS9 新增加的
     AVAudioSessionCategoryOptionAllowBluetoothA2DP
     适用于AVAudioSessionCategoryPlayAndRecord，蓝牙和a2dp
     AVAudioSessionCategoryOptionAllowAirPlay
     适用于AVAudioSessionCategoryPlayAndRecord，airplay
     AVAudioSessionCategoryOptionDuckOthers
     在设置 CategoryPlayAndRecord 时，同时设置option为Duckothers 那么会压低其他音量播放
     解决办法，重新设置。
     This allows an application to set whether or not other active audio apps will be ducked when when your app's audio
     session goes active. An example of this is the Nike app, which provides periodic updates to its user (it reduces the
     volume of any music currently being played while it provides its status). This defaults to off. Note that the other
     audio will be ducked for as long as the current session is active. You will need to deactivate your audio
     session when you want full volume playback of the other audio.
     */
    /*
     AVAudioSessionCategoryOptionMixWithOthers//是否可以和其他后台App进行混音 如果确实用的
     AVAudioSessionCategoryOptionDuckOthers//是否压低其他App声音
     AVAudioSessionCategoryOptionAllowBluetooth//是否支持蓝牙耳机电话
     AVAudioSessionCategoryOptionDefaultToSpeaker//是否默认用免提声音
     AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers//支持蓝牙A2DP耳机和AirPlay
     AVAudioSessionCategoryOptionAllowBluetoothA2DP
     AVAudioSessionCategoryOptionAllowAirPlay
     */
    /*
     AVAudioSessionCategoryAmbient//只用于播放音乐时，并且可以和QQ音乐同时播放，比如玩游戏的时候还想听QQ音乐的歌，那么把游戏播放背景音就设置成这种类别。同时，当用户锁屏或者静音时也会随着静音，这种类别基本使用所有App的背景场景
     AVAudioSessionCategorySoloAmbient//也是只用于播放,但是和"AVAudioSessionCategoryAmbient"不同的是，用了它就别想听QQ音乐了，比如不希望QQ音乐干扰的App，类似节奏大师。同样当用户锁屏或者静音时也会随着静音，锁屏了就玩不了节奏大师了。
     AVAudioSessionCategoryPlayback//如果锁屏了还想听声音怎么办？用这个类别，比如App本身就是播放器，同时当App播放时，其他类似QQ音乐就不能播放了。所以这种类别一般用于播放器类App 实现共存
     AVAudioSessionCategoryRecord//有了播放器，肯定要录音机，比如微信语音的录制，就要用到这个类别，既然要安静的录音，肯定不希望有QQ音乐了，所以其他播放声音会中断。想想微信语音的场景，就知道什么时候用他了。
     AVAudioSessionCategoryPlayAndRecord//如果既想播放又想录制该用什么模式呢？比如VoIP，打电话这种场景，PlayAndRecord就是专门为这样的场景设计的 。
     AVAudioSessionCategoryAudioProcessing//主要用于音频格式处理，一般可以配合AudioUnit进行使用，使用硬件解码器处理音频，该音频会话使用期间，不能播放或录音
     AVAudioSessionCategoryMultiRoute//想象一个DJ用的App，手机连着HDMI到扬声器播放当前的音乐，然后耳机里面播放下一曲，这种常人不理解的场景，这个类别可以支持多个设备输入输出。多种音频输入输出，例如可以耳机、USB设备同时播放等
     */
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionAllowBluetooth error:nil];

    /* 不需要保存录音文件 */
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error = nil;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (recorder)
    {
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }
    else
    {
        NSLog(@"%@", [error description]);
    }
    //让自己的Session解除激活后恢复其他App Session的激活状态
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    ///使用通知消息机制：
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    ///开启接收通知事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    ///获取手机设备音量 KVO监听属性outputVolume
    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:(void*)[AVAudioSession sharedInstance]];
    
    ///监听耳机拔插
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallbackCallback:)  name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
}
- (void)audioRouteChangeListenerCallbackCallback:(NSNotification*)notification {

    NSDictionary *interuptionDict = notification.userInfo;

    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];

    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            
            NSLog(@"耳机插入");
            
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"耳机拔出");
            //耳机拔出
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //做操作,用主线程调用,如果不用主线程会报黄,提示,从一个线程跳到另一个线程容易产生崩溃,所以这里要用主线程去做操作
                
            });
            
            break;
            
        case AVAudioSessionRouteChangeReasonOverride:
            
            NSLog(@"耳机拔出");
            
            break;
            
    }
}
/* 该方法确实会随环境音量变化而变化，但具体分贝值是否准确暂时没有研究 */
- (void)levelTimerCallback:(NSTimer *)timer {
    [recorder updateMeters];
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -60.0f; // use -80db Or use -60dB, which I measured in a silent room.
    float   decibels    = [recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 5.0f; //modified level from 2.0 to 5.0 is neast to real test
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    
    /* level 范围[0 ~ 1], 转为[0 ~120] 之间 */
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"voice updated :%f",level * 120);
        self.layerVoice.frame = CGRectMake(0, 0, level * 120, 50);
        self.labelVoice.text = [NSString stringWithFormat:@"分别是：%.f",level * 120];
    });
}
//耳机插入检测
- (BOOL)isHeadsetPluggedInIn {
    /*
     AVAudioSessionPortLineOut//线路级输出到总线坞
     AVAudioSessionPortHeadphones//输出到有线耳机
     AVAudioSessionPortBluetoothA2DP//输出到蓝牙A2DP设备(A2DP全名是Advanced Audio Distribution Profile 蓝牙音频传输模型协定)
     AVAudioSessionPortBuiltInReceiver//贴耳朵时候内置扬声器（打电话的时候的听筒）
     AVAudioSessionPortBuiltInSpeaker//输出到设备的内置扬声器。(iOS设备内置的扬声器)
     AVAudioSessionPortHDMI//通过高清多媒体接口（HDMI）规范输出到设备
     AVAudioSessionPortAirPlay//远程AirPlay设备
     AVAudioSessionPortBluetoothLE//蓝牙低电量输出设备
     AVAudioSessionPortBluetoothHFP
     AVAudioSessionPortUSBAudio
     AVAudioSessionPortCarAudio
     */
//    AVAudioSessionRouteDescription *routeDescription = dict[AVAudioSessionRouteChangePreviousRouteKey];

//    AVAudioSessionPortDescription  *portDescription  = [routeDescription.outputs firstObject];

//    NSString *portType = portDescription.portType;

    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones]){
            NSLog(@"耳机输入");
            return YES;
        }
        if ([[desc portType] isEqualToString:@"BluetoothA2DPOutput"]||[[desc portType] isEqualToString:AVAudioSessionPortBluetoothA2DP]) {
            NSLog(@"蓝牙耳机音箱");
            return YES;
        }
    }
    return NO;
}
- (void)checkDevice{
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,audioRouteChangeListenerCallback,CFBridgingRetain(self));
}
- (BOOL)addMutedListener{
    OSStatus s = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,
                                                 audioRouteChangeListenerCallback,
                                                 CFBridgingRetain(self));
    return s == kAudioSessionNoError;
}

//触发的监听事件
void audioRouteChangeListenerCallback (void *inUserData, AudioSessionPropertyID inPropertyID, UInt32 inPropertyValueSize,const void *inPropertyValue ) {
   // ensure that this callback was invoked for a route change
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange)return;
    {
        CFDictionaryRef routeChangeDictionary = (CFDictionaryRef)inPropertyValue;
        CFNumberRef routeChangeReasonRef = (CFNumberRef)CFDictionaryGetValue (routeChangeDictionary, CFSTR (kAudioSession_AudioRouteChangeKey_Reason) );
        SInt32 routeChangeReason;
        CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
        /*
         变更原因代码
         这些是kAudioSessionProperty_AudioRoute属性更改时使用的代码
         @constant kAudioSessionRouteChangeReason_Unknown
         原因尚不清楚。
         @constant kAudioSessionRouteChangeReason_NewDeviceAvailable
         一种新的设备出现了(例如，耳机已经插好了)。
         @constant kAudioSessionRouteChangeReason_OldDeviceUnavailable
         旧设备无法使用(例如耳机被拔下)。
         @constant kAudioSessionRouteChangeReason_CategoryChange
         音频类别已经改变(例如kAudioSessionCategory_MediaPlayback)
         已更改为kAudioSessionCategory_PlayAndRecord)。
         @constant kAudioSessionRouteChangeReason_Override
         路径已被覆盖(例如，类别为kAudioSessionCategory_PlayAndRecord)
         输出已经从默认的接收器更改为扬声器)。
         @constant kAudioSessionRouteChangeReason_WakeFromSleep
         设备从睡梦中醒来。
         @constant kAudioSessionRouteChangeReason_NoSuitableRouteForCategory
         当当前类别(例如RecordCategory)没有路由时返回
         但没有输入设备)
         @constant kaudiosessionroutechangereason_routeconfigurationchange
         指示输入和/我们的输出端口的集合没有改变，但是它们的某些方面改变了
         配置发生了变化。例如，端口所选的数据源已更改。
         */
        
        if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
            NSLog(@"没有耳机！");
        } else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
            NSLog(@"有耳机！");
        } else if (routeChangeReason ==  kAudioSessionRouteChangeReason_CategoryChange){
            NSLog(@"耳机发生改变！");//初始化
        } else if (routeChangeReason == kAudioSessionRouteChangeReason_RouteConfigurationChange){
            NSLog(@"耳机配置发生了变化！");///没有输出
        } else if (routeChangeReason == kAudioSessionRouteChangeReason_NoSuitableRouteForCategory){
            NSLog(@"没有耳机！");
        } else if (routeChangeReason == kAudioSessionRouteChangeReason_Override){
            NSLog(@"没有耳机改为扬声器播放！");
        }
    }
}
- (void)getVolume:(NSNotification *)sender {
    if ([sender.name isEqualToString:KNotificationApplicationSystemVolumeDidChange]) {
            NSLog(@"_observerApplicationVolumeAction");
            NSDictionary *dict = sender.userInfo;
            NSLog(@"--%@",dict[@"AVSystemController_AudioVolumeNotificationParameter"] );
    //        [0]    (null)    @"AVSystemController_AudioVolumeNotificationParameter" : (double)0.5
    //        [1]    (null)    @"AVSystemController_AudioCategoryNotificationParameter" : @"Audio/Video"
    //        [2]    (null)    @"AVSystemController_AudioVolumeChangeReasonNotificationParameter" : @"RouteChange"
    //        [3]    (null)    @"AVSystemController_UserVolumeAboveEUVolumeLimitNotificationParameter" : NO
        }
}
- (void)_observerApplicationVolumeAction:(NSNotification *)sender {
    if ([sender.name isEqualToString:KNotificationApplicationSystemVolumeDidChange]) {
        NSLog(@"_observerApplicationVolumeAction");
        NSDictionary *dict = sender.userInfo;
        NSLog(@"--%@",dict[@"AVSystemController_AudioVolumeNotificationParameter"] );
//        [0]    (null)    @"AVSystemController_AudioVolumeNotificationParameter" : (double)0.5
//        [1]    (null)    @"AVSystemController_AudioCategoryNotificationParameter" : @"Audio/Video"
//        [2]    (null)    @"AVSystemController_AudioVolumeChangeReasonNotificationParameter" : @"RouteChange"
//        [3]    (null)    @"AVSystemController_UserVolumeAboveEUVolumeLimitNotificationParameter" : NO
    }
}
- (void)volumeChanged:(NSNotification *)notification{

    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    NSLog(@"当前设备音量为：%f",volume);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == [AVAudioSession sharedInstance]) {
        if ([keyPath isEqualToString:@"outputVolume"]) {
            float newValue = [change[@"new"] floatValue];
            float oldValue = [change[@"old"] floatValue];
            NSLog(@"newValue: %f--oldValue: %f",newValue,oldValue);
        }
    }
}
///是否是静音
- (BOOL)isMuted{
    CFStringRef route;
    UInt32 routeSize = sizeof(CFStringRef);
    OSStatus status = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &routeSize, &route);
    if (status == kAudioSessionNoError){
        if (route == NULL || !CFStringGetLength(route))
            return TRUE;
    }
    return FALSE;
}
/**

 截取视频的背景音乐

 */
+ (void)videoChangeGetBackgroundMiusicWithVideoUrl:(NSURL*)videoUrl completion:(void(^)(NSString*data))completionHandle{
    AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    NSArray *keys = @[@"duration",@"tracks"];
    [videoAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        NSError*error =nil;
        AVKeyValueStatus status = [videoAsset statusOfValueForKey:@"tracks"error:&error];
        if(status ==AVKeyValueStatusLoaded) {//数据加载完成
            AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
            // 2 - Video track
            //Audio Recorder
            //创建一个轨道,类型是AVMediaTypeAudio
            AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            //获取videoAsset中的音频,插入轨道
            [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];//输出为M4A音频
            NSString *documentsDirPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/%@.m4a",@"music"]];
            NSURL *documentsDirUrl = [NSURL fileURLWithPath:documentsDirPath isDirectory:YES];
            exporter.outputURL = documentsDirUrl;
            exporter.outputFileType=@"com.apple.m4a-audio";//类型和输出类型一致
            exporter.shouldOptimizeForNetworkUse = YES;
            [exporter exportAsynchronouslyWithCompletionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (exporter.status == AVAssetExportSessionStatusCompleted) {
                        completionHandle(exporter.outputURL.path);
                    }else{
                        NSLog(@"失败了，原因是：%@,%@",exporter.error,exporter.error.userInfo.description);
                        completionHandle([exporter.error.userInfo.description description]);
                    }
                });
            }];
        }
    }];
}
- (UILabel *)labelVoice{
    if (!_labelVoice){
        _labelVoice = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, 120, 50)];
        _labelVoice.backgroundColor = [UIColor orangeColor];
        _labelVoice.textColor = [UIColor redColor];
        _labelVoice.font = [UIFont systemFontOfSize:14];
        [_labelVoice setTextColor:[UIColor redColor]];
        
        
        _layerVoice = [CALayer layer];
        _layerVoice.backgroundColor = [[UIColor greenColor]CGColor];
        _layerVoice.frame = _labelVoice.bounds;
        [_labelVoice.layer addSublayer:_layerVoice];
    }
    return _labelVoice;
}
// 复用队列
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.layer.transform = CATransform3DMakeScale(1.5, 1.5, 0);
//    cell.alpha = 0.0;
//    [UIView animateWithDuration:1 animations:^{
//        cell.layer.transform = CATransform3DIdentity;
//        cell.alpha = 1.0;
//    }];
//}
////增加点击动画
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    /*! 第二种：卡片式动画 */
//    static CGFloat initialDelay = 0.2f;
//    static CGFloat stutter = 0.06f;
//
//    cell.contentView.transform =  CGAffineTransformMakeTranslation(DH_DeviceWidth, 0);
//    [UIView animateWithDuration:1.0f delay:initialDelay + ((indexPath.row) * stutter) usingSpringWithDamping:0.6 initialSpringVelocity:1 options:0.5 animations:^{
//        cell.contentView.transform = CGAffineTransformIdentity;
//    } completion:NULL];
//
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
