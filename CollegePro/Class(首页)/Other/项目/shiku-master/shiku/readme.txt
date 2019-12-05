
############目录结构说明###########


优惠券     coupon|-backend      后台内容
                |-controllers  业务逻辑
                |-viewcells
                |-model         所有的模型都存在base-model目录下

********以下目录结构类似*******

积分      integration
消息      information
生产日志   viewlogistics
新品推荐   topic
品位      grade
其他设置   setting
喜欢      like
收货地址   address
下单      checkout
用户      user
商品      goods
订单信息   order
支付      payment
物流信息   shipment
购物车     cart
分类      cate
农户      fav
首页      home




END############目录结构说明###########




###############开源框架说明###########

SDWebImage                     加载网络图片框架
AFNetworking                   网络框架
CocoaLumberjack                日志框架
    用DDLog替换NSLog语句
    DDLog的头文件定义了你用来替换NSLog语句的宏，本质上看起来向下边这样：
    // Convert from this:
    NSLog(@"Broken sprocket detected!");
    NSLog(@"User selected file:%@ withSize:%u", filePath, fileSize);

    // To this:
    DDLogError(@"Broken sprocket detected!");
    DDLogVerbose(@"User selected file:%@ withSize:%u", filePath, fileSize);


SVPullToRefresh                 下拉加载更多，下拉刷新
SWTableViewCell                 cell左滑右滑
ReactiveCocoa                   事件响应
CocoaSecurity                   机密解密
Masonry                         AutoLayout
DKCarouselView                  自动滚动无限循环View，主要用途焦点广告
ZWIntroductionViewController    引导页界面
MZTimerLabel                    倒计时广告

END###############开源框架说明###########







