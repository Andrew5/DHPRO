//
//  HomeMapViewController.h
//  shiku
//
//  Created by Rilakkuma on 15/7/24.
//  Copyright (c) 2015年 txj. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "CategoryViewController.h"
#import "GuideViews.h"
@interface HomeMapViewController : TBaseUIViewController<BMKGeoCodeSearchDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    CGFloat pointX;

}
@property(strong,nonatomic) BMKMapView *mapView;
@property(strong,nonatomic) BMKLocationService *locService;
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property(strong,nonatomic) BMKPoiSearch *searcher;

@property (weak, nonatomic) IBOutlet UIButton *btnRound;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnRoundMarginLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnThinkOvewMarginLeft;

@property (weak, nonatomic) IBOutlet UIButton *btnThinkOvew;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) IBOutlet GuideViews* guideView;
@end
