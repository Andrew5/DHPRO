#ifndef shiku_Public_h
#define shiku_Public_h

#define MARGIN 10
#define SEARCH_FIELD_WIDTH 220
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth [UIScreen mainScreen].bounds.size.width

#define url_share @"http://api.shiku.com/buyerApi"

#define url_ckwl @"http://www.shiku.com/?g=wap&m=public&a=get_kuaidi&"
//友盟
#define UMENG_APP_KEY @"55bed51e67e58e10780094d7"
//BMP
#define kBMPAppKey      @"0Q9PupWp5DTUTGy1QWmVPmbl"
//com.sina.weibo.SNWeiboSDKDemo
#define kAppKey         @"1714006768"
#define kAppSecret      @"b13166351a9329dd2d7362f13d2e095a"
#define kRedirectURI    @"http://115.28.219.106/changmai"

//qq
#define kQQAppKey         @"1104679170"
#define kQQAppSecret      @"f68XvyrVfMJ55nRb"

//微信
#define kWXAppKey         @"wx1bb7c1026ef3a822"
#define kWXAppSecret      @"dbae5df216ca9fe3f95622def37eab3f"

#define coverimagewidth 1

//系统颜色
#define MAIN_COLOR         [UIColor colorWithRed:0.129 green:0.649 blue:0.286 alpha:1.000]
#define MAIN_COLOR2         [UIColor redColor]
#define TEXT_COLOR_LIGHT       [UIColor colorWithRed:229/255.f green:229/255.f blue:229/255.f alpha:1.000]
#define TEXT_COLOR_DARK       [UIColor colorWithRed:160/255.f green:160/255.f blue:160/255.f alpha:1.000]
#define TEXT_COLOR_BLACK       [UIColor colorWithRed:67/255.f green:67/255.f blue:67/255.f alpha:1.000]
#define BG_COLOR         [UIColor colorWithRed:229/255.f green:229/255.f blue:229/255.f alpha:1.000]
#define WHITE_COLOR [UIColor whiteColor]
#define LIGHT  [UIColor colorWithRed:194.0/255.f green:194.0/255.f blue:194.0/255.f alpha:0.900]
#define RGBCOLORV(rgbValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0x0000FF))/255.0 \
    alpha:1.0]

#define img_placehold [UIImage imageNamed:@"placehold.png"]
#define img_placehold_long [UIImage imageNamed:@"placeholdlong.png"]
#define url(v) [NSURL URLWithString:v]

//字号
#define ICON_TEXT_SIZE 35
#define LARGE_TEXT_SIZE 18
#define MEDIUM_TEXT_SIZE 15
#define SMALL_TEXT_SIZE 12
#define MICRO_TEXT_SIZE 12

//常用字体
#define FONT_LARGE_BOLD [UIFont boldSystemFontOfSize:LARGE_TEXT_SIZE]
#define FONT_LARGE [UIFont systemFontOfSize:LARGE_TEXT_SIZE]
#define FONT_MEDIUM [UIFont systemFontOfSize:MEDIUM_TEXT_SIZE]
#define FONT_SMALL [UIFont systemFontOfSize:SMALL_TEXT_SIZE]
#define FONT_MICRO [UIFont systemFontOfSize:MICRO_TEXT_SIZE]
#define FONT_ICON [UIFont fontWithName:@"iconfont" size:20]

//图标字体
#define ICON_CART_TEXT @""

#define img_placehold [UIImage imageNamed:@"placehold.png"]

//商品详情页
#define GOODS_DETAIL_TAB_ICONS  @[@"icon_product.png", @"icon_log.png", @"icon_origin.png", @"icon_rate.png"]
#define GOODS_DETAIL_TAB_ICONS_SELECTED  @[@"icon_product_active.png", @"icon_log_active.png", @"icon_origin_active.png", @"icon_rate_active.png"]
#define GOODS_DETAIL_TAB_ICONS_TITLE  @[@"产品信息", @"生产过程", @"产地", @"店铺评价"]

#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DeviceHeight [UIScreen mainScreen].bounds.size.height

#define LOADING @"加载中..."

#endif
