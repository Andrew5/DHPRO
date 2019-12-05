//
//  TConfig.h
//  btc
//
//  Created by txj on 15/1/25.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PartnerID @""
//收款支付宝账号
#define SellerID  @""

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @""

//商户私钥，自助生成
#define PartnerPrivKey @""

//支付宝公钥
#define AlipayPubKey @""
@interface TConfig : NSObject
@property (strong, nonatomic) UIColor *APP_MAIN_COLOR;
@property (strong, nonatomic) UIColor *APP_SPLITE_COLOR;
@property (strong, nonatomic) NSString *backendURL;
@property (strong, nonatomic) NSString *OAuthAccessTokenURL;
@property (strong, nonatomic) NSString *devid;
@property (strong, nonatomic) NSString *devtype;
@property (strong, nonatomic) NSString *currlng;
@property (strong, nonatomic) NSString *currlat;

+ (instancetype)shared;
@end
