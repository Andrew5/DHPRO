//
//  SoapUtil.m
//  News
//
//  Created by iPolaris on 13-5-23.
//
//

#import "SoapUtil.h"

@implementation SoapUtil
@synthesize endpoint = _endpoint,nameSpace = _nameSpace;
-(id)initWithNameSpace:(NSString *)nameSpace andEndpoint:(NSString *)endpoint{
    self = [super init];
    if (self) {
        _endpoint = endpoint;
        _nameSpace = nameSpace;
    }
    return self;
}
-(NSData *)requestMethod:(NSString *)method withDate:(NSArray *)array{
    return [self soapInvoke:method params:array];
}
- (NSData *) soapCall:(NSString *)method  postData:(NSString *)post
{
   
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    //[postData autorelease];
    if (![_nameSpace hasSuffix:@"/"]) {
        _nameSpace = [_nameSpace stringByAppendingString:@"/"];
    }
    NSString *soapAction = [NSString stringWithFormat:@"%@%@",_nameSpace , method  ];
    
    NSURL *url=[[NSURL alloc]initWithString:_endpoint];
    NSMutableURLRequest  *request=[[NSMutableURLRequest alloc]init];
    
    [request setTimeoutInterval: 10 ];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setURL: url ] ;
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    NSError *err=nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil
                                                   error:&err];
    return data ;
}


- (NSData *)soapInvoke:(NSString *)method params:(NSArray *)params
{
    NSMutableString * post = [[ NSMutableString alloc ] init ] ;
   // [ post autorelease ];
    
    [ post appendString:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
     "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\""
     " xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\""
     " xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
     "<soap:Body>\n" ];
    
    [ post appendString:@"<"];
    [ post appendString:method];
    [ post appendString:[NSString stringWithFormat:@" xmlns=\"%@\">\n",_nameSpace]];
    
    for (NSDictionary *dict in params)
    {
        NSString *value = nil;
        
        NSString *key = [[dict keyEnumerator] nextObject];
        
        if (key != nil)
        {
            value = [dict valueForKey:key];
            
            [ post appendString:@"<"];
            [ post appendString:key];
            [ post appendString:@">"];
            if( value != nil )
            {
                [ post appendString:value];
            }
            else
            {
                [ post appendString:@""];
            }
            
            [ post appendString:@"</"];
            [ post appendString:key];
            [ post appendString:@">\n"];
        }
    }
    
    [ post appendString:@"</"];
    [ post appendString:method];
    [ post appendString:@">\n"];
    
    [ post appendString:
     @"</soap:Body>\n"
     "</soap:Envelope>\n"
     ];

//    NSLog(@"request：n%@\n", post);
    
    return [self soapCall:method postData:post];
}

@end
