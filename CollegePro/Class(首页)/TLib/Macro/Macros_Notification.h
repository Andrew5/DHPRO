//
//  Macros_Notification.h
//  zichan
//
//  Created by Mike on 16/6/14.
//  Copyright © 2016年 Mike. All rights reserved.
//

#ifndef Macros_Notification_h
#define Macros_Notification_h

// 用户角色改变
#define NOTI_ROLE_CHANGED (@"com.combanc.zichan.role.changed")

// 向`资产领用`订单添加资产 // userInfo:@{@"asset":_dataModel}
#define NOTI_ADD_ASSET_TO_ZCLY (@"com.combanc.zichan.add.asset.to.zcly")
// 向`资产借用`订单添加资产
#define NOTI_ADD_ASSET_TO_ZCJY (@"com.combanc.zichan.add.asset.to.zcjy")
// 向`低值领用`订单添加资产
#define NOTI_ADD_ASSET_TO_DZLY (@"com.combanc.zichan.add.asset.to.dzly")
// 向`低值借用`订单添加资产
#define NOTI_ADD_ASSET_TO_DZJY (@"com.combanc.zichan.add.asset.to.dzjy")
// 修改用户信息上传至服务器成功
#define NOTI_USER_INFO_MODIFY_SUCCESS (@"com.combanc.zichan.user.info.modify.success")
// 添加订单过程中修改了资产
//#define NOTI_MODIFY_ASSET_WHEN_ADD_TICKET (@"com.combanc.zichan.modify.asset.when.add.ticket")
// 添加单据之后，`保存`或者`提交`成功，需要刷新我发起的页面
#define NOTI_NEED_REFRESH_I_START_AFTER_ADD_TICKET_SUCCESS (@"com.combanc.zichan.need.refresh.i.start.after.add.ticket.success")

// `资产领用` `资产借用` `低值领用` `低值借用`基本信息被修改 // userInfo:@{@"baseInfo":_dataModel}
#define NOTI_MODIFY_BASEINFO_TO_ADD_TICKET (@"com.combanc.zichan.modify.baseinfo.to.ticket")

// 修改了资产的信息，需要更新资产详情页的数据 userInfo:@{@"assetCode":_assetInfoModelFromOther.code}
#define NOTI_NEED_UPDATE_ASSET_DETAIL_AFTER_MODIFY (@"com.combanc.need.update.asset.detail.after.modify")
#define NOTI_NEED_REFRESH_PANDIAN_PLAN_LIST_AFTER_PANDIAN_COMPLETED (@"com.combanc.need.refresh.pandian.plan.list.after.pandian.complteted")
#define NOTI_NEED_REFRESH_PANDIAN_ASSET_LIST_AFTER_SCAN_PANDIAN (@"com.combanc.need.refresh.pandian.asset.list.after.scan.pandian")


//我发起的添加通知
// 向`资产领用`订单添加资产 // userInfo:@{@"asset":_dataModel}
#define NOTI_ZCLY (@"com.combanc.zichan.add.asset.zcly")
// 向`资产借用`订单添加资产
#define NOTI_ZCJY (@"com.combanc.zichan.add.asset.zcjy")
// 向`低值领用`订单添加资产
#define NOTI_DZLY (@"com.combanc.zichan.add.asset.dzly")
// 向`低值借用`订单添加资产
#define NOTI_DZJY (@"com.combanc.zichan.add.asset.dzjy")

#define NOTI_DZRK (@"com.combanc.zichan.add.asset.dzrk")
#define NOTI_ZCRK (@"com.combanc.zichan.add.asset.zcrk")


#define NOTI_UPDATE_BASEINFO_TO_ADD_TICKET (@"com.combanc.zichan.update.baseinfo.to.ticket")


#endif /* Macros_Notification_h */
