//
//  SomeoneView.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface SomeoneView : BaseView

@property(nonatomic,retain)UIImageView *headImage;
@property(nonatomic,retain)UILabel     *nameLabel;
@property(nonatomic,retain)UIButton    *codeBtn;

@property(nonatomic,retain)UIButton    *setBtn;

@property(nonatomic,retain)UILabel     *psLabel;

@property(nonatomic,strong)UIButton    *infoBtn;


@end
