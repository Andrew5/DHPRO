//
//  TBaseUIViewController.m
//  shiku
//
//  Created by txj on 15/4/2.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "TBaseUIViewController.h"
#import "UDNavigationController.h"
#import <ShareSDK/ShareSDK.h>
#import "HomeMapViewController.h"
#import "AppDelegate.h"
@implementation UIView (FindFirstResponder)

-(UIView*) findFirstResponder {
    
    if (self.isFirstResponder) return self;
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) return firstResponder;
    }
    return nil;
    
}

@end
@interface TBaseUIViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>

@end

@implementation TBaseUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ISIOS7PLUS=[[[UIDevice currentDevice] systemVersion] floatValue]>=7;
    
    if (ISIOS7PLUS) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    ISIPHONE6=[UIScreen mainScreen].bounds.size.width>750;
    screenSize=self.navigationController.view.frame.size;
    
    //初始化进度框，置于当前的View当中
    progressbar = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:progressbar];
    
    //如果设置此属性则当前的view置于后台
    progressbar.dimBackground = YES;
    progressbar.userInteractionEnabled = NO;
    //设置对话框文字
    progressbar.labelText = LOADING;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIToolbar*)createToolbar {
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(nextTextField)];
    
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(prevTextField)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(textFieldDone)];
    toolBar.items = @[prevButton, nextButton, space, done];
    
    return toolBar;
    
}
-(UIView *)tToolbarSearchField:(CGFloat)width withheight:(CGFloat)height isbecomeFirstResponder:(BOOL)becomeFirstResponder action:(SEL)fun textFieldDelegate:(id<UITextFieldDelegate>)fdelegate
{
    
    CGFloat searchfieldHeight=32;
 
    UIView *searchFieldView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    searchFieldView.backgroundColor=[UIColor blackColor];
    
    UIView *searchField=[[UIView alloc] initWithFrame:CGRectMake(0, (height-searchfieldHeight)/2, ISIPHONE6?width:width-10, searchfieldHeight)];
//    searchField.backgroundColor=[UIColor orangeColor];

    searchField.backgroundColor=WHITE_COLOR;
    searchField.layer.cornerRadius=5;
    
    CGSize iconTextSize = [self getSizeForText:@"\U0000B25A" havingWidth:MAXFLOAT havingHeight:MAXFLOAT andFont:[UIFont fontWithName:@"iconfont" size:22]];
    UILabel *label=[self tIconLable:@"\U0000B07A" withFrame:CGRectMake(8, (searchfieldHeight-iconTextSize.height)/2, iconTextSize.width, iconTextSize.height) fontSize:22 fontColor:TEXT_COLOR_DARK];
//    label.backgroundColor=[UIColor brownColor];

    [searchField addSubview:label];
    
    UITextField *search=[[UITextField alloc] initWithFrame:CGRectMake(40, (searchField.frame.size.height-20)/2, searchField.frame.size.width-label.frame.size.width, 25)];
    search.placeholder=NSLocalizedString(@"你想吃什么？",@"");
    if (fun) {
        [search addTarget:self action:fun forControlEvents:UIControlEventTouchDown];
    }
//    search.delegate = self;
    search.font=[UIFont systemFontOfSize:16];
    //search.backgroundColor=[UIColor blackColor];
    search.returnKeyType=UIReturnKeySearch;
    search.textColor=TEXT_COLOR_DARK;
    if (becomeFirstResponder) {
        [search becomeFirstResponder];
    }
    search.delegate=fdelegate;
    [searchField addSubview:search];
    [searchFieldView addSubview:searchField];
//    search.backgroundColor=[UIColor brownColor];
    [self addListener:searchFieldView action:fun];

    return searchFieldView;
}

