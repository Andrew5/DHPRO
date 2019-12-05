//
//  PayMentSuccessViewController.m
//  shiku
//
//  Created by txj on 15/5/23.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "PaymentSuccessViewController.h"

@interface PaymentSuccessViewController ()

@end

@implementation PaymentSuccessViewController
-(instancetype)initWithOrder:(ORDER *)anOrder
{
    self=[self init];
    if (self) {
        self.order=anOrder;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"选择支付方式";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    
    self.orderIdLabel.text=[NSString stringWithFormat:@"订单编号：%@",self.order.order_info.order_id];
    self.paySnLabel.text=[NSString stringWithFormat:@"支付交易号：%@",self.order.payment_item.pay_code];
    self.orderTimeLabel.text=[NSString stringWithFormat:@"成交时间：%@",self.order.order_info.order_time];
    self.payTimeLabel.text=[NSString stringWithFormat:@"支付时间：%@",self.order.payment_item.pay_time];
    
    self.orderInfoContainer.backgroundColor=MAIN_COLOR;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
