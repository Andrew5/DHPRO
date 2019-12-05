//
//  OrderManager.m
//  shiku
//
//  Created by  on 15/9/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "OrderManager.h"

@implementation OrderManager

static OrderManager* _order = nil;

+ (OrderManager*)shareOrederManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (_order==nil) {
            _order = [[OrderManager alloc]init];
            [_order getNumFromUser];
        }
    });
    return _order;
}

- (void)getNumFromUser
{
    NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
    _order.orderNum =[[myUser objectForKey:@"order"] integerValue];
    _order.sendNum = [[myUser objectForKey:@"sendNum"] integerValue];
    _order.recerveNum = [[myUser objectForKey:@"receive"] integerValue];
    _order.refundNum = [[myUser objectForKey:@"refund"] integerValue];
}
+ (void)changeOrderNum
{

}
+ (void)changeReceiceNum
{

}
+ (void)changeRefundNUm
{

}
+ (void)changeSendNum
{

}
+ (void)saveData
{
    NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
    
    _order.orderNum = _order.orderNum<0?0:_order.orderNum;
    _order.refundNum = _order.refundNum<0?0:_order.refundNum;
    _order.recerveNum = _order.recerveNum<0?0:_order.recerveNum;
    _order.sendNum = _order.sendNum<0?0:_order.sendNum;
    [myUser setObject:[NSNumber numberWithInteger:_order.orderNum] forKey:@"order"];
    
    [myUser setObject:[NSNumber numberWithInteger:_order.sendNum] forKey:@"sendNum"];
    
    [myUser setObject:[NSNumber numberWithInteger:_order.recerveNum] forKey:@"receive"];
   
    [myUser setObject:[NSNumber numberWithInteger:_order.refundNum] forKey:@"refund"];
}
@end
