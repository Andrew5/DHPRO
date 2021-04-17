//
//  LBHTTPTool.m
//  LeBangYZ
//
//  Created by Rillakkuma on 2016/10/25.
//  Copyright © 2016年 zhongkehuabo. All rights reserved.
//

#import "DHTool.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreText/CoreText.h>
//获取设备当前连接网段IP
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#import <dlfcn.h>
#import <netinet/in.h>
#import <mach/mach.h>

@implementation DHTool

#pragma mark - ***** 判断字符串是否为空
//根据需求 待修改
+ (BOOL)IsNSStringNULL:(NSString *)stirng
{
	if([stirng isKindOfClass:[NSNull class]]) return YES;
	if(![stirng isKindOfClass:[NSString class]]) return YES;
	
	if(stirng == nil) return YES;
    if([stirng isEqualToString:@"(null)"]) return YES;
    if([stirng isEqualToString:@"NULL"]) return YES;
    if([stirng isEqualToString:@"<null>"]) return YES;
    if([stirng isEqualToString:@"null"]) return YES;

    if(stirng == nil || stirng == NULL) return YES;
	NSString * string1 = [stirng stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSUInteger len=[string1 length];
	if (len <= 0) return YES;
	return NO;
}
//检查手机是否设置了代理
- (BOOL) checkProxySetting {
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSLog(@"\n%@",proxies);

    NSDictionary *settings = proxies[0];
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);

    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        NSLog(@"没设置代理");
        return NO;
    }
    else
    {
        
        NSLog(@"设置了代理");
        return YES;
    }

}

+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width otherBorderWidth:(CGFloat)otherWidth topColor:(UIColor *)topColor leftColor:(UIColor *)leftColor bottomColor:(UIColor *)bottomColor  rightColor:(UIColor *)rightColor
{
	if (top) {
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
		layer.backgroundColor = color.CGColor;
		[view.layer addSublayer:layer];
	} else {
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(0, 0, view.frame.size.width, otherWidth);
		layer.backgroundColor = topColor.CGColor;
		[view.layer addSublayer:layer];
	}
	if (left) {
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
		layer.backgroundColor = color.CGColor;
		[view.layer addSublayer:layer];
	} else {
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(0, 0, otherWidth, view.frame.size.height);
		layer.backgroundColor = leftColor.CGColor;
		[view.layer addSublayer:layer];
	}
	if (bottom) {
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
		layer.backgroundColor = color.CGColor;
		[view.layer addSublayer:layer];
	} else {
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(0, view.frame.size.height - otherWidth, view.frame.size.width, otherWidth);
		layer.backgroundColor = bottomColor.CGColor;
		[view.layer addSublayer:layer];
	}
	if (right) {
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
		layer.backgroundColor = color.CGColor;
		[view.layer addSublayer:layer];
	} else {
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(view.frame.size.width - width, 0, otherWidth, view.frame.size.height);
		layer.backgroundColor = rightColor.CGColor;
		[view.layer addSublayer:layer];
	}
}


+ (CGSize)autoSizeOfWidthWithText:(NSString *)text font:(UIFont *)font height:(CGFloat)height
{
    CGSize size = CGSizeMake(MAXFLOAT, height);
    //    NSDictionary *attributesDic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    //    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil];
    
    // iOS7以后使用boundingRectWithSize，之前使用sizeWithFont
    // 多行必需使用NSStringDrawingUsesLineFragmentOrigin，网上有人说不是用NSStringDrawingUsesFontLeading计算结果不对
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
    
    CGRect rect = [text boundingRectWithSize:size
                                     options:opts
                                  attributes:attributes
                                     context:nil];
    return rect.size;
    
}
+ (CGSize)autoSizeOfHeghtWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width{
	CGSize size = CGSizeMake(width, MAXFLOAT);
	//    NSDictionary *attributesDic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
	//    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil];
	//
	// iOS7以后使用boundingRectWithSize，之前使用sizeWithFont
	// 多行必需使用NSStringDrawingUsesLineFragmentOrigin，网上有人说不是用NSStringDrawingUsesFontLeading计算结果不对
	NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
	NSStringDrawingUsesFontLeading;
	
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	[style setLineBreakMode:NSLineBreakByCharWrapping];
	
	NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
	
	CGRect rect = [text boundingRectWithSize:size
									 options:opts
								  attributes:attributes
									 context:nil];
	return rect.size;
}
+ (CGFloat)contentSizeWithText:(NSString *)text{
	NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType } documentAttributes:nil error:nil];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineSpacing:8];//调整行间距
	NSDictionary * attriBute = @{NSFontAttributeName:DH_FontSize(14)};
	[attrStr addAttributes:attriBute range:NSMakeRange(0, [attrStr length])];
	[attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrStr length])];
	
	CGSize labelSize=[attrStr boundingRectWithSize:CGSizeMake(DH_DeviceWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
	return labelSize.height;
	
}
+ (BOOL)isValidateMobile:(NSString *)mobileNum{

	/**
	 * 手机号码
	 * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
	 * 联通：130,131,132,152,155,156,185,186
	 * 电信：133,1349,153,180,189
	 */
	NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
	/**
	 10         * 中国移动：China Mobile
	 11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,184,187,188
	 12         */
	NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2478])\\d)\\d{7}$";
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
	
	NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
	NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
	NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
	NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
	
	if (([regextestmobile evaluateWithObject:mobileNum] == YES)
		|| ([regextestcm evaluateWithObject:mobileNum] == YES)
		|| ([regextestct evaluateWithObject:mobileNum] == YES)
		|| ([regextestcu evaluateWithObject:mobileNum] == YES))
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

