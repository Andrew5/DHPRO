//
//  EmptyViewController.h
//  btc
//
//  Created by txj on 15/3/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *   空页面模板
 */

@interface EmptyData : NSObject
@property (assign, nonatomic) NSString *iconText;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *subTitleText;
@end

@interface EmptyViewController : UIViewController
{
    NSString *titletext,*subtitletext,*icontext;
}

@property (assign, nonatomic) BOOL authenticated;

@property (strong, nonatomic) EmptyData *emptyData;

@property (weak, nonatomic) IBOutlet UILabel *iconLable;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

+ (instancetype)shared;
-(IBAction)tapGoHome:(id)sender;
/**
 *  设置提示信息，详情请对照.xib文件
 *
 *  @param icon     页面中间显示的字体图标
 *  @param title    主标题
 *  @param subTitle 副标题（可以为空）
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithIcon:(NSString *)icon andTitle:(NSString *)title subTitle:(NSString *)subTitle;
- (void)bind;
@end
