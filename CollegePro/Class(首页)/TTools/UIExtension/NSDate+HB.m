#import "NSDate+HB.h"

@implementation NSDate (HB)
+ (NSString *)dateWithString:(NSString *)string
{
    NSTimeInterval msgTime = [string longLongValue]/ 1000.0;
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:msgTime];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSString *time = [fmt stringFromDate:timeDate];
    
    return time;
}
+ (NSString *)dateWithString1:(NSString *)string
{
    NSTimeInterval msgTime = [string longLongValue]/ 1000.0;
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:msgTime];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy/MM/dd";
    NSString *time = [fmt stringFromDate:timeDate];
    
    return time;
}
+(NSString*)changeTimeStrTo:(NSString*)timeStr{
//    NSLog(@"%@-",timeStr);
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter  alloc ]  init ];
    
    [formatter setDateFormat:@"yyyyMMdd"];
    
    NSString *todayTime = [formatter stringFromDate:today];
    
    NSString * strRang = [timeStr substringWithRange:NSMakeRange(0, 8)];
    
    if ([strRang isEqualToString:todayTime]) {
        NSString * HH = [timeStr substringWithRange:NSMakeRange(8, 2)];
        NSString * mm = [timeStr substringWithRange:NSMakeRange(10, 2)];
        if ([HH intValue]>12) {
            int hour=[HH intValue]-12;
            return [NSString stringWithFormat:@"下午%d:%@",hour,mm];
        }else {
            return [NSString stringWithFormat:@"%@:%@",HH,mm];
        }
        
    }else{
        NSString * year = [timeStr substringWithRange:NSMakeRange(2, 2)];
        NSString * mouth1 = [timeStr substringWithRange:NSMakeRange(4, 1)];
        NSString * mouth2 = [timeStr substringWithRange:NSMakeRange(5, 1)];
        NSString * day1 = [timeStr substringWithRange:NSMakeRange(6, 1)];
        NSString * day2 = [timeStr substringWithRange:NSMakeRange(7, 1)];
        if ([mouth1 isEqualToString:@"0"]) {
            mouth1=@"";
        }
        if ([day1 isEqualToString:@"0"]) {
            day1=@"";
        }
        return [NSString stringWithFormat:@"%@-%@%@-%@%@",year,mouth1,mouth2,day1,day2];
        
    }
    
    
    
}

+(NSString*)changeTheDateTo:(NSString*)theDate{
    
    NSTimeInterval msgTime = [theDate longLongValue]/ 1000.0;
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:msgTime];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat: @"yyyy/MM/dd HH:mm:ss"];
    //    NSDate * d = [dateFormatter dateFromString:theDate];
    
    NSTimeInterval late = [timeDate timeIntervalSince1970]*1;
    
    NSString * timeString = nil;
    
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha = now - late;
    NSUserDefaults * ud=[NSUserDefaults standardUserDefaults];
    
    
    if ([[ud objectForKey:@"userLanguage"]isEqualToString:@"zh-Hans"]) {
        
        
        
        if (cha/3600 < 1) {
            
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            int num= [timeString intValue];
            
            if (num <= 1) {
                
                timeString = [NSString stringWithFormat:@"刚刚..."];
                
            }else{
                
                timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
                
            }
            
        }
        
        if (cha/3600 > 1 && cha/86400 < 1) {
            
            timeString = [NSString stringWithFormat:@"%f", cha/3600];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            timeString = [NSString stringWithFormat:@"%@小时前", timeString];
            
        }
        
        if (cha/86400 > 1)
            
        {
            
            timeString = [NSString stringWithFormat:@"%f", cha/86400];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            int num = [timeString intValue];
            
            if (num < 2) {
                
                timeString = [NSString stringWithFormat:@"昨天"];
                
            }else if(num == 2){
                
                timeString = [NSString stringWithFormat:@"前天"];
                
            }else if (num > 2 && num <7){
                
                timeString = [NSString stringWithFormat:@"%@天前", timeString];
                
            }else if (num >= 7 && num <= 14) {
                
                timeString = [NSString stringWithFormat:@"1周前"];
                
            }else if(num >= 14 && num <= 21){
                
                timeString = [NSString stringWithFormat:@"2周前"];
                
            }
            else if(num >= 21 && num <= 28){
                
                timeString = [NSString stringWithFormat:@"3周前"];
                
            }
            else if(num >= 21 ){
                
                timeString = [NSString stringWithFormat:@"4周前"];
                
            }
            
        }
        if (cha/2592000 >= 1 && cha/31104000){
            timeString = [NSString stringWithFormat:@"%f", cha/2592000];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            timeString = [NSString stringWithFormat:@"%@个月前", timeString];
        }
        if (cha/31104000 >= 1 ){
            timeString = [NSString stringWithFormat:@"%f", cha/31104000];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            timeString = [NSString stringWithFormat:@"%@年前", timeString];
        }
    }else{
        
        if (cha/3600 < 1) {
            
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            int num= [timeString intValue];
            
            if (num <= 1) {
                
                timeString = [NSString stringWithFormat:@"A moment ago..."];
                
            }else{
                
                timeString = [NSString stringWithFormat:@"%@ minutes ago.", timeString];
                
            }
            
        }
        
        if (cha/3600 > 1 && cha/86400 < 1) {
            
            timeString = [NSString stringWithFormat:@"%f", cha/3600];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            timeString = [NSString stringWithFormat:@"%@ hours ago.", timeString];
            
        }
        
        if (cha/86400 > 1)
            
        {
            
            timeString = [NSString stringWithFormat:@"%f", cha/86400];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            int num = [timeString intValue];
            
            if (num < 2) {
                
                timeString = [NSString stringWithFormat:@"yesterday"];
                
            }
            //            else if(num == 2){
            //
            //                timeString = [NSString stringWithFormat:@"The day before yesterday"];
            //
            //            }
            else if (num >= 2 && num <7){
                
                timeString = [NSString stringWithFormat:@"%@days ago", timeString];
                
            }else if (num >= 7 && num <= 14) {
                
                timeString = [NSString stringWithFormat:@"1 week ago"];
                
            }else if(num >= 14 && num <= 21){
                
                timeString = [NSString stringWithFormat:@"2 weeks ago"];
                
            }
            else if(num >= 21 && num <= 28){
                
                timeString = [NSString stringWithFormat:@"3 weeks ago"];
                
            }
            else if(num >= 21 ){
                
                timeString = [NSString stringWithFormat:@"4 weeks ago"];
                
            }
            
        }
        if (cha/2592000 >= 1 && cha/31104000){
            timeString = [NSString stringWithFormat:@"%f", cha/2592000];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            timeString = [NSString stringWithFormat:@"%@monthes ago", timeString];
        }
        if (cha/31104000 >= 1 ){
            timeString = [NSString stringWithFormat:@"%f", cha/31104000];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            timeString = [NSString stringWithFormat:@"%@years ago", timeString];
        }
    }
    
    return timeString;
}
@end
