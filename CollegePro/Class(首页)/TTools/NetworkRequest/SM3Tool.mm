#import "SM3Tool.h"
#include "SM3.hpp"

@implementation SM3Tool


+(NSString *)sm3Method:(NSString *)password
{
    NSData *testData = [password dataUsingEncoding: NSUTF8StringEncoding];
    // Byte * input =（Byte *）malloc [testData bytes];
    
    Byte *input = (Byte *)[testData bytes];
    const char *byteLength = [password UTF8String];
    size_t length = strlen(byteLength);
    
    /*Byte *byteArray = (Byte *)[data bytes];
     struct ouConnect_msg *ouconmsg ;
     ouconmsg=(struct ouConnect_msg*) malloc(sizeof(struct ouConnect_msg));
     struct hlink_msg *hlinkmsg;
     hlinkmsg=(struct hlink_msg*) malloc(sizeof(struct hlink_msg));*/
    
    
    
    Word* hash = SM3T::hash(input, length);
    
    NSMutableString *result = [NSMutableString string];
    //NSLog(@"%u",hash[0]);
    for (int i = 0; i < 8; i++) {
        [result appendFormat:@"%.8x",hash[i]];
    }
    NSLog(@"result = %@",result);
    return [result uppercaseString];
}


@end
