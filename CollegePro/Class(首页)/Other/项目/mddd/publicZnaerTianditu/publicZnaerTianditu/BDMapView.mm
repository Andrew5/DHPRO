//
//  BDMapView.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BDMapView.h"
#import "UIButton+AFNetworking.h"
#import "FriendEntity.h"
#import "BaseHandler.h"
@implementation BDMapView
{
    NSArray *_recentFriendArray;
}

@synthesize headsView;

#define CELL_IDENTIFIER @"CELL_IDENTIFIER"

-(void)layoutView:(CGRect)frame
{
    self.tMapView = [[TMapView alloc]initWithFrame:frame];
    [self addSubview:self.tMapView];
    
    self.locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, frame.size.height * 0.8, 42, 42)];
    [self.locationBtn setImage:[UIImage imageNamed:@"gongxiang.png"] forState:UIControlStateNormal];
    [self.locationBtn setImage:[UIImage imageNamed:@"gongxiang_sel.png"] forState:UIControlStateHighlighted];

    [self addSubview:self.locationBtn];

    self.peopleBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 10 - 42, frame.size.height * 0.8, 42, 42)];
    [self.peopleBtn setImage:[UIImage imageNamed:@"liebiao.png"] forState:UIControlStateNormal];
    [self.peopleBtn setImage:[UIImage imageNamed:@"liebiao_sel.png"] forState:UIControlStateHighlighted];
    [self.peopleBtn setImage:[UIImage imageNamed:@"hide_icon.png"] forState:UIControlStateSelected];
    
    [self.peopleBtn addTarget:self action:@selector(showAndHidePeopleList) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.peopleBtn];
    
    headsView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width-50, self.peopleBtn.frame.origin.y, 40, 0)];
    headsView.backgroundColor = [UIColor clearColor];
    headsView.hidden = YES;
    [self insertSubview:headsView belowSubview:self.peopleBtn];
}

-(void)showAndHidePeopleList{
    if (headsView.frame.size.height == 0) {
        headsView.hidden = NO;
        [UIView beginAnimations:@"showAnimation" context:nil];
        [UIView setAnimationDuration:0.25];
        headsView.frame = CGRectMake(self.frame.size.width-50, self.peopleBtn.frame.origin.y - 160, 40, 200);
        [UIView commitAnimations];
        self.peopleBtn.selected = YES;
    }else{
        [UIView beginAnimations:@"hideAnimation" context:nil];
        [UIView setAnimationDuration:0.25];
        headsView.frame = CGRectMake(self.frame.size.width-50, self.peopleBtn.frame.origin.y, 40, 0);
        [UIView commitAnimations];
        headsView.hidden = YES;
        self.peopleBtn.selected = NO;
    }
}

-(void)setFriendListData:(NSArray *)datas{
    
    _recentFriendArray = datas;
    
    for (int i = 0; i < _recentFriendArray.count; i ++ ) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 150 - i * (40 + 10) - 30, 40, 40);
        btn.tag = i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.0f;
        [btn addTarget:self action:@selector(friendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        FriendEntity *entity = _recentFriendArray[i];
        NSString *placeHolderHead = (entity.gender == SEXMAN ? @"user_man.png" : @"user_woman.png");
        
        NSString *imageUrl = [BaseHandler retImageUrl:entity.equipIcon];
        NSURL *url = [NSURL URLWithString:imageUrl];
        
        [btn setImageForState:UIControlStateNormal withURL:url placeholderImage:[UIImage imageNamed:placeHolderHead]];
        
        [headsView addSubview:btn];
    }
    
}

-(void)friendBtnAction:(UIButton *)btn{
    FriendEntity *entity = _recentFriendArray[btn.tag];
    [self.baseViewDelegate btnClick:entity];
}

@end
