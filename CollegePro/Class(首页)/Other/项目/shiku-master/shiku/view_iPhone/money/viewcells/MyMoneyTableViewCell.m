//
//  MyMoneyTableViewCell.m
//  shiku
//
//  Created by yanglele on 15/9/9.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "MyMoneyTableViewCell.h"
@interface MyMoneyTableViewCell ()

@property(nonatomic ,strong)UILabel * m_TypeLabel;

@property(nonatomic ,strong)UILabel * m_TimeLabel;

@property(nonatomic ,strong)UILabel * m_MoneyLabel;

@end

@implementation MyMoneyTableViewCell

- (void)awakeFromNib {
   
    [self createView];
}

-(void)createView
{
    self.m_TypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    self.m_TypeLabel.textColor = [UIColor blackColor];
    self.m_TypeLabel.textAlignment = NSTextAlignmentLeft;
    self.m_TypeLabel.font = [UIFont systemFontOfSize:14];
    self.m_TypeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.m_TypeLabel];
    
    self.m_TimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 200, 15)];
    self.m_TimeLabel.textColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1.0];
    self.m_TimeLabel.textAlignment = NSTextAlignmentLeft;
    self.m_TimeLabel.font = [UIFont systemFontOfSize:12];
    self.m_TimeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.m_TimeLabel];
    
    self.m_MoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 20, self.frame.size.width-225,20)];
    self.m_MoneyLabel.textColor = [UIColor colorWithRed:0.39 green:0.62 blue:0.53 alpha:1.0];
    self.m_MoneyLabel.textAlignment = NSTextAlignmentRight;
    self.m_MoneyLabel.font = [UIFont systemFontOfSize:18];
    self.m_MoneyLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.m_MoneyLabel];
}

-(void)reloadMode:(NSDictionary *)m_dict
{
    if (m_dict) {
        switch ([[m_dict objectForKey:@"type"] integerValue]) {
            case 1:
            {
                if ([[m_dict objectForKey:@"status"] integerValue]==1) {
                    self.m_TypeLabel.text = @"支付宝申请提现";
                }
                else if([[m_dict objectForKey:@"status"] integerValue]==2)
                {
                    self.m_TypeLabel.text = @"支付宝提现成功";
                }
            
            }
            break;
            case 2:
            {
                if ([[m_dict objectForKey:@"status"] integerValue]==1) {
                    self.m_TypeLabel.text = @"微信申请提现";
                }
                else if([[m_dict objectForKey:@"status"] integerValue]==2)
                {
                    self.m_TypeLabel.text = @"微信提现成功";
                }

            }
                break;
            case 3:
            {
                if ([[m_dict objectForKey:@"status"] integerValue]==1) {
                    self.m_TypeLabel.text = @"银行卡申请提现";
                }
                else if([[m_dict objectForKey:@"status"] integerValue]==2)
                {
                    self.m_TypeLabel.text = @"银行卡提现成功";
                }

            
            }
                break;
            default:
                break;
        }
        
        if ([m_dict objectForKey:@"add_time"]&&[[m_dict objectForKey:@"add_time"] length]>0) {
            self.m_TimeLabel.text = [m_dict objectForKey:@"add_time"];
        }
        if ([m_dict objectForKey:@"money"]&&[[m_dict objectForKey:@"money"] length]>0) {
            self.m_MoneyLabel.text = [NSString stringWithFormat:@"-%@",[m_dict objectForKey:@"money"]];
            if ([[m_dict objectForKey:@"status"] integerValue]==2) {
                self.m_MoneyLabel.textColor = [UIColor orangeColor];
            }
        }
    }


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
