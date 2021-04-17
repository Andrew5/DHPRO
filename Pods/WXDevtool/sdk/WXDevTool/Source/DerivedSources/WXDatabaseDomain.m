//
//  WXDatabaseDomain.m
//  PonyDebuggerDerivedSources
//
//  Generated on 8/23/12
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "WXObject.h"
#import "WXDatabaseDomain.h"
#import "WXObject.h"
#import "WXDatabaseTypes.h"


@interface WXDatabaseDomain ()
//Commands

@end

@implementation WXDatabaseDomain

@dynamic delegate;

+ (NSString *)domainName;
{
    return @"Database";
}

// Events
- (void)addDatabaseWithDatabase:(WXDatabaseDatabase *)database;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

    if (database != nil) {
        [params setObject:[database WX_JSONObject] forKey:@"database"];
    }
    
    [self.debuggingServer sendEventWithName:@"Database.addDatabase" parameters:params];
}
- (void)sqlTransactionSucceededWithTransactionId:(NSNumber *)transactionId columnNames:(NSArray *)columnNames values:(NSArray *)values;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];

    if (transactionId != nil) {
        [params setObject:[transactionId WX_JSONObject] forKey:@"transactionId"];
    }
    if (columnNames != nil) {
        [params setObject:[columnNames WX_JSONObject] forKey:@"columnNames"];
    }
    if (values != nil) {
        [params setObject:[values WX_JSONObject] forKey:@"values"];
    }
    
    [self.debuggingServer sendEventWithName:@"Database.sqlTransactionSucceeded" parameters:params];
}
- (void)sqlTransactionFailedWithTransactionId:(NSNumber *)transactionId sqlError:(NSDictionary *)sqlError;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

    if (transactionId != nil) {
        [params setObject:[transactionId WX_JSONObject] forKey:@"transactionId"];
    }
    if (sqlError != nil) {
        [params setObject:[sqlError WX_JSONObject] forKey:@"sqlError"];
    }
    
    [self.debuggingServer sendEventWithName:@"Database.sqlTransactionFailed" parameters:params];
}



- (void)handleMethodWithName:(NSString *)methodName parameters:(NSDictionary *)params responseCallback:(WXResponseCallback)responseCallback;
{
    if ([methodName isEqualToString:@"enable"] && [self.delegate respondsToSelector:@selector(domain:enableWithCallback:)]) {
        [self.delegate domain:self enableWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"disable"] && [self.delegate respondsToSelector:@selector(domain:disableWithCallback:)]) {
        [self.delegate domain:self disableWithCallback:^(id error) {
            responseCallback(nil, error);
        }];
    } else if ([methodName isEqualToString:@"getDatabaseTableNames"] && [self.delegate respondsToSelector:@selector(domain:getDatabaseTableNamesWithDatabaseId:callback:)]) {
        [self.delegate domain:self getDatabaseTableNamesWithDatabaseId:[params objectForKey:@"databaseId"] callback:^(NSArray *tableNames, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];

            if (tableNames != nil) {
                [params setObject:tableNames forKey:@"tableNames"];
            }

            responseCallback(params, error);
        }];
    } else if ([methodName isEqualToString:@"executeSQL"] && [self.delegate respondsToSelector:@selector(domain:executeSQLWithDatabaseId:query:callback:)]) {
        [self.delegate domain:self executeSQLWithDatabaseId:[params objectForKey:@"databaseId"] query:[params objectForKey:@"query"] callback:^(NSNumber *success, NSNumber *transactionId, id error) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];

            if (success != nil) {
                [params setObject:success forKey:@"success"];
            }
            if (transactionId != nil) {
                [params setObject:transactionId forKey:@"transactionId"];
            }

            responseCallback(params, error);
        }];
    } else {
        [super handleMethodWithName:methodName parameters:params responseCallback:responseCallback];
    }
}

@end


@implementation WXDebugger (WXDatabaseDomain)

- (WXDatabaseDomain *)databaseDomain;
{
    return [self domainForName:@"Database"];
}

@end
