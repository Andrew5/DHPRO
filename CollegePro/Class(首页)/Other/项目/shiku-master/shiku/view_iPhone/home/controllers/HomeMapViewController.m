//
//  HomeMapViewController.m
//  shiku
//
//  Created by Rilakkuma on 15/7/24.
//  Copyright (c) 2015年 txj. All rights reserved.
//
#import "HomeMapViewController.h"
#import "HomeViewControllernew.h"
#import "MyAnimatedAnnotationView.h"
//#import "BMKActionPaopaoView.h"
#import "MapAnnotationMode.h"
#import "HomeWebViewController.h"
//附近农户
#import "MainAnnotationView.h"
#import "NearbViewController.h"
#import "GuideViews.h"
#import "InfoViewController.h"

@interface HomeMapViewController ()<MyAnimatedAnnotationViewDelegate,BMKGeoCodeSearchDelegate,MBProgressHUDDelegate>
{
    BMKCircle* circle;
    BMKPolygon* polygon;
    BMKPolygon* polygon2;
    BMKPolyline* polyline;
    BMKArcline* arcline;
    NSInteger ANNTag;
    BMKGroundOverlay* ground2;
    BMKGeoCodeSearch* _geocodesearch;
    BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
    BOOL isBool;
    BOOL m_Bool;
    NSString *midStr;
    bool isGeoSearch;
    CLLocation *centerlocation;
    UIView *_searchFieldView;

}

@property (nonatomic,strong)UIWebView *webView;

@property (nonatomic,strong)NSString *m_address;

@property(nonatomic ,strong)NSMutableArray * m_DataArr;

- (void)willStartLocatingUser;
@end

@implementation HomeMapViewController
-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.m_DataArr = [[NSMutableArray alloc]init];
//添加导航搜索
    UIView *searchFieldView=[self tToolbarSearchField:[UIScreen mainScreen].bounds.size.width-100 withheight:20
                               isbecomeFirstResponder:NO action:@selector(searchFieldTouched) textFieldDelegate:self];
    searchFieldView.autoresizingMask=YES;
    self.navigationItem.titleView=searchFieldView;

    //周边  寻味
    float margin = (screenSize.width-120)/3.0;
    self.btnRoundMarginLeft.constant = margin;
    self.btnThinkOvewMarginLeft.constant = margin;
    

//地图初始化
    //self.view.frame.size.width
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _locService = [[BMKLocationService alloc]init];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44-68)];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
//    _mapView.centerCoordinate = CLLocationCoordinate2DMake(40.003029, 116.489426);
    _mapView.zoomLevel = 10;//加载比例尺
    _mapView.zoomEnabled = YES;//多点缩放
    _mapView.zoomEnabledWithTap = YES;//缩放(双击或双指单击)
//    _mapView.mapType = BMKMapTypeStandard;
    _mapView.rotateEnabled = NO;//支持旋转
    _mapView.overlookEnabled = NO;//支持俯仰角
//    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.showMapScaleBar = NO;//比例尺
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.centerCoordinate = _locService.userLocation.location.coordinate;

    //定位设置
    //初始化BMKLocationService
    _locService.delegate = self;
    
    //启动LocationService
    [_locService startUserLocationService];
   
    [_rootView addSubview:_mapView];
    

//导航栏按钮配置
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 10, 18, 22);
    [leftBtn setImage:[UIImage imageNamed:@"leftIcon_03.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickleftButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtnItem;
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(5, 10, 26, 20);
    [rightBtn setImage:[UIImage imageNamed:@"iii_05"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;


    [_btnRound addTarget:self action:@selector(clickRound) forControlEvents:(UIControlEventTouchUpInside)];
    [_btnThinkOvew addTarget:self action:@selector(clickThinkOver) forControlEvents:(UIControlEventTouchUpInside)];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackKeyboard)];
    _mapView.userInteractionEnabled = YES;
    [_mapView addGestureRecognizer:tap];
}
#pragma mark 寻味
-(void)clickThinkOver{
    HomeWebViewController *thinkOver = [HomeWebViewController new];
    [self.navigationController pushViewController:thinkOver animated:YES];
//    [self showNavigationView:thinkOver];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;

}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];

}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

-(void)tapBackKeyboard{
    [_mapView endEditing:YES];
}
- (void)setVisibleMapRect:(BMKMapRect)mapRect edgePadding:(UIEdgeInsets)insets animated:(BOOL)animate{

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];

    _mapView.centerCoordinate = centerlocation.coordinate;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _searcher.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
     _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil; // 不用时，置nil

}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
    [self onClickLocationImage];

}
-(void)onClickLocationImage{
    if (_locService.userLocation != nil) {
        [_mapView setCenterCoordinate:_locService.userLocation.location.coordinate];
    }
}
//周边
-(void)clickRound
{
   
    [self ReloadView];
}
#pragma mark 加载附近农户

