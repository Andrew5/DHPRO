//
//  AdItem.h
//  btc
//
//  Created by txj on 15/2/6.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    AD_TYPE_PRODUCT,
    AD_TYPE_CATEGORY,
    AD_TYPE_KEY_WORDS,
    AD_TYPE_HTML
}AdType;

@interface AdItem : NSObject
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *html;
@property (strong, nonatomic) NSString *htmlcontent;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *keyWords;
@property (strong, nonatomic) NSString *actiontype;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSNumber *adTypeInt;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) NSString *lat;
@property (assign, nonatomic) BOOL     *adType;
@end
