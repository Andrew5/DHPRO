//
//  Macro_String.h
//  zichan
//
//  Created by Mike on 16/5/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#ifndef Macro_String_h
#define Macro_String_h

// user default access
#define USERDEFAULT_OBJ4KEY(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define USERDEFAULT_SETOBJ4KEY(obj, key) [[NSUserDefaults standardUserDefaults]setObject:obj forKey:key]

#define USERDEFAULT_BOOL4KEY(key) [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define USERDEFAULT_SETBOOL4KEY(bool, key) [[NSUserDefaults standardUserDefaults] setBool:bool forKey:key]

#define kServerURL (@"kServerURL")
#define kJXHDServerURL (@"kJXHDServerURL")
#define isNotFirstOpenApp (@"isFirstOpenApp")
#define kRememberPassword (@"kRememberPassword")
#define kAutoLogin (@"kAutoLogin")
#define kUsername (@"kUsername")
#define kPassword (@"kPassword")
#define kHandshakePassword (@"kHandshakePassword")


#pragma mark - 网络请求提示信息

// 弹框提示信息
#define KREQUESTLOADING @"加载中..."
#define KREQUESTSUCCESS @"请求成功"
#define KREQUESTERROR @"网络异常 请稍后再试"
#define kREQUESTSERVICEERROR @"服务器错误"
#define kREQUESTSERVICECONNECTERROR @"无法连接服务器"
#define kREQUESTUNKNOWERROR @"加载信息失败"
#define KREQUESTNODATA @"暂无数据"
#define KREQUESTNOACCESS @"无权限"
#define KREQUESTOVERTIME @"请求超时"
#define KREQUESTLOGINERROR @"登录失败"
#define KREQUESTERRORPASSWORD @"密码错误"
#define KREQUESTADDSUCCESS @"添加成功"
#define KREQUESTADDFAILED @"添加失败"
#define KREQUESTOPERATESUCCESS @"操作成功"
#define KREQUESTOPERATEFAILED @"操作失败"
#define KREQUESTCONTAINILLEGALSTRING @"包含非法字符 请重新输入"
#define KREQUESTPLEASEINPUTALLINFO @"请填写完整信息"
#define KREQUESTLIMITCOUNT @"标题最多输入100字"
#define KCONTENTLIMITCOUNT @"内容最多输入100字"
#define KDESCRIPTIONLIMITCOUNT @"描述最多输入100字"
#define KCOMMENTLIMITCOUNT @"评论最多输入100字"
#define KREQUESTADDING @"提交中..."
#define KREQUESTATLEASTONECONDITION @"至少选择一个搜索条件"
#define KREQUESTDOWNLOADING @"下载中..."
#define KREQUESTDOWNLOADSUCCESS @"下载成功"
#define KREQUESTDOWNLOADFAILED @"下载失败"
#define KREQUESTUPLOADSUCCESS @"上传成功"
#define KREQUESTUPLOADFAILED @"上传失败"
#define KREQUESTCHANGEPASSWORDSUCCESS @"密码修改成功"
#define KREQUESTCHANGEPASSWORDFAILED @"密码修改失败"
#define KREQUESTCLEANSUCCESS @"已清理"
#define KREQUESTDURATIONHALFSECOND 0.5
#define KREQUESTDURATION 1.0
#define KREQUESTONEANDHALFSECOND 1.5
#define KOPENAPPFAILD @"请检查是否安装该应用"

/**
 *  是否第一次出现,0表示第一次出现，1表示出现了好多次
 */
#define KNOTIFY_FIRSTSHOW @"kfirstShow"

#endif /* Macro_String_h */
