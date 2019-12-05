//
//  PaymentViewController.m
//  shiku
//
//  Created by txj on 15/5/14.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "PaymentViewController.h"
#import "PaymentSuccessViewController.h"

#import "AppDelegate.h"

#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlixPayOrder.h"
//APP端签名相关头文件
#import "payRequsestHandler.h"

//服务端签名只需要用到下面一个头文件
//#import "ApiXml.h"
#import <QuartzCore/QuartzCore.h>

#define TableCell @"OrderSummaryTableViewCell"
#define TableCell2 @"PaymentTableViewCell"
NSString * const HUDDismissNotification = @"HUDDismissNotification";

@interface PaymentViewController ()

@end

@implementation PaymentViewController
-(instancetype)initWithOrder:(ORDER *)anOrder
{
    self=[self init];
    if (self) {
        self.order=anOrder;
        self.backend=[PaymentBackend new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title=@"选择支付方式";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    
    
    paymentIconArray=[[NSMutableArray alloc] initWithArray:@[@"zfb.png",@"wxzf.png"]];
    paymentTextArray=[[NSMutableArray alloc] initWithArray:@[@"支付宝",@"微信支付"]];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:TableCell bundle:nil] forCellReuseIdentifier:TableCell];
    [self.tableView registerNib:[UINib nibWithNibName:TableCell2 bundle:nil] forCellReuseIdentifier:TableCell2];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return favoriteList.count;
    if (section==0) {
        return 1;
    }
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        OrderSummaryTableViewCell *cell = (OrderSummaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.order=self.order;
        [cell bind];
        return cell;
    }
    else{
        PaymentTableViewCell *cell = (PaymentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCell2 forIndexPath:indexPath];
//        cell.imageView.image=[UIImage imageNamed:[paymentIconArray objectAtIndex:indexPath.row]];
//        cell.nameLabel.text=[paymentTextArray objectAtIndex:indexPath.row];
        
        [cell setCellContent:[paymentTextArray objectAtIndex:indexPath.row] withImageName:[paymentIconArray objectAtIndex:indexPath.row]];
//                SHOP_ITEM *item=[self.cart.checkout_shop_list objectAtIndex:indexPath.section];
                //    cell.delegate = self;
//                cell.cartItem=[item.cart_goods_list objectAtIndex:indexPath.row];
//                cell.cartItem.indexPath=indexPath;
                //    cell.cartItem.isInEditMode=isTableCellEdit;
        
                [cell bind];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 100;
    }
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PaymentSuccessViewController *ps=[[PaymentSuccessViewController alloc] initWithOrder:self.order];
//    [self.navigationController pushViewController:ps animated:YES];
    
//    progressbar.labelText=@"支付中";
//    [progressbar show:YES];
    if (indexPath.section == 0) {
        
    }
    else if (indexPath.section == 1){
        if(indexPath.row==0)
        {
            [[self.backend requestCheckout:self.order payId:3] subscribeNext:[self didSubmit]];
        }
        else if(indexPath.row==1){
            [[self.backend requestCheckout:self.order payId:4] subscribeNext:[self didSubmit]];
        }
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void(^)(RACTuple *))didSubmit
{
    //    @weakify(self)
    return ^(RACTuple *parameters) {
        
        
        PAYMENT *payment=(PAYMENT *)parameters;
        
        if (payment.type==PaymentTypeAlipay) {
            NSString *appScheme = @"alisdkshiku";
            [[AlipaySDK defaultService] payOrder:payment.sign fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                BaseResp *br=[[BaseResp alloc] init];
                if ([[resultDic objectForKey:@"resultStatus"] intValue]==6001) {
                    br.errCode=-2;
                }
                else if ([[resultDic objectForKey:@"resultStatus"] intValue]==9000) {
                    br.errCode=0;
                }
                else {
                    br.errCode=-1;
                }
                [self onResp:br];
            }];
        }
        else
        {
            PayReq *request = [[PayReq alloc] init];
            request.openID=payment.appid;
            request.partnerId = payment.partner_id;
            
            //            request.prepayId=@"wx2015042521303170a977f2ef0721904873";
            //            request.nonceStr=@"6e4621af9a4da94a7c85d7ecd19b1271";
            //            NSMutableString *s=[[NSMutableString alloc] initWithString:@"1429968631"];
            //            request.timeStamp=[s intValue];
            //            request.sign=@"CEBE137C95CDD65D8516A9FF228A1B62";
            
            
            request.prepayId= payment.prepay_id;
            request.nonceStr= payment.nonceStr;
            request.timeStamp=[payment.time_stamp intValue];
            request.package =payment.package;
            request.sign= payment.sign;
            
            
            [WXApi safeSendReq:request];
            
        }
        
        [progressbar hide:YES];
        //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
        //        @strongify(self)
        
        
        
    };
}

#define PAY_SUCCESS @"支付成功！"

/*===============================微信支付=================================
 ========================================================================
 */
- (void)onResp:(BaseResp *)resp {
    if (YES) {
        //if ([resp isKindOfClass:[PayResp class]]) {
        
        NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
        
        NSString *strMsg = nil;
        if(resp.errCode==0)
        {
            strMsg=PAY_SUCCESS;
        }
        else if(resp.errCode==-1)
        {
            strMsg=@"支付失败，稍后再试（错误代码：-1）！";
        }
        else if(resp.errCode==-2)
        {
            strMsg=@"您已取消支付。";
        }
        else
        {
            strMsg=@"支付失败，未知错误。";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:strMsg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        alert.delegate=self;
        [alert show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HUDDismissNotification object:nil userInfo:nil];
        
        [self.tableView reloadData];
    }
    
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:PAY_SUCCESS]) {
        PaymentSuccessViewController *ps=[[PaymentSuccessViewController alloc] initWithOrder:self.order];
        [self.navigationController pushViewController:ps animated:YES];
    }
    //    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
}

//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismissWithButtonIndex");
}

//ALertView即将消失时的事件
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"willDismissWithButtonIndex");
}

//AlertView的取消按钮的事件
-(void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"alertViewCancel");
}

//AlertView已经显示时的事件
-(void)didPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"didPresentAlertView");
}

//AlertView即将显示时
-(void)willPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"willPresentAlertView");
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
