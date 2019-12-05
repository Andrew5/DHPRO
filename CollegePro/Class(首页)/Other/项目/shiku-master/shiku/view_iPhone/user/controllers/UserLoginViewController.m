//
//  UerLoginViewController.m
//  shiku
//
//  Created by txj on 15/5/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserLoginViewController.h"
#import <CocoaSecurity.h>
#import "CartViewController.h"
#import "AppDelegate.h"
@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"用户登录";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    self.backend=[UserBackend shared];
    
    _backgroundView.layer.cornerRadius=5;
    
    self.loginBtn.backgroundColor=RGBCOLORV(0x7a9c5c);//MAIN_COLOR;
    self.loginBtn.layer.cornerRadius=5;
    [self.loginBtn setTintColor:WHITE_COLOR];
    
    
    
    self.registerBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    [self.registerBtn setTintColor:TEXT_COLOR_DARK];
    
//    [self.lbOtherLoginLabel setTextColor:TEXT_COLOR_DARK];
    [self.lbqqlogin setTextColor:TEXT_COLOR_DARK];
    [self.lbwblogin setTextColor:TEXT_COLOR_DARK];
    [self.lbwxlogin setTextColor:TEXT_COLOR_DARK];
    
    self.forgetPassworBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    [self.forgetPassworBtn setTintColor:TEXT_COLOR_DARK];
    
    [self.validationView setHidden:YES];
    
    //第三方登录
    AppDelegate *delgate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    delgate.delegate_weibo=self;
    delgate.delegate_wx=self;
    _tencentOAuth=[[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:self];
    _qqpermissions =[[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil]]
    ;

    if (!self.user) {
        self.user=[USER new];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)callKeyboard{
    [self.view endEditing:YES];
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
#pragma 用户登录
- (IBAction)loginBtnTapped:(id)sender {
    
    if([self validateMobile:self.usernameLabel.text]||[self.usernameLabel.text isEqualToString:@"12345678911"]){
    
    USER *u=[USER new];
    u.name=self.usernameLabel.text;
    u.password=[CocoaSecurity md5:self.userPassworLabel.text].hexLower;
    [[self.backend requestAuthenticate:u]
     subscribeNext:[self didGetUserInfoSuccess]];
        
    }
    else{
        [self.view showHUD:@"请输入正确的手机号" afterDelay:1];
    }
}
- (void(^)(AccessToken *))didAuthencateUserSuccess
{
    return ^(AccessToken *token) {
        
        if (token==nil) {
            [self.view showHUD:@"用户名或密码错误" afterDelay:2];
        }else{
            [self.backend.repository storageToken:token];
            [[self.backend requestUser:token]
             subscribeNext:[self didGetUserInfoSuccess]];
        }
    };
}
- (void(^)(USER *))didGetUserInfoSuccess
{
    return ^(USER *user) {
        if (user==nil) {
//            [self.view showHUD:@"用户名或密码错误" afterDelay:2];
        }else{
            [[App shared] setCurrentUser:user];
            [self.backend.repository storage:user];
            CartViewController *cb=[[CartViewController alloc]init];
            [cb setup];
            if ([self.delegate respondsToSelector:@selector(authencateUserSuccess:authController:)]) {
                [self.delegate authencateUserSuccess:user authController:self];
            }
            else{
                [self goBack];
            }
        }
    };
}

- (IBAction)loginBtnWbTapped:(id)sender//新浪微博登录按钮
{
//    [self wbssoButtonPressed];
}
- (IBAction)loginBtnWxTapped:(id)sender{//微信登录按钮
    [self wxssoButtonPressed];
}
- (IBAction)loginBtnQQTapped:(id)sender{//qq登录按钮
    [self qqssoButtonPressed];
}
- (IBAction)registerBtnTapped:(id)sender {
    UserRegisterStep1ViewController *c=[UserRegisterStep1ViewController new];
    c.stateN = 12;
    [self.navigationController pushViewController:c animated:YES];
}

- (IBAction)forgetPasswordBtnTapped:(id)sender {
    UserRegisterStep1ViewController *c=[[UserRegisterStep1ViewController alloc] initWithRestPsw:YES];
    c.stateN = 13;
    [self.navigationController pushViewController:c animated:YES];
}




-(void)qqssoButtonPressed
{
    [_tencentOAuth authorize:_qqpermissions inSafari:NO];
    if (_tencentOAuth.getUserInfo == YES) {
        NSLog(@"xianshi ");
    }else{
        NSLog(@"buxianshi ");

    }
}

//用户绑定结束
-(void)finishBindUser:(USER *)anUser bindController:(UserBindViewController *)controller
{
    if ([self.delegate respondsToSelector:@selector(authencateUserSuccess:authController:)]) {
        [self.delegate authencateUserSuccess:anUser authController:self];
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}

//用户绑定失败
- (void(^)(NSError *))didAuthencateUserFailure
{
    return ^(NSError *error) {
        [self.view showHUD:error.localizedDescription afterDelay:1];
    };
}
//用户绑定成功
- (void(^)(USER *))didAuthencateUserBindSuccess
{
    return ^(USER *user) {
        if (user==nil) {
            [self bindUser];
        }else{
//            [[self.backend requestAuthenticate:user]
//             subscribeNext:[self didGetUserInfoSuccess]];
            if ([self.delegate respondsToSelector:@selector(authencateUserSuccess:authController:)]) {
                [self.delegate authencateUserSuccess:user authController:self];
            }
            else{
                [self goBack];
            }
        }
    };
}
-(void)bindUser
{
    UserBindViewController *c=[[UserBindViewController alloc] initWithUserMode:self.user];
    c.delegate=self;
    [self.navigationController pushViewController:c animated:YES];
}

//#pragma mark -
//#pragma WBHttpRequestDelegate
//
//- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
//{
//    NSString *title = nil;
//    UIAlertView *alert = nil;
//    
//    title = NSLocalizedString(@"收到网络回调", nil);
//    alert = [[UIAlertView alloc] initWithTitle:title
//                                       message:[NSString stringWithFormat:@"%@",result]
//                                      delegate:nil
//                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                             otherButtonTitles:nil];
//    [alert show];
//}
//
//- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
//{
//    NSString *title = nil;
//    UIAlertView *alert = nil;
//    
//    title = NSLocalizedString(@"请求异常", nil);
//    alert = [[UIAlertView alloc] initWithTitle:title
//                                       message:[NSString stringWithFormat:@"%@",error]
//                                      delegate:nil
//                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                             otherButtonTitles:nil];
//    [alert show];
//}
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
//{
//    
//}
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
//{
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
//    {
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
//        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
//        if (accessToken)
//        {
//            self.wbtoken = accessToken;
//        }
//        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
//        if (userID) {
//            self.wbCurrentUserID = userID;
//        }
//        [alert show];
//    }
//    else if ([response isKindOfClass:WBAuthorizeResponse.class])
//    {
//        self.user.usertype=@"wb";
//        self.user.keyid=[(WBAuthorizeResponse *)response userID];
//        [[self.backend requestAuthenticateUserBind:self.user]
//         subscribeNext:[self didAuthencateUserBindSuccess]
//         error:[self didAuthencateUserFailure]];
////                NSString *title = NSLocalizedString(@"认证结果", nil);
////                NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
////                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
////                                                                message:message
////                                                               delegate:nil
////                                                      cancelButtonTitle:NSLocalizedString(@"确定", nil)
////                                                      otherButtonTitles:nil];
////        
////                self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
////                self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
////                [alert show];
//    }
//    else if ([response isKindOfClass:WBPaymentResponse.class])
//    {
//        NSString *title = NSLocalizedString(@"支付结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//}

#pragma mark -pragma TencenSessionDelegate
- (void)tencentDidNotNetWork
{
    NSLog(@"没有网络");
}
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"登录失败");
}
- (void)getUserInfoResponse:(APIResponse*) response{
    
}

- (void)tencentDidLogin
{
    //    NSLog(@"登录成功");
    //    NSLog(@"token===%@",[_tencentOAuth accessToken] );
    //    NSLog(@"openId===%@",[_tencentOAuth openId]) ;
    //    NSLog(@"appid === %@",[_tencentOAuth appId]);
    self.user.usertype=@"qq";
    self.user.keyid=[_tencentOAuth openId];
    self.user.keyid = [CocoaSecurity md5:self.user.keyid].hexLower;
    

    [[self.backend requestAuthenticateUserBind:self.user]
     subscribeNext:[self didAuthencateUserBindSuccess]
     error:[self didAuthencateUserFailure]];
   
    
//    [self loadDataValueAndKeyid:self.user.keyid Type:self.user.usertype Username:<#(NSString *)#> Img:<#(NSString *)#>];
}
/**
 * 初始化TencentOAuth对象
 * \param appId 第三方应用在互联开放平台申请的唯一标识
 * \param delegate 第三方应用用于接收请求返回结果的委托对象
 * \return 初始化后的授权登录对象
 */
-(void)loadDataValueAndKeyid:(NSString *)keyid
                        Type:(NSString *)type
                    Username:(NSString *)username
                         Img:(NSString *)img{
    NSString *urlStr1 = @"http://www.shiku.cc/buyerApi/user_bind/callback";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"keyid":keyid,@"type":type,@"username":username,@"img":img}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [manager POST:urlStr1  parameters:@{@"data":jsonStr}
          success:^(AFHTTPRequestOperation *operation,id json) {
              SBJsonParser *parser = [[SBJsonParser alloc]init];
              NSDictionary *dictArray = [parser objectWithString:operation.responseString];
              NSLog(@"callback data %@",dictArray);
          }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              printf("失败");
              
          }
     ];
    
}

#pragma mark -pragma WeiXinSessionDelegate
-(void)wxssoButtonPressed
{
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}
//第一步获取code
- (void)onResp:(BaseResp *)resp {
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0) {
        NSString *code = aresp.code;
        //NSDictionary *dic = @{@"code":code};
        [self getAccess_token:code];
    }
}
//第二步：token和openid
-(void)getAccess_token:(NSString *)wxcode
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAppKey,kWXAppSecret,wxcode];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                [self getUserInfo:[dic objectForKey:@"access_token"] withOpenId:[dic objectForKey:@"openid"]];
                
            }
        });
    });
}
//第三步：userinfo
-(void)getUserInfo:(NSString *)accessToken withOpenId:(NSString *)openid
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                
//                self.nickname.text = [dic objectForKey:@"nickname"];
//                self.wxHeadImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
                NSLog(@"--1--%@",[dic objectForKey:@"nickname"]);
                NSLog(@"--2--%@",[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]]);
                self.user.usertype=@"wx";
                self.user.keyid=openid;
                [[self.backend requestAuthenticateUserBind:self.user]
                 subscribeNext:[self didAuthencateUserBindSuccess]
                 error:[self didAuthencateUserFailure]];
                
            }
        });
        
    });
}


@end
