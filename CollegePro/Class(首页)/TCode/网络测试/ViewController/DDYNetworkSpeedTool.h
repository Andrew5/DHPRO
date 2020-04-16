#import <Foundation/Foundation.h>

@interface DDYNetworkSpeedTool : NSObject

/** 测速回调 如果出错则有error否则nil,如果完成finish=YES,否则正在测速finish=NO */
@property (nonatomic, copy) void (^measureBlock)(NSError *error, BOOL finish, float speed);
/** 开始测速 */
- (void)ddy_StartMeasureSpeed;
/** 结束测速 */
- (void)ddy_StopMeasureSpeed;


/** 网卡上下行流量速率 upSpeed:上行速率 downSpeed:下行速率 */
@property (nonatomic, copy) void (^instantBlock)(float upSpeed, float downSpeed);
/** 开启关闭网卡流量监测 */
@property (nonatomic, assign) BOOL isMoniteInstantSpeed;

@end
