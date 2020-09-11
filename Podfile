platform :ios, "9.0"

##循环target 添加pod
#inhibit_all_warnings!
#targetArray = ['CollegePro','CollegeProWidge']
#	targetArray.each do |t|
#		target t do

#abstract_target 'CommonPods' do
# 多个target共用一套pod的写法，项目中不能有名字为CommonPods，防止冲突；
def commonPods
  #自动布局界面库
  pod 'Masonry'
  pod 'SDAutoLayout','~>2.2.1'
  pod 'SDWebImage'
  pod 'MJExtension'
end

target "CollegePro" do
#source 'https://github.com/CocoaPods/Specs.git'
	use_frameworks!
#使用数字比较符号指定版本
#'> 0.1'   // tag 0.1以上
#'>= 0.1'   // tag  0.1以上，包括0.1
#'< 0.1'    // tag 0.1以下
#'<= 0.1'   //  tag 0.1以下，包括0.1
#除了上述的指定版本方法外还有使用 ~> 指定相应的tag版本
#'~> 0.1.2'   // 0.2以下(不含0.2)，0.1.2以上（含0.1.2）
#'~> 0.1'      // 1.0以下(不含1.0)，0.1以上（含0.1）
#'~> 0'        // 0和以上，等于没有此约束
  pod 'AFNetworking'
  pod 'YTKNetwork'#, '~> 3.0.3'
  #YTKNetwork结合PromiseKit，添加链式调用方法
  pod 'PromiseYTKNetwork'#, '~> 0.1.2'
#  pod 'AFNetworking', (~> 4.0.1)
  commonPods
#  #自动布局界面库
#  pod 'Masonry'
#  pod 'SDAutoLayout','~>2.2.1'
  #网络加载转圈图标
  pod 'SVProgressHUD'
#  pod 'MBProgressHUD'
  pod 'MBProgressHUD+JDragon'
  #图片处理
  pod 'TZImagePickerController'
#  pod 'SDWebImage'
  #键盘自适应
  pod 'IQKeyboardManager'
  #上拉下拉刷新
  pod 'MJRefresh'
#  #JSON数据与Model模型之间的转化
#  pod 'MJExtension'
#  #极光推送
  pod 'JPush', '3.1.0'
#  #MD5加密
  pod 'CocoaSecurity'
  
  pod 'BaiduMapKit', '~> 5.4.0'

  pod 'pop','~>1.0'
  pod 'YHPopupView'
#  pod 'YYKit'
#  
  pod 'WKVCDeallocMonitor'##内寸检测
  pod 'MLeaksFinder'
  pod 'AvoidCrash'
  pod 'SocketRocket'#socket

  pod "DKNightVersion"##暗黑模式
  pod 'FDFullscreenPopGesture'
#pod 'WechatOpenSDK'
  pod 'FBRetainCycleDetector'
  pod 'AliPaySDK', '~> 1.0'
  pod 'FSCalendar', '~> 2.6.0'
  pod 'YYCache'
  pod 'ReactiveCocoa'
  #injectionIII iOS代码注入工具
#pod 'ReactiveCocoa', '2.3.1'
#pod 'ReactiveCocoa', '~> 4.0.2-alpha-1'
#  pod 'Realm/Headers' ##移动平台设计的数据库
#  pod 'QMUIKit'
#pod 'CardIO'
#  pod 'TesseractOCRiOS'
#pod 'OpenCV', '~>3.4.1'
	end
#end
#target 'CollegeProWidge' do
#  use_frameworks!
#    pod 'MJExtension'
#    pod 'AFNetworking'
#    #自动布局界面库
#    pod 'Masonry'
#    pod 'SDWebImage'
#end
