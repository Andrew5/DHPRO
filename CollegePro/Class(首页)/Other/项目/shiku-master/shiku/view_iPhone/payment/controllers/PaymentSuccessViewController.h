//
//  PayMentSuccessViewController.h
//  shiku
//
//  Created by txj on 15/5/23.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  支付成功界面
 *  各属性请对照.xib文件
 */
@interface PaymentSuccessViewController : TBaseUIViewController
@property (strong, nonatomic) ORDER *order;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *paySnLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *orderInfoContainer;

-(instancetype)initWithOrder:(ORDER *)anOrder;
@end