-(UIBarButtonItem*)leftBarBtnItem{
    //导航栏添加左右按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(-10, 0, 30,30);
    [leftBtn setImage:[UIImage imageNamed:@"iii_03"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(8,5,5,15)];
    [leftBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    return leftBarBtnItem;
}

-(UIBarButtonItem *)tbarBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(-10, 0, 30,30);
    [backBtn setImage:[UIImage imageNamed:@"iii_03"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(8,5, 5,15)];
//    [backBtn setTitle:@"\U0000A07A" forState:UIControlStateNormal];
//    backBtn.titleLabel.font=[UIFont fontWithName:@"iconfont" size:18];
//    backBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
//    // [backBtn setImage:[UIImage imageNamed:@"image1.png"] forState:UIControlStateNormal];
//    [backBtn setTitleColor:TEXT_COLOR_BLACK forState:UIControlStateNormal];
    
    
    [backBtn addTarget:self action:@selector(goSBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return backItem;
}
-(UIBarButtonItem *)tbarBackButtonWhite
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(-10, 0, 30,30);
    [backBtn setImage:[UIImage imageNamed:@"iii_03"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(8,5, 5,15)];

//    [backBtn setTitle:@"\U0000A07A" forState:UIControlStateNormal];
//    backBtn.titleLabel.font=[UIFont fontWithName:@"iconfont" size:18];
//    backBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
//    // [backBtn setImage:[UIImage imageNamed:@"image1.png"] forState:UIControlStateNormal];
//    [backBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(goABack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return backItem;
}

-(UIBarButtonItem *)tBarButtonItem:(NSString *)text action:(SEL)selctor
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 40);
    backBtn.backgroundColor=[UIColor clearColor];
    [backBtn setTitle:text forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    // [backBtn setImage:[UIImage imageNamed:@"image1.png"] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:selctor forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return backItem;
}
-(UIBarButtonItem *)tBarIconButtonItem:(NSString *)text action:(SEL)selctor
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    //backBtn.backgroundColor=[UIColor blackColor];
    [backBtn setTitle:text forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont fontWithName:@"iconfont" size:25];
    
    // [backBtn setImage:[UIImage imageNamed:@"image1.png"] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:selctor forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return backItem;
}


-(void)addListener:(UIView *)view action:(SEL)fun
{
    view.userInteractionEnabled = YES;
    view.hidden = NO;
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:fun];
    [view addGestureRecognizer:tapGesture];
}
-(UILabel *)tIconLable:(NSString *)iconcode withFrame:(CGRect)frame fontSize:(CGFloat)fsize fontColor:(UIColor *)fcolor
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"iconfont" size:fsize];
    label.text = iconcode;
    label.backgroundColor = [UIColor clearColor];
    label.textColor=fcolor;
    return label;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(CGSize)getSizeForText:(NSString *)text havingWidth:(CGFloat)widthValue  havingHeight:(CGFloat)heightValue andFont:(UIFont *)font
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        return [text boundingRectWithSize:CGSizeMake(widthValue, heightValue)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{
                                            NSFontAttributeName:font,
                                            NSForegroundColorAttributeName: [UIColor blackColor],
                                            }
                                  context:nil].size;
    }
    else{
        return [text sizeWithFont:font
                constrainedToSize:CGSizeMake(widthValue, heightValue)];
    }
}

-(void) nextTextField {
    
    NSUInteger currentIndex = [[self inputViews] indexOfObject:[self.view findFirstResponder]];
    
    NSUInteger nextIndex = currentIndex + 1;
    nextIndex += [[self inputViews] count];
    nextIndex %= [[self inputViews] count];
    
    UITextField *nextTextField = [[self inputViews] objectAtIndex:nextIndex];
    
    [nextTextField becomeFirstResponder];
    
}

-(void) prevTextField {
    
    NSUInteger currentIndex = [[self inputViews] indexOfObject:[self.view findFirstResponder]];
    
    NSUInteger prevIndex = currentIndex - 1;
    prevIndex += [[self inputViews] count];
    prevIndex %= [[self inputViews] count];
    
    UITextField *nextTextField = [[self inputViews] objectAtIndex:prevIndex];
    
    [nextTextField becomeFirstResponder];
    
}
-(NSArray*)inputViews {
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (UIView *eachView in self.view.subviews) {
        
        if ([eachView respondsToSelector:@selector(setText:)]) {
            
            [returnArray addObject:eachView];
            
        }
        
    }
    
    return returnArray;
    
}
-(void) textFieldDone {
    
    [[self.view findFirstResponder] resignFirstResponder];
    
}
-(void)showNavigationView:(UIViewController *)controller
{
    UDNavigationController *thirdNavigationController = [[UDNavigationController alloc]
                                                         initWithRootViewController:controller];
    //导航栏背景颜色
    thirdNavigationController.alphaView.backgroundColor=RGBCOLORV(0X7A9C5C);//BG_COLOR;
    //导航栏title颜色
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];//TEXT_COLOR_BLACK
    
    thirdNavigationController.navigationBar.titleTextAttributes = dict;
    [self presentViewController:thirdNavigationController animated:NO completion:^{}];
    
}
-(void)showNavigationViewMainColor:(UIViewController *)controller
{
    UDNavigationController *thirdNavigationController = [[UDNavigationController alloc]
                                                         initWithRootViewController:controller];
    thirdNavigationController.alphaView.backgroundColor=RGBCOLORV(0X7A9C5C);//[UIColor colorWithRed:121/255.f green:155/255.f blue:92/255.f alpha:1];//RGBCOLORV(0X7A9C5C);
    //  NSDictionary * dict=[NSDictionary dictionaryWithObject:WHITE_COLOR forKey:UITextAttributeTextColor];
    ////
    //  thirdNavigationController.navigationBar.titleTextAttributes = dict;
    
    [self presentViewController:thirdNavigationController animated:NO completion:^{}];
    
}

