//
//  SearchViewController.h
//  shiku
//
//  Created by txj on 15/5/22.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListViewController.h"
/**
 *  搜索页面
 */
@interface SearchViewController : TBaseUIViewController<UITextFieldDelegate>
{
    FILTER *filter;
}
/**
 *  废弃，单例模式
 *
 *  @return <#return value description#>
 */
//+ (instancetype)shared;
@end
