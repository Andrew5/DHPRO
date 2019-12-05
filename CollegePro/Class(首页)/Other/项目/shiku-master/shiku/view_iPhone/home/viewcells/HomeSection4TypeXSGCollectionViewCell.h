//
//  HomSection4CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/4/2.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/AdItem.h>
#import <XZFramework/JDFlipNumberView.h>
#import <XZFramework/JDGroupedFlipNumberView.h>
#import <XZFramework/JDDateCountdownFlipView.h>
#import "SBTickerView.h"
#import "SBTickView.h"



@interface HomeSection4TypeXSGCollectionViewCell : TUICollectionViewCell
{
    NSDateFormatter *dateformatter;
     JDDateCountdownFlipView *flipView;
    NSString *_currentClock;
    NSArray *_clockTickers;
    SBTickerView *clockTickerViewDay1;
    SBTickerView *clockTickerViewDay2;
    SBTickerView *clockTickerViewHour1;
    SBTickerView *clockTickerViewHour2;
    SBTickerView *clockTickerViewMinute1;
    SBTickerView *clockTickerViewMinute2;
    SBTickerView *clockTickerViewSecond1;
    SBTickerView *clockTickerViewSecond2;
     CGFloat clockfontsize;
     NSDate *targetDate;
}


@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UIButton *btn_fav;
@property (weak, nonatomic) IBOutlet UIButton *btn_cart;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIView *timerContainer;
@property (strong,nonatomic) AdItem *aditem;
@end