-(void)showalphaNavigateControl:(UIViewController *)controller
{
    UDNavigationController *thirdNavigationController = [[UDNavigationController alloc]
                                                         initWithRootViewController:controller];
    thirdNavigationController.alphaView.alpha = 0;
    thirdNavigationController.navigationBarHidden = YES;
    //  backgroundColor=RGBCOLORV(0X7A9C5C);
    //  [UIColor colorWithRed:121/255.f green:155/255.f blue:92/255.f alpha:1];
    //  RGBCOLORV(0X7A9C5C);
    //  NSDictionary * dict=[NSDictionary dictionaryWithObject:WHITE_COLOR forKey:UITextAttributeTextColor];
    //  thirdNavigationController.navigationBar.titleTextAttributes = dict;
    
    [self presentViewController:thirdNavigationController animated:NO completion:^{}];
    
}

-(void)goABack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goSBack{

    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)goBack
{
//    HomeMapViewController *u = [[HomeMapViewController alloc]init];
//    [self.navigationController presentViewController:u animated:YES completion:nil];
//    [self.navigationController pushViewController:u animated:YES];
//    [self showNavigationView:u];
//    [self.navigationController popToViewController:u animated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (void(^)(RACTuple *))didUpdate:(NSString *)text
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs=(ResponseResult *)parameters;
        if (rs.success) {
            [self.view showHUD:text afterDelay:2];
        }
        else{
            [self.view showHUD:rs.messge afterDelay:2];
        }
        
    };
}
- (void(^)(RACTuple *))didUpdate:(NSString *)text withTableView:(UITableView *)tableview
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs=(ResponseResult *)parameters;
        if (rs.success) {
            [self.view showHUD:text afterDelay:2];
            [tableview reloadData];
            
            [self dismissViewControllerAnimated:YES completion:nil];

        }
        else{
            [self.view showHUD:rs.messge afterDelay:2];
        }
        
    };
}
//分享事件
/**
 * @param goodsid商品ID
 * @param couponstr优惠券
 * @param titleStr标题内容
 * @param infoStr 分享内容
 * @param urlImage 图片地址
 */
