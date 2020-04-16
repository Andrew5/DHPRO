#import "DDYNetworkSpeedTool.h"
#import <arpa/inet.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <net/if_dl.h>

#define start1 -0.33
#define measureURL @"http://down.sandai.net/thunder7/Thunder_dl_7.9.34.4908.exe"

@interface DDYNetworkSpeedTool ()<NSURLConnectionDelegate>
/** 测速定时器 */
@property (nonatomic, strong) NSTimer *measureTimer;
/** 测速计时秒 */
@property (nonatomic, assign) NSInteger measureSeconds;
/** 测速请求 */
@property (nonatomic, strong) NSURLConnection *measureConnect;
/** 即时数据 */
@property (nonatomic, strong) NSMutableData *measureInstantData;
/** 累计数据 */
@property (nonatomic, strong) NSMutableData *measureTotalData;
/** 实时网速 */
@property (nonatomic, strong) NSTimer *moniteTimer;

@end

@implementation DDYNetworkSpeedTool
{
    uint32_t _iBytes;
    uint32_t _oBytes;
}

#pragma mark 测速
- (void)ddy_StartMeasureSpeed {
    _measureSeconds = 0;
    _measureInstantData = [NSMutableData data];
    _measureTotalData = [NSMutableData data];
    _measureTimer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    [_measureTimer fire];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:measureURL]];
    _measureConnect = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)countTime {
    if (_measureSeconds >= 15) {
        [self ddy_StopMeasureSpeed];
        return;
    }
    _measureSeconds ++;
    if (_measureBlock) {
        _measureBlock(nil, NO, _measureInstantData.length);
    }
    _measureInstantData = [NSMutableData data];
}

- (void)ddy_StopMeasureSpeed {
    if (_measureSeconds && _measureBlock) {
        _measureBlock(nil, YES, (_measureTotalData.length/_measureSeconds));
    }
    
    [_measureTimer invalidate];
    _measureTimer = nil;
    [_measureConnect cancel];
    _measureConnect = nil;
    _measureTotalData = nil;
}

#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (_measureBlock) _measureBlock(error, NO, 0.);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_measureInstantData appendData:data];
    [_measureTotalData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    [self ddy_StopMeasureSpeed];
}

- (void)setIsMoniteInstantSpeed:(BOOL)isMoniteInstantSpeed {
    _isMoniteInstantSpeed = isMoniteInstantSpeed;
    if (_isMoniteInstantSpeed) {
        _moniteTimer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(handleMonite) userInfo:nil repeats:YES];
    } else {
        [_moniteTimer invalidate];
        _moniteTimer = nil;
    }
}

- (void)handleMonite {
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)  return;
    
    uint32_t iBytes     = 0;
    uint32_t oBytes     = 0;
    uint32_t allFlow    = 0;
    uint32_t wifiIBytes = 0;
    uint32_t wifiOBytes = 0;
    uint32_t wifiFlow   = 0;
    uint32_t wwanIBytes = 0;
    uint32_t wwanOBytes = 0;
    uint32_t wwanFlow   = 0;
    // struct timeval32 time;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        // network flow
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
        }
        
        // wifi flow
        if (!strcmp(ifa->ifa_name, "en0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wifiIBytes += if_data->ifi_ibytes;
            wifiOBytes += if_data->ifi_obytes;
            wifiFlow    = wifiIBytes + wifiOBytes;
        }
        
        // 3G and gprs flow
        if (!strcmp(ifa->ifa_name, "pdp_ip0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wwanIBytes += if_data->ifi_ibytes;
            wwanOBytes += if_data->ifi_obytes;
            wwanFlow    = wwanIBytes + wwanOBytes;
        }
    }
    freeifaddrs(ifa_list);
    
    if (_iBytes && _oBytes && _instantBlock) {
        _instantBlock((oBytes-_oBytes), (iBytes - _iBytes));
    }
    _iBytes = iBytes;
    _oBytes = oBytes;
}

@end
