//
//  BDMapViewController.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BDMapViewController.h"
#import "JPSThumbnailAnnotation.h"
#import "JPSPopoverView.h"
#import "AddFirendViewController.h"
#import "MainTabBarController.h"

#import "Contacts.h"
#import "Constants.h"
#import "MJExtension.h"

#import "UserInfoStorage.h"
#import "ContactsViewController.h"
#import "FriendInfoViewController.h"
//#import "ScanViewController.h"
#import "FriendManagerHandler.h"
#import "RecentFriendStorage.h"


@implementation BDMapViewController
{
 //   BMKLocationService *_locationService;
    NSMutableArray     *_annots;   //地图上显示气泡集合
    NSMutableArray     *_annotFriends;//气泡对应的好友集合,用于判断是否地图上已经加载了这个好友
    FriendManagerHandler *_friendHandler;
    NSArray            *_recentFriendArray;
    RecentFriendStorage *_friendStorage;
    FriendEntity       *_selectedFriend;//当前操作的好友对象
    
    NSTimer            *_timer;//搜寻范围内好友时，延迟请求

}
@synthesize mapView;

#define RECENT_FRIEND_COUNT 3 // 最近联系人列表长度
-(void)loadView{
    [super loadView];
    
    
    self.mapView = [[BDMapView alloc]initWithController:self];
    
    self.mapView.tMapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
   [self.mapView.locationBtn addTarget:self action:@selector(shareLocation) forControlEvents:UIControlEventTouchUpInside];
    
    self.mapView.baseViewDelegate = self;
    
    self.view = self.mapView;

    
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setTitle:@"在那儿"];
    
     self.mapView.tMapView.delegate = self;

    
    [self startLocation];
    
    [self initNav];
    
    //注册获取好友位置信息通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFriendLocationNotification:) name:SHOW_FRIEND_LOCATION object:nil];
    
    _annots = [NSMutableArray array];
    
    _friendHandler = [[FriendManagerHandler alloc]init];
    
    __unsafe_unretained BDMapViewController *safeSelf = self;
    
    //请求成功返回
    _friendHandler.successBlock = ^(id obj){
        
        int opt = [[obj objectForKey:REQUEST_ACTION]intValue];
       
        if (opt == GET_FRIEND_LOCATION_OPT) {
            //查询到好友最近位置
            NSDictionary *retDic = [obj objectForKey:RET_RESULT];
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:retDic];
            [info setObject:safeSelf->_selectedFriend.equipId forKey:@"equipId"];
            [info setObject:safeSelf->_selectedFriend.equipName forKey:@"equipName"];
            [info setObject:(safeSelf->_selectedFriend.equipIcon ? safeSelf->_selectedFriend.equipIcon : @"")forKey:@"equipIcon"];
            [info setObject:[NSNumber numberWithInt:safeSelf->_selectedFriend.gender] forKey:@"gender"];
            
            [safeSelf showFriendLocationOnMap:info isCenter:YES];
        }
        /*
        else if (opt == SEARCH_FRIEND_IN_AREA_OPT){
           //地图范围内查询到好友位置
            NSArray *arrayResult = [obj objectForKey:RET_RESULT];
            for (NSDictionary *dic in arrayResult) {
                //将好友位置显示在地图上
                [safeSelf showFriendLocationOnMap:dic isCenter:NO];
            }
        }*/
        
    };
  //  [_friendHandler getRecentFriend];
  
    _friendStorage = [RecentFriendStorage defaultStorage];
    
    self.arrayRecentFriend = [NSMutableArray arrayWithCapacity:RECENT_FRIEND_COUNT];
    [self.arrayRecentFriend addObjectsFromArray:[_friendStorage getAllFriend]];
    
    [self.mapView setFriendListData:self.arrayRecentFriend];
    
    
}

