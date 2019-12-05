//
//  AlertInfoItemViewController.h
//  publicZnaer
//
//  Created by Jeremy on 15/1/21.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    ALERT_NICKNAME,//修改昵称
    ALERT_PS//修改备注
}AlertInfoItem;

//用户信息修改界面
@interface AlertInfoItemViewController : BaseViewController<PassValueDelegate>

@property(nonatomic,strong)UITextField *tf;


@end
