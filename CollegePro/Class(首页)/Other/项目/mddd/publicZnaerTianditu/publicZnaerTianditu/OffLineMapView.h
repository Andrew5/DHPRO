//
//  OffLineMapView.h
//  publicZnaer
//
//  Created by Jeremy on 15/1/29.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "BaseView.h"
@interface OffLineMapView : BaseView<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UITableView  *downLoadTableView;
@property(nonatomic,strong)UITableView  *cityTableView;
@property(nonatomic,strong)UIButton     *downLoadBtn;
@property(nonatomic,strong)UIButton     *cityBtn;
@property(nonatomic,strong)UIView       *offView;
@property(nonatomic       )int          currentPage;
@end