+ (BOOL)validateVerifyCode:(NSString *)verifyCode {
	BOOL flag;
	if (verifyCode.length != 5) {
		flag = NO;
		return flag;
	}
	NSString *regex2 = @"^(\\d{5})";
	NSPredicate *verifyCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
	return [verifyCodePredicate evaluateWithObject:verifyCode];
}

//密码
+ (BOOL)validatePassword:(NSString *)passWord {
	NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}+$";
	NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
	return [passWordPredicate evaluateWithObject:passWord];
}
//MMM:6月 MM:06 MMMMM:6 K:mm-10:21 上午
+ (NSString *)getCurrectTimeWithPar:(NSString *)par{
	NSDate *currentDate = [NSDate date];//获取当前时间，日期
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:par];
	NSString *dateString = [dateFormatter stringFromDate:currentDate];
	NSLog(@"dateString:%@",dateString);
	return dateString;
}
// 将NSlog打印信息保存到Document目录下的文件中
+ (void)redirectNSlogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];
    // 注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:logFilePath]) {
        NSLog(@"大文件小：%llu",[[fileManager attributesOfItemAtPath:logFilePath error:nil] fileSize]);
    }
    [defaultManager removeItemAtPath:logFilePath error:nil]; // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
}
/*******************************************************************************/

