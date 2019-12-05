//
//  OrderAssembler.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "PaymentAssembler.h"

@implementation PaymentAssembler
- (PAYMENT *)paymentWithJSON:(NSDictionary *)paymentJSON
{
    PAYMENT *payment;
    payment = [[PAYMENT alloc] init];
    NSString *paytype=[NSString stringWithFormat:@"%@",[paymentJSON objectForKey:@"pays"]];
    if ([paytype isEqualToString:@"3"]) {
        NSDictionary *data=[paymentJSON objectForKey:@"ali_pay_result"];
        payment.type=PaymentTypeAlipay;
        payment.sign=[data objectForKey:@"orderString"];
    }
    else{
        NSDictionary *data=[paymentJSON objectForKey:@"wx_pay_result"];
        
        payment.type=PaymentTypeWeixin;
        payment.appid=[data objectForKey:@"appid"];
        payment.nonceStr=[data objectForKey:@"noncestr"];
        payment.package=[data objectForKey:@"package"];
        payment.partner_id=[data objectForKey:@"partnerid"];
        payment.prepay_id=[data objectForKey:@"prepayid"];
        payment.sign=[data objectForKey:@"sign"];
        payment.time_stamp=[data objectForKey:@"timestamp"];
        
        // NSLog([[paymentJSON objectForKey:@"signStr"] stringValue]);
    }
    
    return payment;
}
@end