-(void)ReloadView
{
     NSLog(@"%lu",(unsigned long)_m_DataArr.count);
    [self removeMyAnimatedAnnotations];
    isBool = NO;
    ANNTag=1000;
    NSMutableArray * Annotations = [[NSMutableArray alloc]init];
    for (int i = 0; i<[self.m_DataArr count]; i++) {
        MapAnnotationMode * mode = [self.m_DataArr objectAtIndex:i];
        BMKPointAnnotation * Annotation = [self addAnimatedAnnotationpos_lat:mode.pos_lat pos_lng:mode.pos_lng];
        [Annotations addObject:Annotation];
    }
    [_mapView addAnnotations:Annotations];
    _mapView.centerCoordinate = centerlocation.coordinate;
    [self.view showHUD:[NSString stringWithFormat:@"你的附近共有%lu家精品农场",(unsigned long)[self.m_DataArr count]] afterDelay:0.5];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    SearchViewController *sc=[SearchViewController new];
    
    [self.navigationController pushViewController:sc animated:YES];
}
-(void)searchFieldTouched{
    

}
//原：定位
-(void)clickleftButton
{
    CGFloat lat = centerlocation.coordinate.latitude;
    CGFloat longit =  centerlocation.coordinate.longitude;
    NearbViewController *nearb= [NearbViewController new];
    nearb.lat = lat;
    nearb.longati = longit;
    nearb.subtitle = self.m_address;
    nearb.locationDataArray = _m_DataArr;
//    [self showNavigationView:nearb];
    [self.navigationController pushViewController:nearb animated:YES];
//    //启动LocationService
//    [_locService startUserLocationService];
//    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
//    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
//    _mapView.showsUserLocation = YES;//显示定位图层
////    _mapView.centerCoordinate = CLLocationCoordinate2DMake(40.003029, 116.489426);
//    _mapView.centerCoordinate = _locService.userLocation.location.coordinate;
//
//
//    //设置定位精确度，默认：kCLLocationAccuracyBest
//    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
//    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
//    [BMKLocationService setLocationDistanceFilter:100.f];


}
-(void)clickRightButton{
        InfoViewController *info = [InfoViewController new];
        [self showViewController:info sender:self];
    //    HomeViewControllernew *info = [[HomeViewControllernew alloc]init];
//    [self.navigationController pushViewController:info animated:YES];

}


- (BOOL) checkCardNo:(NSString*) cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];

    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }

    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}


#pragma mark -
#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if (isBool) {
        //动画annotation
        NSString *AnnotationViewID = @"MainAnimatedAnnotation";
        MainAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MainAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }

        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pin_purple.png"]];
        annotationView.annotationImage = image;
        return annotationView;
    }
    else
    {
        //动画annotation
        NSString *AnnotationViewID = @"AnimatedAnnotation";
        MyAnimatedAnnotationView *annotationView = nil;
        MapAnnotationMode * mode;

        mode = [self.m_DataArr objectAtIndex:ANNTag-1000];
        
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            annotationView.delegete = self;
            annotationView.tag = ANNTag++;
        }
        
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            
            UIImage *image;
            if (i==0) {
                image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_home_farmer_flag.png"]];
            }
            else
            {
                NSLog(@"图片名称 %@",mode.ImgID);
                image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_goods_%@.png",mode.ImgID]];
            }
            
            [images addObject:image];
        }
        
        annotationView.annotationImages = images;

          return annotationView;
    }
   
}

//商家点击代理
-(void)AnimatedAnnotationClick:(UIButton *)sender
{
    if (_m_DataArr.count != 0) {
        MapAnnotationMode * mode = [self.m_DataArr objectAtIndex:sender.tag-1000];
        HomeViewControllernew *info = [[HomeViewControllernew alloc]init];
        info.midStr = mode.m_Mid;
        [self.navigationController pushViewController:info animated:YES];
        return;

    }
        
        [self.view showHUD:@"此处无数据" afterDelay:0.3];
    
    //    [self.view showHUD:[NSString stringWithFormat:@"你点击m_id:%@的农场",m_id] afterDelay:1];

}

//点击弹出框 泡泡
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    NSLog(@"erer");

}
//点击地图标注
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
//    [mapView bringSubviewToFront:view];
//    [mapView setNeedsDisplay];
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
      NSLog(@"didAddAnnotationViews");