-(void)showSharedView:(GOODS *)goods goodsID:(NSString *)goodsid couponCode:(NSString *)couponstr goodstitle:(NSString *)titleStr goodsinfor:(NSString *)infoStr imgUrl:(NSString *)urlImage shareUrl:(NSString *)shareurlStr
{
    //分享链接
    NSString * url = nil;
    if (goodsid&&couponstr) {
        //合作社
        url =[NSString stringWithFormat:@"http://www.shiku.com/index.php/?g=webview&m=welfare&a=activity&type=1&coupon_code=%@&id=%@",couponstr,goodsid];
    }
    else if (couponstr){
        //招募
        url = [NSString stringWithFormat:@"http://www.shiku.com/index.php?g=webview&m=registe&a=register&type=2&coupon_code=%@&from=singlemessage&isappinstalled=1",couponstr];
    }
    else if (shareurlStr){
        url = shareurlStr;
    }
    else{
        url = @"www.shiku.com";
//        url = [NSString stringWithFormat:@"http://www.shiku.com/index.php?g=webview&m=registe&a=register&type=2&coupon_code=%@&from=singlemessage&isappinstalled=1",couponstr];
    }
    
    //标题
    NSString *title = nil;
    if (titleStr != nil) {
        title = titleStr;
    }
    else if(goods){
        title = @"食库";
    }
    else{
        title = @"终身折扣get！你还不赶紧的～";
    }
    //分享内容
    NSString *infomanagerStr = nil;
    if (infoStr) {
        infomanagerStr = infoStr;
    }
    else if(goods){
        
        infomanagerStr = goods.goods_name;
    }
    else{
        
        infomanagerStr = @"鲜苹果，大螃蟹，农田直送，现在加入，终身9折";
    }
    //正确
    id<ISSContent> publishContent = nil;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon_login" ofType:@"png"];
    if (urlImage) {
        publishContent = [ShareSDK content:infomanagerStr
                            defaultContent:nil
                                     image:[ShareSDK imageWithUrl:urlImage]
                                     title:title
                                       url:url
                               description:nil
                                 mediaType:SSPublishContentMediaTypeNews];
    }
    else{
        publishContent = [ShareSDK content:infomanagerStr
                            defaultContent:nil
                                     image:[ShareSDK imageWithPath:imagePath]
                                     title:title
                                       url:url
                               description:nil
                                 mediaType:SSPublishContentMediaTypeNews];

    }



    //分享商品ID
    NSString *text = nil;
    if (goods) {
        text=goods.goods_name;
        
    }else{
        text=goodsid;
    }
    
    
    
    
    id<ISSAuthOptions> authOptions=[ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
    [authOptions setPowerByHidden:YES];
    /*
     @param 	content 	分享内容
     @param 	defaultContent 	默认分享内容
     @param 	image 	分享图片
     @param 	title 	标题
     @param 	url 	链接
     @param 	description 	主体内容
     @param 	mediaType 	分享类型
     */
    //构造分享内容[ShareSDK imageWithPath:imagePath]

    //正确
//    id<ISSContent> publishContent = [ShareSDK content:infoStr
//                                       defaultContent:nil
//                                                image:[ShareSDK imageWithUrl:urlImage]
//                                                title:titleStr
//                                                  url:url
//                                          description:nil
//                                            mediaType:SSPublishContentMediaTypeNews];
    
//    //定制sina微博信息
//    [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@?platform=sina",text] image:[ShareSDK imageWithUrl:urlImage]];
    
    //QQ好友
    [publishContent addQQUnitWithType:INHERIT_VALUE content:INHERIT_VALUE title:INHERIT_VALUE url:[NSString stringWithFormat:@"%@?platform=qq_send",url] image:[ShareSDK imageWithUrl:url]];
    
    //qq空间
    [publishContent addQQSpaceUnitWithTitle:titleStr
                                        url:[NSString stringWithFormat:@"%@&platform=qzone",url]
                                       site:INHERIT_VALUE
                                    fromUrl:INHERIT_VALUE
                                    comment:INHERIT_VALUE
                                    summary:INHERIT_VALUE
                                      image:INHERIT_VALUE
                                       type:INHERIT_VALUE
                                    playUrl:INHERIT_VALUE
                                       nswb:INHERIT_VALUE];
    //微信好友  [NSString stringWithFormat:@"%@&platform=weixin_send",url]
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:url
                                      thumbImage:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                          content:text
                                            title: titleStr
                                              url:[NSString stringWithFormat:@"%@&platform=weixin_quan",url]
                                       thumbImage:INHERIT_VALUE
                                            image:INHERIT_VALUE
                                     musicFileUrl:INHERIT_VALUE
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    //微信收藏
    [publishContent addWeixinFavUnitWithType:INHERIT_VALUE content:INHERIT_VALUE title:INHERIT_VALUE url:[NSString stringWithFormat:@"%@&platform=weixin_fav",url] thumbImage:INHERIT_VALUE image:INHERIT_VALUE musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
//    id<ISSShareActionSheetItem> sinaItem = [ShareSDK
//                                            shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
//                                            icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
//                                            clickHandler:^{
//                                                [ShareSDK clientShareContent:publishContent //内容对象
//                                                                        type:ShareTypeSinaWeibo //平台类型
//                                                               statusBarTips:YES
//                                                                      result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
//                                                                          
//                                                                          if (state == SSPublishContentStateSuccess)
//                                                                          {
//                                                                              NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
//                                                                          }
//                                                                          else if (state == SSPublishContentStateFail)
//                                                                          {
//                                                                              NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
//                                                                          }
//                                                                      }];
//                                            }];
    
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                         
                          [NSNumber numberWithInteger:ShareTypeQQ],
                          [NSNumber numberWithInteger:ShareTypeQQSpace],
                          [NSNumber numberWithInteger:ShareTypeWeixiSession],
                          [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
                          [NSNumber numberWithInteger:ShareTypeWeixiFav],
                          nil];
    
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];

}

- (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSString * CTS  = @"/(^1[3|4|5|7|8][0-9]{9}$)/";
    
    NSString * CTSS  = @"^[1][3,4,5,7,8][0-9]{9}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    NSPredicate *regextestctS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CTS];

    NSPredicate *regextestctSS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CTSS];

    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestctS evaluateWithObject:mobileNum] == YES)
        || ([regextestctSS evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)ShowHDImgView:(NSString *)Title
{
    //自定义view
    progressbar = [[MBProgressHUD alloc] initWithView:self.view];
    progressbar.customView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_char_shi_white.png"]];
    // Set custom view mode
    progressbar.mode = MBProgressHUDModeCustomView;
    progressbar.delegate = self;
    progressbar.labelText = Title;
    [progressbar show:YES];
    [progressbar hide:NO afterDelay:1.5];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.window addSubview:progressbar];
}

-(void)Showprogress
{
    if (!progressbar) {
        progressbar = [[MBProgressHUD alloc] initWithView:[[UIApplication  sharedApplication] keyWindow]];
        progressbar.delegate = self;
        [[[UIApplication  sharedApplication] keyWindow] addSubview:progressbar];
    }
    progressbar.dimBackground = NO;
    progressbar.mode = MBProgressHUDModeIndeterminate;
    [progressbar show:YES];


}

- (void)hideHUDView
{
    [progressbar hide:YES afterDelay:0.1];
}

#pragma mark - MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)ahud
{
    [progressbar removeFromSuperview];
    progressbar = nil;
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField isFirstResponder];
//    return YES;
//
//}

@end
