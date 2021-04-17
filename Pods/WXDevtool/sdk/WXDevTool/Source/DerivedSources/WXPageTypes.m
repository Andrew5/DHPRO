//
//  WXPageTypes.m
//  PonyDebuggerDerivedSources
//
//  Generated on 8/23/12
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "WXPageTypes.h"
@implementation WXFrameResource

+ (NSDictionary *)keysToEncode {
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"url",@"url",
                    @"type",@"type",
                    @"mimeType",@"mimeType",
                    @"failed",@"failed",
                    @"canceled",@"canceled",
                    nil];
    });
    
    return mappings;
}

@dynamic url,type,mimeType,failed,canceled;

@end

@implementation WXPageFrame

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"id",@"identifier",
                    @"parentId",@"parentId",
                    @"loaderId",@"loaderId",
                    @"name",@"name",
                    @"url",@"url",
                    @"securityOrigin",@"securityOrigin",
                    @"mimeType",@"mimeType",
                    nil];
    });

    return mappings;
}

@dynamic identifier;
@dynamic parentId;
@dynamic loaderId;
@dynamic name;
@dynamic url;
@dynamic securityOrigin;
@dynamic mimeType;
 
@end

@implementation WXPageFrameResourceTree

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"frame",@"frame",
                    @"childFrames",@"childFrames",
                    @"resources",@"resources",
                    nil];
    });

    return mappings;
}

@dynamic frame;
@dynamic childFrames;
@dynamic resources;
 
@end

@implementation WXPageSearchMatch

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"lineNumber",@"lineNumber",
                    @"lineContent",@"lineContent",
                    nil];
    });

    return mappings;
}

@dynamic lineNumber;
@dynamic lineContent;
 
@end

@implementation WXPageSearchResult

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"url",@"url",
                    @"frameId",@"frameId",
                    @"matchesCount",@"matchesCount",
                    nil];
    });

    return mappings;
}

@dynamic url;
@dynamic frameId;
@dynamic matchesCount;
 
@end

@implementation WXPageCookie

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"name",@"name",
                    @"value",@"value",
                    @"domain",@"domain",
                    @"path",@"path",
                    @"expires",@"expires",
                    @"size",@"size",
                    @"httpOnly",@"httpOnly",
                    @"secure",@"secure",
                    @"session",@"session",
                    nil];
    });

    return mappings;
}

@dynamic name;
@dynamic value;
@dynamic domain;
@dynamic path;
@dynamic expires;
@dynamic size;
@dynamic httpOnly;
@dynamic secure;
@dynamic session;
 
@end

@implementation WXScreencastFrameMetadata

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"offsetTop",@"offsetTop",
                    @"pageScaleFactor",@"pageScaleFactor",
                    @"deviceWidth",@"deviceWidth",
                    @"deviceHeight",@"deviceHeight",
                    @"scrollOffsetX",@"scrollOffsetX",
                    @"scrollOffsetY",@"scrollOffsetY",
                    @"timestamp",@"timestamp",
                    nil];
    });
    
    return mappings;
}

@dynamic offsetTop;
@dynamic pageScaleFactor;
@dynamic deviceWidth;
@dynamic deviceHeight;
@dynamic scrollOffsetX;
@dynamic scrollOffsetY;
@dynamic timestamp;

@end

@implementation WXScreencastFrame

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"data",@"data",
                    @"metadata",@"metadata",
                    @"sessionId",@"sessionId",
                    nil];
    });
    
    return mappings;
}

@dynamic data;
@dynamic metadata;
@dynamic sessionId;

@end

@implementation WXStartScreencast

+ (NSDictionary *)keysToEncode;
{
    static NSDictionary *mappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mappings = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"format",@"format",
                    @"quality",@"quality",
                    @"maxWidth",@"maxWidth",
                    @"maxHeight",@"maxHeight",
                    @"everyNthFrame",@"everyNthFrame",
                    nil];
    });
    
    return mappings;
}

@dynamic format;
@dynamic quality;
@dynamic maxWidth;
@dynamic maxHeight;
@dynamic everyNthFrame;

@end