//
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{


    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];

    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [annotations addObject:item];
        }

        for (NSInteger i = result.poiInfoList.count/2; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            animatedAnnotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = poi.pt.latitude;
            coor.longitude = poi.pt.longitude;
            animatedAnnotation.coordinate = coor;
            animatedAnnotation.title = poi.name;
            [annotations addObject:animatedAnnotation];

        }

        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];


    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}


/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}


/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    [self onClickReverseGeocode:userLocation.location.coordinate];
    centerlocation = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    [self loadLocation:userLocation.location.coordinate];


    
}
-(void)loadLocation:(CLLocationCoordinate2D)location{
    NSLog(@"%f",location.latitude);
    
    NSLog(@"%f",location.longitude);
    
    [self Showprogress];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"pos_lng\":\"%f\",\"pos_lat\":\"%f\"}",location.longitude,location.latitude]
                   forKey:@"data"];
    NSLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@/member_shop/lists",url_share];
    [mgr POST:url parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (responseObject[@"data"]) {
              NSLog(@"成功%@",responseObject[@"data"]);
              
              [self reloadDataArr:[responseObject objectForKey:@"data"]];
              
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
      }];

}
-(void)reloadDataArr:(NSArray *)Arr
{
    [self hideHUDView];
    [self.m_DataArr removeAllObjects];
    for(int i = 0 ;i<[Arr count];i++)
    {
        NSDictionary * dict = [Arr objectAtIndex:i];
        MapAnnotationMode * mode = [[MapAnnotationMode alloc]init];
        mode.ImgUrl = [[dict objectForKey:@"pcate"] objectForKey:@"img"];
        mode.ImgID = [[dict objectForKey:@"pcate"] objectForKey:@"id"];
        mode.m_Mid = [dict objectForKey:@"mid"];
        mode.pos_lat = [dict objectForKey:@"pos_lat"];
        mode.pos_lng = [dict objectForKey:@"pos_lng"];
        NSLog(@"%@---%@",mode.pos_lat,mode.pos_lng);
        mode.titleStr = [dict objectForKey:@"title"];//产品标题
        mode.areaStr = [dict objectForKey:@"ares"];//产地
        mode.catenmaeStr = dict[@"cate"][@"name"];//主营
        mode.distanceStr = dict[@"distance"];//距离
        mode.membersaleStr = dict[@"member"][@"sales"];//销量
        [self.m_DataArr addObject:mode];
    }
            [self ReloadView];

}


// 添加动画Annotation
- (BMKPointAnnotation *)addAnimatedAnnotationpos_lat:(NSString *)pos_lat pos_lng:(NSString *)pos_lng
{
//    if (animatedAnnotation == nil) {
        animatedAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [pos_lat floatValue];
        coor.longitude = [pos_lng floatValue];
        animatedAnnotation.coordinate = coor;
//    }
    return animatedAnnotation;
}


/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}



#pragma mark 底图手势操作
/**
 *点中底图标注后会回调此接口
 *@param mapview 地图View
 *@param mapPoi 标注点信息
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi
{
//    NSLog(@"onClickedMapPoi-%@",mapPoi.text);
//    NSString* showmeg = [NSString stringWithFormat:@"您点击了底图标注:%@,\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", mapPoi.text,mapPoi.pt.longitude,mapPoi.pt.latitude, (int)_mapView.zoomLevel,_mapView.rotation,_mapView.overlooking];
}

-(void)removeMyAnimatedAnnotations
{
    // 清楚屏幕中所有的annotation
    NSMutableArray * m_Arr = [[NSMutableArray alloc]init];
    for (BMKAnnotationView * annotation in _mapView.annotations) {
        if ([annotation isKindOfClass:[MyAnimatedAnnotationView class]]) {
            [m_Arr addObject:annotation];
        }
    }
    [_mapView removeAnnotations:m_Arr];
}

-(void)removeAnnotations
{
    [_mapView removeAnnotations:_mapView.annotations];

}

/**
 *长按地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    isBool = YES;
    m_Bool = YES;
    [self removeAnnotations];
     _mapView.centerCoordinate = centerlocation.coordinate;
    [self.mapView addAnnotation: [self addAnimatedAnnotationpos_lat:[NSString stringWithFormat:@"%f",coordinate.latitude] pos_lng:[NSString stringWithFormat:@"%f",coordinate.longitude]]];
     _mapView.showsUserLocation = NO;//显示定位图层
    [self onClickReverseGeocode:coordinate];
     centerlocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
     [_locService stopUserLocationService];
    [self loadLocation:coordinate];
}


//地理反编码

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
     if (error == 0) {
         self.m_address = result.address;
    }
}



-(void)onClickReverseGeocode:(CLLocationCoordinate2D)location
{
    isGeoSearch = false;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = location;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