-(void)initNav{
    
    UIButton *search = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [search addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    [search setImage:[UIImage imageNamed:@"search_bt.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithCustomView:search];
    
    
    UIButton *add = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [add setImage:[UIImage imageNamed:@"add_bg.png"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(doAdd) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithCustomView:add];
    
    [self.navigationItem setRightBarButtonItems:@[addBtn,searchBtn]];
    
    UIImageView *logoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_logo.png"]];
    UIBarButtonItem *leftLogo = [[UIBarButtonItem alloc]initWithCustomView:logoImage];
    [self.navigationItem setLeftBarButtonItem:leftLogo];
}

 

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.mapView.tMapView.UserTrackMode == TUserTrackingModeFollow)
        [self.mapView.tMapView StartGetPosition];
    
    [self showTabBar];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self.mapView.tMapView StopGetPosition];
}


#pragma mark - Button Action
-(void)shareLocation{
    
    //开始定位
    [self startLocation];
    
}



-(void)doSearch{

   
}

-(void)doAdd{
    CGPoint point = CGPointMake(self.view.frame.size.width-30, 65);
    JPSPopoverView *popView = [[JPSPopoverView alloc]initWithPoint:point];
    
    popView.selectItemAtIndex = ^(NSInteger index){
       
        if (index == 0) {
            
            AddFirendViewController *addController = [[AddFirendViewController alloc]init];
            [self hideTabBar];
            [self.navigationController pushViewController:addController animated:YES];
            
        }
        else {
//             [self.navigationController pushViewController:[[ScanViewController alloc]init] animated:YES];
//             [self hideTabBar];
        }
    };
    
    [popView show];

}

//开启定位服务
-(void)startLocation{
    
    // 启动定位服务
    [self.mapView.tMapView StartGetPosition];
    // 显示用户位置
    self.mapView.tMapView.ShowPosition = YES;
    // 当前跟踪模式,跟踪状态
    self.mapView.tMapView.UserTrackMode = TUserTrackingModeFollow;
    
    
}


-(void)showFriendLocationOnMap:(NSDictionary *)locationInfor isCenter:(BOOL)center{


    CLLocationDegrees lat=[[locationInfor objectForKey:@"lat"] floatValue];
    CLLocationDegrees lon=[[locationInfor objectForKey:@"lon"] floatValue];
    
    FriendEntity *friend = [[FriendEntity alloc]init];
    
    friend.equipId = [locationInfor objectForKey:@"equipId"];
    friend.equipIcon = [locationInfor objectForKey:@"equipIcon"];
    friend.equipName = [locationInfor objectForKey:@"equipName"];
    friend.gender = [[locationInfor objectForKey:@"gender"]intValue];
    
   
    JPSThumnail *empire = [[JPSThumnail alloc] init];
    empire.title = [locationInfor objectForKey:@"address"];
    empire.subtitle = [locationInfor objectForKey:@"createTime"];
    empire.coordinate = CLLocationCoordinate2DMake(lat,lon);
    __unsafe_unretained BDMapViewController *safeSelf = self;
    empire.disclosureBlock = ^{
        
        
        FriendInfoViewController *infoVC = [[FriendInfoViewController alloc]init];
        
        safeSelf.valueDelegate = infoVC;
        
        [safeSelf.valueDelegate setValue:friend];
        
        [safeSelf.navigationController pushViewController:infoVC animated:YES];
        
        [safeSelf hideTabBar];
        
    };
    
    empire.info = locationInfor;
    
    JPSThumbnailAnnotation *annot = [JPSThumbnailAnnotation annotationWithThumbnail:empire];
    
    if (_annotFriends == nil) {
        _annotFriends = [NSMutableArray array];
    }
    
    //判断地图是否存在了这个用户
    NSArray *tmpArray = [_annotFriends filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"equipId contains[cd] %@", friend.equipId]];
    
    
    //不存在这个用户，就在地图上添加
    if (tmpArray.count == 0) {
//        [self.mapView.bMapView removeAnnotations:_annots];
        [_annotFriends addObject:friend];
        [_annots addObject:annot];
        [self.mapView.tMapView addAnnotations:_annots];
        [self.mapView.tMapView addAnnotation:annot];
    }
  
    
    if (center) {
       // self.mapView.tMapView.showsUserLocation = NO;
        self.mapView.tMapView.ShowPosition=NO;
         [self.mapView.tMapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lon) animated:YES];
    }
    
    NSArray *arrayTmp = [self.arrayRecentFriend filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"equipId contains[cd] %@", friend.equipId]];
    
    //对象已经存在列表中
    if (arrayTmp.count > 0) {
        return;
    }
    
    //如果列表中数据已经满，则删除最后一个
    if(self.arrayRecentFriend.count == RECENT_FRIEND_COUNT)
        [self.arrayRecentFriend removeObjectAtIndex:RECENT_FRIEND_COUNT - 1];
    
    [self.arrayRecentFriend addObject:friend];
    [_friendStorage saveFriend:self.arrayRecentFriend];
    
    [self.mapView setFriendListData:self.arrayRecentFriend];
}

#pragma mark - BaseViewDelegate
-(void)btnClick:(id)obj{
   
    _selectedFriend = obj;
    //处理快捷方式点击头像事件
    [_friendHandler getFriendCurrentLocation:_selectedFriend.equipId];

    
}

#pragma mark -
#pragma mark -显示好友位置

-(void)showFriendLocationNotification:(NSNotification *)notification{
   
     NSDictionary *locationInfor=notification.object;
    [self showFriendLocationOnMap:locationInfor isCenter:YES];
 
}


//当前屏幕显示区域内请求
-(void)requestSearchFriendInArea{
    /*
    BMKCoordinateRegion region = self.mapView.bMapView.region;
    
    CLLocationCoordinate2D coor0;
    CLLocationCoordinate2D coor1;
    
    coor0.latitude =  region.center.latitude + region.span.latitudeDelta;
    coor0.longitude = region.center.longitude + region.span.longitudeDelta;
    coor1.latitude =  region.center.latitude - region.span.latitudeDelta;
    coor1.longitude = region.center.longitude - region.span.longitudeDelta;
    
    NSString *secPoint= [NSString stringWithFormat:@"%f,%f",coor0.longitude,coor0.latitude];
    NSString *firstPoint = [NSString stringWithFormat:@"%f,%f",coor1.longitude,coor1.latitude];
    NSDictionary *params = @{@"first":firstPoint,@"second":secPoint};
    
    [_friendHandler searchFriendInArea:params];
     
*/
}


#pragma mark - BMKMapViewDelegate

- (void)mapView:(TMapView *)mapView didSelectAnnotationView:(TAnnotationView *)view
{
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:self.mapView.tMapView];
    }
}

- (void)mapView:(TMapView *)mapView didDeselectAnnotationView:(TAnnotationView *)view
{
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:self.mapView.tMapView];
    }
    
}

- (TAnnotationView *)mapView:(TMapView *)mapView
             viewForAnnotation:(id <TAnnotation>)annotation{
    
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation)
                annotationViewInMap:self.mapView.tMapView];
    }
    
    
    
    return nil;
}

#define TIME_INTERVAL 2

- (void)mapView:(TMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    //等待两秒如果地图没有移动就发送请求
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(requestSearchFriendInArea) userInfo:nil repeats:NO];
    
}


#pragma mark - PassValueDelegate
- (void)setValue:(NSObject *)value{
    //通讯录界面回调，显示好友位置
    NSDictionary *locationInfor = (NSDictionary *)value;
    [self showFriendLocationOnMap:locationInfor isCenter:YES];
}

@end