// 将NSlog打印信息保存到Caches目录下的文件中 写入缓存数据
+ (void)writeLocalCacheDataToCachesFolderWithKey:(NSString *)key fileName:(NSString *)file{
    // 设置存储路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * path1 = [path stringByAppendingPathComponent:file];
    //    // 判读缓存数据是否存在
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
    //        // 删除旧的缓存数据
    //        [[NSFileManager defaultManager] removeItemAtPath:cachesPath error:nil];
    //    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:path1]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path1 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * cachesPath = [path1 stringByAppendingPathComponent:key];

    freopen([cachesPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([cachesPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

// 读缓存
+ (NSData *)readLocalCacheDataWithKey:(NSString *)key {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                            stringByAppendingPathComponent:key];
    // 判读缓存数据是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
        // 读取缓存数据
        return [NSData dataWithContentsOfFile:cachesPath];
    }
    return nil;
}

// 删缓存
+ (void)deleteLocalCacheDataWithKey:(NSString *)key {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                            stringByAppendingPathComponent:key];
    // 判读缓存数据是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
        // 删除缓存数据
        [[NSFileManager defaultManager] removeItemAtPath:cachesPath error:nil];
    }
}

+ (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

+ (double)freeMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    vm_size_t pageSize;
    mach_port_t selfhost = mach_host_self();
    host_page_size(selfhost, &pageSize);
    kern_return_t kernReturn = host_statistics(selfhost,
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    mach_port_deallocate(mach_task_self(), selfhost);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

+ (double)appUsedMemory
{
    mach_task_basic_info_data_t taskInfo;
    unsigned infoCount = sizeof(taskInfo);
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         MACH_TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}
+ (void)setToken:(id)tokenObj{
    NSMutableDictionary *tokenDic = [NSMutableDictionary new];
    tokenDic[@"access_token"] = tokenObj[@"data"][@"access_token"];
    tokenDic[@"expires_time"] = tokenObj[@"data"][@"expires_in"];
    tokenDic[@"token_getTime"] = [NSDate date];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:tokenDic forKey:@"access_token"];
    [userDefault synchronize];
}
+ (NSDictionary *)userTokenObj{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *tokenObj = [userDefault objectForKey:@"access_token"];
    
    [userDefault synchronize];
    return tokenObj;
}
///TODO: 获取网络流量信息
+ (NSString *)getByteRate {
    long long int currentBytes = [DHTool getInterfaceBytes];
    //格式化一下
    NSString*rateStr = [DHTool formatNetWork:currentBytes];
    NSLog(@"当前网速%@",rateStr);
    return rateStr;
}
+ (long long) getInterfaceBytes
{
	struct ifaddrs *ifa_list = 0, *ifa;
	if (getifaddrs(&ifa_list) == -1)
	{
		return 0;
	}
	
	uint32_t iBytes = 0;
	uint32_t oBytes = 0;
	
	for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
	{
		if (AF_LINK != ifa->ifa_addr->sa_family)
			continue;
		
		if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
			continue;
		
		if (ifa->ifa_data == 0)
			continue;
		
		/* Not a loopback device. */
		if (strncmp(ifa->ifa_name, "lo", 2))
		{
			struct if_data *if_data = (struct if_data *)ifa->ifa_data;
			
			iBytes += if_data->ifi_ibytes;
			oBytes += if_data->ifi_obytes;
		}
	}
	freeifaddrs(ifa_list);
	return iBytes + oBytes;
}
+ (NSString *)formatNetWork:(long long int)rate {
    if (rate <1024) {
        return [NSString stringWithFormat:@"%lldB/秒", rate];
    } else if (rate >=1024&& rate <1024*1024) {
        return [NSString stringWithFormat:@"%.1fKB/秒", (double)rate /1024];
    } else if (rate >=1024*1024&& rate <1024*1024*1024) {
        return [NSString stringWithFormat:@"%.2fMB/秒", (double)rate / (1024*1024)];
    } else {
        return@"10Kb/秒";
    };
}
//获取WiFi 信息，返回的字典中包含了WiFi的名称、路由器的Mac地址、还有一个Data(转换成字符串打印出来是wifi名称)
+ (NSDictionary *)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return nil;
    }
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}
//网速测试
+(NSMutableDictionary *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    NSMutableDictionary *wifiDic = [[NSMutableDictionary alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            //            NSLog(@"ifa_name %s == %@n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                    // NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
                    //NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                    // NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
                    //NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    NSLog(@"nwifiSend:%.2f MBn wifiReceived:%.2f MBn wwansend:%.2f MBn wwanreceived:%.2f MBn",WiFiSent/1024.0/1024.0,WiFiReceived/1024.0/1024.0,WWANSent/1024.0/1024.0,WWANReceived/1024.0/1024.0);
    [wifiDic setValue:[NSString stringWithFormat:@"%.f",WiFiSent/1024.0/1024.0] forKey:@"nwifiSend"];
    [wifiDic setValue:[NSString stringWithFormat:@"%.f",WiFiReceived/1024.0/1024.0] forKey:@"wifiReceived"];
    [wifiDic setValue:[NSString stringWithFormat:@"%.f",WWANSent/1024.0/1024.0] forKey:@"wwansend"];
    [wifiDic setValue:[NSString stringWithFormat:@"%.f",WWANReceived/1024.0/1024.0] forKey:@"wwanreceived"];
    return wifiDic;
}
//获取手机的网络的ip地址
+ (NSString *)getIPAddress
{
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	success = getifaddrs(&addrs) == 0;
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
			// the second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"]) // Wi-Fi adapter
					NSLog(@"IP:%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)]);
				return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return nil;
}
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    ///过滤非汉字字符
    ///@"[^\u4e00-\u9fa5]"
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}
// add by yangyanhui base64加密
- (NSString *)base64Encode:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    int length = (int)[data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = (const unsigned char *)[data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}
+ (NSMutableAttributedString *)addWithName:(UILabel *)label more:(NSString *)morestr nameDict:(NSDictionary *)nameDict moreDict:(NSDictionary *)moreDict numberOfLines:(NSInteger)num{
    
    NSArray *array = [self getSeparatedLinesFromLabel:label];
    NSString *showText = @"";
    //    if (array.count == 4){
    //        //最后一行显示的内容
    //        NSString *line4String = array[3];
    //        //整体显示内容拼接
    //        showText = [NSString stringWithFormat:@"%@%@%@%@…%@", array[0], array[1], array[2], [line4String substringToIndex:line4String.length-2],morestr];
    //    }
    //    if (array.count == 3){
    //        NSString *line4String = array[2];
    //        showText = [NSString stringWithFormat:@"%@%@%@…%@", array[0], array[1], [line4String substringToIndex:line4String.length-2],morestr];
    //    }
    //    if (array.count == 2){
    //        NSString *line4String = array[1];
    //        showText = [NSString stringWithFormat:@"%@%@…%@", array[0], [line4String substringToIndex:line4String.length-2],morestr];
    //    }
    //    if (array.count == 1){
    //        NSString *line4String = array[0];
    //        showText = [NSString stringWithFormat:@"%@…%@",[line4String substringToIndex:line4String.length-2],morestr];
    //    }
    //判断行数限制
    if (num == 1){
        if (array.count>0) {
            NSString *line4String = array[0];
            showText = [NSString stringWithFormat:@"%@…%@",[line4String substringToIndex:line4String.length-3],morestr];
        }else{
            showText = label.text;
            //设置label的attributedText富文本
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:showText attributes:nameDict];
            return attStr;
        }
    }
    if (num == 2){
        if (array.count>1) {
            NSString *line4String = array[1];
            showText = [NSString stringWithFormat:@"%@%@…%@", array[0], [line4String substringToIndex:line4String.length-3],morestr];
        }else{
            showText = label.text;
            //设置label的attributedText富文本
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:showText attributes:nameDict];
            return attStr;
        }
    }
    if (num == 3){
        if (array.count>2) {
            NSString *line4String = array[2];
            showText = [NSString stringWithFormat:@"%@%@%@…%@", array[0], array[1], [line4String substringToIndex:line4String.length-3],morestr];
        }else{
            showText = label.text;
            //设置label的attributedText富文本
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:showText attributes:nameDict];
            return attStr;
        }
    }
    if (num == 4){
        if (array.count>3) {
            NSString *line4String = array[3];
            showText = [NSString stringWithFormat:@"%@%@%@%@…%@", array[0], array[1], array[2], [line4String substringToIndex:line4String.length-3],morestr];
        }else{
            showText = label.text;
            //设置label的attributedText富文本
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:showText attributes:nameDict];
            return attStr;
        }
    }
    if (array.count == 0) {
        return nil;
    }
    //设置label的attributedText富文本
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:showText attributes:nameDict];
    [attStr addAttributes:moreDict range:NSMakeRange(showText.length-3, 3)];
    return attStr;
    /*
     4行
     NSString *line4String = array[3];
     NSString *showText = [NSString stringWithFormat:@"%@%@%@%@...更多>", array[0], array[1], array[2], [line4String substringToIndex:line4String.length-5]];
     
     
     //3
     NSString *line4String = array[2];
     NSString *showText = [NSString stringWithFormat:@"%@%@%@%@", array[0], array[1], [line4String substringToIndex:line4String.length-5],str];
     
     //2
     NSString *line4String = array[1];
     NSString *showText = [NSString stringWithFormat:@"%@%@%@%@", array[0], [line4String substringToIndex:line4String.length-5],str];
     
     //1
     NSString *line4String = array[0];
     NSString *showText = [NSString stringWithFormat:@"%@%@%@%@", [line4String substringToIndex:line4String.length-5],str];
     */
}
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)name
{
    NSString *text = [name text];
    UIFont   *font = [name font];
    CGRect    rect = [name frame];
    //设置字体属性
    //这里设置了同样的字体格式
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    //设置富文本
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    //对同一段字体进行多属性设置 计算富文本行高
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    //创建绘制路劲
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,MAXFLOAT));
    //设置富文本位置属性
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    //设置富文本的基线
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return linesArray;
    
}
//// 这种是路径遮盖法

