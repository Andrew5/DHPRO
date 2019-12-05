//
//  TButton.h
//  btc
//
//  Created by txj on 15/2/12.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TButtonDelegate <NSObject>

-(void)tbtnTaped;

@end

@interface TButton : UIView
{
    UILabel *bage;
}
@property (strong,nonatomic) UIButton *btn;
@property (assign,nonatomic) int badge;
@property (assign,nonatomic) id<TButtonDelegate> delegate;

-(void)setBadgeNum:(int)badge;
-(NSDecimalNumber *)getBadgeNum;
@end
