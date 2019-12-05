//
//  CoopViewController.h
//  shiku
//
//  Created by Rilakkuma on 15/9/10.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "TBaseUIViewController.h"
#import "WebViewJavascriptBridge.h"
#import "GoodsDetailShareViewCell.h"
@interface CoopViewController : TBaseUIViewController<UIWebViewDelegate,GoodsDetailShareViewCellDelegate>
/**
 * 背景框
 */
@property (strong, nonatomic) IBOutlet UIView *vbackground;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
/**
 * 财富
 */
@property (strong, nonatomic) IBOutlet UILabel *labelWealth;

/**
 * wealth财富按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *wealthBtn;

/**
 * 社员管理
 */
@property (strong, nonatomic) IBOutlet UIButton *memberBtn;

/**
 * 社长种子
 */
@property (strong, nonatomic) IBOutlet UIButton *societyBtn;

/**
 * 社长优惠码
 */
@property (copy,nonatomic) NSString *tokenStr;

@property WebViewJavascriptBridge* bridge;

@end