+ (UIImage*)maskImage:(UIImage*)originImage toPath:(UIBezierPath*)path{
    
    UIGraphicsBeginImageContextWithOptions(originImage.size,NO,0);
    [path addClip];
    [originImage drawAtPoint:CGPointZero];
    UIImage* img =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
////为图像创建透明区域
+ (CGImageRef)CopyImageAndAddAlphaChannel:(CGImageRef)sourceImage{
   CGImageRef retVal = NULL;
   size_t width = CGImageGetWidth(sourceImage);
   size_t height = CGImageGetHeight(sourceImage);
   CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
   CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,8,0, colorSpace,kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little);
    if (offscreenContext !=NULL){
        CGContextDrawImage(offscreenContext,CGRectMake(0,0, width, height), sourceImage);
        retVal = CGBitmapContextCreateImage(offscreenContext);
        CGContextRelease(offscreenContext);
    }
    CGColorSpaceRelease(colorSpace);
    return retVal;
}
+(NSString *)dataInMyCollectionData:(NSString *)dateStr {
    NSRange rangeBegin = [dateStr rangeOfString:@"("];
    NSRange rangeEnd = [dateStr rangeOfString:@"+"];
    if (rangeBegin.location != NSNotFound && rangeEnd.location != NSNotFound) {
        NSString *realtme = [dateStr substringWithRange:NSMakeRange(rangeBegin.location + 1, rangeEnd.location - rangeBegin.location - 1)];
        return [self getTimeStringWithTimeInterval:[realtme doubleValue]/1000];
    } else {
        return dateStr;
    }
}

