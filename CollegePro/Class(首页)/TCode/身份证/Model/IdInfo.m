//
//  IdInfo.m
//  idcard
//
//  Created by hxg on 16-4-10.
//  Copyright (c) 2016年 林英伟. All rights reserved.
//

#import "IdInfo.h"

@implementation IdInfo
-(NSString *)toString
{
    return [NSString stringWithFormat:@"身份证号:%@\n姓名:%@\n性别:%@\n民族:%@\n地址:%@",
            _code, _name, _gender, _nation, _address];
}

-(BOOL)isOK
{
    if (_code !=nil && _name!=nil && _gender!=nil && _nation!=nil && _address!=nil)
    {
        if (_code.length>0 && _name.length >0 && _gender.length>0 && _nation.length>0 && _address.length>0)
        {
            return true;
        }
    }
    else if (_issue !=nil && _valid!=nil)
    {
        if (_issue.length>0 && _valid.length >0)
        {
            return true;
        }
    }
    return false;
}

-(BOOL)isEqual:(IdInfo *)idInfo
{
    if (idInfo == nil)
        return false;
    
    if ((_type == idInfo.type) &&
        [_code isEqualToString:idInfo.code] &&
        [_name isEqualToString:idInfo.name] &&
        [_gender isEqualToString:idInfo.gender] &&
        [_nation isEqualToString:idInfo.nation] &&
        [_address isEqualToString:idInfo.address] &&
        [_issue isEqualToString:idInfo.issue] &&
        [_valid isEqualToString:idInfo.valid])
        return true;
    
    return false;
}

@end
