//
//  SoapUtil.h
//  News
//
//  Created by iPolaris on 13-5-23.
//
//

#import <Foundation/Foundation.h>

@interface SoapUtil : NSObject
@property (strong) NSString *nameSpace;
@property (strong) NSString *endpoint;
-(id)initWithNameSpace:(NSString *)nameSpace andEndpoint:(NSString *)endpoint;
-(NSData *)requestMethod:(NSString *)method withDate:(NSArray *)array;
@end