+ (NSString *)getTimeStringWithTimeInterval:(double)tInterval {
    //    发布时间显示规则：发布新闻的时间与手机系统时间的差值，时间间隔为，一个小时内则显示xx分钟前，如11分钟前，52分钟前，10分钟前显示刚刚；一小时后显示xx小时前，如3小时前，23小时前；超过一天则显示具体月日，如01-21；跨年则显示具体年月日，如2014-01-02
    NSDate *origion = [NSDate dateWithTimeIntervalSince1970:tInterval];
    NSDate *currentDate = [NSDate date];
    NSString *str = nil;
    NSInteger startYear=[[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitYear inUnit: NSCalendarUnitEra forDate:origion];
    NSInteger endYear=[[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitYear inUnit: NSCalendarUnitEra forDate:currentDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"]];
    if (endYear > startYear) {
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *dt = origion;
        str = [formatter stringFromDate:dt];
    } else {
        NSTimeInterval time=[currentDate timeIntervalSinceDate:origion];
        long nMinutes = time/60;
        if (nMinutes >= 24 * 60  ) {
            formatter.dateFormat = @"MM-dd";
            NSDate *dt = origion;
            str = [formatter stringFromDate:dt];
        } else if (nMinutes >= 20*60){
            str = [NSString stringWithFormat:@"20小时前"];
        } else if (nMinutes >= 10*60){
            str = [NSString stringWithFormat:@"10小时前"];
        } else if (nMinutes >= 5*60){
            str = [NSString stringWithFormat:@"5小时前"];
        } else if (nMinutes >= 3*60){
            str = [NSString stringWithFormat:@"3小时前"];
        } else if (nMinutes >= 1*60) {
            str = [NSString stringWithFormat:@"1小时前"];
        } else if (nMinutes >= 50){
            str = [NSString stringWithFormat:@"50分钟前"];
        } else if (nMinutes >= 40){
            str = [NSString stringWithFormat:@"40分钟前"];
        } else if (nMinutes >= 30){
            str = [NSString stringWithFormat:@"30分钟前"];
        } else if (nMinutes >= 20){
            str = [NSString stringWithFormat:@"20分钟前"];
        } else if (nMinutes >= 10) {
            str = [NSString stringWithFormat:@"10分钟前"];
        } else {
            str = @"刚刚";
        }
    }
    if (!str) {
        str = [NSString stringWithFormat:@"%f",tInterval];
    }
    return str;
}
/////利用图像遮盖

//+ (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage
//
//{
//
//    CGImageRef maskRef = maskImage.CGImage;
//
//    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
//
//                                                                                CGImageGetHeight(maskRef),
//
//                                                                                CGImageGetBitsPerComponent(maskRef),
//
//                                                                                CGImageGetBitsPerPixel(maskRef),
//
//                                                                                CGImageGetBytesPerRow(maskRef),
//
//                                                                                CGImageGetDataProvider(maskRef), NULL, true);
//
//
//
//    CGImageRef sourceImage = [image CGImage];
//
//    CGImageRef imageWithAlpha = sourceImage;
//
//
//
//    //add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
//
//    //this however has a computational cost
//
//    if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
//
//        imageWithAlpha = [ImageUtil CopyImageAndAddAlphaChannel:sourceImage];
//
//    }
//
//
//
//    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
//
//    CGImageRelease(mask);
//
//
//
//    //release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
//
//        if (sourceImage != imageWithAlpha) {
//
//                CGImageRelease(imageWithAlpha);
//
//            }
//
//
//
//    UIImage* retImage = [UIImage imageWithCGImage:masked];
//
//    CGImageRelease(masked);
//
//
//
//    return retImage;
//
//
//
//}

@end
